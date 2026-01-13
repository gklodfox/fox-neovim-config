
local M = {'let-def/texpresso.vim'}

function M.config(_, _)
    require("texpresso").texpresso_path ="/home/foxy/.sources/texpresso/build/texpresso"
end

return M
