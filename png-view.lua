local component = require("component")
local computer = require("computer")
local internet = require("internet") 
local fs = require("filesystem") 
local gpu = component.gpu
local w, h = gpu.getResolution()
local png = require("png")
local imgPath = ".dload.png"
local serialization = require("serialization")

local args = {...}
-- local url = args[1] or "http://hydra-media.cursecdn.com/minecraft.gamepedia.com/0/03/Grid_Cobblestone.png?version=9c40e554c7fedeb09915273311398b2f"
local url = args[1] or "http://sportstradinglife.com/wp-content/uploads/2015/08/betfair-what-if-150x100.png"
local startX = args[2] or 1
local startY = args[3] or 1

local function clear()
    gpu.fill(1, 1, w, h, " ")
end

local function resetPalette()
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
end   

local function dload(url, path)
    local file = io.open(path, "w")
    for chunk in internet.request(url) do
        file:write(chunk)
    end
    file:close()
end

local function DEC_HEX(IN)
    local B, K, OUT, I, D = 16, "0123456789ABCDEF", "", 0

    while IN>0 do
        I = I + 1
        IN, D = math.floor(IN/B), (IN%B)+1
        OUT = string.sub(K,D,D)..OUT
    end
    if (OUT == "") then
        OUT = "0"
    end

    return tonumber(OUT, 16)
end

local function toHex(pixel)
    return DEC_HEX(pixel.R) * 0x10000 + DEC_HEX(pixel.G) * 0x100 + DEC_HEX(pixel.B)
end

local oddPixels
local function draw2(rowNum, rowTotal, rowPixels)
    if ((rowNum % 2) == 1) then
        oddPixels = rowPixels
    else
        for pixelNum, pixel in pairs(rowPixels) do
            local x = pixelNum + startX - 1
            local y = rowNum + startY - 1
            gpu.setForeground(toHex(oddPixels[pixelNum]))
            gpu.setBackground(toHex(pixel))
            gpu.fill(x, y/2, 1, 1, "▀")
        end
        oddPixels = nil
    end      
end

local function render(path)
    clear()
    local img = png(path, draw2, true)
    resetPalette()
    print("Free Memory: "..computer.freeMemory())
    -- clear()
end

dload(url, imgPath)
render(imgPath)
