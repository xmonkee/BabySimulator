-- title:   Baby Simulator
-- author:  Mayank Mandava, mayankmandava@gmail.com
-- desc:    Baby simulator
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

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
		local pbloc = {x1=x+5*l.sc,y1=y+14*l.sc,x2=x+10*l.sc,y2=y+16*l.sc}
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
	locs.work = {x=200,y=20,w=2,h=2,s=282,sc=2}
	locs.groc = {x=20,y=20,w=2,h=2,s=278,sc=2}
	locs.stove = {x=100,y=20,w=2,h=2,s=284,sc=2}
	locs.trash = {x=20,y=116,w=2,h=2,s=274,sc=1}
	locs.baby = {x=200,y=100,w=2,h=2,s=272,sc=2}
	for _,props in pairs(locs) do
		table.insert(blocs,{
			x1=props.x,
			y1=props.y,
			x2=props.x+props.w*props.sc*8,
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
	local x=200
	local y=0
	for k,v in pairs(s.r) do
		sprint(k.."="..v,x,y,10)
		y=y+8
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


-- <TILES>
-- 000:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 001:ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0fffffff00f
-- 002:fffffff0ffffff00fffff000ffff00fffff00fffff00fffff00fffff00ffffff
-- 003:ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0fffffff00f
-- 004:ffffffffffffffffffffffffffff0ffffff0ffffff0ffffff0ffffff0fffffff
-- 005:fffffffffffffffff0ffffffffffffffffffffffffffffffffffffffffffffff
-- 006:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 007:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 016:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff
-- 017:fffff000fffff00ffffff0ffffff0ffffff0ffffff0ffffff0ffffff0fffffff
-- 018:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff
-- 019:fffff000fffff00ffffff0ffffff0ffffff0ffffff0ffffff0ffffff0fffffff
-- 020:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0fffffffffffffffff
-- 021:fffffff0ffffffffffffffffffffffffffffffffff0fffffffffffffffffffff
-- 022:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 023:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 032:fffffff0ffffff00fffff00fffff00fffff00fffff00fffff0ffffff0fffffff
-- 033:ffffffff0fffffff00ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0f
-- 034:fffffff0ffffff00fffff00fffff0ffffff0ffffff0ffffff00fffff00ffffff
-- 035:ffffffff0ffffffff0ffffffff0fffffffffffffffffffffffffffffffffffff
-- 036:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 037:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 038:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 039:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 048:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff00fffffff0ffffffff
-- 049:fffffff0ffffff0ffffff0ffffff0ffffff0ffff000fffff00ffffff0fffffff
-- 050:f0ffffffff0ffffffffffffffffffffffffff0ffffffffffffffffffffffffff
-- 051:ffffffffffffff0fffffffffffffffffffffffffffffffffffffffff0fffffff
-- 052:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 053:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 054:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 055:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 064:fffffff0ffffff00fffff00fffff0ffffff0ffffff0ffffff00fffff00ffffff
-- 065:ffffffff0ffffffff0ffffffff0fffffffffffffffffffffffffffffffffffff
-- 066:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 067:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 068:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 069:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 070:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 071:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 080:f0ffffffff0ffffffffffffffffffffffffff0ffffffffffffffffffffffffff
-- 081:ffffffffffffff0fffffffffffffffffffffffffffffffffffffffff0fffffff
-- 082:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 083:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 084:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 085:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 086:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 087:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 096:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 097:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 098:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 099:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 100:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 101:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 102:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 103:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 112:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 113:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 114:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 115:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 116:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 117:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 118:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 119:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 128:3333333333333333333333333333333333333333333333333333333333333333
-- 129:3333333c333333cc33333ccc3333cccc333ccccc33cccccc3ccccccccccccccc
-- 130:c3333333cc333333ccc33333cccc3333ccccc333cccccc33ccccccc3cccccccc
-- 131:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 144:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 145:cccccccc3ccccccc33cccccc333ccccc3333cccc33333ccc333333cc3333333c
-- 146:ccccccccccccccc3cccccc33ccccc333cccc3333ccc33333cc333333c3333333
-- 160:4444444446666664466666644666666446666664466666644666666444444444
-- </TILES>

-- <SPRITES>
-- 000:00cde0000c000d00c00c00e0c0cc00e0c00000e00c000d0000cde00000000000
-- 002:000000000c302200c3333320c33333200c33320000c320000002000000000000
-- 003:0000cccc00dddddceeeeedc0000edc0000edcccc0eddddd0eeeee00000000000
-- 004:c0000000000000000000000000000000c0000000000000000000000000000000
-- 005:55555555566666665665555556555ccc56555ccc566555555666666655555555
-- 006:555555556666666555555665ccc55565ccc55565555556656666666555555555
-- 007:00c333000c444440c4c44c43c4444443c4244243c44224430c44444000c33300
-- 008:000ee000eeeeeeeeeeeeeeee0cecece00cecece00cecece00cecece00eeeeee0
-- 016:00000444000044440004444400448c4800448c48004444440004444400004444
-- 017:400000004400000044400000c4440000c4440000444400004440000044000000
-- 018:000eeeee000eeeeeeeeeeeeeeeeeeeee0000000000ddceec00ddceec00ddceec
-- 019:eeeee000eeeee000eeeeeeeeeeeeeeee00000000eeceee00eeceee00eeceee00
-- 020:03300000322300c232c230c2322230c2322300c23230000003000000000000aa
-- 021:00000000222c0000222c0000222c0000222c00000000000000000000aaaa0000
-- 022:444444444444444444444444222222222333333323cccc3321cccc1121999911
-- 023:4444444444444444444444442222222263633332366333322332111223331112
-- 024:4444444444444444444444442222222223333333233333332111111121111111
-- 025:4444444444444444444444442222222233333332333333321111111211111112
-- 026:00000ddd00000dcc00000dcc00000ddd0000000d0000222d000233dd00233ddd
-- 027:ddd00000ccd00000ccd00000ddd00000d0000000d2220000dd332000ddd33200
-- 028:dddddddddd2222ddd233332dd233332ddd2222ddddddddddccccccccc8888888
-- 029:dddddddddd2222ddd233332dd233332ddd2222ddddddddddcccccccc8888888c
-- 032:000444440044444404444444000ccccc0004cccc00044ccc0004400000044000
-- 033:444000004444000044444000ccc00000cc400000c44000000440000004400000
-- 034:00ddceec000dceec000dceec000dceec000dceec000dceec000ddeee0000deee
-- 035:eeceee00eecee000eecee000eecee000eecee000eecee000eeeee000eeee0000
-- 036:060600aa00660099023320990233209902332099023200990220009900200000
-- 037:aaaa000099990000999900009999000099990000999900009999000000000000
-- 038:2199991122222222233333332333333321c222c121c222c121c222c122222222
-- 039:23321112222222223333333232223332133311123c2231121333331222222222
-- 040:2111111122222222233333332333333321111111211111112111111122222222
-- 041:1111111222222222333333323333333211111112111111121111111222222222
-- 042:0233333322222222023200000232000002322222023200000220000002000000
-- 043:3333332022222222000023200000232022222320000023200000220000002000
-- 044:c8ccccccc88c8888c8888888c8888888c8888888c8888888c8888888cccccccc
-- 045:cccccc8c8888c88c8888888c8888888c8888888c8888888c8888888ccccccccc
-- 048:0000222200222222002222240222244402200444220004442000099900009999
-- 049:2200000022000000c00000004400000044000000440000009900000099900000
-- 050:0000222200222222002222240222244402200444220004442000099900009999
-- 051:2200000022000000c00000004400000044000000440000009900000099900000
-- 052:0000222200222222002222240222244402200444220004442000099900009999
-- 053:2200000022000000c00000004400000044000000440000009900000099900000
-- 064:000999990099099900c0099900000ccc00000cc000000cc000000cc000000990
-- 065:99990000990990009900c000cc000000cc000000cc000000cc00000099000000
-- 066:000999990099099900c0099900000ccc00000cc000000cc00000099000000000
-- 067:99990000990990009900c000cc000000cc000000cc000000cc00000099000000
-- 068:000999990099099900c0099900000ccc00000cc000000cc000000cc000000990
-- 069:99990000990990009900c000cc000000cc000000cc0000009900000000000000
-- 080:00033300000033300003333300333333033c333c333333333333ccc303333333
-- 081:0000000000000000000000003000000033000000333000003330000033000000
-- </SPRITES>

-- <MAP>
-- 007:280808182808081828080818280808182808081828080818280808182808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:092818093828180938281809382818093828180938281809382818093828000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:092919383829193838291938382919383829193838291938382919383829000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:290808192908081929080819290808192908081929080819290808192908000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

