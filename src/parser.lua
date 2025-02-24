-- File: src/parser.lua
local Parser = {}
Parser.__index = Parser

function Parser.new(tokens)
    local self = setmetatable({}, Parser)
    self.tokens = tokens
    self.position = 1
    return self
end

-- Mengembalikan AST berupa daftar statement
function Parser:parse()
    local ast = {}
    while self.position <= #self.tokens do
        local stmt = self:parseStatement()
        if stmt then
            table.insert(ast, stmt)
        end
    end
    return ast
end

function Parser:parseStatement()
    local token = self.tokens[self.position]
    if not token then return nil end
    if token.type == "NILAI" then
        return self:parseVariable()
    elseif token.type == "FUNGSI" then
        return self:parseFunction()
    elseif token.type == "KELAS" then
        return self:parseClass()
    elseif token.type == "JIKA" then
        return self:parseIf()
    elseif token.type == "ULANGI" then
        return self:parseLoop()
    elseif token.type == "CETAK" then
        return self:parsePrint()
    elseif token.type == "GOROUTINE" then
        return self:parseGoroutine()
    else
        self.position = self.position + 1
        return nil
    end
end

function Parser:parseVariable()
    self.position = self.position + 1 -- consume 'nilai'
    local name = self.tokens[self.position].value
    self.position = self.position + 1 -- consume identifier
    self.position = self.position + 1 -- consume '='
    local value = self:parseExpression()
    return { type = "VARIABLE", name = name, value = value }
end

function Parser:parseFunction()
    self.position = self.position + 1 -- consume 'fungsi'
    local name = self.tokens[self.position].value
    self.position = self.position + 1 -- consume identifier
    local params = {} -- Parsing parameter bisa ditambahkan di sini
    local body = self:parseBlock()
    return { type = "FUNGSI", name = name, params = params, body = body }
end

function Parser:parseClass()
    self.position = self.position + 1 -- consume 'kelas'
    local name = self.tokens[self.position].value
    self.position = self.position + 1 -- consume identifier
    local body = self:parseBlock()
    return { type = "KELAS", name = name, body = body }
end

function Parser:parseIf()
    self.position = self.position + 1 -- consume 'jika'
    local condition = self:parseExpression()
    local thenBlock = self:parseBlock()
    local elseBlock = nil
    if self.tokens[self.position] and self.tokens[self.position].type == "LAIN" then
        self.position = self.position + 1 -- consume 'lain'
        elseBlock = self:parseBlock()
    end
    return { type = "JIKA", condition = condition, thenBlock = thenBlock, elseBlock = elseBlock }
end

function Parser:parseLoop()
    self.position = self.position + 1 -- consume 'ulangi'
    local condition = self:parseExpression()
    local block = self:parseBlock()
    return { type = "ULANGI", condition = condition, block = block }
end

function Parser:parsePrint()
    self.position = self.position + 1 -- consume 'cetak'
    local value = self:parseExpression()
    return { type = "CETAK", value = value }
end

function Parser:parseGoroutine()
    self.position = self.position + 1 -- consume 'goroutine'
    local body = self:parseBlock()
    return { type = "GOROUTINE", body = body }
end

function Parser:parseBlock()
    local block = {}
    while self.position <= #self.tokens and self.tokens[self.position].type ~= "END" do
        local stmt = self:parseStatement()
        if stmt then
            table.insert(block, stmt)
        end
    end
    self.position = self.position + 1 -- consume 'END'
    return block
end

-- Parsing ekspresi dengan prioritas operator sederhana
function Parser:parseExpression()
    return self:parseAddition()
end

function Parser:parseAddition()
    local expr = self:parseMultiplication()
    while self.position <= #self.tokens and self.tokens[self.position].type == "SYMBOL" and 
          (self.tokens[self.position].value == "+" or self.tokens[self.position].value == "-") do
        local op = self.tokens[self.position].value
        self.position = self.position + 1
        local right = self:parseMultiplication()
        expr = { type = "BINARY", operator = op, left = expr, right = right }
    end
    return expr
end

function Parser:parseMultiplication()
    local expr = self:parsePrimary()
    while self.position <= #self.tokens and self.tokens[self.position].type == "SYMBOL" and 
          (self.tokens[self.position].value == "*" or self.tokens[self.position].value == "/") do
        local op = self.tokens[self.position].value
        self.position = self.position + 1
        local right = self:parsePrimary()
        expr = { type = "BINARY", operator = op, left = expr, right = right }
    end
    return expr
end

function Parser:parsePrimary()
    local token = self.tokens[self.position]
    if token.type == "BILANGAN" or token.type == "TEKS" then
        self.position = self.position + 1
        return { type = token.type, value = token.value }
    elseif token.type == "IDENTIFIER" then
        self.position = self.position + 1
        return { type = "IDENTIFIER", value = token.value }
    elseif token.type == "SYMBOL" and token.value == "(" then
        self.position = self.position + 1
        local expr = self:parseExpression()
        if self.tokens[self.position] and self.tokens[self.position].type == "SYMBOL" and self.tokens[self.position].value == ")" then
            self.position = self.position + 1
        else
            error("Expected )")
        end
        return expr
    end
    error("Unexpected token in expression: " .. token.value)
end

return Parser
