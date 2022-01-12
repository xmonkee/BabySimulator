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
    baby = {E=100, C=100, B=0, DF=100}
    setmetatable(baby, {
        __index=function(table,key)
            if key=="H" then return table.B + table.DF end
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
        rectb(x,y,20,7,colors.meter)
        rect(x,y,person[field]//20*4,7, colors.meter)
    end
end

function drawMeters()
    drawMeter(baby, "--Baby--", 0, 0)
    drawMeter(parent, "--Papa--", 0, 40)
end

function drawClock()
    print("Time: "..math.floor(hour)..":"..math.floor(minute), 90,0, colors.label)
    line(120,0,120,100,5)
end

function draw()
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

-- <TILES>
-- 000:6666000065560000655600006556000065560000655600006666000000000000
-- </TILES>

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

