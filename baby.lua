function initBaby()
	local baby = makeObj({x=100,y=114,w=2,h=2,ospr=336,spr=336,sc=1,rt=12,lf=4})
	baby.props = {full=50, love=50, wake=50}
	baby.poops = 0
	baby.poopedAt = 0
	baby.mainColor = 4

	function baby.happ(self)
		local p = self.props
		return ((p.wake/100) * (p.love/100)  * (p.full)/100* (maxPoops-self.poops)/maxPoops)*100
	end

	baby.asleep=false
	baby.sleptAt=0

	function baby.sleep(self)
		self.asleep=true
		self.sleptAt = t
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

	function baby.isFlashing(self)
		return self:happ() <= 5
	end

	function drawMeter(icon,x,y,val)
		local y = y + 2
		rectb(x,y,15,4,colors.label)
		rect(x+1,y+1,val/100*14,2,colors.label)
		local x = x - 5
		y = y - 2
		spr(icon,x,y,0)
	end

	baby._draw = baby.draw -- original draw fn
	function baby.draw(self, isActive)
		self:_draw(isActive)

		local loc = self.loc

		-- Draw meters
		local x = loc.x + loc.w*loc.sc*8 + 4
		local y = loc.y - 10
		drawMeter(handSprs.food.spr,x,y,self.props.full)
		y = y + 8
		drawMeter(265,x,y,self.props.wake)
		y = y + 8
		drawMeter(258,x,y,self.props.love)
		y = y + 8
		-- draw the poops
		spr(267,x-5,y,0)
		print("x"..self.poops, x+4, y, colors.label)
	end

	baby.adj = adjMetric

	function baby.updateTimeBasedStats(self)
		if self.asleep then
			self:adj("wake", 30/ticsPerHour)
			self:adj("full",-20/ticsPerHour)
		else
			self:adj("full",-50/ticsPerHour)
			self:adj("wake",-30/ticsPerHour)
			self:adj("love",-30/ticsPerHour)
		end
	end

	poopProb = probgen(4, 1)
	wakeProb = probgen(3, 0.5)
	function baby.fireEvents(self)
		if poopProb(self.poopedAt)  then
			fireEvent(function() self:poop() end, "Baby Pooped")
		end
		if s.b.asleep then
			if wakeProb(self.sleptAt) then
				fireEvent(function() self:awake() end, "Baby Woke Up")
			end
		end
	end

	return baby
end

