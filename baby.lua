function initBaby()
	local baby = makeObj({x=100,y=116,w=2,h=2,ospr=336,spr=336,sc=1,rt=12,lf=4})
	baby.props = {full=40, love=40, wake=40}
	baby.poops = 0
	baby.poopedAt = 0
	baby.mainColor = 4
	baby.asleep=false
	baby.sleptAt=0

	function baby.sad(self)
		local p = self.props
		if p.full <= 0 then return "Baby got too hungry" end
		if p.love <= 0 then return "Baby got too sad" end
		if p.wake <= 0 then return "Baby got too sleepy" end
		if self.poops >= 3 then return "Baby got too dirty" end
		return false
	end

	function baby.sleep(self)
		self.asleep=true
		self.sleptAt = t
		self:adj("wake", 40)
		self.loc.spr=self.loc.ospr+self.loc.w
	end

	function baby.awake(self)
		self.asleep=false
		self.loc.spr=self.loc.ospr
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
		x = x + 22
		drawMeter(265,x,y,self.props.wake)
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

	baby.adj = adjMetric

	function baby.updateTimeBasedStats(self)
		self:adj("full",-50/ticsPerHour)
		self:adj("wake",-30/ticsPerHour)
		self:adj("love",-30/ticsPerHour)
	end

	poopProb = probgen(4, 1.5)
	function baby.fireEvents(self)
		if poopProb(self.poopedAt)  then
			self:poop()
			notify("Baby Pooped")
		end
		if self.asleep and (t - self.sleptAt) > 5*ticsPerMinute  then
			self:awake()
			notify("Baby Woke Up")
		end
	end

	return baby
end

