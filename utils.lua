PALETTE_MAP = 0x3FF0

function calcBloc(obj)
	local loc = obj.loc
	return {
		x1=loc.x+(loc.lf or 0)*loc.sc,
		y1=loc.y,
		x2=loc.x+(loc.rt or loc.w*8)*loc.sc,
		y2=loc.y+loc.h*loc.sc*8
	}
end

function _objDraw(self, active)
	local loc = self.loc
	spr(loc.spr,loc.x,loc.y,0,loc.sc,0,0,loc.w,loc.h)
	if active then
		rect(loc.x-1,loc.y-1,loc.x+loc.w*loc.sc+1,loc.y+loc.h*loc.sc,5)
	end
end

function makeObj(loc)
	local obj = {loc=loc,draw=_objDraw}
	obj.calcBloc = calcBloc
	obj.bloc = obj:calcBloc() -- useful for static objects
	return obj
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
