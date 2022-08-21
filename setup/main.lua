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

local g_win = window.create(term.current(),1,1,term.getSize())
local program,w,h = ...
local args = {...}
table.remove(args,1)
table.remove(args,1)
table.remove(args,1)
w,h = (w ~= "") and w or "25",(h ~= "") and h or "15"
local api = require("/tmp/GuiH")
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
local shown = true
local win = frame.window
local ele = frame.child
local w,h = win.getSize()
local t_win = window.create(win,2,2,w-2,h-2)

win.setCursorPos(1,1)
win.blit((" "):rep(w),("f"):rep(w),("7"):rep(w))
for i=2,h-1 do
    win.setCursorPos(1,i)
    win.blit(("\149"):rep(w),"8"..("f"):rep(w-1),"f"..("8"):rep(w-1))
end
win.setCursorPos(1,h)
win.blit("\141"..("\140"):rep(w-2).."\142",("8"):rep(w),("f"):rep(w))


t_win.clear()
local old_term = term.redirect(t_win)
local shell_coro = coroutine.create(function()
    shell.run((program ~= "") and program or "sh",unpack(args))
end)
local function update_shell()
    sleep(0.05)
    while coroutine.status(shell_coro) ~= "dead" do
        local ev_data = table.pack(os.pullEvent())
        local ev = api.convert_event(table.unpack(ev_data,1,ev_data.n))
        if api.valid_events[ev.name] then
            local x,y = win.getPosition()
            ev_data[3] = ev.x-x
            ev_data[4] = ev.y-y
        end
        if not (frame.dragged and ev_data[1] == "mouse_drag") and ev_data[1] ~= "key_up" then
            coroutine.resume(shell_coro,table.unpack(ev_data,1,ev_data.n))
        end
        local cx,cy = win.getCursorPos()
        local prg = shell.getRunningProgram():match("[^%/-]+$")
        local px,py = win.getCursorPos()
        win.setCursorPos(1,1)
        win.blit(" "..prg..(" "):rep(w-#prg-1),("0"):rep(w),("7"):rep(w))
        win.setCursorPos(px,py)
    end
end
local err = gui.execute(update_shell)
term.redirect(old_term)
term.clear()
term.setCursorPos(1,1)
print("Ended window session. "..((err ~= nil) and err or ""))
term.setCursorPos(1,2)