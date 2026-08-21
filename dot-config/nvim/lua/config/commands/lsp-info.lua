vim.api.nvim_create_user_command('LspInfo', function()
  local clients = vim.lsp.get_clients { bufnr = 0 }

  if #clients == 0 then
    vim.notify('No LSP clients attached to this buffer', vim.log.levels.WARN)
    return
  end

  local names = vim.tbl_map(function(client)
    return client.name
  end, clients)
  table.sort(names)

  vim.notify('LSP clients: ' .. table.concat(names, ', '))
end, { desc = 'Show LSP clients attached to the current buffer' })
