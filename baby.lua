require "utils"

function initConstants()
	t=0
	colors={
		label=12,
		meter=5,
		background=15,
		menuItem=10,
		menuItemSelected=9,
		menuItemText=12,
		menuItemProgress=6,
		textShadow=0,
	}
	ticsPerSecond=1 --actually it's 60, game is sped up by 60x
	ticsPerMinute=60*ticsPerSecond
	ticsPerHour=60*ticsPerMinute
end

function adjMetric(self,metric,val)
	local nval = self.props[metric]+val
	nval = math.max(0,math.min(100,nval))
	self.props[metric]=nval
end

function initBaby()
	local baby = makeObj({x=200,y=116,w=2,h=2,ospr=336,spr=336,sc=1,rt=12,lf=4})
	baby.props = {enr=100, brd=0, poops=0, sleepy=0}

	function baby.happ(self)
		local p = self.props
		return ((p.enr/100) * (100-p.brd)/100 * (3-p.poops)/3 * (100-p.sleepy)/100)*100
	end

	baby.asleep=false
	baby.sleptAt=0
	function baby.sleep(self)
		self.asleep=true
		self.loc.spr=self.loc.ospr+self.loc.w
	end

	function baby.awake(self)
		self.asleep=false
		self.loc.spr=self.loc.ospr
	end

	baby._draw = baby.draw -- original draw fn
	function baby.draw(self, isActive)
		local loc = self.loc
		local flip = t//240%2
		local function drawBaby()
			self:_draw(isActive)
		end
		local isRed = self:happ() <= 0 or
			(self:happ() <= 20 and (t//20%2) == 0)
		if isRed then
			withSwap(4,3,drawBaby)
		else
			self:_draw(isActive)
		end

		-- draw the poops
		for i=1,self.props.poops do
			spr(368,loc.x+loc.w*loc.sc*8+2,loc.y+9*(i-2),0,1,0,0,2,1)
		end
		-- Draw happ meter
		local h = math.ceil(baby:happ()/100*14)
		rectb(loc.x-4,loc.y,4,16,colors.label)
		rect(loc.x-3,loc.y+15-h,2,h,colors.meter)
	end

	baby.adj = adjMetric
	return baby
end

function initParent()
	local parent = makeObj({
		x=100,y=100,ospr=304,spr=304,sc=2,w=2,h=2,
		flip=0,lf=6,rt=10,up=14,dn=16
	})
	parent.props = {enr=100, hpy=100}
	parent._hand = nil
	function parent.emptyHanded(self)
		return self._hand == nil
	end
	function parent.hold(self, item)
		self._hand = item
	end
	function parent.drop(self, item)
		self._hand = nil
	end

	function parent.draw(self)
		local l = self.loc
		spr(l.spr,l.x,l.y,0,l.sc,l.flip,0,l.w,l.h)
	end

	function parent.handleKeys(self)
		if btn(0) then self:mv(0,-1) end
		if btn(1) then self:mv(0, 1) end
		if btn(2) then self:mv(-1,0) end
		if btn(3) then self:mv( 1,0) end
	end

	function parent.mv(self, dx, dy)
		local l = self.loc
		local x,y=l.x+dx,l.y+dy
		local pbloc = {x1=x+l.lf*l.sc,y1=y+l.up*l.sc,x2=x+l.rt*l.sc,y2=y+l.dn*l.sc}
		if not anyCollisions(pbloc, objs) then
			l.x=math.max(0, math.min(l.x+dx, 210))
			l.y=math.max(10, math.min(l.y+dy, 100))
		end
		l.spr = l.ospr + ((t//10)%2 + 1)*2
		if dx==-1 then l.flip=1 elseif dx==1 then l.flip=0 end
	end

	parent.adj = adjMetric
	return parent
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
	s.activeChanged = true
	s.mode = "normal"
end

function initObjs()
	objs = {}
	objs.work = makeObj({x=200,y=15,w=2,h=2,spr=282,sc=2})
	objs.shelf = makeObj({x=10,y=15,w=2,h=2,spr=278,sc=2})
	objs.stove = makeObj({x=110,y=15,w=2,h=2,spr=284,sc=2})
	objs.trash = makeObj({x=20,y=116,w=2,h=2,spr=274,sc=1})
	objs.trash = makeObj({x=40,y=116,w=2,h=2,spr=274,sc=1})
	objs.store = makeObj({x=10,y=50,w=2,h=2,spr=282,sc=2})
	objs.baby = s.b
end

function initTriggers()

	local emptyHand = function()
		return s.p:emptyHanded()
	end

	local resAbove = function(res, lvl)
		return function()
			return res > lvl
		end
	end

	triggers = {}

	triggers.baby = {
		Trigger{
			name="play",
			obj=objs.baby,
			conds={emptyHand},
			action=Action("Play", 1, function() s.b:adj("brd",-10) end)
		}
	}

	triggers.shelf = {
		Trigger{
			name="takeDiap",
			obj=objs.shelf,
			conds={emptyHand,resAbove(s.r.groc,0)},
			action=Action("Take Diaper", 1, function()
				s.r.diap = s.r.diap - 1
				s.p:hold("diap")
			end)
		}, Trigger{
			name="takeIngr",
			obj=objs.shelf,
			conds={emptyHand,resAbove(s.r.diap,0)},
			action=Action("Take Ingredients", 1, function()
				s.r.groc = s.r.groc - 1
				s.p:hold("ingr")
			end)
		}
	}
end

function initEvents()
	events = {}
	function events.poop()
		s.b:adj("poops",1)
		s.b.poopedAt=t
	end
	function events.babyWakeUp()
		s.b:awake()
	end
end

function init()
	initConstants()
	initState()
	initObjs()
	initTriggers()
	initEvents()
end

init()

-----------------------------------------------------------------

function animResets()
	s.p.loc.spr=s.p.loc.ospr
end

function updateLiveliness()
	if s.b:happ() <= 0 then s.go = true end
end

function updateTimeBasedStats()
	s.p:adj("enr",-30/ticsPerHour)
	s.p:adj("hpy",-10/ticsPerHour)
	s.b:adj("enr",-50/ticsPerHour)
	if s.b.asleep then
		s.b:adj("sleepy", -30/ticsPerHour)
	else
		s.b:adj("sleepy", 20/ticsPerHour)
		s.b:adj("brd", 30/ticsPerHour)
	end
end

function fireEvent(event, notification)
	event()
	s.n = notification
end

function updateEvents()
	if math.random() < 1/(3*ticsPerHour) then
		fireEvent(events.poop, "Baby Pooped")
	end
	if math.random() < 1/(3*ticsPerHour) then
		if s.b.asleep then
			fireEvent(events.babyWakeUp, "Baby Woke Up")
		end
	end
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
	s.activeChanged = s.activeObj ~= prevActive
end

function calcTriggers()
	if not s.activeChanged then return end
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
	updateEvents()
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
	--drawNotifications()
	drawGameOver()
	drawFps()
end

------------------------------------------------------------------

function TIC()
	update()
	draw()
end
