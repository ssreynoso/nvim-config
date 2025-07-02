local ok, highlighter = pcall(require, "vim.treesitter.highlighter")

if ok and highlighter and highlighter.hl_callback then
  local original_callback = highlighter.hl_callback

  highlighter.hl_callback = function(winid, ...)
    if vim.api.nvim_win_is_valid(winid) then
      return original_callback(winid, ...)
    end
    -- evitamos crash silenciosamente
  end
end