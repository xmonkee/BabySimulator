Menu = {}
Menu.__index = Menu

function Menu.new(self, actions)
	-- modes = shown | selected | started
	-- shown + z -> selected
	-- selected + x -> shown
	-- selected + z -> started
	-- started + z(hold) -> progressing
	-- progressing == 100 = action() -> selected
	-- for single item
	-- shown + z -> started
	local o = {
		actions=actions or {},
		selected=1,
		mode="shown",
		progress=0,
		waitRelease=false
	}
	setmetatable(o, self)
	return o
end

function Menu.empty(self)
	self.actions={}
	self.selected=1
	self.mode="shown"
	self.progress=0
end

function Menu.add(self, action)
	table.insert(self.actions, action)
end

function Menu.incSel(self)
	self.selected = math.min(#self.actions, self.selected + 1)
	self.mode = "selected"
	self.progress=0
end

function Menu.decSel(self)
	self.selected = math.max(1, self.selected - 1)
	self.mode = "selected"
	self.progress=0
end

function Menu.drawLabel(self,label,x,y,selected)
	local color = colors.menuItem
	local w,h = 70,8
	if selected then
		rect(x,y,w+1,h+1,0)
		rect(x-1,y-1,w,h,colors.menuItemSelected)
		rect(x-1,y-1,w/100*self.progress,h,colors.menuItemProgress)
		print(label, x,y,colors.menuItemText, false, 1, true)
	else
		rect(x,y,w,h,color)
		print(label, x+1,y+1,colors.menuItemText, false, 1, true)
	end
end

function Menu.draw(self)
	local x=max(5,min(players.parent.loc.x,168))
	local ys=players.parent.loc.y-(#self.actions*8)-2
	if ys < 20 then ys=players.parent.loc.y+players.parent.loc.h*players.parent.loc.sc*8+2 end
	for i,action in pairs(self.actions) do
		local y=ys+(i-1)*9
		self:drawLabel(action.label,x,y,self.mode ~= "shown" and self.selected==i)
	end
end

function Menu.handleKeys(self)
	-- return boolean indicating if caller can process other keystrokes
	if self.waitRelease then
		if not btn(4) then self.waitRelease = false
		else return true
		end
	end
	if self.mode == "shown" and btn(4) then
			self.mode = "selected"
	elseif self.mode == "selected" then
		if btnp(4,10,0) then self.mode = "started" end
		if btnp(0) then self:decSel() end
		if btnp(1) then self:incSel() end
		if btnp(2) or btnp(3) or btnp(5) then self.mode = "shown" end
	elseif self.mode == "started" then
		if self.progress >= 100 then
			sfx(32,"C-4",30,2,15,0)
			self.actions[self.selected].fn()
			self.progress = 0
			self.mode = "selected"
			self.waitRelease=true
			s.recalcTrigs = true
		else
			if btnp(0) then self:decSel() end
			if btnp(1) then self:incSel() end
			if btn(2) or btn(3) or btn(5) then
				self.mode = "selected"
				self.progress = 0
			end
			if btn(4) then
				self.progress = self.progress+self.actions[self.selected].rate/ticsPerMin*60*3
			end
		end
	end
	return self.mode == "shown" or #self.actions == 1
end
