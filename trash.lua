function initTrash()
	local trash = makeObj({x=20,y=116,w=2,h=2,spr=274,sc=1})

	trash._draw = trash.draw -- original draw fn
	function trash.draw(self, isActive)
		self:_draw(isActive)

		local loc = self.loc
		-- Draw trash meter
		local h = math.ceil(s.r.trash/maxTrash*14)
		rectb(loc.x-5,loc.y,4,16,colors.label)
		rect(loc.x-4,loc.y+15-h,2,h,4)
	end
	return trash
end
