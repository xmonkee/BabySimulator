-- title:   game title
-- author:  game developer, email, etc.
-- desc:    short description
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua

function initConstants()
    t=0
    labels = {
        E="Ener", C="Calm", B="Boredom",
        DF="DiaperFullness", H="Happ"
    }
    meterFields = {"E", "C", "H"}
    colors={label=12, meter=5, background=0}
end

function initState()
    baby = {E=100, C=100, B=0, DF=50}
    setmetatable(baby, {
        __index=function(table,key)
            if key=="H" then return 100 - math.min(100, table.B + table.DF) end
            return nil
        end
    })
    parent = {E=50, C=100, H=100}
end


function init()
    initConstants()
    initState()
end

init()

------------------------------------------------------------------

function drawMeter(person, label, startx, starty)
    print(label, startx, starty, colors.label)
    for i,field in pairs(meterFields) do
        local x=startx
        local y = starty + (i)*8
        x = x + print(labels[field],x,y,colors.label, true, 1, true) + 1
        rectb(x,y,24,7,colors.label)
        rect(x+2,y+2,person[field]/20*4,3, colors.meter)
    end
end

function drawMeters()
    drawMeter(baby, "--Baby--", 0, 0)
    drawMeter(parent, "--Papa--", 0, 35)
end

function drawClock()
    spr(258,100,0,0)
    print(string.format("%.2d:%.2d", math.floor(hour), math.floor(minute)), 110,1, colors.label, true, 1, true)
end

function draw()
    rect(119,0,1,136,5)
    rect(0,67,240,1,5)
    drawMeters()
    drawClock()
end

------------------------------------------------------------------

function TIC()
    cls(colors.background)
	t=t+1
    minute=(t/60) % 60
    hour=(t/(60*60)) % 24
    draw()
end

-- <SPRITES>
-- 000:00cdedc00d00c00dc000c000d000c000e0ccc000d0000200c00000200d00000d
-- 001:0000000000000000c0000000d0000000e0000000d0000000c000000000000000
-- 002:00cde0000c000d00c00c00e0c0cc00e0c00000e00c000d0000cde00000000000
-- 016:00cdedc000000000000000000000000000000000000000000000000000000000
-- </SPRITES>

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

