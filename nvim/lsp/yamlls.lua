local schemas = {}

local ok, schemastore = pcall(require, 'schemastore')
if ok then
  schemas = schemastore.yaml.schemas()
end

return {
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    yaml = {
      completion = true,
      hover = true,
      schemaStore = {
        enable = false,
        url = '',
      },
      schemas = schemas,
      validate = true,
    },
  },
}
