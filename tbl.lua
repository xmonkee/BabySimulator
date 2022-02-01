function initTbl()
	local tbl = makeObj({x=50,y=116,w=4,h=4,spr=412,sc=1,bt=18})
	tbl.holding = nil

	tbl._draw = tbl.draw -- original draw fn
	function tbl.draw(self, isActive)
		self:_draw(isActive)
		local l = self.loc
		local hspr = self.holding
		if hspr then
			local x = l.x + 10
			local y = l.y + 10
			spr(hspr,x,y,0,1,0,0,hspr.s,hspr.s)
		end
	end
	return tbl
end
	