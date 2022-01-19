function collision(obj1, obj2)
	local left,right = obj1,obj2
	local up,down = obj1,obj2
	if obj1.x1 > obj2.x1 then left,right = right,left end
	if obj1.y1 > obj2.y1 then up,down = down,up end
	if left.x2 < right.x1 then return false end
	if up.y2 < down.y1 then return false end
	return true
end

function anyCollisions(obj1, objs)
	for _,obj in pairs(objs) do
		if collision(obj1, obj) then return true end
	end
	return false
end

function initConstants()
	t=0
	labels = {
		enr="Ener", clm="Calm", brd="Boredom",
		dpf="DiaperFullness", hpy="Happ"
	}
	meterFields = {"enr", "clm", "hpy"}
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

function initState()
	s = {}

	local baby = {enr=100, clm=100, brd=0, dpf=0, asleep=false, sleptAt=0}
	baby.meterFields = {"enr", "clm", "dpf", "brd"}
	setmetatable(baby, {
		__index=function(table,key)
			if key=="hpy" then
				return 100 - math.min(100, table.brd + table.dpf)
			end
			return nil
		end
	})

	local parent = {enr=100, clm=100, hpy=100}
	parent.meterFields = {"enr", "clm", "hpy"}
	parent.loc = {x=100,y=100,ospr=304,spr=304,sc=2,w=2,h=2,flip=0}

	function parent.draw(self)
		local l = self.loc
		spr(l.spr,l.x,l.y,0,l.sc,l.flip,0,l.w,l.h)
	end

	function parent.mv(self, dx, dy)
		local l = self.loc
		local x,y=l.x+dx,l.y+dy
		local pbloc = {x1=x+6*l.sc,y1=y+14*l.sc,x2=x+10*l.sc,y2=y+16*l.sc}
		if not anyCollisions(pbloc, blocs) then
			l.x=math.max(0, math.min(l.x+dx, 210))
			l.y=math.max(10, math.min(l.y+dy, 100))
		end
		l.spr = l.ospr + ((t//10)%2 + 1)*2
		if dx==-1 then l.flip=1 elseif dx==1 then l.flip=0 end
	end

	function adjMetric(self,metric,val)
		local nval = self[metric]+val
		nval = math.max(0,math.min(100,nval))
		self[metric]=nval
	end

	baby.adj=adjMetric
	parent.adj=adjMetric

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

	local garbageTruck = {
		present = false,
		arrivedAt = 0
	}

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

	s.b = baby
	s.p = parent
	s.m = menu
	s.r = resources
	s.g = garbageTruck
	s.n = notifications
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
			s.b:adj("dpf",-30)
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
			s.b:adj("clm",100)
			s.p:adj("enr",-10)
		end
		function actions.sleepb()
			s.b:adj("clm",100)
			s.p:adj("enr",-20)
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
		s.b:adj("dpf",30)
		s.b.poopedat=t
	end
	function events.garbCome()
		s.g.present=true
		s.g.arrivedAt=t
	end
	function events.garbGo()
		s.g.present=false
	end
	function babyWakeUp()
		s.b.asleep=false
	end

end

function initLocs()
	locs = {}
	blocs = {}
	locs.work = {x=200,y=15,w=2,h=2,s=282,sc=2,rt=16}
	locs.groc = {x=10,y=15,w=2,h=2,s=278,sc=2,rt=16}
	locs.stove = {x=110,y=15,w=2,h=2,s=284,sc=2,rt=16}
	locs.trash = {x=20,y=116,w=2,h=2,s=274,sc=1,rt=16}
	locs.baby = {x=200,y=116,w=2,h=2,s=272,sc=1,rt=12}
	for _,props in pairs(locs) do
		table.insert(blocs,{
			x1=props.x,
			y1=props.y,
			x2=props.x+props.rt*props.sc,
			y2=props.y+props.h*props.sc*8
		})
	end
end

function init()
	initConstants()
	initState()
	initActions()
	initEvents()
	initLocs()
end

init()

-----------------------------------------------------------------

function animResets()
	s.p.loc.spr=s.p.loc.ospr
end

function updateTimeBasedStats()
	s.p:adj("enr",-30/ticsPerHour)
	s.p:adj("hpy",-10/ticsPerHour)
	s.p:adj("clm",-10/ticsPerHour)
	s.b:adj("enr",-50/ticsPerHour)
	if s.b.asleep then
		s.b:adj("clm", 30/ticsPerHour)
	else
		s.b:adj("clm", -20/ticsPerHour)
		s.b:adj("brd", 30/ticsPerHour)
	end
end

function fireEvent(event, notification)
	event()
	s.n:push(notification)
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

function drawResources()
	--local x=200
	--local y=0
	--for k,v in pairs(s.r) do
		--sprint(k.."="..v,x,y,10)
		--y=y+8
	--end
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
	spr(256,100,0,0)
	sprint(timestamp(),110,1,colors.label)
end

function drawLocs()
	for locName,props in pairs(locs) do
		spr(props.s,props.x,props.y,0,props.sc,0,0,props.w,props.h)
	end
end

function drawNotifications()
	local x,y = 100,50
	for item in s.n:iter() do
		sprint(item.ts.." "..item.msg,x,y,5)
		y=y+8
	end
end

function draw()
	cls()
  map()
	drawResources()
	drawClock()
	drawLocs()
	s.p:draw()
	drawMenu()
	drawNotifications()
end

------------------------------------------------------------------

function TIC()
	update()
	draw()
end
