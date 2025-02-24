-- File: src/lexer.lua
local Lexer = {}
Lexer.__index = Lexer

function Lexer.new(source)
    local self = setmetatable({}, Lexer)
    self.source = source
    self.position = 1
    self.length = #source
    return self
end

function Lexer:peek()
    return self.source:sub(self.position, self.position)
end

function Lexer:advance()
    local ch = self:peek()
    self.position = self.position + 1
    return ch
end

function Lexer:tokenize()
    local tokens = {}
    while self.position <= self.length do
        local ch = self:peek()
        if ch:match("%s") then
            self:advance()
        elseif ch:match("%d") then
            table.insert(tokens, self:tokenizeNumber())
        elseif ch == '"' then
            table.insert(tokens, self:tokenizeString())
        elseif ch:match("[%a_]") then
            table.insert(tokens, self:tokenizeIdentifier())
        else
            table.insert(tokens, { type = "SYMBOL", value = self:advance() })
        end
    end
    return tokens
end

function Lexer:tokenizeNumber()
    local num = ""
    while self.position <= self.length and self:peek():match("%d") do
        num = num .. self:advance()
    end
    return { type = "BILANGAN", value = tonumber(num) }
end

function Lexer:tokenizeString()
    local str = ""
    self:advance() -- lewati tanda kutip pembuka
    while self.position <= self.length and self:peek() ~= '"' do
        str = str .. self:advance()
    end
    self:advance() -- lewati tanda kutip penutup
    return { type = "TEKS", value = str }
end

function Lexer:tokenizeIdentifier()
    local id = ""
    while self.position <= self.length and self:peek():match("[%w_]") do
        id = id .. self:advance()
    end
    local keywords = {
        nilai = "NILAI",
        fungsi = "FUNGSI",
        kelas = "KELAS",
        jika = "JIKA",
        ulangi = "ULANGI",
        cetak = "CETAK",
        goroutine = "GOROUTINE",
        end = "END",
    }
    local tokenType = keywords[id]
    if tokenType then
        return { type = tokenType, value = id }
    else
        return { type = "IDENTIFIER", value = id }
    end
end

return Lexer
