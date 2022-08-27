local Class = require "IPvCC.class"
local Interface = require "IPvCC.types.Interface"

ModemInterface = Class:new(Interface)

function ModemInterface:__new(side)
    local ModemLayer = require "IPvCC.types.ModemLayer"
    self.modem = peripheral.wrap(side)
    self.layer = ModemLayer:new()
    self.layer.interface = self
    self.side = side
    self.tx = 0
    self.rx = 0
    self.errors = 0

    local statsPath = "/sys/class/net/"..self.side
    if fs.exists(statsPath.."/stats") then
        local h = fs.open(statsPath.."/stats", "r")
        local stats = textutils.unserialiseJSON(h.readAll())
        h.close()
        if stats ~= nil then
            if stats.tx ~= nil then
                self.tx = stats.tx
            end
            if stats.rx ~= nil then
                self.rx = stats.rx
            end
            if stats.errors ~= nil then
                self.errors = stats.errors
            end
        end
    end

    self.modem.open(2)
    self:update()
end

function ModemInterface:update()
    self.infoString = [[

        id ]]..os.getComputerID()..[[

        RX packets:]]..self.rx..[[
        TX packets:]]..self.tx..[[
        errors:]]..self.errors..[[
        ]]

    local statsPath = "/sys/class/net/"..self.side
    fs.makeDir(statsPath)
    local h = fs.open(statsPath.."/address", "w")
    h.write(os.getComputerID())
    h.close()
    h = fs.open(statsPath.."/stats", "w")
    h.write(textutils.serialiseJSON({rx=self.rx, tx=self.tx, errors=self.errors}))
    h.close()
end

function ModemInterface:open(port)
end
function ModemInterface:close(port)
end

return ModemInterface