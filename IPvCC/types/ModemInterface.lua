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

    local statsPath = "/sys/class/net/"..self.side
    if fs.exists(statsPath.."/stats") then
        local h = fs.open(statsPath.."/stats", "r")
        local stats = textutils.unserialiseJSON(h.readAll())
        h.close()
        if stats ~= nil then
            self.tx = stats.tx
            self.rx = stats.rx
        end
    end

    self:update()
end

function ModemInterface:update()
    self.infoString = [[

        id ]]..os.getComputerID()..[[

        RX packets:]]..self.rx..[[      
        TX packets:]]..self.tx..[[   
        ]]

    local statsPath = "/sys/class/net/"..self.side
    fs.makeDir(statsPath)
    local h = fs.open(statsPath.."/address", "w")
    h.write(os.getComputerID())
    h.close()
    h = fs.open(statsPath.."/stats", "w")
    h.write(textutils.serialiseJSON({rx=self.rx, tx=self.tx}))
    h.close()
end

function ModemInterface:open(port)
    self.modem.open(port)
end
function ModemInterface:close(port)
    self.modem.close(port)
end

return ModemInterface