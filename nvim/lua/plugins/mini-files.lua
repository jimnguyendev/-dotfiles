return {
  "nvim-mini/mini.files",
  opts = {
    mappings = {
      go_in = "l",
      go_in_plus = "L",
      go_out = "h",
      go_out_plus = "H",
    },
  },
  config = function(_, opts)
    require("mini.files").setup(opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "MiniFilesBufferCreate",
      callback = function(args)
        local buf_id = args.data.buf_id
        -- Force 'l' to go_in (override LazyVim's gj mapping)
        vim.keymap.set("n", "l", function()
          require("mini.files").go_in({ close_on_file = true })
        end, { buffer = buf_id, desc = "Go in / Open file" })

        -- Force Enter to go_in
        vim.keymap.set("n", "<CR>", function()
          require("mini.files").go_in({ close_on_file = true })
        end, { buffer = buf_id, desc = "Open file" })
      end,
    })
  end,
}
