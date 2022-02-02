require "menu"

PALETTE_MAP = 0x3FF0
RED = 3
SOLIDS = {[73]=1,[74]=1,[75]=1}  -- "solid" map sprites
min = math.min
max = math.max

function solid(x,y)
	return SOLIDS[mget(x//8,y//8)]
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
		withSwapAll(12, function()
			spr(loc.spr,loc.x-1,loc.y,loc.zero,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x+1,loc.y,loc.zero,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x,loc.y-1,loc.zero,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x,loc.y+1,loc.zero,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x-1,loc.y-1,loc.zero,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x+1,loc.y-1,loc.zero,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x-1,loc.y+1,loc.zero,loc.sc,0,0,loc.w,loc.h)
			spr(loc.spr,loc.x+1,loc.y+1,loc.zero,loc.sc,0,0,loc.w,loc.h)
		end)
	end
	spr(loc.spr,loc.x,loc.y,loc.zero,loc.sc,0,0,loc.w,loc.h)
end

function withFlashing(mainColor, swapWith, isFlashing, f)
	if isFlashing() and (t//10%2) == 0 then
		withSwap(mainColor, swapWith, f)
	else
		f()
	end
end

function makeObj(loc)
	loc.zero = loc.zero or 0
	local obj = {loc=loc,draw=_objDraw}
	obj.calcBloc = calcBloc
	obj.bloc = obj:calcBloc() -- useful for static objects
	return obj
end

function withSwapAll(newi, f)
	for i = 0,15 do poke4(PALETTE_MAP*2+i, newi) end
	f()
	for i = 0,15 do poke4(PALETTE_MAP*2+i, i) end
end

function withSwap(i, j, f)
	poke4(PALETTE_MAP*2+i,j)
	f()
	poke4(PALETTE_MAP*2+i,i)
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

function drawMeter(icon,x,y,val)
	withFlashing(0, 1, function() return val < 20 end, function()
		rect(x+8,y+2,15,4,0)
	end)
	withFlashing(colors.label, RED, function() return val < 20 end, function()
		rect(x+9,y+3,math.ceil(val/100*14),2,colors.label)
	end)
	spr(icon,x,y,0)
end

function isAdjacent(bloc1, bloc2)
	-- technically adjacent OR overlapping,
	-- but we assume overlap is avoided elsewhere
	local left,right = bloc1,bloc2
	local up,down = bloc1,bloc2
	if bloc1.x1 > bloc2.x1 then left,right = right,left end
	if bloc1.y1 > bloc2.y1 then up,down = down,up end
	if left.x2 < right.x1-3 then return false end
	if up.y2 < down.y1-3 then return false end
	return true
end

function anyCollisions(bloc, objs)
	for _,obj in pairs(objs) do -- objects
		if collision(bloc, obj.bloc) then return true end
	end
	if solid(bloc.x1,bloc.y1) or -- walls
		solid(bloc.x2,bloc.y1) or
		solid(bloc.x1,bloc.y2) or
		solid(bloc.x2,bloc.y2) then
		return true
	end
	if bloc.x1 < 10 or -- edges
		 bloc.x2 > 230 or
		 bloc.y1 < 40 or
		 bloc.y2 > 136 then
		return true
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
