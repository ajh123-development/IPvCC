fs.makeDir("GuiH")
local github_api = http.get(
	"https://api.github.com/repos/9551-Dev/GuiH/git/trees/main?recursive=1",
	_G._GIT_API_KEY and {Authorization = 'token ' .. _G._GIT_API_KEY}
)

local list = textutils.unserialiseJSON(github_api.readAll())
local ls = {}
local len = 0
github_api.close()
for k,v in pairs(list.tree) do
    if v.type == "blob" and v.path:lower():match(".+%.lua") then
        ls["https://raw.githubusercontent.com/9551-Dev/GuiH/main/"..v.path] = v.path
        len = len + 1
    end
end
local percent = 100/len
local finished = 0
local size_gained = 0
local downloads = {}
for k,v in pairs(ls) do
    table.insert(downloads,function()
        local web = http.get(k)
        local file = fs.open("/tmp/GuiH/"..v,"w")
        file.write(web.readAll())
        file.close()
        web.close()
        finished = finished + 1
        local file_size = fs.getSize("/tmp/GuiH/"..v)
        size_gained = size_gained + file_size
        print("downloading "..v.."  "..tostring(math.ceil(finished*percent)).."% "..tostring(math.ceil(file_size/1024*10)/10).."kB total: "..math.ceil(size_gained/1024).."kB")
    end)
end
parallel.waitForAll(table.unpack(downloads))
print("Finished downloading GuiH")

local api = require "/tmp/GuiH"
local main = {}

local g_win = window.create(term.current(),1,1,term.getSize())
local program,w,h = ...
local args = {...}
table.remove(args,1)
table.remove(args,1)
table.remove(args,1)
w,h = (w ~= "") and w or "25",(h ~= "") and h or "15"

local gui = api.create_gui(g_win)

local frame = gui.create.frame({
    x=2,2,width=tonumber(w),height=tonumber(h),
    dragger={
        x=1,y=1,width=tonumber(w),height=1
    },
    on_move=function(object,pos)
        local term = object.canvas.term_object
        local w,h = term.getSize()
        object.window.reposition(
            math.max(
                math.min(
                    pos.x+object.positioning.width,
                    w+1
                )-object.positioning.width,1
            ),
            math.max(
                math.min(
                    pos.y+object.positioning.height,
                    h+1
                )-object.positioning.height,1
            )
        )
        object.window.restoreCursor()
        return true
    end,
    btn={true}
})

local w, h = term.getSize()
local gui = api.create_gui(g_win)
local frame = gui.create.frame({
    x=0,y=0,width=w,height=h,
    dragger={x=1,y=1,width=w,height=1}
})
local sGui = frame.child
sGui.create.button({
    x=5,y=6,width=10,height=3,
    background_color=colors.green,
    text=gui.text{
    text="Reboot",
    centered=true,
    transparent=true
    },
    on_click=function(object)
    os.reboot()
    end
})
gui.execute()

local err = gui.execute()

term.clear()
term.setCursorPos(1,1)
print("Ended window session. "..((err ~= nil) and err or ""))
term.setCursorPos(1,2)
