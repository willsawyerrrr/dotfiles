return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  ---@module "noice.config"
  ---@type NoiceConfig
  opts = {
    presets = {
      command_palette = true,
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
  },
}
