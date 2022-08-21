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

function IPvCC.isIPv4(ip)
    local chunks = {ip:match("(%d+)%.(%d+)%.(%d+)%.(%d+)")}
    if (#chunks == 4) then
        for _,v in pairs(chunks) do
            if (tonumber(v) < 0 or tonumber(v) > 255) then
                return 0
            end
        end
        return 1
    else
        return 0
    end
end


return IPvCC