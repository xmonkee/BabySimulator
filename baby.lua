-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

function initConstants()
	t=0
	labels = {
		E="Ener", C="Calm", B="Boredom",
		DF="DiaperFullness", H="Happ"
	}
	meterFields = {"E", "C", "H"}
	colors={
		label=12,
		meter=5,
		background=0,
		menuItem=10,
		selectedMenuItem=9,
		menuItemText=12,
	}
	ticsPerSecond=.1 --actually it's 60, game is sped up by 60x
	ticsPerMinute=60*ticsPerSecond
	ticsPerHour=60*ticsPerMinute
end

function initState()
	s = {}

	local baby = {E=100, C=100, B=0, DF=50}
	setmetatable(baby, {
		__index=function(table,key)
			if key=="H" then
				return 100 - math.min(100, table.B + table.DF)
			end
			return nil
		end
	})

	local parent = {E=100, C=100, H=100}

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

	s.b = baby
	s.p = parent
	s.m = menu
	s.r = resources
end

function initActions()
	actions = {
		work=function()
			s.r.money = s.r.money + 20
			s.p:adj("E",-10)
		end,
		buyd=function()
			s.r:adj("money", -10)
			s.r:adj("diap", 10)
		end,
		buyf=function()
			s.r:adj("food",30)
			s.r:adj("money",-10)
		end,
		garb=function()
			s.r:adj("trash",-s.r.trash)
		end,
		changed=function()
			s.r:adj("diap",-1)
			s.r:adj("trash",10)
			s.b:adj("DF",-30)
		end,
		cook=function()
			s.r:adj("food",-10)
			s.r:adj("trash",20)
			s.p:adj("E",-10)
		end,
		feed=function()
			s.b:adj("E",100)
		end,
		bath=function()
			s.b:adj("C",100)
			s.p:adj("E",-10)
		end,
		sleepb=function() end,
		play=function() end,
		eat=function() end,
		sleep=function() end,
		soc=function() end
	}

	for i,item in pairs(s.m.items) do
		if actions[item[1]] == nil then
			error("action "..k.."not found")
		end
	end
end

function init()
	initConstants()
	initState()
	initActions()
end

init()

-----------------------------------------------------------------


function updateTimeBasedStats()
	s.p:adj("E",-30/ticsPerHour)
	s.p:adj("H",-10/ticsPerHour)
	s.p:adj("C",-10/ticsPerHour)

	s.b:adj("E",-50/ticsPerHour)
	s.b:adj("B", 10/ticsPerHour)
	s.b:adj("C",-20/ticsPerHour)
end

function readKeys()
	if s.m.shown then
		if btnp(0,60,5) then s.m:dec() end
		if btnp(1,60,5) then s.m:inc() end
		if btnp(4,60,5) then
			actions[s.m.items[s.m.selected][1]]()
			s.m.shown=false
		end
	end
	if btnp(4,60,5) and not s.m.shown then s.m.shown=true end
	if btnp(5,60,5) and s.m.shown then s.m.shown=false end
end

function update()
	t=t+1
	minute=(t/ticsPerMinute) % 60
	hour=(t/ticsPerHour) % 24
	updateTimeBasedStats()
	readKeys()
end

---------------------------------------------------------------

function drawMenu()
	if not s.m.shown then return end
	function drawItem(item,x,y,selected)
		local color = colors.menuItem
		if selected then color = colors.selectedMenuItem end
		rect(x,y,61,10,color)
		print(item[2],x+1,y+1,colors.menuItemText,true,1,true)
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
	for i,field in pairs(meterFields) do
		local x=startx
		local y = starty + (i)*8
		x = x + print(labels[field],x,y,colors.label, true, 1, true) + 1
		rectb(x,y,24,7,colors.label)
		rect(x+2,y+2,person[field]/20*4,3, colors.meter)
	end
end

function drawResources()
	local x=200
	local y=0
	for k,v in pairs(s.r) do
		print(k.."="..v,x,y,10,true,1,true)
		y=y+8
	end
end

function drawMeters()
	drawMeter(s.b, "Baby", 0, 0)
	drawMeter(s.p, "Papa", 0, 35)
end

function drawClock()
	spr(258,100,0,0)
	print(string.format("%.2d:%.2d",
	math.floor(hour),
	math.floor(minute)),
	110,1, colors.label, true, 1, true)
end

function draw()
	cls(colors.background)
	rect(119,0,1,136,5)
	rect(0,67,240,1,5)
	drawMeters()
	drawResources()
	drawClock()
	drawMenu()
end

------------------------------------------------------------------

function TIC()
	update()
	draw()
end


-- <SPRITES>
-- 000:00cdedc00d00c00dc000c000d000c000e0ccc000d0000200c00000200d00000d
-- 001:0000000000000000c0000000d0000000e0000000d0000000c000000000000000
-- 002:00cde0000c000d00c00c00e0c0cc00e0c00000e00c000d0000cde00000000000
-- 016:00cdedc000000000000000000000000000000000000000000000000000000000
-- </SPRITES>

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


