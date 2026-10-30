local scratch_toggle = require("scratch")
rex.action({
	name = "scratch_toggle",
	title = "Toggle Tab Scratch Terminal",
	run = scratch_toggle,
})
rex.bind("alt+shift+f", "scratch_toggle")

-- Run scratch events separately: rex do ~/.config/rex/scratch-events.lua --all --fail-fast

-- Rex doesn't expose sidebar state, so remember the last request per client and session.
local session_collapse_requested = {}
rex.action({
	name = "session_toggle_collapse",
	title = "Toggle Session Collapse",
	run = function(ctx)
		if not ctx.client_id or not ctx.session_id then
			error("Cannot toggle a session without a client and session", 0)
		end
		local key = ctx.client_id .. "/" .. ctx.session_id
		local action = session_collapse_requested[key] and "session.expand" or "session.collapse"
		rex.client.queue(action, { session_id = ctx.session_id })
		session_collapse_requested[key] = not session_collapse_requested[key] or nil
	end,
})
rex.bind("cmd+shift+h", "session_toggle_collapse")

require("worktree")
