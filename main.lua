-- title:   Baby Simulator
-- author:  Mayank Mandava, mayankmandava@gmail.com
-- desc:    Baby simulator
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

require "sim"

-- <TILES>
-- 000:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 001:ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0fffffff00f
-- 002:fffffff0ffffff00fffff000ffff00fffff00fffff00fffff00fffff00ffffff
-- 003:ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0fffffff00f
-- 004:ffffffffffffffffffffffffffff0ffffff0ffffff0ffffff0ffffff0fffffff
-- 005:fffffffffffffffff0ffffffffffffffffffffffffffffffffffffffffffffff
-- 006:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 007:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 008:7777777777777777777777777878777777777777777777777777777777777777
-- 009:7777777788777777777777777777777777777777777777777777777777777777
-- 010:7777777777777777777777777777777777777777777777777777777777777777
-- 011:7777777777877777777777777777777777777777777777777777777777777777
-- 016:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff
-- 017:fffff000fffff00ffffff0ffffff0ffffff0ffffff0ffffff0ffffff0fffffff
-- 018:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff
-- 019:fffff000fffff00ffffff0ffffff0ffffff0ffffff0ffffff0ffffff0fffffff
-- 020:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0fffffffffffffffff
-- 021:fffffff0ffffffffffffffffffffffffffffffffff0fffffffffffffffffffff
-- 022:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 023:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 024:7777777777777777777777777777777777777777777777777777777777777777
-- 025:7777777777777777877777777777777777777777777777777777777777777777
-- 026:7777777777777777777777777777777777777777777777777777777777777777
-- 027:7777777777777777777777777777777777777777777777777777777777777777
-- 032:fffffff0ffffff00fffff00fffff00fffff00fffff00fffff0ffffff0fffffff
-- 033:ffffffff0fffffff00ffffffff0ffffffff0ffffffff0ffffffff0ffffffff0f
-- 034:fffffff0ffffff00fffff00fffff0ffffff0ffffff0ffffff00fffff00ffffff
-- 035:ffffffff0ffffffff0ffffffff0fffffffffffffffffffffffffffffffffffff
-- 036:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 037:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 038:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 039:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 040:7777777777777777777777777777777777777777777777777777777777777777
-- 041:7777777777777777777777777777777777777777777777777777777777777777
-- 042:7777777777777777777777778777777777777777777777777777777777777777
-- 043:7777777777777777777777777777777777777777777777777777777777777777
-- 048:f0ffffffff0ffffffff0ffffffff0ffffffff0ffffffff00fffffff0ffffffff
-- 049:fffffff0ffffff0ffffff0ffffff0ffffff0ffff000fffff00ffffff0fffffff
-- 050:f0ffffffff0ffffffffffffffffffffffffff0ffffffffffffffffffffffffff
-- 051:ffffffffffffff0fffffffffffffffffffffffffffffffffffffffff0fffffff
-- 052:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 053:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 054:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 055:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 056:7777777777777877777777777777777777777777777777777777777777777777
-- 057:7777777777778777787777777777777777777777777777777777777777777777
-- 058:7777777777777777777777777777777777777777777777777777777777777777
-- 059:7777777777777777777877777778777777777777777777777777777777777777
-- 064:fffffff0ffffff00fffff00fffff0ffffff0ffffff0ffffff00fffff00ffffff
-- 065:ffffffff0ffffffff0ffffffff0fffffffffffffffffffffffffffffffffffff
-- 066:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 067:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 068:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 069:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 070:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 071:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 072:efffefffefffefffefffefffefffeeeeefffefffefffefffefffefffeeeeefff
-- 073:3444344334443443344434433444333334443443344434433444344333333443
-- 074:3444344334443443344434433444333334443443344434433444344333333333
-- 075:3333333334443443344434433444333334443443344434433444344333333443
-- 080:f0ffffffff0ffffffffffffffffffffffffff0ffffffffffffffffffffffffff
-- 081:ffffffffffffff0fffffffffffffffffffffffffffffffffffffffff0fffffff
-- 082:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 083:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 084:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 085:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 086:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 087:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 088:3444344434443444344434443444333334443444344434443444344433333444
-- 089:3444344434443444344434443444333334443444344434443444344433333444
-- 090:3444344434443444344434443444333334443444344434443444344433333444
-- 091:3444344434443444344434443444333334443444344434443444344433333444
-- 096:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 097:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 098:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 099:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 100:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 101:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 102:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 103:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 104:6666666666666666666666666666666666656566666656666666666666666666
-- 105:6666666666666666666666666666666666666666666666666666666666666666
-- 106:ffffffff2222224f2222224f2222224f2222224f2222224f2222224f2222224f
-- 107:fffffffff222222ff222222ff222222ff222222ff222222ff222222ff222222f
-- 112:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 113:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 114:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 115:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 116:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 117:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 118:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 119:ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
-- 120:6666666666666666666666666666666666666666666666666666666666666666
-- 121:6666666666666666666666665556666666666666666666666666666666666666
-- 122:2222224f2222224f2222224f2222224f2222224f2222224f2222224f2222224f
-- 123:f222222ff222222ff222222ff222222ff222222ff222222ff222222ff222222f
-- 128:3333333333333333333333333333333333333333333333333333333333333333
-- 129:3333333c333333cc33333ccc3333cccc333ccccc33cccccc3ccccccccccccccc
-- 130:c3333333cc333333ccc33333cccc3333ccccc333cccccc33ccccccc3cccccccc
-- 131:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 138:2222224f2222224f2222224f2222224f2222224f2222224f2222224f2222224f
-- 139:f222222ff222222ff222222ff222222ff222222ff222222ff222222ff222222f
-- 144:cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
-- 145:cccccccc3ccccccc33cccccc333ccccc3333cccc33333ccc333333cc3333333c
-- 146:ccccccccccccccc3cccccc33ccccc333cccc3333ccc33333cc333333c3333333
-- 154:2222224f2222224f2222224f2222224f2222224f2222224f2222224fffffffff
-- 155:f222222ff222222ff222222ff222222ff222222ff222222ff222222fffffffff
-- 160:4444444446666664466666644666666446666664466666644666666444444444
-- </TILES>

