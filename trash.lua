function initTrash()
	local trash = makeObj({x=20,y=116,w=2,h=2,spr=274,sc=1})
	local truck = makeObj({x=160,y=90,w=4,h=4,spr=343,sc=2,dn=16, up=5})
	trash.maxTrash = 5
	trash.truck = nil

	trash._draw = trash.draw -- original draw fn
	function trash.draw(self, isActive)
		self:_draw(isActive)

		local loc = self.loc
		-- Draw trash meter
		local h = math.ceil(s.r.trash/self.maxTrash*14)
		rect(loc.x-5,loc.y,4,16,0)
		rect(loc.x-4,loc.y+15-h,2,h,12)
	end

	function trash.fireEvents(self)
		if math.floor(minute) == 30 and not self.truck then
			self.truck=true
			objs.truck=truck
			notify("Garbage truck is here")
		end
		if math.floor(minute) == 40 and self.truck then
			self.truck=false
			objs.truck=nil
			notify("Garbage truck has left")
		end
	end

	return trash
end
