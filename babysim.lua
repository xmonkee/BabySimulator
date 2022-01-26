require "utils"
require "baby"
require "parent"
require "trash"
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
	ticsPerSecond=1 --actually it's 60, game is sped up by 60x
	ticsPerMinute=60*ticsPerSecond
	ticsPerHour=60*ticsPerMinute

	maxTrash = 5
	maxPoops = 3
	costs = {diaps=30,groc=50}
end

function initResources()
	local resources = {
		money=100,
		groc=3,
		diap=10,
		trash=0
	}
	setmetatable(resources, {
		__index={
			adj=function(self,r,val)
				self[r] = math.max(0, self[r]+val)
			end
		}
	})
	return resources
end

function initState()
	s = {}
	s.b = initBaby()
	s.p = initParent()
	s.r = initResources()
	s.go = false -- game over
	s.activeObj = nil
	s.recalcTrigs = true
	s.mode = "normal"
end

function initObjs()
	objs = {}
	objs.baby = s.b
	objs.work = makeObj({x=100,y=15,w=2,h=2,spr=282,sc=2})
	objs.dshelf = makeObj({x=10,y=15,w=2,h=2,spr=278,sc=2})
	objs.gshelf = makeObj({x=50,y=15,w=2,h=2,spr=310,sc=2})
	objs.stove = makeObj({x=10,y=65,w=2,h=2,spr=284,sc=2})
	objs.dstore = makeObj({x=200,y=15,w=2,h=2,spr=286,sc=2})
	objs.gstore = makeObj({x=160,y=15,w=2,h=2,spr=272,sc=2})
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

function updateLiveliness()
	if s.b:happ() <= 0 then
		s.go = true
		notify("Baby got too sad")
	end
	if s.r.trash > maxTrash then 
		s.go = true
		notify("Trash got too full")
	end
end

function updateTimeBasedStats()
	s.b:updateTimeBasedStats()
	s.p:updateTimeBasedStats()
end

function notify(notification)
	s.notification = notification
	s.notificationAt = t
end

function fireEvent(event, notification)
	event()
	notify(notification)
end

function fireEvents()
	s.b:fireEvents()
end

function handleKeys()
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
		s.menu = nil
	else
		local menu = Menu:new()
		for tname, trigger in pairs(triggers[s.activeObj]) do
			if trigger:triggered() then
				menu:add(trigger.action)
			end
		end
		if #menu.actions > 0 then
			s.mode = "menu"
			s.menu = menu
		else
			s.mode = "normal"
			s.menu = nil
		end
	end
	s.recalcTrigs = false
end

function update()
	t=t+1
	minute=(t/ticsPerMinute) % 60
	hour=(t/ticsPerHour) % 24
	animResets()
	updateLiveliness()
	if s.go then return end
	updateTimeBasedStats()
	calcActiveObj()
	calcTriggers()
	handleKeys()
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
	spr(256,0,0,0)
	sprint(timestamp(),10,1,colors.label)
end

function drawObjs()
	for objName,obj in pairs(objs) do
		obj:draw(objName == s.activeObj)
	end
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
	if s.go then
		rect(80,52,80,40,0)
		print("GAME OVER", 92, 70, 5*(t/10%3))
	end
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
