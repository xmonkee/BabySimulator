handSprs = {
	diaps={spr=371,s=2},
	diap={spr=260,s=1},
	pdiap={spr=257,s=1}, --poop diaper
	groc={spr=276,s=2},
	ingr={spr=370,s=1},
	food={spr=270,s=1},
	trash={spr=278,s=2},
}

function initParent()
	local parent = makeObj({
		x=50,y=50,ospr=304,spr=304,sc=2,w=2,h=2,
		flip=0,lf=6,rt=10,up=14,dn=16,
		vx=0,vy=0
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
		local r = self._hand
		self._hand = nil
		return r
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
		x = 214
		spr(269,x,0, 0)
		x = x + 8
		print(s.r.money, x, 1, colors.label)
	end

	local dx, dy = 0, 0
	local function decelerateX()
		if dx < -0.2 then dx = dx + 0.2
		elseif dx < -0.1 then dx = dx + 0.1
		elseif dx > 0.2 then dx = dx - 0.2
		elseif dx > 0.1 then dx = dx - 0.1
		else dx = 0
		end
	end
	local function decelerateY()
		-- if dy < -0.2 then dy = dy + 0.2
		if dy < -0.1 then dy = dy + 0.1
		-- elseif dy > 0.2 then dy = dy - 0.2
		elseif dy > 0.1 then dy = dy - 0.1
		else dy = 0
		end
	end

	function parent.handleKeys(self)
		if btn(0) then dy=max(-2,dy-.1) elseif btn(1) then dy=min(2,dy+.1) else decelerateY() end
		if btn(2) then dx=max(-2,dx-.1) elseif btn(3) then dx=min(2,dx+.1) else decelerateX() end
		if btnp(2) then self.loc.flip = 1 end
		if btnp(3) then self.loc.flip = 0 end
		if dx ~= 0 or dy ~= 0 then self:mv() end
	end


	function parent.mv(self)
		local l = self.loc
		local x,y,pbloc

		x=l.x+dx
		y=l.y
		pbloc = {x1=x+l.lf*l.sc,y1=y+l.up*l.sc,x2=x+l.rt*l.sc,y2=y+l.dn*l.sc}
		if anyCollisions(pbloc, objs) then dx=-dx/4	end

		x=l.x
		y=l.y+dy
		pbloc = {x1=x+l.lf*l.sc,y1=y+l.up*l.sc,x2=x+l.rt*l.sc,y2=y+l.dn*l.sc}
		if anyCollisions(pbloc, objs) then dy=-dy/4	end

		x=l.x+dx
		y=l.y+dy
		pbloc = {x1=x+l.lf*l.sc,y1=y+l.up*l.sc,x2=x+l.rt*l.sc,y2=y+l.dn*l.sc}
		if anyCollisions(pbloc, objs) then dx,dy=0,0	end

		l.x = l.x+dx
		l.y = l.y+dy

		l.spr = l.ospr + ((t//10)%2 + 1)*2 -- walking animation
		--if dx<0 then l.flip=1 elseif dx>0 then l.flip=0 end
	end

	parent.adj = adjMetric

	function parent.updateTimeBasedStats(self)
		self:adj("enr",-30/ticsPerHour)
		self:adj("hpy",-10/ticsPerHour)
	end

	return parent
end