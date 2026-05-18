--  Check out: https://github.com/nvim-mini/mini.nvim

return {
  -- Collection of various small independent plugins/modules
  'nvim-mini/mini.nvim',
  config = function()
    local function linewise(spec)
      return function(ai_type, id, opts)
        local result = spec(ai_type, id, opts)
        if not result then
          return
        end
        local regions = vim.islist(result) and result or { result }
        for _, r in ipairs(regions) do
          r.vis_mode = 'V'
        end
        return result
      end
    end

    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
    --  - ci'  - [C]hange [I]nside [']quote
    local ts = require('mini.ai').gen_spec.treesitter
    require('mini.ai').setup {
      n_lines = 500,
      custom_textobjects = {
        c = linewise(ts { a = '@class.outer', i = '@class.inner' }),
        f = linewise(ts { a = '@function.outer', i = '@function.inner' }),
      },
    }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()
  end,
}
