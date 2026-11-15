-- Point ~/.local/bin/rex at the CLI inside the Rex app bundle.
--
-- App updates replace the bundle tree, so a hand-made link goes stale and
-- rex.exec.start fails with "no such file or directory". init.lua may not call
-- os.execute and the server's launchd PATH has no rex on it, so probe the
-- bundle directly. Only a missing or broken link is repaired; one that still
-- resolves is left alone, so a deliberate choice of your own survives.

-- True when argv ran and exited zero. rex.exec returns nil plus a reason on
-- spawn failure rather than throwing, so no pcall is needed.
local function ok(argv)
	local result = rex.exec(argv)
	return result and result.code == 0
end

-- Returns the CLI path to spawn, or nil and why the link could not be repaired.
return function()
	local home = os.getenv("HOME")
	if not home or home == "" then
		return nil, "HOME is not set"
	end

	local link = home .. "/.local/bin/rex"
	local cli = home .. "/Library/Application Support/com.superlogical.rex"
		.. "/RexServer/Versions/Current/Rex Server.app/Contents/MacOS/rex"

	-- Resolve the link rather than reading its target: a relative target would
	-- otherwise be resolved against the server's working directory, and a link
	-- to a directory would pass a plain existence check.
	if ok({ "/bin/test", "-f", link, "-a", "-x", link }) then
		return link
	end

	-- ln -sfn treats a real directory as the target folder and exits 0, leaving
	-- <link>/rex behind, so reject it before linking.
	if ok({ "/bin/test", "-d", link, "-a", "!", "-L", link }) then
		return nil, link .. " is a directory"
	end

	if not ok({ cli, "version" }) then
		return nil, "cannot run the Rex CLI at " .. cli
	end

	local bin_dir = home .. "/.local/bin"
	if not ok({ "/bin/mkdir", "-p", bin_dir }) then
		return nil, "could not create " .. bin_dir
	end
	-- -n replaces the link itself; without it ln writes into whatever folder a
	-- stale link points at.
	if not ok({ "/bin/ln", "-sfn", cli, link }) then
		return nil, "could not link " .. link .. " to " .. cli
	end
	-- ln can report success without producing the link we asked for.
	if not ok({ "/bin/test", "-f", link, "-a", "-x", link }) then
		return nil, "linking " .. link .. " did not produce a runnable path"
	end

	return link
end
