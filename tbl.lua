function initTbl()
	local tbl = Obj:new({x=50,y=116,w=4,h=4,spr=412,sc=1,bt=18})
	tbl.holding = nil

	tbl._draw = tbl.draw -- original draw fn
	function tbl.draw(self, isActive)
		self:_draw(isActive)
		local l = self.loc
		local hspr = handSprs[self.holding]
		if hspr then
			local x = l.x + 12
			local y = l.y + 5
			spr(hspr.spr,x,y,0,1,0,0,hspr.s,hspr.s)
		end
	end

	function tbl.isEmpty(self)
		return not self.holding
	end

	function tbl.hold(self, item)
		self.holding = item
	end

	function tbl.drop(self)
		local r = self.holding
		self.holding = nil
		return r
	end
	
	return tbl
end
	