-- <SPRITES>
-- 000:00cde0000c000d00c00c00e0c0cc00e0c00000e00c000d0000cde00000000000
-- 001:0008800000833800083333808caccac88aaccaa808cccc80088cc88000888800
-- 002:000000000c302200c3333328c33333280c33328000c328000002800000000000
-- 003:0000cccc00dddddceeeeedc0000edc0000edcccc0eddddd0eeeee00000000000
-- 004:00000000ccaccacc0aaccaa800cccc80000cc800000080000000000000000000
-- 005:55555555566666665665555556555ccc56555ccc566555555666666655555555
-- 006:555555556666666555555665ccc55565ccc55565555556656666666555555555
-- 007:00444400044444404fc44fc44fc44fc444444444044444480088888000000000
-- 008:000ee000eeeeeeeeeeeeeeee0cecece00cecece00cecece00cecece00eeeeee0
-- 009:00000fc00000fcf8000fcf80000cccc80000fcf8000fcf80000cf80000008000
-- 010:0033300000033300003333300333333333c33c3333333333033cc33000000000
-- 011:0030000000030000003330000333330033c3c330033333800033380000088000
-- 012:6060000006600000233200002332800023328000232800002280000008000000
-- 013:0006800000666800068686800066800000066800068686800066680000068000
-- 016:000088880008ff22008f663308fff6338fff6f228fffffff8888888808666666
-- 017:8888000022ff8000332ff80033322f80222ffff8fffffff88888888866666680
-- 018:00888888888eeeee8eeeeeee8eeeeeee8888888808ddceec08ddceec08ddceec
-- 019:88888800eeeee888eeeeeee8eeeeeee888888888eeceee80eeceee80eeceee80
-- 020:03300000322300c232c230c2322230c2322300c23230000003000000000000aa
-- 021:00000000222c0000222c0000222c0000222c00000000000000000000aaaa0000
-- 022:0000000000550000000550550005555500000555000008880000055500005555
-- 023:0000000000000000050000005000000000000000000000000000000050000000
-- 026:00000ddd00000dcc00000dcc00000ddd0000000d0000222d000233dd00233ddd
-- 027:ddd00000ccd00000ccd00000ddd00000d0000000d2220000dd332000ddd33200
-- 028:dddddddddd2222ddd233332dd233332ddd2222ddddddddddcccccccccfffffff
-- 029:dddddddddd2222ddd233332dd233332ddd2222ddddddddddccccccccfffffffc
-- 030:000088880008ffff008fccac08fffaac8fffffcc8fffffff888888880866666c
-- 031:88880000ffff8000caccf800caafff80ccfffff8fffffff8c8888888cc666680
-- 032:0866666608666666086666660866666608666666086666660866666608888888
-- 033:6666668066666680666666806666668066666680666666806666668088888880
-- 034:08ddceec088dceec008dceec008dceec008dceec008dceec008ddeee00888888
-- 035:eeceee80eecee880eecee800eecee800eecee800eecee800eeeee80088888800
-- 036:060600aa00660099023320990233209902332099023200990220009900200000
-- 037:aaaa000099990000999900009999000099990000999900009999000000000000
-- 038:0005555600555565005556550055655500556666000555550000555500000000
-- 039:5500000065500000565000005560000066500000555000005500000000000000
-- 042:0233333322222222023200000232000002322222023200000220000002000000
-- 043:3333332022222222000023200000232022222320000023200000220000002000
-- 044:cfcccccccffcffffcfffffffcfffffffcfffffffcfffffffcfffffffcccccccc
-- 045:ccccccfcffffcffcfffffffcfffffffcfffffffcfffffffcfffffffccccccccc
-- 046:086666c6086666c60866666c08666666086666c60866666c0866666608888888
-- 047:c6c66680c6666680cc666680c6c66680c6c66680cc666680c666668088888880
-- 048:00002222002222220022222402222444022004442200044420000aaa0000aaaa
-- 049:2200000022000000cf000000440000004400000044000000aa000000aaa00000
-- 050:00002222002222220022222402222444022004442200044420000aaa0000aaaa
-- 051:2200000022000000cf000000440000004400000044000000aa000000aaa00000
-- 052:00002222002222220022222402222444022004442200044420000aaa0000aaaa
-- 053:2200000022000000cf000000440000004400000044000000aa000000aaa00000
-- 064:000aaaaa00aa0aaa00c00aaa00000ccc00000cc000000cc000000cc000000aa0
-- 065:aaaa0000aa0aa000aa00c000cc000000cc000000cc000000cc000000aa000000
-- 066:000aaaaa00aa0aaa00c00aaa00000ccc00000cc000000cc000000aa000000000
-- 067:aaaa0000aa0aa000aa00c000cc000000cc000000cc000000cc000000aa000000
-- 068:000aaaaa00aa0aaa00c00aaa00000ccc00000cc000000cc000000cc000000aa0
-- 069:aaaa0000aa0aa000aa00c000cc000000cc000000cc000000aa00000000000000
-- 080:00000888000084440008444400844fc400844fc4008444440008444400008444
-- 081:888000004448000044448000fc444800fc444800444448004444800044480000
-- 082:000008880000844400084444008444440084444400844ff40008444400008444
-- 083:88800000444800004444800044444800444448004ff448004444800044480000
-- 085:dddddddddfffffffdfff2222dff23333dff23333dfff2222dfffffffdfffffff
-- 086:ddddddddfffffffd2222fffd33332ffd33332ffd2222fffdfffffffdfffffffd
-- 087:0000000000088888000855550008566600855655008565550855655508566555
-- 088:0000000088888888555555556666666655555555555555555ccc5555c555c555
-- 089:0000000088800000558000006580008865800844658008446580084465800844
-- 090:000000000000000000000000888000009ab800009ab800009aab80009aab8000
-- 096:0008444400844444084444440088ccac00084aac000844cc0008448800088880
-- 097:444480004444480044444480cacc8800caa48000cc4480008844800008888000
-- 098:0008444400844444084444440088ccac00084aac000844cc0008448800088800
-- 099:444480004444480044444480cacc8800caa48000cc4480008844800008888000
-- 101:dfff2222dff23333dff23333dfff2222dfffffffdddddddddddddddddddddddd
-- 102:2222fffd33332ffd33332ffd2222fffdfffffffddddddddddddddddddddddddd
-- 103:0856555c8556555585655555856555558565566685666688085558ee08558eee
-- 104:55555c55c555c5555ccc555555555555655555556666666685555555e8555555
-- 105:6580084465800844658008446580084465800844655884445555544455555444
-- 106:9aaab8009aaab8009999998044444448444444484488444848ee84488eeee848
-- 112:00033300000033300003333300333333033c333c333333333333ccc303333333
-- 113:0000000000000000000000003000000033000000333000003330000033000000
-- 114:033066603223818032c281c83222811832238118323881180388118008808800
-- 115:ccaccacc0aaccaa800cccc88000cc88a000088c80000cc880000088c00000cc8
-- 116:8000000080000000c8000000880000008c800000a88000008800000080000000
-- 117:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 118:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 119:0888eeee00008eee000008ee0000008800000000000000000000000000000000
-- 120:ee888888e8000000800000000000000000000000000000000000000000000000
-- 121:8888888800000000000000000000000000000000000000000000000000000000
-- 122:eeeeee808eeee80008ee80000088000000000000000000000000000000000000
-- 128:000cc00000cccc000cccccc04c4c444404c44448004444800008888000000000
-- 131:0000008800000000000000000000000000000000000000000000000000000000
-- 133:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 134:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 144:000000000000000f0ffffff4f4444444f4444444f4444444f4444444f4444444
-- 145:ffffffff444444444fff4f4f4f444f4f4fff4fff444f4f4f4fff4f4f44444444
-- 146:ffffffff444444444fff4fff4f4f4f4f4f4f4fff4f4f4f444ff44f4444444444
-- 147:f00000004f00000044fffff04444444f4444444f4444444f4444444f4444444f
-- 148:0008888800084444000844440084444400844444084444440844444484444444
-- 149:8888888844444444444444444444444444444444444444444444444444444444
-- 150:8888888844444444444444444444444444444444444444444444444444444444
-- 151:8888800044448000444480004444480044444800444444804444448044444448
-- 152:00000000000000000000000000000888000008cc000008cd000008dd000008de
-- 153:00000000000008cc0000008888888888ddeeeeeed888e888eeeeeeeeeee88888
-- 154:00000000800000000000000088888888eeeeeeeeee88888eeeeeeeee8888e8ee
-- 155:00000000000000000000000088000000e8000000e8000000e8000000e8000000
-- 160:fffffffffcccccccfcccfffffccf6666fccf6666fccf6666fccf6666fccf6666
-- 161:ffffffffccccccccfffffccc66666fcc66666fcc66666fcc66666fcc66666fcc
-- 162:ffffffffcccccccccccfffffccfcbcb9ccfbcb99ccfcb999ccfb9999ccf99999
-- 163:ffffffffcccccccffffffccf99999fcf99999fcf99999fcf99999fcf99999fcf
-- 164:8444444488888888222222222222222222222222223333332233333322332222
-- 165:4444444488888888222222222222222222222222333333333333333322222223
-- 166:4444444488888888222222222222222222222222333333333333333332222222
-- 167:4444444888888888222222222222222222222222333333223333332222223322
-- 168:000008ee000008ee000008880000000000000222000023330002333300233333
-- 169:eeeeeeeeeeeeeeee888888880000008822222288333388883338ff88338fffff
-- 170:eeeeeeeeeeeeeeee88888888000000002222222288333333ff833338fff83333
-- 171:e8000000e8000000880000000000000022200000333200008333200088333200
-- 176:fccf6666fccf6666fccf6666fccf6666fccf6666fccf6666fccf6666fccf6666
-- 177:66666fcc66ff6fcc66666fcc66666fcc66666fcc66666fcc66666fcc66666fcc
-- 178:ccf99999ccf99999ccf99999ccf99999ccf99999ccf99999ccf99999ccf99999
-- 179:99999fcf99999fcf99999fcf99999fcf99999fcf99999fcf99999fcf99999fcf
-- 180:2233222222332222223322222233222222332222223322222233222222332222
-- 181:2222222322222223222222232222222322882223228822232222222322222223
-- 182:3222222232222222322222223222222232228822322288223222222232222222
-- 183:2222332222223322222233222222332222223322222233222222332222223322
-- 184:0233333323333333222222220002333300023333000233330002333300023333
-- 185:3888888833333333222222222000000020000000200000002000000020000000
-- 186:8888833333333333222222220000002300000023000000230000002300000023
-- 187:3333332033333332222222223332000033320000333200003332000033320000
-- 192:fcccfffffcccccccfffffffff666f222f666fffff66f2222f66f2222ffffffff
-- 193:fffffcccccccccccffffffff2222f666fffff66622222f6622222f66ffffffff
-- 194:cccfffffccccccccffffffff66666666666666666666666666666666ffffffff
-- 195:fffffccfcccccccfffffffff6666666f6666666f6666666f6666666fffffffff
-- 196:2233222222332222223322222233222222333333223333332222222222222222
-- 197:2222222322222223222222232222222333333333333333332222222222222222
-- 198:3222222232222222322222223222222233333333333333332222222222222222
-- 199:2222332222223322222233222222332233333322333333222222222222222222
-- 200:0002333300023333000233330002333200023320000232000002200000020000
-- 201:2000000022222222200000000000000000000000000000000000000000000000
-- 202:0000002322222223000000230000000200000000000000000000000000000000
-- 203:3332000033320000333200003332000023320000023200000022000000020000
-- </SPRITES>

