-- File: src/runtime/saluran.lua
local Saluran = {}
Saluran.__index = Saluran

function Saluran.new()
    local self = setmetatable({}, Saluran)
    self.queue = {}
    self.waiting = {}
    return self
end

function Saluran:send(value)
    table.insert(self.queue, value)
    if #self.waiting > 0 then
        local waitingCo = table.remove(self.waiting, 1)
        coroutine.resume(waitingCo)
    end
end

function Saluran:receive()
    while #self.queue == 0 do
        table.insert(self.waiting, coroutine.running())
        coroutine.yield()
    end
    return table.remove(self.queue, 1)
end

return Saluran
