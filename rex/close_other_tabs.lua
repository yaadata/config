local function close_other_tabs(ctx)
	if not ctx.session_id then
		error("Cannot close tabs without a session", 0)
	end
	local view, err = rex.session.view({})
	if not view then
		error(err, 0)
	end

	-- Prefer the invoking pane's tab; without a pane, use the active tab.
	local keep_window_id
	for _, window in ipairs(view.windows or {}) do
		if not window.window_id then
			error("Cannot close tabs without their IDs", 0)
		end
		if ctx.block_id then
			for _, layer in ipairs(window.layers or {}) do
				for _, block in ipairs(layer.blocks or {}) do
					if block.block_id == ctx.block_id then
						keep_window_id = window.window_id
					end
				end
			end
		elseif window.window_id == view.active_window_id then
			keep_window_id = window.window_id
		end
	end
	if not keep_window_id then
		error("Cannot identify the current tab", 0)
	end

	for _, window in ipairs(view.windows or {}) do
		if window.window_id ~= keep_window_id then
			local closed, close_err = rex.session.close_window({ window_id = window.window_id })
			if not closed then
				error("Could not close tab " .. window.window_id .. ": " .. tostring(close_err), 0)
			end
		end
	end
end

return close_other_tabs
