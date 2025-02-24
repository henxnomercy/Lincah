-- File: src/runtime/mtk.lua
local mtk = {}

function mtk.tambah(a, b)
    return a + b
end

function mtk.kurang(a, b)
    return a - b
end

function mtk.kali(a, b)
    return a * b
end

function mtk.bagi(a, b)
    if b == 0 then
        error("Pembagian dengan nol!")
    end
    return a / b
end

function mtk.pangkat(a, b)
    return a ^ b
end

function mtk.mod(a, b)
    return a % b
end

function mtk.sin(a)
    return math.sin(a)
end

function mtk.cos(a)
    return math.cos(a)
end

function mtk.tan(a)
    return math.tan(a)
end

return mtk
