IPvCC = require("IPvCC")
local one = IPvCC.types.Packable:new("1", IPvCC.types.Packable:new("2", {msg="Hello"}, {}), {})
local table = one:toTable()
local table2 = IPvCC.PackableFromTable(table):toTable()

print(textutils.serialise(table))
print(textutils.serialise(table2))
if textutils.serialise(table2) == textutils.serialise(table) then
    print("MATCHED!")
end