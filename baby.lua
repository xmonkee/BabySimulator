require "utils"

function initConstants()
	t=0
	colors={
		label=12,
		meter=5,
		background=15,
		menuItem=10,
		selectedMenuItem=9,
		menuItemText=12,
		textShadow=0,
	}
	ticsPerSecond=0.3 --actually it's 60, game is sped up by 60x
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

	function baby.draw(self)
		local loc = self.loc
		local flip = t//240%2
		local function drawBaby()
			spr(loc.spr,loc.x,loc.y,0,loc.sc,flip,0,loc.w,loc.h)
		end
		local isRed = self:happ() <= 0 or
			(self:happ() <= 20 and (t//20%2) == 0)
		if isRed then withSwap(4,3,drawBaby) else drawBaby() end

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
	local parent = makeObj({x=100,y=100,ospr=304,spr=304,sc=2,w=2,h=2,flip=0})
	parent.props = {enr=100, clm=100, hpy=100}

	function parent.draw(self)
		local l = self.loc
		spr(l.spr,l.x,l.y,0,l.sc,l.flip,0,l.w,l.h)
	end

	function parent.mv(self, dx, dy)
		local l = self.loc
		local x,y=l.x+dx,l.y+dy
		local pbloc = {x1=x+6*l.sc,y1=y+14*l.sc,x2=x+10*l.sc,y2=y+16*l.sc}
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

function initMenu()
	local menu = {
		shown=false,
		items={
			{"work", "Work"},
			{"buyd", "Buy diapers"},
			{"buyf", "Buy food"}, {"garb", "Put out garbage"},
			{"changed", "Change diaper"},
			{"cook", "Cook food"},
			{"feed", "Feed baby"},
			{"sleepb", "Sleep baby"},
			{"play", "Play with baby"},
			{"eat", "Eat a meal"},
			{"sleep", "Take a nap"},
			{"soc", "Socialize"}
		},
		selected=1,
		inc=function(self)
			self.selected = math.min(#self.items, self.selected+1)
		end,
		dec=function(self)
			self.selected = math.max(1, self.selected-1)
		end
	}
	return menu
end

function initResources()
	local resources = {
		money=100,
		food=100,
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

function initNotifications()
	local notifications = {first=nil, size=0, last=nil}
	function notifications.push(self, notification)
		self.size = self.size + 1
		if self.first == nil then
			self.first = {msg=notification,ts=timestamp()}
			self.last = self.first
		else
			self.first = {
				msg=notification,
				ts=timestamp(),
				nxt=self.first
			}
			self.first.nxt.prev=self.first
		end
		while self.size > 5 do
			self.last = self.last.prev
			self.last.nxt = nil
			self.size = self.size - 1
		end
	end

	function notifications.iter(self)
		local curr = self.first
		return function()
			if curr ~= nil then
				local ret = curr
				curr = curr.nxt
				return ret
			end
		end
	end

	return notifications
end

function initState()
	s = {}
	s.b = initBaby()
	s.p = initParent()
	s.m = initMenu()
	s.r = initResources()
	s.g = {here=false,arrivedAt=0}
	s.n = initNotifications()
	s.go = false -- game over
end

function initActions()
	actions = {}
		function actions.work()
			s.r.money = s.r.money + 20
			s.p:adj("enr",-10)
		end
		function actions.buyd()
			s.r:adj("money", -10)
			s.r:adj("diap", 10)
		end
		function actions.buyf()
			s.r:adj("food",30)
			s.r:adj("money",-10)
		end
		function actions.garb()
			s.r:adj("trash",-s.r.trash)
		end
		function actions.changed()
			s.r:adj("diap",-1)
			s.r:adj("trash",10)
			s.b.props.poops=0
		end
		function actions.cook()
			s.r:adj("food",-10)
			s.r:adj("trash",20)
			s.p:adj("enr",-10)
		end
		function actions.feed()
			s.b:adj("enr",100)
		end
		function actions.bath()
			s.b:adj("sleepy",100)
			s.p:adj("enr",-10)
		end
		function actions.sleepb()
			s.p:adj("enr",-20)
			s.b:sleep()
		end
		function actions.play()
			s.b:adj("brd",-30)
			s.p:adj("enr",-10)
		end
		function actions.eat()
			s.p:adj("enr",50)
		end
		function actions.sleep()
			s.p:adj("clm",100)
		end
		function actions.soc()
			s.p:adj("hpy",50)
		end

	for i,item in pairs(s.m.items) do
		if actions[item[1]] == nil then
			error("action "..k.."not found")
		end
	end
end

function initEvents()
	events = {}
	function events.poop()
		s.b:adj("poops",1)
		s.b.poopedAt=t
	end
	function events.garbCome()
		s.g.present=true
		s.g.arrivedAt=t
	end
	function events.garbGo()
		s.g.present=false
	end
	function events.babyWakeUp()
		s.b:awake()
	end

end

function initObjs()
	objs = {}
	objs.work = makeObj({x=200,y=15,w=2,h=2,spr=282,sc=2})
	objs.groc = makeObj({x=10,y=15,w=2,h=2,spr=278,sc=2})
	objs.stove = makeObj({x=110,y=15,w=2,h=2,spr=284,sc=2})
	objs.trash = makeObj({x=20,y=116,w=2,h=2,spr=274,sc=1})
	objs.baby = s.b
end

function init()
	initConstants()
	initState()
	initActions()
	initEvents()
	initObjs()
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
	s.p:adj("clm",-10/ticsPerHour)
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
	s.n:push(notification)
end

function updateEvents()
	if math.random() < 10/(3*ticsPerHour) then
		fireEvent(events.poop, "Baby Pooped")
	end
	if math.random() < 1/(3*ticsPerHour) then
		if s.b.asleep then
			fireEvent(events.babyWakeUp, "Baby Woke Up")
		end
	end
end

function readKeys()
	if s.m.shown then
		if btnp(0,60,5) then s.m:dec() end
		if btnp(1,60,5) then s.m:inc() end
		if btnp(4,60,5) then
			actions[s.m.items[s.m.selected][1]]()
			s.m.shown=false
		end
	else
		if btn(0) then s.p:mv(0,-1) end
		if btn(1) then s.p:mv(0, 1) end
		if btn(2) then s.p:mv(-1,0) end
		if btn(3) then s.p:mv( 1,0) end
	end
	if btnp(4,60,5) and not s.m.shown then s.m.shown=true end
	if btnp(5,60,5) and s.m.shown then s.m.shown=false end
end

function update()
	t=t+1
	minute=(t/ticsPerMinute) % 60
	hour=(t/ticsPerHour) % 24
	animResets()
	if s.go then return end
	updateLiveliness()
	updateTimeBasedStats()
	updateEvents()
	readKeys()
end

---------------------------------------------------------------

function sprint(msg,x,y,color)
	print(msg,x+1,y+1,colors.textShadow,true,1,true)
	return print(msg,x,y,color,true,1,true)
end

function drawMenu()
	if not s.m.shown then return end
	function drawItem(item,x,y,selected)
		local color = colors.menuItem
		if selected then color = colors.selectedMenuItem end
		rect(x,y,61,10,color)
		sprint(item[2],x+1,y+1,colors.menuItemText)
	end
	local x=130
	local ys=10
	for i,item in pairs(s.m.items) do
		local y=ys+i*8
		drawItem(item, x, y,s.m.selected==i)
	end
end

function drawMeter(person, label, startx, starty)
	print(label, startx, starty, colors.label)
	for i,field in pairs(person.meterFields) do
		local x=startx
		local y = starty + (i)*8
		x = x + sprint(labels[field],x,y,colors.label) + 1
		rectb(x,y,24,7,colors.label)
		rect(x+2,y+2,person[field]/20*4,3, colors.meter)
	end
end

function drawMeters()
	drawMeter(s.b, "Baby", 0, 0)
	drawMeter(s.p, "Mom", 0, 35)
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
	for _,obj in pairs(objs) do
		obj:draw()
		if isAdjacent(obj.bloc, s.p:calcBloc()) then
			obj:draw(true)
		end
	end
end

function drawNotifications()
	local x,y = 100,50
	for item in s.n:iter() do
		sprint(item.ts.." "..item.msg,x,y,5)
		y=y+8
	end
end

function drawGameOver()
	if s.go then
		rect(80,52,80,40,0)
		print("GAME OVER", 92, 70, 5*(t/10%3))
	end
end

function draw()
	cls()
  map()
	drawClock()
	drawObjs()
	s.p:draw()
	drawMenu()
	--drawNotifications()
	drawGameOver()
end

------------------------------------------------------------------

function TIC()
	update()
	draw()
end
