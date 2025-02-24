-- File: src/interpreter.lua
local Saluran = require("src.runtime.saluran")

local Interpreter = {}
Interpreter.__index = Interpreter

function Interpreter.new()
    local self = setmetatable({}, Interpreter)
    self.variables = {}
    self.functions = {}
    self.classes = {}
    self.channels = {}
    return self
end

function Interpreter:run(ast)
    for _, node in ipairs(ast) do
        self:executeStatement(node)
    end
end

function Interpreter:executeStatement(node)
    if node.type == "VARIABLE" then
        self.variables[node.name] = self:evaluate(node.value)
    elseif node.type == "FUNGSI" then
        self.functions[node.name] = node
    elseif node.type == "KELAS" then
        self.classes[node.name] = node
    elseif node.type == "CETAK" then
        print(self:evaluate(node.value))
    elseif node.type == "GOROUTINE" then
        self:runGoroutine(node.body)
    elseif node.type == "JIKA" then
        if self:evaluate(node.condition) then
            self:executeBlock(node.thenBlock)
        elseif node.elseBlock then
            self:executeBlock(node.elseBlock)
        end
    elseif node.type == "ULANGI" then
        while self:evaluate(node.condition) do
            self:executeBlock(node.block)
        end
    else
        -- Handling node lainnya dapat ditambahkan di sini
    end
end

function Interpreter:executeBlock(block)
    for _, stmt in ipairs(block) do
        self:executeStatement(stmt)
    end
end

function Interpreter:evaluate(node)
    if node.type == "BILANGAN" then
        return node.value
    elseif node.type == "TEKS" then
        return node.value
    elseif node.type == "IDENTIFIER" then
        return self.variables[node.value]
    elseif node.type == "BINARY" then
        local left = self:evaluate(node.left)
        local right = self:evaluate(node.right)
        if node.operator == "+" then
            return left + right
        elseif node.operator == "-" then
            return left - right
        elseif node.operator == "*" then
            return left * right
        elseif node.operator == "/" then
            return left / right
        else
            error("Operator tidak dikenal: " .. node.operator)
        end
    end
    return nil
end

function Interpreter:runGoroutine(body)
    local co = coroutine.create(function()
        local interp = Interpreter.new()
        interp:executeBlock(body)
    end)
    coroutine.resume(co)
end

return Interpreter
