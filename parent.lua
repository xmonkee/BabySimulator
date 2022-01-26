function initParent()
	local handSprs = {
		diaps={spr=371,s=2},
		diap={spr=260,s=1},
		pdiap={spr=257,s=1}, --poop diaper
		groc={spr=276,s=2},
		ingr={spr=370,s=1},
		food={spr=384,s=1},
	}

	local parent = makeObj({
		x=50,y=100,ospr=304,spr=304,sc=2,w=2,h=2,
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
	function parent.isHolding(self, item)
		return self._hand == item
	end
	function parent.handSpr(self)
		if self:emptyHanded() then return nil end
		return handSprs[self._hand]
	end

	function parent.draw(self)
		local l = self.loc
		spr(l.spr,l.x,l.y,0,l.sc,l.flip,0,l.w,l.h)
		local hspr = self:handSpr()
		if hspr then -- draw object in hand
			local x = l.x + 23
			if l.flip==1 then x = l.x+1 end
			spr(hspr.spr,x,l.y+10,0,1,0,0,hspr.s,hspr.s)
		end
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

	function parent.updateTimeBasedStats(self)
		self:adj("enr",-30/ticsPerHour)
		self:adj("hpy",-10/ticsPerHour)
	end

	return parent
end
