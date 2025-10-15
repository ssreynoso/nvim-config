-- Fix para prevenir crash de treesitter con ventanas inválidas
local ok, highlighter = pcall(require, "vim.treesitter.highlighter")

if ok and highlighter then
  -- Proteger hl_callback si existe
  if highlighter.hl_callback then
    local original_callback = highlighter.hl_callback

    highlighter.hl_callback = function(winid, ...)
      if vim.api.nvim_win_is_valid(winid) then
        return original_callback(winid, ...)
      end
      -- evitamos crash silenciosamente
    end
  end

  -- Proteger nvim__redraw para evitar errores con ventanas inválidas
  local original_redraw = vim.api.nvim__redraw
  vim.api.nvim__redraw = function(opts)
    if opts and opts.win then
      -- Si se especifica una ventana, verificar que sea válida
      if not vim.api.nvim_win_is_valid(opts.win) then
        return -- Ignorar silenciosamente si la ventana no es válida
      end
    end
    return original_redraw(opts)
  end
end