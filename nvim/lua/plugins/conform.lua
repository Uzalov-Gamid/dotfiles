return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        sql = { "sqltools" },
        pgsql = { "sqltools" },
        fish = { "fish_indent" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },

      formatters = {
        sqltools = {
          command = "node",
          env = {
            NODE_PATH = "/opt/homebrew/lib/node_modules",
          },
          args = {
            "-e",
            "const f=require('@sqltools/formatter');let c='';process.stdin.on('data',d=>c+=d);process.stdin.on('end',()=>process.stdout.write(f.format(c,{language:'postgresql',reservedWordCase:'lower',indentSize:2})));",
          },
        },
        shfmt = {
          prepend_args = {
            "-i",
            "2",
            "-ci",
          },
        },
      },
    },
  },
}
