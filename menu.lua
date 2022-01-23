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
	local o = {actions=actions or {}, selected=1, mode="shown", progressed=0}
	setmetatable(o, self)
	return o
end

function Menu.add(self, action)
	table.insert(self.actions, action)
end

function Menu.activate(self)
	if #self.actions > 0 then
		s.mode = "menu"
		s.menu = self
		self.mode = "shown"
	end
end

function Menu.incSel(self)
	self.selected = math.min(#self.actions, self.selected + 1)
end

function Menu.decSel(self)
	self.selected = math.max(1, self.selected - 1)
end

function Menu.drawLabel(self, label,x,y,selected,progress)
	local color = colors.menuItem
	if selected then color = colors.selectedMenuItem end
	rect(x,y,62,10,color)
	rect(x+1,y+1,60/100*progress,8,5)
	sprint(label, x+1,y+1,colors.menuItemText)
end

function Menu.draw(self)
	local x=130
	local ys=10
	for i,action in pairs(s.actions) do
		local y=ys+i*8
		self:drawLabel(action.label,x,y,self.selected==i, self.progress)
	end
end

function Menu.handleKeys(self)
	local returnControl = false -- return indicating if caller can process other keystrokes
	if self.mode == "shown" then
		returnControl = true
		if btnp(4,60,5) then
			if #self.actions == 1 then
				self.mode = "started"
				self.progress = 0
			else
				self.mode = "selected"
			end
		end
	end
	if self.mode == "selected" then
		if btnp(0,10,5) then self:decSel() end
		if btnp(1,10,5) then self:incSel() end
		if btnp(4,60,5) then
			self.mode = "started"
			self.progress = 0
		end
		if btnp(5,60,5) then self.mode = "shown" end
	end
	if self.mode == "started" then
		if self.progress == 100 then
			self.actions[self.selected].fn()
			self.progress = 0
			self.mode = "selected"
		elseif not btn(4) or btn(1) or btn(2) or btn(3) or btn(5) then
			self.mode = "selected"
			self.progress = 0
		else -- only btn(4)
			self.progress = self.progress + self.actions[self.selected].rate
		end
	end
	return returnControl
end
