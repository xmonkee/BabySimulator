-- title:   Baby Simulator
-- author:  Mayank Mandava, mayankmandava@gmail.com
-- desc:    Baby simulator
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

require "baby"

-- <TILES>
-- 000:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 001:ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0fffffff00f
-- 002:fffffff0ffffff00fffff000ffff00fffff00fffff00fffff00fffff00ffffff
-- 003:ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0fffffff00f
-- 004:ffffffffffffffffffffffffffff0ffffff0ffffff0ffffff0ffffff0fffffff
-- 005:fffffffffffffffff0ffffffffffffffffffffffffffffffffffffffffffffff
-- 006:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 007:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 016:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff
-- 017:fffff000fffff00ffffff0ffffff0ffffff0ffffff0ffffff0ffffff0fffffff
-- 018:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff
-- 019:fffff000fffff00ffffff0ffffff0ffffff0ffffff0ffffff0ffffff0fffffff
-- 020:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0fffffffffffffffff
-- 021:fffffff0ffffffffffffffffffffffffffffffffff0fffffffffffffffffffff
-- 022:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 023:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 032:fffffff0ffffff00fffff00fffff00fffff00fffff00fffff0ffffff0fffffff
-- 033:ffffffff0fffffff00ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0f
-- 034:fffffff0ffffff00fffff00fffff0ffffff0ffffff0ffffff00fffff00ffffff
-- 035:ffffffff0ffffffff0ffffffff0fffffffffffffffffffffffffffffffffffff
-- 036:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 037:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 038:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 039:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 048:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff00fffffff0ffffffff
-- 049:fffffff0ffffff0ffffff0ffffff0ffffff0ffff000fffff00ffffff0fffffff
-- 050:f0ffffffff0ffffffffffffffffffffffffff0ffffffffffffffffffffffffff
-- 051:ffffffffffffff0fffffffffffffffffffffffffffffffffffffffff0fffffff
-- 052:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 053:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 054:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 055:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 064:fffffff0ffffff00fffff00fffff0ffffff0ffffff0ffffff00fffff00ffffff
-- 065:ffffffff0ffffffff0ffffffff0fffffffffffffffffffffffffffffffffffff
-- 066:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 067:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 068:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 069:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 070:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 071:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 080:f0ffffffff0ffffffffffffffffffffffffff0ffffffffffffffffffffffffff
-- 081:ffffffffffffff0fffffffffffffffffffffffffffffffffffffffff0fffffff
-- 082:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 083:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 084:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 085:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 086:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 087:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 096:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 097:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 098:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 099:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 100:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 101:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 102:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 103:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 112:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 113:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 114:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 115:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 116:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 117:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 118:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 119:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 128:3333333333333333333333333333333333333333333333333333333333333333
-- 129:3333333c333333cc33333ccc3333cccc333ccccc33cccccc3ccccccccccccccc
-- 130:c3333333cc333333ccc33333cccc3333ccccc333cccccc33ccccccc3cccccccc
-- 131:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 144:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 145:cccccccc3ccccccc33cccccc333ccccc3333cccc33333ccc333333cc3333333c
-- 146:ccccccccccccccc3cccccc33ccccc333cccc3333ccc33333cc333333c3333333
-- 160:4444444446666664466666644666666446666664466666644666666444444444
-- </TILES>

