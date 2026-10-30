local TERM = "com.superlogical.terminal"
local SHELL = TERM .. ".shell"
local PREFIX = "rex.scratch.tab:"

local function must(result, err)
	if not result then
		error(tostring(err or "Rex API call failed"), 0)
	end
	return result
end

local function blocks_in(session_id)
	return must(rex.call("session.list_blocks", { session_id = session_id })).blocks or {}
end

local function owned(block, label)
	return block and block.label == label and block.creator_name == TERM and block.flavor == SHELL
end

local function close_if_still_owned(session_id, block, label)
	local latest = rex.call("session.describe_block", {
		session_id = session_id,
		block_id = block.block_id,
	})
	-- It may have been closed by Rex when the tab closed. If it still exists,
	-- recheck the reserved label and type before ending its program.
	if latest and owned(latest.block, label) then
		must(rex.call("block.close", { session_id = session_id, block_id = block.block_id }))
	end
end

rex.on("window_closed", function(ctx, ev)
	local label = PREFIX .. ev.window_id
	for _, block in ipairs(blocks_in(ctx.session_id)) do
		if owned(block, label) then
			close_if_still_owned(ctx.session_id, block, label)
		end
	end
end)

local armed = {} -- session ID -> scratch last observed with focus

local function focused_block(view)
	if not view then
		return nil
	end
	for _, window in ipairs(view.windows or {}) do
		if window.window_id == view.active_window_id then
			return window.focused_block_id
		end
	end
end

local function floating_window(view, block_id)
	if not view then
		return nil
	end
	for _, window in ipairs(view.windows or {}) do
		local count, found = 0, false
		for _, layer in ipairs(window.layers or {}) do
			for _, pane in ipairs(layer.blocks or {}) do
				count = count + 1
				if layer.kind == "floating" and pane.block_id == block_id then
					found = true
				end
			end
		end
		if found then
			return window, count
		end
	end
end

local function update_focus(ctx)
	local session_id = ctx.session_id
	if not session_id then
		return
	end
	local view = rex.call("session.view", { session_id = session_id })
	local current = focused_block(view)
	if not current then
		return
	end

	local previous = armed[session_id]
	if previous and previous ~= current then
		local detail = rex.call("session.describe_block", {
			session_id = session_id,
			block_id = previous,
		})
		-- Recheck the view after metadata, immediately before detaching.
		local latest = rex.call("session.view", { session_id = session_id })
		local now = focused_block(latest)
		if not now then
			return
		end
		local window, count = floating_window(latest, previous)
		if window and count > 1 and now ~= previous and detail and owned(detail.block, PREFIX .. window.window_id) then
			local detached, err = rex.call("session.detach_block", {
				session_id = session_id,
				block_id = previous,
			})
			if not detached then
				rex.log("warn", "Scratch auto-hide: " .. tostring(err))
			end
		end
		armed[session_id] = nil
		view, current = latest, now
	end

	local window = floating_window(view, current)
	if window then
		local detail = rex.call("session.describe_block", {
			session_id = session_id,
			block_id = current,
		})
		if detail and owned(detail.block, PREFIX .. window.window_id) then
			armed[session_id] = current
		end
	end
end

rex.on("active_window_changed", update_focus)
rex.on("session_destroyed", function(_, ev)
	if ev.session_id then
		armed[ev.session_id] = nil
	end
end)

-- Recognize a scratch already focused when the listener starts.
rex.after(0, function()
	local sessions = rex.call("session.list", {})
	if not sessions then
		return
	end
	for _, session in ipairs(sessions.sessions or {}) do
		update_focus({ session_id = session.session_id })
	end
end)

local function reconcile()
	local sessions = must(rex.call("session.list", {})).sessions or {}
	for _, session in ipairs(sessions) do
		-- Blocks first, windows second: a tab newly created between reads is not
		-- mistaken for an orphan because of an older window snapshot.
		local blocks = blocks_in(session.session_id)
		local view = must(rex.call("session.view", { session_id = session.session_id }))
		local live = {}
		for _, window in ipairs(view.windows or {}) do
			if window.window_id then
				live[window.window_id] = true
			end
		end
		for _, block in ipairs(blocks) do
			local label = block.label or ""
			if label:sub(1, #PREFIX) == PREFIX then
				local owner = label:sub(#PREFIX + 1)
				if owner:match("^window:[%x%-]+$") and not live[owner] and owned(block, label) then
					close_if_still_owned(session.session_id, block, label)
				end
			end
		end
	end
end

-- Run after event registration, and periodically recover missed closes or
-- force a supervised restart on an API failure (--fail-fast).
rex.after(1, reconcile)
rex.every(30, reconcile)
