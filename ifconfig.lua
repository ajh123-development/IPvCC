package.path = "/?/init.lua;" .. package.path
IPvCC = require("IPvCC")


IPvCC.checkInterfaces()
for id, interface in pairs(IPvCC.interfaces) do
    print(id, "Link encap:", interface.layer.type, interface.infoString)
end