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
		yellow=4,
		white=12,
		menuItem=10,
		menuItemSelected=9,
		menuItemText=12,
		menuItemProgress=6,
		textShadow=0,
	}
	ticsPerHour=3600 -- starting speed, 1 tic = 1 sec
	costs = {diaps=30,groc=50}
end

function initResources()
	res = {
		money=50,
		groc=2,
		diap=2,
		trash=2
	}
end

function initState()
	s = {}
	s.go = false -- game over
	s.goAt = 0
	s.activeObj = nil
	s.recalcTrigs = true
	s.mode = "normal"
end

function initMenu()
	menu = Menu:new()
end

function initPlayers()
	players = {}
	players.baby = initBaby()
	players.parent = initParent()
end

function initObjs()
	objs = {}
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
	initResources()
	initState()
	initMenu()
	initPlayers()
	initObjs()
	initTriggers()
end

init()

-----------------------------------------------------------------

function animResets()
	players.parent.loc.spr=players.parent.loc.ospr
end

function gameOver()
	s.go = true
	s.goAt = t
end

function updateLiveliness()
	local babySad = players.baby:sad()
	if babySad and not s.go then
		gameOver()
		notify(babySad)
	end
end

function updateTimeBasedStats()
	players.baby:updateTimeBasedStats()
end

function notify(notification)
	s.notification = notification
	s.notificationAt = t
end

function fireEvents()
	players.baby:fireEvents()
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
		local returnControl = menu:handleKeys()
		if not returnControl then return end
	end
	players.parent:handleKeys()
end

function calcActiveObj()
	local prevActive = s.activeObj

	s.activeObj = nil

	for playerName,player in pairs(players) do
		if playerName ~= "parent" then
			if isAdjacent(player:calcBloc(), players.parent:fullBloc()) then
				s.activeObj = playerName
			end
		end
	end

	local parentBloc = players.parent:calcBloc()
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
		menu:empty()
		for tname, trigger in pairs(triggers[s.activeObj]) do
			if trigger:triggered() then
				menu:add(trigger.action)
			end
		end
		if #menu.actions > 0 then
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
	handleKeys()
	if s.go then return end
	animResets()
	updateLiveliness()
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

function drawPlayers()
	players.baby:draw(s.activeObj == "baby")
	players.parent:draw()
end

function drawResources()
	-- diapers
	spr(260,objs.dshelf.loc.x+1,objs.dshelf.loc.y+1,0) -- on shelf
	print("x"..res.diap, objs.dshelf.loc.x+11,objs.dshelf.loc.y+2, 15, false, 1, false)
	spr(260,objs.dstore.loc.x+20,objs.dstore.loc.y+15,0) -- on shop
	print("$", objs.dstore.loc.x+6,objs.dstore.loc.y+12,colors.white,false,1,false)
	print(costs.diaps, objs.dstore.loc.x+5,objs.dstore.loc.y+18,colors.white,true,1,true)

	-- grocs
	spr(268,objs.gshelf.loc.x+5,objs.gshelf.loc.y+1,0) -- on shelf
	print("x"..res.groc, objs.gshelf.loc.x+11,objs.gshelf.loc.y+2, 15, false, 1, false)
	spr(268,objs.gstore.loc.x+22,objs.gstore.loc.y+14,0) -- on shop
	print("$", objs.gstore.loc.x+6,objs.gstore.loc.y+12,colors.white,false,1,false)
	print(costs.groc, objs.gstore.loc.x+5,objs.gstore.loc.y+18,colors.white,true,1,true)
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
	print("GAME OVER", 92, 64, 5*(t/10%3))
	print("Score: "..s.goAt,92, 72, 5*(t/10%3))
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
	drawPlayers()
	if s.mode == "menu" then
		menu:draw()
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