-- <SPRITES>
-- 000:00cde0000c000d00c00c00e0c0cc00e0c00000e00c000d0000cde00000000000
-- 002:000000000c302200c3333320c33333200c33320000c320000002000000000000
-- 003:0000cccc00dddddceeeeedc0000edc0000edcccc0eddddd0eeeee00000000000
-- 004:c0000000000000000000000000000000c0000000000000000000000000000000
-- 005:55555555566666665665555556555ccc56555ccc566555555666666655555555
-- 006:555555556666666555555665ccc55565ccc55565555556656666666555555555
-- 007:00c333000c444440c4c44c43c4444443c4244243c44224430c44444000c33300
-- 008:000ee000eeeeeeeeeeeeeeee0cecece00cecece00cecece00cecece00eeeeee0
-- 018:000eeeee000eeeeeeeeeeeeeeeeeeeee0000000000ddceec00ddceec00ddceec
-- 019:eeeee000eeeee000eeeeeeeeeeeeeeee00000000eeceee00eeceee00eeceee00
-- 020:03300000322300c232c230c2322230c2322300c23230000003000000000000aa
-- 021:00000000222c0000222c0000222c0000222c00000000000000000000aaaa0000
-- 022:444444444444444444444444222222222333333323cccc3321cccc1121999911
-- 023:4444444444444444444444442222222263633332366333322332111223331112
-- 024:4444444444444444444444442222222223333333233333332111111121111111
-- 025:4444444444444444444444442222222233333332333333321111111211111112
-- 026:00000ddd00000dcc00000dcc00000ddd0000000d0000222d000233dd00233ddd
-- 027:ddd00000ccd00000ccd00000ddd00000d0000000d2220000dd332000ddd33200
-- 028:dddddddddd2222ddd233332dd233332ddd2222ddddddddddccccccccc8888888
-- 029:dddddddddd2222ddd233332dd233332ddd2222ddddddddddcccccccc8888888c
-- 034:00ddceec000dceec000dceec000dceec000dceec000dceec000ddeee0000deee
-- 035:eeceee00eecee000eecee000eecee000eecee000eecee000eeeee000eeee0000
-- 036:060600aa00660099023320990233209902332099023200990220009900200000
-- 037:aaaa000099990000999900009999000099990000999900009999000000000000
-- 038:2199991122222222233333332333333321c222c121c222c121c222c122222222
-- 039:23321112222222223333333232223332133311123c2231121333331222222222
-- 040:2111111122222222233333332333333321111111211111112111111122222222
-- 041:1111111222222222333333323333333211111112111111121111111222222222
-- 042:0233333322222222023200000232000002322222023200000220000002000000
-- 043:3333332022222222000023200000232022222320000023200000220000002000
-- 044:c8ccccccc88c8888c8888888c8888888c8888888c8888888c8888888cccccccc
-- 045:cccccc8c8888c88c8888888c8888888c8888888c8888888c8888888ccccccccc
-- 048:0000222200222222002222240222244402200444220004442000099900009999
-- 049:2200000022000000cf0000004400000044000000440000009900000099900000
-- 050:0000222200222222002222240222244402200444220004442000099900009999
-- 051:2200000022000000cf0000004400000044000000440000009900000099900000
-- 052:0000222200222222002222240222244402200444220004442000099900009999
-- 053:2200000022000000cf0000004400000044000000440000009900000099900000
-- 064:000999990099099900c0099900000ccc00000cc000000cc000000cc000000990
-- 065:99990000990990009900c000cc000000cc000000cc000000cc00000099000000
-- 066:000999990099099900c0099900000ccc00000cc000000cc00000099000000000
-- 067:99990000990990009900c000cc000000cc000000cc000000cc00000099000000
-- 068:000999990099099900c0099900000ccc00000cc000000cc000000cc000000990
-- 069:99990000990990009900c000cc000000cc000000cc0000009900000000000000
-- 080:00000044000004440000444400044fc400044fc4000444440000444400000444
-- 081:440000004440000044440000fc444000fc444000444440004444000044400000
-- 082:000000440000044400004444000444440004444400044ff40000444400000444
-- 083:44000000444000004444000044444000444440004ff440004444000044400000
-- 096:0000444400044444004444440000cccc00004ccc000044cc0000440000004400
-- 097:444400004444400044444400cccc0000ccc40000cc4400000044000000440000
-- 098:0000444400044444004444440000cccc00004ccc000044cc0000440000004400
-- 099:444400004444400044444400cccc0000ccc40000cc4400000044000000440000
-- 112:00033300000033300003333300333333033c333c333333333333ccc303333333
-- 113:0000000000000000000000003000000033000000333000003330000033000000
-- </SPRITES>

-- <MAP>
-- 007:280808182808081828080818280808182808081828080818280808182808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:092818093828180938281809382818093828180938281809382818093828000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:092919383829193838291938382919383829193838291938382919383829000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:290808192908081929080819290808192908081929080819290808192908000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>
