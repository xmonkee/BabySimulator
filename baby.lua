function drawMeter(icon,x,y,val)
	withFlashing(0, 1, function() return val < 20 end, function()
		rect(x+8,y+2,15,4,0)
	end)
	withFlashing(colors.label, RED, function() return val < 20 end, function()
		rect(x+9,y+3,math.ceil(val/100*13),2,colors.label)
	end)
	spr(icon,x,y,0)
end

function initBaby()
	local baby = makeObj({x=100,y=116,w=2,h=2,ospr=336,spr=336,sc=1,rt=12,lf=4})
	baby.props = {full=100, love=100}
	baby.poops = 0
	baby.poopedAt = 0
	baby.mainColor = 4

	function baby.sad(self)
		local p = self.props
		if p.full <= 0 then return "Baby got too hungry" end
		if p.love <= 0 then return "Baby got too sad" end
		if self.poops >= 3 then return "Baby got too dirty" end
		return false
	end

	function baby.poop(self)
		self.poops = self.poops + 1
		self.poopedAt=t
	end

	baby._draw = baby.draw -- original draw fn
	function baby.draw(self, isActive)
		self:_draw(isActive)

		local loc = self.loc

		-- Draw meters
		local x = 120
		local y = 0
		spr(263,x,y,0) -- baby face
		x = x + 10
		print("[",x,y+1,colors.label)
		x = x + 4
		drawMeter(handSprs.food.spr,x,y,self.props.full)
		x = x + 25
		drawMeter(258,x,y,self.props.love)
		x = x + 26
		print("]",x,y+1,colors.label)
		-- draw the poops
		x = loc.x+15
		y = loc.y+10
		for _ = 1,self.poops do
			spr(267,x,y,0)
			x = x + 8
		end
	end

	function baby.updateTimeBasedStats(self)
		local p = self.props
		local TPH = ticsPerHour
		p.full = max(0,p.full-100/TPH)
		p.love = max(0,p.love-100/TPH)
	end

	function baby.fireEvents(self)
		if math.random() < 0.007*(t - self.poopedAt)/ticsPerHour then
			self:poop()
			notify("Baby Pooped")
		end
	end

	return baby
end

