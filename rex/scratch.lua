-- Tab scratch terminal: one floating shell per tab, remembered and restored.
local TERM = "com.superlogical.terminal"
local SHELL = TERM .. ".shell"
local PREFIX = "rex.scratch.tab:"
local previous, busy = {}, {}

local function find(items, field, value)
	for _, item in ipairs(items or {}) do
		if item[field] == value then
			return item
		end
	end
end

-- A destroyed session means its tab and blocks are already gone; other
-- API failures should still be reported.
local function session_result(ctx, result, err)
	if result then
		return result
	end
	local sessions = rex.call("session.list", {})
	if sessions and not find(sessions.sessions, "session_id", ctx.session_id) then
		return nil
	end
	error(tostring(err or "Rex API call failed"), 0)
end

local function fail_unless_closed(ctx, window_id, message)
	local view = session_result(ctx, rex.session.view({}))
	if view and find(view.windows, "window_id", window_id) then
		error(tostring(message), 0)
	end
end

local function toggle(ctx)
	if not ctx.session_id or not ctx.block_id then
		return
	end
	local first = session_result(ctx, rex.session.list_blocks({}))
	if not first then
		return
	end
	local current = find(first.blocks, "block_id", ctx.block_id)
	if not current or current.placement ~= "placed" or not current.window_id then
		return
	end

	local window_id = current.window_id
	local key = ctx.session_id .. "/" .. window_id
	if busy[key] then
		return
	end
	busy[key] = true

	local ok, result = pcall(function()
		-- Re-read after taking the in-process guard; a prior snapshot may be stale.
		local listed = session_result(ctx, rex.session.list_blocks({}))
		if not listed then
			return
		end
		local blocks = listed.blocks or {}
		local here = find(blocks, "block_id", ctx.block_id)
		if not here or here.placement ~= "placed" or here.window_id ~= window_id then
			return
		end
		local view = session_result(ctx, rex.session.view({}))
		if not view then
			return
		end
		local window = find(view.windows, "window_id", window_id)
		if not window then
			return
		end -- the window_closed listener performs teardown

		local saved = previous[ctx.session_id] or {}
		previous[ctx.session_id] = saved
		for id in pairs(saved) do
			if not find(view.windows, "window_id", id) then
				saved[id] = nil
			end
		end

		local label = PREFIX .. window_id
		local scratch
		for _, block in ipairs(blocks) do
			if block.label == label then
				if scratch then
					error("Duplicate scratch blocks for this tab", 0)
				end
				if block.flavor ~= SHELL or block.creator_name ~= TERM then
					error("The tab's scratch label belongs to a different block type", 0)
				end
				scratch = block
			end
		end

		if scratch and scratch.placement == "placed" then
			if scratch.window_id ~= window_id then
				error("This tab's scratch was moved to another tab", 0)
			end
			local other
			for _, block in ipairs(blocks) do
				if
					block.placement == "placed"
					and block.window_id == window_id
					and block.block_id ~= scratch.block_id
				then
					other = block
					break
				end
			end
			if not other then
				error("Cannot hide the last pane in a tab", 0)
			end
			local detached, err = rex.session.detach_block({ block_id = scratch.block_id })
			if not detached then
				return fail_unless_closed(ctx, window_id, err)
			end
			local back = saved[window_id]
			saved[window_id] = nil
			if ctx.block_id == scratch.block_id and back then
				local target = find(blocks, "block_id", back)
				if target and target.placement == "placed" and target.window_id == window_id then
					local focused, focus_err = rex.session.focus_block({ block_id = back })
					if not focused then
						rex.log("warn", "Scratch focus restore: " .. tostring(focus_err))
					end
				end
			end
			return detached
		end
		if scratch and scratch.placement ~= "detached" then
			error("Unsupported scratch placement", 0)
		end

		local anchor
		for _, layer in ipairs(window.layers or {}) do
			if layer.kind == "tiled" then
				for _, block in ipairs(layer.blocks or {}) do
					if not anchor or block.block_id == ctx.block_id then
						anchor = block.block_id
					end
				end
			end
		end
		if not anchor then
			error("This tab has no tiled pane to float beside", 0)
		end

		local created = false
		if not scratch then
			local process = rex.block.call(TERM, "process", { block_id = ctx.block_id })
			local cwd = process and process.foreground and process.foreground.cwd
			local options = {}
			if type(cwd) == "string" and cwd ~= "" then
				options.cwd = cwd
			end
			local new_block, err = rex.session.new_block({
				flavor = SHELL,
				label = label,
				options = options,
			})
			if not new_block then
				return fail_unless_closed(ctx, window_id, err)
			end
			scratch, created = new_block, true
		end
		if not scratch.block_id then
			error("Rex created a block without an ID", 0)
		end

		local moved, move_err = rex.session.move_block({
			block_id = scratch.block_id,
			anchor_block_id = anchor,
		})
		if not moved then
			if created then
				local closed, close_err = rex.call("block.close", {
					session_id = ctx.session_id,
					block_id = scratch.block_id,
				})
				if not closed and rex.session.describe_block({ block_id = scratch.block_id }) then
					rex.log("warn", "Scratch cleanup failed: " .. tostring(close_err))
				end
			end
			return fail_unless_closed(ctx, window_id, move_err)
		end

		local function rollback(message)
			local detached, err = rex.session.detach_block({ block_id = scratch.block_id })
			if not detached then
				message = message .. "; detach failed: " .. tostring(err)
			end
			return fail_unless_closed(ctx, window_id, message)
		end
		local floated, float_err = rex.session.float_block({
			block_id = scratch.block_id,
			bounds = { 0.1, 0.1, 0.8, 0.8 },
		})
		if not floated then
			return rollback("Could not float scratch: " .. tostring(float_err))
		end
		local focused, focus_err = rex.session.focus_block({ block_id = scratch.block_id })
		if not focused then
			return rollback("Could not focus scratch: " .. tostring(focus_err))
		end
		saved[window_id] = ctx.block_id
		return focused
	end)

	busy[key] = nil
	if not ok then
		error(result, 0)
	end
	return result
end

return toggle
