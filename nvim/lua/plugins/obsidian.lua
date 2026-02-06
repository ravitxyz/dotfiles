return {
  "epwalsh/obsidian.nvim",
  version = "*",
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      {
        name = "personal",
        path = "~/Documents/ravit_personal",
      },
    },

    notes_subdir = "notes",

    daily_notes = {
      folder = "journal",
      date_format = "%Y-%m-%d",
      template = "Daily note.md",
    },

    templates = {
      folder = "templates",
      date_format = "%Y-%m-%d",
      time_format = "%H:%M",
    },

    -- Disable default frontmatter since you have your own template
    disable_frontmatter = true,

    -- Wiki-style links
    wiki_link_func = function(opts)
      return string.format("[[%s]]", opts.path)
    end,

    -- Completion
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },

    -- Follow links with gf
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url })
    end,

    -- Customize how note IDs are generated (use title as filename)
    note_id_func = function(title)
      if title ~= nil then
        return title
      else
        return tostring(os.date("%Y-%m-%d-%H%M"))
      end
    end,

    -- Customize how note paths are generated
    note_path_func = function(spec)
      local path = spec.dir / spec.id
      return path:with_suffix(".md")
    end,

    -- UI settings
    ui = {
      enable = true,
      checkboxes = {
        [" "] = { char = "☐", hl_group = "ObsidianTodo" },
        ["x"] = { char = "✔", hl_group = "ObsidianDone" },
      },
    },
  },

  keys = {
    { "<leader>zs", "<cmd>ObsidianQuickSwitch<cr>", desc = "Search notes" },
    { "<leader>zn", "<cmd>ObsidianNew<cr>", desc = "New note" },
    { "<leader>zd", "<cmd>ObsidianToday<cr>", desc = "Today's daily note" },
    { "<leader>zb", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
    { "<leader>zc", "<cmd>ObsidianToggleCheckbox<cr>", desc = "Toggle checkbox" },
    { "<leader>zt", "<cmd>ObsidianTemplate<cr>", desc = "Insert template" },
    { "<leader>zl", "<cmd>ObsidianLinks<cr>", desc = "Show links in note" },
    { "<leader>zf", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link" },
    { "gf", "<cmd>ObsidianFollowLink<cr>", desc = "Follow link", ft = "markdown" },
  },
}
