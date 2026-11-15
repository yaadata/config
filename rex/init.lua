local close_other_tabs = require("close_other_tabs")
local scratch_toggle = require("scratch")
local rex_link = require("rex_link")
require("worktree")

local HOME = os.getenv("HOME")
-- A missing HOME must not abort the config load, or every action dies with it.
local LISTENER = HOME and HOME ~= "" and (HOME .. "/.config/rex/scratch-events.lua")
-- pgrep treats this as an unescaped ERE, and " do <path> --all" only matches a
-- real listener rather than an editor or a cat that merely mentions the path.
local LISTENER_PATTERN = LISTENER
	and " do " .. LISTENER:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "\\%1") .. " --all"
local scratch_listener

-- A detached listener outlives a config reload, but the module-level handle does
-- not, so a reload would let the next press start a second one. Ask the process
-- table instead, which stays correct across reloads.
local function listener_running()
	if not LISTENER_PATTERN then
		return false
	end
	local result = rex.exec({ "/usr/bin/pgrep", "-f", LISTENER_PATTERN })
	return result ~= nil and result.code == 0
end

-- ACTIONS
rex.action({
	name = "scratch_toggle",
	title = "Toggle Tab Scratch Terminal",
	run = function(ctx)
		local alive = scratch_listener and scratch_listener:running()
		if not alive and not listener_running() then
			local rex_bin, problem = rex_link()
			if not rex_bin then
				error("Cannot start the scratch listener: " .. problem, 0)
			end
			local proc, spawn_problem = rex.exec.start({
				rex_bin,
				"do", LISTENER,
				"--all", "--fail-fast",
			}, { detach = true })
			if not proc then
				error("Cannot start the scratch listener: " .. tostring(spawn_problem), 0)
			end
			scratch_listener = proc
		end
		return scratch_toggle(ctx)
	end,
})

-- Rex doesn't expose sidebar state, so remember the last request per client and session.
local session_collapse_requested = {}
rex.action({
	name = "session_toggle_collapse",
	title = "Session Collapse (Toggle)",
	category = "Session",
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

rex.action({
	name = "close_other_tabs",
	title = "Close Other Tabs",
	description = "Close the other tabs in this session and stop their running programs.",
	category = "Tab",
	run = close_other_tabs,
})

-- Keybindings
rex.bind("alt+shift+f", "scratch_toggle")
rex.bind("cmd+shift+h", "session_toggle_collapse")
