
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

	triggers = {}


	triggers.dshelf = {
		Trigger{
			name="takeDiap",
			conds={emptyHand, function() return s.r.diap >= 1 end},
			action=Action("Take diaper", 3, function()
				s.r.diap = s.r.diap - 1
				s.p:hold("diap")
			end)
		}, Trigger{
			name="storeDiaps",
			conds={holding("diaps")},
			action=Action("Store diapers", 2, function()
				s.r.diap = s.r.diap + 3
				s.p:drop()
			end)
		}, Trigger{
			name="storeDiap",
			conds={holding("diap")},
			action=Action("Store diaper", 3, function()
				s.r.diap = s.r.diap + 1
				s.p:drop()
			end)
		}
	}

	triggers.gshelf = {
		Trigger{
			name="takeIngr",
			conds={emptyHand,function() return s.r.groc >= 1 end},
			action=Action("Take ingredients", 3, function()
				s.r.groc = s.r.groc - 1
				s.p:hold("ingr")
			end)
		}, Trigger{
			name="storeGrocs",
			conds={holding("groc")},
			action=Action("Store groceries", 1, function()
				s.r.groc = s.r.groc + 3
				s.p:drop()
			end)
		}, Trigger{
			name="storeIngr",
			conds={holding("ingr")},
			action=Action("Store ingredients", 2, function()
				s.r.groc = s.r.groc + 1
				s.p:drop()
			end)
		}
	}

	triggers.trash = {
		Trigger{
			name="throw",
			conds={notEmptyHand},
			action=Action("Throw", 4, function()
				if s.r.trash >= 10 then
					notify("Trash is full")
				else
					s.p:drop()
					s.r.trash = s.r.trash + 1
				end
			end)
		}
	}

	triggers.dstore = {
		Trigger{
			name="buyDiaps",
			conds={emptyHand, function() return s.r.money >= costs.diaps end},
			action=Action("Buy diapers", 2, function()
				s.p:hold("diaps")
				s.r.money = s.r.money - costs.diaps
			end)
		}
	}

	triggers.gstore = {
		Trigger{
			name="buyGroc",
			conds={emptyHand, function() return s.r.money >= costs.groc end},
			action=Action("Buy groceries", 2, function()
				s.p:hold("groc")
				s.r.money = s.r.money - costs.groc
			end)
		}
	}

	triggers.stove = {
		Trigger{
			name="cook",
			conds={holding("ingr")},
			action=Action("Cook", 1, function()
				s.p:hold("food")
			end)
		}
	}

	triggers.baby = {
		Trigger{
			name="changeDiap",
			conds={holding("diap"), function() return s.b.poops >= 1 end},
			action=Action("Change diaper", 1, function()
				s.b.poops = 0
				s.p:hold("pdiap")
			end)
		}, Trigger{
			name="sleep",
			conds={emptyHand},
			action=Action("Put baby to sleep", 1, function()
				if math.random()*90 < s.b.props.sleepy then
					notify("Baby didn't sleep")
				else
					s.b:sleep()
				end
			end)
		}, Trigger{
			name="play",
			conds={emptyHand},
			action=Action("Play", 1, function() s.b:adj("brd",-10) end)
		}, Trigger{
			name="Feed",
			conds={holding("food")},
			action=Action("Feed baby", 1, function()
				s.b:adj("enr",30)
				s.p:drop()
			end)
		}
	}
end
