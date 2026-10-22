return {
  "folke/snacks.nvim",
  opts = {
    scroll = {
      enabled = false,
    },

    picker = {
      enabled = false,
      sources = {
        buffers = {
          sort_lastused = true,
        },

        files = {
          hidden = true,
          ignored = true,
          follow = true,
        },

        explorer = {
          enabled = false,
          focus = false,
          hidden = true,
          ignored = true,

          icons = {
            tree = {
              vertical = "  ",
              middle = "  ",
              last = "  ",
            },
          },

          layout = {
            preset = "sidebar",

            layout = {
              width = 27,
              min_width = 10,
              position = "left",
            },
            hidden = { "input" },
            auto_hide = { "input" },
          },
        },
      },
    },

    dashboard = {
      enabled = true,
      preset = {
        header = {
          [[                                                    
     ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓
     ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒
    ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░
    ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██ 
    ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒
    ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░
    ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░
       ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░   
             ░    ░  ░    ░ ░        ░   ░         ░   
                                    ░                  
          ]],
        },
      },
    },
  },
}
