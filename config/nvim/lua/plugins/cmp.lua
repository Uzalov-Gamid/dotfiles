return {
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "*",
    event = "InsertEnter",
    opts = {
      keymap = { preset = "enter" },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        menu = { border = "rounded" },
      },
      signature = { window = { border = "rounded" } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
    opts_extend = { "sources.default" },
  },
}
