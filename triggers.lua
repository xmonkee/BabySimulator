
function initTriggers()

	local emptyHand = function()
		return s.p:emptyHanded()
	end

	local notEmptyHand = function()
		return not s.p:emptyHanded()
	end

	local holding = function(thing)
		return function()
			return s.p:isHolding(thing)
		end
	end

	local resAbove = function(res, lvl)
		return function()
			return res > lvl
		end
	end

	local resBelow = function(res, lvl)
		return function()
			return res <= lvl
		end
	end

	triggers = {}

	triggers.baby = {
		Trigger{
			name="play",
			conds={emptyHand},
			action=Action("Play", 1, function() s.b:adj("brd",-10) end)
		}
	}

	triggers.shelf = {
		Trigger{
			name="takeDiap",
			conds={emptyHand,resAbove(s.r.groc,0)},
			action=Action("Take diaper", 3, function()
				s.r.diap = s.r.diap - 1
				s.p:hold("diap")
			end)
		}, Trigger{
			name="takeIngr",
			conds={emptyHand,resAbove(s.r.diap,0)},
			action=Action("Take ingredients", 3, function()
				s.r.groc = s.r.groc - 1
				s.p:hold("ingr")
			end)
		}, Trigger{
			name="storeGrocs",
			conds={holding("groc"),resAbove(s.r.diap,0)},
			action=Action("Store groceries", 1, function()
				s.r.groc = s.r.groc + 3
				s.p:drop()
			end)
		}, Trigger{
			name="storeDiaps",
			conds={holding("diaps"),resAbove(s.r.diap,0)},
			action=Action("Store diapers", 2, function()
				s.r.diap = s.r.diap + 4
				s.p:drop()
			end)
		}
	}

	triggers.trash = {
		Trigger{
			name="throw",
			conds={notEmptyHand},
			action=Action("Throw", 4, function()
				s.p:drop()
				s.r.trash = s.r.trash + 1
			end)
		}
	}

	triggers.store = {
		Trigger{
			name="buyDiaps",
			conds={emptyHand, resAbove(s.r.money,costs.diaps)},
			action=Action("Buy diapers", 2, function()
				s.p:hold("diaps")
				s.r.money = s.r.money - costs.diaps
			end)
		}, Trigger{
			name="buyGroc",
			conds={emptyHand, resAbove(s.r.money,costs.groc)},
			action=Action("Buy groceries", 2, function()
				s.p:hold("groc")
				s.r.money = s.r.money - costs.groc
			end)
		}
	}

	triggers.baby = {
		Trigger{
			name="changeDiap",
			conds={holding("diap"),resAbove(s.b.poops,1)},
			action=Action("Change diaper", 1, function()
				s.b.poops = s.b.poops-1
				s.p:hold("pdiap")
			end)
		}
	}

end
