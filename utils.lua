PALETTE_MAP = 0x3FF0

function calcBloc(obj)
	local loc = obj.loc
	return {
		x1=loc.x+(loc.lf or 0)*loc.sc,
		y1=loc.y+(loc.up or 0)*loc.sc,
		x2=loc.x+(loc.rt or loc.w*8)*loc.sc,
		y2=loc.y+(loc.dn or loc.h*8)*loc.sc
	}
end

function _objDraw(self, active)
	local loc = self.loc
	if active then
		--rectb(loc.x-1,loc.y-1,loc.w*loc.sc*8+1,loc.h*loc.sc*8+1,colors.label)
		withSwapAll(12, function()
			spr(loc.spr,loc.x-1,loc.y-1,0,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x+1,loc.y-1,0,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x-1,loc.y+1,0,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x+1,loc.y+1,0,loc.sc,0,0,loc.w,loc.h)
		end)
	end
	spr(loc.spr,loc.x,loc.y,0,loc.sc,0,0,loc.w,loc.h)
end

function makeObj(loc)
	local obj = {loc=loc,draw=_objDraw}
	obj.calcBloc = calcBloc
	obj.bloc = obj:calcBloc() -- useful for static objects
	return obj
end

function withSwapAll(newi, f) -- Swap colors and do f()
	-- newi is the palette index of the color you want to swap in
	local oldc = {}
	local newc = peek4(PALETTE_MAP*2+newi) -- get the color at newi
	for i = 1,15 do
		-- i is the palette index of the color in the sprite to change
		oldc[i] = peek4(PALETTE_MAP*2+i) -- save the original color
		poke4(PALETTE_MAP*2+i, newc) -- write new color at i
	end
		f() -- do the thing
	for i = 1,15 do
		poke4(PALETTE_MAP*2+i, oldc[i]) -- restore oldcinal color at i
	end
end

function withSwap(oldi, newi, f) -- Swap colors and do f()
	-- oldi is the palette index of the color in the sprite to change
	-- newi is the palette index of the color you want to swap in
	local oldc = peek4(PALETTE_MAP*2+oldi) -- save the original color
	local newc = peek4(PALETTE_MAP*2+newi) -- get the color at newi
	poke4(PALETTE_MAP*2+oldi, newc) -- write new color at oldi
	f() -- do the thing
	poke4(PALETTE_MAP*2+oldi, oldc) -- restore oldcinal color at oldi
end

function collision(bloc1, bloc2)
	local left,right = bloc1,bloc2
	local up,down = bloc1,bloc2
	if bloc1.x1 > bloc2.x1 then left,right = right,left end
	if bloc1.y1 > bloc2.y1 then up,down = down,up end
	if left.x2 < right.x1 then return false end
	if up.y2 < down.y1 then return false end
	return true
end

function isAdjacent(bloc1, bloc2)
	-- technically adjacent OR overlapping,
	-- but we assume overlap is avoided elsewhere
	local left,right = bloc1,bloc2
	local up,down = bloc1,bloc2
	if bloc1.x1 > bloc2.x1 then left,right = right,left end
	if bloc1.y1 > bloc2.y1 then up,down = down,up end
	if left.x2 < right.x1-1 then return false end
	if up.y2 < down.y1-1 then return false end
	return true
end

function anyCollisions(bloc, objs)
	for _,obj in pairs(objs) do
		if collision(bloc, obj.bloc) then return true end
	end
	return false
end

function Menu(actions)
	-- modes = shown | selected | started
	-- shown + z -> selected
	-- selected + x -> shown
	-- selected + z -> started
	-- started + z(hold) -> progressing
	-- progressing == 100 = action() -> selected
	-- for single item
	-- shown + z -> started
	local menu = {actions=actions,selected=1, mode="shown"}

	function menu.activate(self)
		s.mode = "menu"
		s.menu = self
		self.mode = "shown"
	end

	function menu.incSel(self)
		self.selected = math.min(#self.actions, self.selected + 1)
	end

	function menu.decSel(self)
		self.selected = math.max(1 self.selected - 1)
	end

	local function drawLabel(label,x,y,selected,progress)
		local color = colors.menuItem
		if selected then color = colors.selectedMenuItem end
		rect(x,y,62,10,color)
		rect(x+1,y+1,60/100*progress,8,5)
		sprint(label, x+1,y+1,colors.menuItemText)
	end

	function menu.draw(self):
		local x=130
		local ys=10
		for i,action in pairs(s.actions) do
			local y=ys+i*8
			drawLabel(action.label,x,y,self.selected==i, self.progress)
		end
	end

	function menu.handleKeys(self)
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
				self.actions[self.selected].fire()
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

end

function Action(label, rate, fire)
	action = {label=label, rate=rate,fire=fire}
end

function Trigger(name, obj, conds, action)
	t={name=name,obj=obj,conds=conds or {},action=action}

	function trigger.check()
		if t.obj and s.activeObj != t.obj then
			return false
		end
		for _, cond in pairs(conds) do
			if not cond() then return false end
		end
		return true
	end

end
