local M = {}

M.state = {
    win = nil,
    buf = nil,
}

function M.show(on_close)
    local lines = {
        "                                                                                              ",
        "                                                                                              ",
        "                                                                                              ",
        "                         `7MMF'                                                               ",
        "                           MM                                                                 ",
        "                           MM   ,pW\"Wq.  `7MM  `7MM  `7Mb,od8 `7MMpMMMb.   .gP\"Ya  `7M'   `MF'",
        "                           MM  6W'   `Wb   MM    MM    MM' \"'   MM    MM  ,M'   Yb   VA   ,V  ",
        '                           MM  8M     M8   MM    MM    MM       MM    MM  8M""""""    VA ,V   ',
        "                      (O)  MM  YA.   ,A9   MM    MM    MM       MM    MM  YM.    ,     VVV    ",
        "                       Ymmm9    `Ybmd9'    `Mbod\"YML..JMML.   .JMML  JMML. `Mbmmd'     ,V     ",
        "                                                                                      ,V      ",
        '                                                                                   OOb"      ',
        "       ",
        "                                            __         ____              ",
        "                                           / /_  ___  / __/___  ________ ",
        "                                          / __ \\/ _ \\/ /_/ __ \\/ ___/ _ \\",
        "                                         / /_/ /  __/ __/ /_/ / /  /  __/",
        "                                        /_.___/\\___/_/  \\____/_/   \\___/ ",
        "                                                                                                            ",
        "                                                                                                            ",
        "                ,,                             ,,                                 ,,                           ",
        "              `7MM                     mm      db                         mm      db                           ",
        "                MM                     MM                                 MM                                   ",
        '           ,M""bMM   .gP"Ya  ,pP"Ybd mmMMmm  `7MM  `7MMpMMMb.   ,6"Yb.  mmMMmm  `7MM   ,pW"Wq.  `7MMpMMMb.     ',
        "         ,AP    MM  ,M'   Yb 8I   `\"   MM      MM    MM    MM  8)   MM    MM      MM  6W'   `Wb   MM    MM     ",
        '         8MI    MM  8M"""""" `YMMMa.   MM      MM    MM    MM   ,pm9MM    MM      MM  8M     M8   MM    MM     ',
        "         `Mb    MM  YM.    , L.   I8   MM      MM    MM    MM  8M   MM    MM      MM  YA.   ,A9   MM    MM  ,, ",
        "          `Wbmd\"MML. `Mbmmd' M9mmmP'   `Mbmo .JMML..JMML  JMML.`Moo9^Yo.  `Mbmo .JMML. `Ybmd9'  .JMML  JMML.db     ",
        "                                                                                                               ",
    }

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local width = math.max(unpack(vim.tbl_map(function(line)
        return vim.fn.strdisplaywidth(line)
    end, lines))) + 4

    local height = #lines + 2
    local ui = vim.api.nvim_list_uis()[1]

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((ui.height - height) / 2),
        col = math.floor((ui.width - width) / 2),
        style = "minimal",
        border = "rounded",
    })

    M.state.win = win
    M.state.buf = buf

    if on_close then
        vim.api.nvim_create_autocmd("BufWipeout", {
            buffer = buf,
            once = true,
            callback = on_close,
        })
    end
end

return M