-- <MAP>
-- 001:848484848484848484848484848484848484b48696869686968696869686960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000084
-- 002:848484848484848484848484848484848484948797879787978797879787970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000085
-- 003:848090b28292a2b28292a2b28292a2b28284948696968696869686968686960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:8481918090a0b08090a0b08090a0b0809084948797978797879787978787970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080
-- 005:8482928191a1b18191a1b18191a1b1819184948696869686968696869686960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000081
-- 006:848393b08090a0b08090a0b08090a0b08084a48797879787978797879787970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000082
-- 007:848090b18191a1b18191a1b18191a1b18184a6b696869686968696869686960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000083
-- 008:848191b28292a2b28292a2b28292a2b28284a7b797879787978797879787970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080
-- 009:8482928090a0b08090a0b08090a0b0809084a8b896869686968696869686960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000081
-- 010:8483938191a1b18191a1b18191a1b1819184a9b997879787978797879787970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000082
-- 011:848090b08090a0b08090a0b08090a0b08084b48696869686968696869686960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000083
-- 012:848191b18191a1b18191a1b18191a1b18184948797879787978797879787970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:84829290a0b08090a0b08090a0b08090a084948696869686968696869686960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:84839391a1b18191a1b18191a1b18191a184948797879787978797879787970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:848484848484848484848484848484848484948696869686968696869686960000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:848484848484848484848484848484848484a48797879787978797879787970000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 017:8292a2b28292a2b28292a2b28292a2b28292a2b28393a3b38393a38393a3b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 018:8393a3b38393a3b38393a3b38393a3b38393a3b3000000008393a3b30000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b7642571790800003b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

