local IPvCC = {interfaces={}}

function IPvCC.checkInterfaces()
    for _, side in pairs(rs.getSides()) do
        if peripheral.getType(side) == "modem" then
            local ModemInterface = require "IPvCC.types.ModemInterface"
            IPvCC.interfaces[side] = ModemInterface:new(side)
        end
    end
end

function IPvCC.deleteInterfaceFiles()
    for _, side in pairs(rs.getSides()) do
        if peripheral.getType(side) == "modem" then
            local statsPath = "/sys/class/net/"..side.."/"
            fs.delete(statsPath.."/stats")
        end
    end
end


function IPvCC.is_instance(o, class)
    while o do
        o = o.metatable
        if class.metatable == o then return true end
    end
    return false
end


return IPvCC