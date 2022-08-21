IPvCC = require("IPvCC")
local one = IPvCC.types.Packable:new("1", IPvCC.types.Packable:new("2", {}, {}), {})
print(textutils.serialise(one:toTable()))