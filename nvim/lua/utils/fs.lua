local fs = {}

local function split_path()
  -- Get the full path of current buffer
  local full_path = vim.fn.expand '%:p'

  -- Split the path by directory separator
  local path_parts = vim.split(full_path, '/')
  return path_parts
end

function fs.buffer_directory_name()
  -- Split the path by directory separator
  local path_parts = split_path()

  -- Get the file name and its directory
  local parent_dir = path_parts[#path_parts - 1]
  return parent_dir
end

function fs.buffer_filename()
  -- Split the path by directory separator
  local path_parts = split_path()

  -- get file name
  local fn = path_parts[#path_parts]
  return fn
end

return fs
