
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
			action=Action("Store groceries", 2, function()
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
			action=Action("Cook", 2, function()
				s.p:hold("food")
			end)
		}
	}

	triggers.baby = {
		Trigger{
			name="changeDiap",
			conds={holding("diap"), function() return s.b.poops >= 1 end},
			action=Action("Change diaper", 1.5, function()
				s.b.poops = 0
				s.p:hold("pdiap")
			end)
		}, Trigger{
			name="sleep",
			conds={emptyHand, function() return not s.b.asleep end},
			action=Action("Put baby to sleep", 1, function()
				if s.b.props.wake > 70 then
					notify("Baby didn't sleep")
				else
					s.b:sleep()
				end
			end)
		}, Trigger{
			name="wake",
			conds={emptyHand, function() return s.b.asleep end},
			action=Action("Wake up baby", 2, function()
					s.b:awake()
			end)
		}, Trigger{
			name="play",
			conds={emptyHand, function() return not s.b.asleep end},
			action=Action("Play", 1, function() s.b:adj("love", 20) end)
		}, Trigger{
			name="Feed",
			conds={holding("food")},
			action=Action("Feed baby", 1.5, function()
				s.b:adj("full",30)
				s.p:drop()
			end)
		}
	}
	triggers.work = {
		Trigger{
			name="work",
			conds={emptyHand},
			action=Action("Work", 1, function() s.r.money = s.r.money + 30 end)
		}
	}
	triggers.trash = {
		Trigger{
			name="takeTrash",
			conds={emptyHand},
			action=Action("Take out trash", 2, function()
				s.r.trashInHand = s.r.trash
				s.r.trash = 0
				s.p:hold("trash")
			end)
		}, Trigger{
			name="putTrashBack",
			conds={holding("trash")},
			action=Action("Put trash back", 2, function()
				s.r.trash = s.r.trashInHand
				s.p:drop()
			end)
		}, Trigger{
			name="throw",
			conds={notEmptyHand},
			action=Action("Throw", 4, function()
				if s.r.trash >= objs.trash.maxTrash then
					notify("Trash is full")
				else
					s.p:drop()
					s.r.trash = s.r.trash + 1
				end
			end)
		}
	}

	triggers.truck = {
		Trigger{
			name="dump",
			conds={holding("trash")},
			action=Action("Dump trash", 3, function()
				s.p:drop()
				s.r.trashInHand=0
			end)
		}
	}

	triggers.tbl = {
		Trigger{
			name="stash",
			conds={notEmptyHand, function() return objs.tbl:isEmpty() end},
			action=Action("Stash item",3, function()
				objs.tbl:hold(s.p:drop())
			end)
		},
		Trigger{
			name="pick",
			conds={emptyHand, function() return not objs.tbl:isEmpty() end},
			action=Action("Pick up item",3, function()
				s.p:hold(objs.tbl:drop())
			end)
		},
		Trigger{
			name="swap",
			conds={notEmptyHand, function() return not objs.tbl:isEmpty() end},
			action=Action("Swap items",3, function()
				local temp = s.p:drop()
				s.p:hold(objs.tbl:drop())
				objs.tbl:hold(temp)
			end)
		}
	}
end
