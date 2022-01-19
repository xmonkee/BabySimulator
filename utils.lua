function calcBloc(loc)
	return {
		x1=loc.x,
		y1=loc.y,
		x2=loc.x+loc.rt*loc.sc,
		y2=loc.y+loc.h*loc.sc*8
	}
end
