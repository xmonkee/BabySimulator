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
	local parent = Obj:new({
		x=50,y=50,ospr=304,spr=304,sc=2,w=2,h=2,
		flip=0,lf=6,rt=10,up=14,dn=16,
		vx=0,vy=0
	})
	function parent.fullBloc(self)
		local l = self.loc
		return {x1=l.x,y1=l.y,x2=l.x+20,y2=l.y+32}
	end
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
		print(res.money, x, 1, colors.label)
	end

	local vx, vy = 0, 0
	function parent.handleKeys(self)

		if btn(0) then vy=max(-2,vy-.1)
		elseif btn(1) then vy=min(2,vy+.1)
		elseif vy>0.1 then vy=vy-0.1
		elseif vy<-0.1 then vy=vy+0.1
		else vy=0
		end

		if btn(2) then vx=max(-2,vx-.1)
		elseif btn(3) then vx=min(2,vx+.1)
		elseif vx>0.1 then vx=vx-0.1
		elseif vx<-0.1 then vx=vx+0.1
		else vx=0
		end

		if btnp(2) then self.loc.flip = 1 end
		if btnp(3) then self.loc.flip = 0 end

		if vx == 0 and vy == 0 then return end

		local l = self.loc
		local x,y,pbloc

		-- Check if x is blocked
		x=l.x+vx
		y=l.y
		pbloc = {x1=x+l.lf*l.sc,y1=y+l.up*l.sc,x2=x+l.rt*l.sc,y2=y+l.dn*l.sc}
		if anyCollisions(pbloc, "parent") then vx=-vx/8	end -- small bounce

		-- Check if y is blocked
		x=l.x
		y=l.y+vy
		pbloc = {x1=x+l.lf*l.sc,y1=y+l.up*l.sc,x2=x+l.rt*l.sc,y2=y+l.dn*l.sc}
		if anyCollisions(pbloc, "parent") then vy=-vy/8	end -- small bounce

		-- Check if x AND y is blocked even if individually unblocked
		-- (heading into a protruding edge)
		x=l.x+vx
		y=l.y+vy
		pbloc = {x1=x+l.lf*l.sc,y1=y+l.up*l.sc,x2=x+l.rt*l.sc,y2=y+l.dn*l.sc}
		if anyCollisions(pbloc, "parent") then vx,vy=0,0	end

		l.x = l.x+vx
		l.y = l.y+vy

		l.spr = l.ospr + ((t//10)%2 + 1)*2 -- walking animation
	end

	return parent
end
