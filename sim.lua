require "utils"
require "baby"
require "parent"
require "trash"
require "tbl"
require "triggers"

function initConstants()
	t=0
	colors={
		label=12,
		meter=5,
		menuItem=10,
		menuItemSelected=9,
		menuItemText=12,
		menuItemProgress=6,
		textShadow=0,
	}
	ticsPerHour=3600 -- starting speed, 1 tic = 1 sec

	maxPoops = 3
	costs = {diaps=30,groc=50}
end

function initResources()
	local resources = {
		money=50,
		groc=2,
		diap=2,
		trash=2
	}
	return resources
end

function initState()
	s = {}
	s.b = initBaby()
	s.p = initParent()
	s.r = initResources()
	s.go = false -- game over
	s.goAt = 0
	s.activeObj = nil
	s.recalcTrigs = true
	s.mode = "normal"
	s.menu = Menu:new()
end

function initObjs()
	objs = {}
	objs.baby = s.b
	objs.work = makeObj({x=100,y=15,w=4,h=4,spr=408,sc=1})
	objs.dshelf = makeObj({x=10,y=15,w=4,h=4,spr=404,sc=1})
	objs.gshelf = makeObj({x=56,y=15,w=4,h=4,spr=404,sc=1})
	objs.stove = makeObj({x=10,y=65,w=2,h=4,spr=341,sc=1})
	objs.dstore = makeObj({x=160,y=15,w=4,h=4,spr=400,sc=1})
	objs.gstore = makeObj({x=200,y=15,w=4,h=4,spr=400,sc=1})
	objs.tbl = initTbl()
	objs.trash = initTrash()
end

function init()
	initConstants()
	initState()
	initObjs()
	initTriggers()
end

init()

-----------------------------------------------------------------

function animResets()
	s.p.loc.spr=s.p.loc.ospr
end

function gameOver()
	s.go = true
	s.goAt = t
end

function updateLiveliness()
	local babySad = s.b:sad()
	if babySad and not s.go then
		gameOver()
		notify(babySad)
	end
end

function updateTimeBasedStats()
	s.b:updateTimeBasedStats()
end

function notify(notification)
	s.notification = notification
	s.notificationAt = t
end

function fireEvents()
	s.b:fireEvents()
	objs.trash:fireEvents()
end

function handleKeys()
	if s.go then
		if (t - s.goAt) > 120 and btn(4) then
			reset()
		end
		return
	end

	if s.mode == "menu" then
		local returnControl = s.menu:handleKeys()
		if not returnControl then return end
	end
	s.p:handleKeys()
end

function calcActiveObj()
	local prevActive = s.activeObj

	s.activeObj = nil
	local parentBloc = s.p:calcBloc()
	for objName,obj in pairs(objs) do
		if isAdjacent(obj.bloc, parentBloc) then
			s.activeObj = objName
		end
	end
	if s.activeObj ~= prevActive then
		s.recalcTrigs = true
	end
end

function calcTriggers()
	if not s.recalcTrigs then return end
	if s.activeObj == nil or triggers[s.activeObj] == nil then
		s.mode = "normal"
	else
		s.menu:empty()
		for tname, trigger in pairs(triggers[s.activeObj]) do
			if trigger:triggered() then
				s.menu:add(trigger.action)
			end
		end
		if #s.menu.actions > 0 then
			s.mode = "menu"
		else
			s.mode = "normal"
		end
	end
	s.recalcTrigs = false
end

function update()
	t=t+1
	minute=(t/ticsPerHour*60) % 60
	hour=(t/ticsPerHour) % 24
	animResets()
	updateLiveliness()
	handleKeys()
	if s.go then return end
	updateTimeBasedStats()
	calcActiveObj()
	calcTriggers()
	fireEvents()
end

---------------------------------------------------------------

function sprint(msg,x,y,color)
	print(msg,x+1,y+1,colors.textShadow,true,1,true)
	return print(msg,x,y,color,true,1,true)
end

function timestamp()
	return string.format(
		"%.2d:%.2d",
		math.floor(hour),
		math.floor(minute)
	)
end

function drawClock()
	spr(256,1,0,0)
	sprint(timestamp(),11,1,colors.label)
end

function drawObjs()
	for objName,obj in pairs(objs) do
		obj:draw(objName == s.activeObj)
	end
end

function drawResources()
	-- diapers
	spr(260,objs.dshelf.loc.x+1,objs.dshelf.loc.y+1,0)
	spr(260,objs.dstore.loc.x+20,objs.dstore.loc.y+15,0)
	print("x"..s.r.diap, objs.dshelf.loc.x+11,objs.dshelf.loc.y+2, 15, false, 1, false)

	-- grocs
	spr(268,objs.gshelf.loc.x+5,objs.gshelf.loc.y+1,0)
	spr(268,objs.gstore.loc.x+22,objs.gstore.loc.y+14,0)
	print("x"..s.r.groc, objs.gshelf.loc.x+11,objs.gshelf.loc.y+2, 15, false, 1, false)
end

function drawNotifications()
	if s.notification and
		s.notificationAt and
		(t-s.notificationAt) < 120 then
		rect(0,0,240,10,0)
		sprint(s.notification, 120-string.len(s.notification)/2*4,2,5)
	end
end

function drawGameOver()
	if not s.go then return end
	rect(80,52,80,40,0)
	print("GAME OVER", 92, 70, 5*(t/10%3))
end

function drawFps()
	local ts = tstamp()
	if ts ~= pts then
		fps = (t - (tst or 0))
		pts = ts
		tst = t
	end
	print(fps, 100, 0, 5)
end

function draw()
	cls()
  map()
	drawClock()
	drawObjs()
	drawResources()
	s.p:draw()
	if s.mode == "menu" then
		s.menu:draw()
	end
	drawNotifications()
	drawGameOver()
	--drawFps()
end

------------------------------------------------------------------

function TIC()
	update()
	draw()
end
