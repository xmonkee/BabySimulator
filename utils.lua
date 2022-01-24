require "menu"

PALETTE_MAP = 0x3FF0

function adjMetric(self,metric,val)
	local nval = self.props[metric]+val
	nval = math.max(0,math.min(100,nval))
	self.props[metric]=nval
end

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
			spr(loc.spr,loc.x-1,loc.y-1,loc.zero,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x+1,loc.y-1,loc.zero,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x-1,loc.y+1,loc.zero,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x+1,loc.y+1,loc.zero,loc.sc,0,0,loc.w,loc.h)
		end)
	end
	spr(loc.spr,loc.x,loc.y,loc.zero,loc.sc,0,0,loc.w,loc.h)
	if self.isFlashing ~= nil then
		local isRed = self:isFlashing() and (t//20%2) == 0
		if isRed then
			withSwapAll(3,function()
				spr(loc.spr,loc.x,loc.y,loc.zero,loc.sc,0,0,loc.w,loc.h)
			end)
		end
	end
end

function makeObj(loc)
	loc.zero = loc.zero or 0
	local obj = {loc=loc,draw=_objDraw}
	obj.calcBloc = calcBloc
	obj.bloc = obj:calcBloc() -- useful for static objects
	return obj
end

function withSwapAll(newi, f) -- Swap colors and do f()
	-- newi is the palette index of the color you want to swap in
	local oldc = {}
	local newc = peek4(PALETTE_MAP*2+newi) -- get the color at newi
	for i = 0,15 do
		-- i is the palette index of the color in the sprite to change
		oldc[i] = peek4(PALETTE_MAP*2+i) -- save the original color
		if i ~= 12 then -- spare whites
			poke4(PALETTE_MAP*2+i, newc) -- write new color at i
		end
	end
		f() -- do the thing
	for i = 0,15 do
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


function Action(label, rate, fn)
	local action = {label=label, rate=rate,fn=fn}
	return action
end

function _triggered(self)
	for _, cond in pairs(self.conds) do
		if not cond() then return false end
	end
	return true
end

function Trigger(triggerArgs)
	local t=triggerArgs --{name, conds, action}
	t.triggered = _triggered
	return t
end
