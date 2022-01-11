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
        E="Energy", C="Calm", B="Boredom",
        DF="DiaperFullness", H="Happiness"
    }
    renderBabyFields = {"E", "C", "H"}
    renderParentFields = {"E", "C", "H"}
    colors={label=5}
end

function initState()
    baby = {E=100, C=100, B=0, DF=0}
    parent = {E=100, C=100, H=100}

    function baby.H(self)
        return self.DF + self.B
    end
end


function init()
    initConstants()
    initState()
end

init()

------------------------------------------------------------------

function renderBabyState()
    for i,field in pairs(renderBabyFields) do
        local x=(9-string.len(labels[field]))*4
        local y = i*8
        x = print(labels[field],x,y,colors.label, true, 1, true)
        for j=1,baby[field]//10 do
            spr(0,x,y,0)
            x=x+4
        end
    end
end

function renderParentState()
end

function render()
    renderBabyState()
    renderParentState()
end

------------------------------------------------------------------

function TIC()
    cls(0)
	t=t+1
    render()
end

-- <TILES>
-- 000:6666000065560000655600006556000065560000655600006556000066660000
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

