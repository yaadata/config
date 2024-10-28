local cfg = {
  name = 'Golang Run Test',
  builder = function(_)
    local uts = require 'overseer.template.golang.utils'
    local test, _ = uts.get_test_at_cursor()
    local cmd = {}
    local args = {}
    if not test then
      vim.notify('no test found', vim.log.levels.ERROR)
      cmd = { 'echo', '"no test found"' }
    else
      local testName
      -- if subtest then
      --   testName = string.format('%s/%s', test.name, subtest.name)
      -- else
      testName = string.format('^%s$', test.name)
      -- end

      cmd = {
        '/opt/homebrew/bin/go',
        'test',
      }
      args = {
        '-timeout',
        '30s',
        '-tags',
        'integration,endtoendtest,integration_snowflake,integrationtest,unit',
        '-run',
        tostring(testName),
      }
    end
    return {
      cmd = cmd,
      args = args,
    }
  end,
  condition = {
    filetype = { 'go' },
    callback = function(_)
      local fp = vim.fn.expand '%:p'
      local fn = vim.fn.fnamemodify(fp, ':t')
      local res = true
      if string.len(fn) < 7 then
        res = false
      end
      res = string.sub(fn, -7) == 'test.go'
      return res
    end,
  },
}

return cfg
