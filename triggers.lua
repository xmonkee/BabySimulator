
function initTriggers()

	local emptyHand = function()
		return players.parent:emptyHanded()
	end

	local notEmptyHand = function()
		return not players.parent:emptyHanded()
	end

	local holding = function(thing)
		return function()
			return players.parent:isHolding(thing)
		end
	end

	triggers = {}


	triggers.dshelf = {
		Trigger{
			name="takeDiap",
			conds={emptyHand, function() return res.diap >= 1 end},
			action=Action("Take diaper", 3, function()
				res.diap = res.diap - 1
				players.parent:hold("diap")
			end)
		}, Trigger{
			name="storeDiaps",
			conds={holding("diaps")},
			action=Action("Store diapers", 2, function()
				res.diap = res.diap + 3
				players.parent:drop()
			end)
		}, Trigger{
			name="storeDiap",
			conds={holding("diap")},
			action=Action("Store diaper", 3, function()
				res.diap = res.diap + 1
				players.parent:drop()
			end)
		}
	}

	triggers.gshelf = {
		Trigger{
			name="takeIngr",
			conds={emptyHand,function() return res.groc >= 1 end},
			action=Action("Take ingredients", 3, function()
				res.groc = res.groc - 1
				players.parent:hold("ingr")
			end)
		}, Trigger{
			name="storeGrocs",
			conds={holding("groc")},
			action=Action("Store groceries", 2, function()
				res.groc = res.groc + 3
				players.parent:drop()
			end)
		}, Trigger{
			name="storeIngr",
			conds={holding("ingr")},
			action=Action("Store ingredients", 2, function()
				res.groc = res.groc + 1
				players.parent:drop()
			end)
		}
	}

	triggers.dstore = {
		Trigger{
			name="buyDiaps",
			conds={emptyHand, function() return res.money >= costs.diaps end},
			action=Action("Buy diapers", 2, function()
				players.parent:hold("diaps")
				res.money = res.money - costs.diaps
			end)
		}
	}

	triggers.gstore = {
		Trigger{
			name="buyGroc",
			conds={emptyHand, function() return res.money >= costs.groc end},
			action=Action("Buy groceries", 2, function()
				players.parent:hold("groc")
				res.money = res.money - costs.groc
			end)
		}
	}

	triggers.stove = {
		Trigger{
			name="cook",
			conds={holding("ingr")},
			action=Action("Cook", 2, function()
				players.parent:hold("food")
			end)
		}
	}

	triggers.baby = {
		Trigger{
			name="changeDiap",
			conds={holding("diap"), function() return players.baby.poops >= 1 end},
			action=Action("Change diaper", 1.5, function()
				players.baby.poops = 0
				players.parent:hold("pdiap")
			end)
		}, Trigger{
			name="play",
			conds={emptyHand},
			action=Action("Play", 1, function()
				players.baby.props.love=min(100, players.baby.props.love+50)
			end)
		}, Trigger{
			name="Feed",
			conds={holding("food")},
			action=Action("Feed baby", 1.5, function()
				players.baby.props.full=min(100, players.baby.props.full+30)
				players.parent:drop()
			end)
		}
	}
	triggers.work = {
		Trigger{
			name="work",
			conds={emptyHand},
			action=Action("Work", 1, function() res.money = res.money + 30 end)
		}
	}
	triggers.trash = {
		Trigger{
			name="takeTrash",
			conds={emptyHand},
			action=Action("Take out trash", 2, function()
				res.trashInHand = res.trash
				res.trash = 0
				players.parent:hold("trash")
			end)
		}, Trigger{
			name="putTrashBack",
			conds={holding("trash")},
			action=Action("Put trash back", 2, function()
				res.trash = res.trashInHand
				players.parent:drop()
			end)
		}, Trigger{
			name="throw",
			conds={notEmptyHand, function() return not players.parent:isHolding("trash") end},
			action=Action("Throw", 4, function()
				if res.trash >= objs.trash.maxTrash then
					notify("Trash is full")
				else
					players.parent:drop()
					res.trash = res.trash + 1
				end
			end)
		}
	}

	triggers.truck = {
		Trigger{
			name="dump",
			conds={holding("trash")},
			action=Action("Dump trash", 3, function()
				players.parent:drop()
				res.trashInHand=0
			end)
		}
	}

	triggers.tbl = {
		Trigger{
			name="stash",
			conds={notEmptyHand, function() return objs.tbl:isEmpty() end},
			action=Action("Stash item",3, function()
				objs.tbl:hold(players.parent:drop())
			end)
		},
		Trigger{
			name="pick",
			conds={emptyHand, function() return not objs.tbl:isEmpty() end},
			action=Action("Pick up item",3, function()
				players.parent:hold(objs.tbl:drop())
			end)
		},
		Trigger{
			name="swap",
			conds={notEmptyHand, function() return not objs.tbl:isEmpty() end},
			action=Action("Swap items",3, function()
				local temp = players.parent:drop()
				players.parent:hold(objs.tbl:drop())
				objs.tbl:hold(temp)
			end)
		}
	}
end
