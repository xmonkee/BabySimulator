function calcBloc(loc)
	return {
		x1=loc.x+(loc.lf or 0)*loc.sc,
		y1=loc.y,
		x2=loc.x+(loc.rt or loc.w*8)*loc.sc,
		y2=loc.y+loc.h*loc.sc*8
	}
end


function _objDraw(self)
	local loc = self.loc
	spr(loc.spr,loc.x,loc.y,0,loc.sc,0,0,loc.w,loc.h)
end


function makeObj(loc)
	local obj = {loc=loc,draw=_objDraw}
	obj.bloc = calcBloc(obj.loc)
	return obj
end
