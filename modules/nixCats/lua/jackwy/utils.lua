local M = {}

---@param plugin_names string[]|string
function M.multi_packadd(plugin_names)
  local names = type(plugin_names) == 'string' and { plugin_names } or plugin_names or {}
  ---@diagnostic disable-next-line: param-type-mismatch
  for _, name in ipairs(names) do
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.cmd.packadd(name)
  end
end

return M
