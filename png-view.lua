local component = require("component")
local computer = require("computer")
local internet = require("internet") 
local fs = require("filesystem") 
local gpu = component.gpu
local w, h = gpu.getResolution()
local png = require("png")

local args = {...}
local url = args[1] or "http://hydra-media.cursecdn.com/minecraft.gamepedia.com/0/03/Grid_Cobblestone.png?version=9c40e554c7fedeb09915273311398b2f"
local startX = args[2] or 1
local startY = args[3] or 1

local function clear()
    gpu.fill(1, 1, w, h, " ")
end

local function resetPalette()
    gpu.setBackground(0x000000)
    gpu.setForeground(0xFFFFFF)
end   

local function draw(img)
    clear()
    local x = 0
    local y = 0
    for rowNum = 1, img.height do
        x = rowNum + startX - 1
        if ((x%2) == 0) then
            for pixelNum = 1, img.width do
                y = pixelNum + startY - 1
                gpu.setForeground(img:getPixel(rowNum-1, pixelNum):toHex())
                gpu.setBackground(img:getPixel(rowNum, pixelNum):toHex())
                gpu.fill(x, y, 1, 1, "▀")
            end
        end
    end
    resetPalette()
end

local function renderPng(url)
    file = io.open("dload.png", "w")
    for chunk in internet.request(url) do
        file:write(chunk)
    end
    file:close()

    local img = png("dload.png")
    draw(img)

    fs.remove("dload.png")
end

renderPng(url)
