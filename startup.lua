fs.delete("/IPvCC")

local function getRunningPath()
    local runningProgram = shell.getRunningProgram()
    local programName = fs.getName(runningProgram)
    return runningProgram:sub( 1, #runningProgram - #programName )
end

IPvCC = require "IPvCC"
IPvCC.deleteInterfaceFiles()

fs.copy(getRunningPath().."/IPvCC", "/IPvCC")

shell.setAlias("ifconfig", "/"..getRunningPath().."/ifconfig.lua")