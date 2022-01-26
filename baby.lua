function initBaby()
	local baby = makeObj({x=100,y=116,w=2,h=2,ospr=336,spr=336,sc=1,rt=12,lf=4})
	baby.props = {full=100, love=0, ener=0}
	baby.poops = 0
	baby.mainColor = 4

	function baby.happ(self)
		local p = self.props
		return ((p.ener/100) * (p.love/100)  * (p.sleepy)/100* (maxPoops-self.poops)/maxPoops)*100
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

	function baby.poop(self)
		self.poops = self.poops + 1
		self.poopedAt=t
	end

	function baby.isFlashing(self)
		return self:happ() <= 20
	end

	baby._draw = baby.draw -- original draw fn
	function baby.draw(self, isActive)
		self:_draw(isActive)

		local loc = self.loc
		-- draw the poops
		for i=1,self.poops do
			spr(368,loc.x+loc.w*loc.sc*8+2,loc.y+9*(i-2),0,1,0,0,2,1)
		end

		-- Draw happ meter
		local h = math.ceil(baby:happ()/100*14)
		rectb(loc.x-4,loc.y,4,16,colors.label)
		rect(loc.x-3,loc.y+15-h,2,h,colors.meter)
	end

	baby.adj = adjMetric

	function baby.updateTimeBasedStats(self)
		self:adj("enr",-50/ticsPerHour)
		if self.asleep then
			self:adj("sleepy", -30/ticsPerHour)
		else
			self:adj("sleepy", 20/ticsPerHour)
			self:adj("brd", 30/ticsPerHour)
		end
	end

	function baby.fireEvents(self)
		if math.random() < 10/(3*ticsPerHour) then
			fireEvent(function() self:poop() end, "Baby Pooped")
		end
		if math.random() < 1/(3*ticsPerHour) then
			if s.b.asleep then
				fireEvent(function() self:awake() end, "Baby Woke Up")
			end
		end
	end

	return baby
end

