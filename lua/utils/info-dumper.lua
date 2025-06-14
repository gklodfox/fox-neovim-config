local InfoDumper = {}
InfoDumper.__index = InfoDumper

function InfoDumper.new()
    local cls = setmetatable({}, InfoDumper)

    cls.runtimePath = vim.opt.runtimePath

    return cls
end

return InfoDumper
