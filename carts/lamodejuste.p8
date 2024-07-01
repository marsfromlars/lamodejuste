pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- la mode juste
-- (c) 1985,2024 lamosoft

function _init()
    cls()
    srand(33)
    defaults()
    pos = 0
    dir, step = 1, 3
    charw, charh = 5, 7
    apps = { create_menu(), create_fan(), create_flags(), create_spacerock() }
    return_to_menu()
    print( "starting up "..app.name )
end

function return_to_menu()
    app_num = 1
    app = apps[ app_num ]
end

function _update60()
    if app == nil then return end
    app:update()
end

function _draw()
    if app == nil then return end
    app:draw()
    rectfill(0,0,127,7,0)
    print( time_string().." "..app_num.." "..app.name, 0, 0, white )

end

-->8
-- app: menu ---------------------------------------------------------------

function create_menu()

    local menu = {
        name = "menu",
        selected = 1
    }

    function menu:update()
        if btnp( up ) then self.selected -= 1 end
        if btnp( down ) then self.selected += 1 end
        if self.selected < 1 then
            self.selected = #apps - 1
        elseif self.selected > #apps - 1 then
            self.selected = 1
        end
        if btnp( action ) then 
            app_num = self.selected + 1
            app = apps[ app_num ]
            app:activate()
        end
    end

    function menu:draw()
        w = 10 * charw + 1
        h = 5 * charh + 1
        x = maxx/2 - w/2
        y = maxy/2 - h/2
        rectfill(x,y,x+w,y+h,black)
        rect(x,y,x+w,y+h,white)
        for i=1,min(5,#apps-1) do
            yrow = y+((i-1)*charh)+2
            textcolor = white
            if i == self.selected then
                rectfill(x+1,yrow-1,x+w-1,yrow+charh-2,red)
                textcolor = black
            end
            print(apps[i+1].name,x+2,yrow,textcolor)
        end
    end

    return menu

end

-->8
-- app: fan ---------------------------------------------------------------

function create_fan()

    local fan = {
        name = "fan"
    }

    function fan:activate()
        cls()
    end

    function fan:update()
        if btnp( action ) then return_to_menu() end
        color = 1+flr(rnd(15))
        pos += step
        if pos > 127 or pos < 0 then
            dir = -dir
            step = dir * ( 2 + flr(rnd(10)) )
            pos = max( 0, pos )
            pos = min( 127, pos )
        end
    end

    function fan:draw()
        rectfill(0,120,127,127,0)
        print( pos, pos, 120, color )    
        line(64,7,pos,118,color)
    end

    return fan

end

-->8
-- app: flags ---------------------------------------------------------------

function create_flags()

    local flags = {
        name = "flags",
        flag_created = false
    }

    function flags:activate()
        self.flag_created = false
    end

    function flags:update()
        if btnp( action ) then return_to_menu() end
        if btnp( down ) then self.flag_created = false end
    end

    function flags:draw()
        if not self.flag_created then
            cls()
            top = 10
            bot = 120
            h = (bot-top)/3
            rectfill(0,top,127,top+h,flr(rnd(16)))
            rectfill(0,top+h,127,top+2*h,flr(rnd(16)))
            rectfill(0,top+2*h,127,top+3*h,flr(rnd(16)))
            print( "press ⬇️ (down) for next flag", 0, 121, white )
            self.flag_created = true
        end
    end

    return flags

end

-->8
-- app: spacerock ---------------------------------------------------------------

function create_spacerock()

    local spacerock = {
        name = "spacerock",
        sky = { dark_gray, yellow, orange, red, purple, dark_blue },
        bluesky = { blue, gray, lavender, dark_blue }
    }

    function spacerock:activate()
        rock = create_rock()
    end

    function spacerock:update()
        if btnp( action ) then return_to_menu() end
        if rock != nil then rock:update() end
    end

    function spacerock:draw()
        cls()
        self:draw_space( true, 2, self.sky )
        self:draw_space( false, 2, self.bluesky )
        if rock != nil then
            rock:draw()
        end
    end

    function spacerock:draw_space( up, resolution, colors )
        if up then step = -1 else step = 1 end
        y=maxy/2 + step * 15
        color = 0
        while y >= 0 and y < maxy do
            for i=0,resolution do
                hor(y+i,colors[color])
            end
            color += 1
            if color > #colors then color = #colors end
            y += step*resolution
        end
    end

    return spacerock

end

function create_rock()
    local rock = {
        x = maxx,
        y = maxy / 2 - 10 + rnd(20),
        sprite_num = 0
    }
    function rock:update()
        self.x -= 0.5
        printh( "update "..self.x )
    end
    function rock:draw()
        spr( self.sprite_num, self.x, self.y )
    end
    return rock
end

-->8
-- utils ---------------------------------------------------------------

function defaults() 
    maxx, maxy = 128, 128
    black,dark_blue,purple,dark_green,brown,dark_gray,gray,white,red,orange,yellow,green,blue,lavender,pink,beige=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    up, down, action, action2 = 2, 3, 5, 4
end

function time_string()
    return two_digits(stat(93))..":"..two_digits(stat(94))..":"..two_digits(stat(95))
end

function two_digits(num)
    if num < 10 then
        return "0"..num
    else
        return num
    end
end

-- horizontal line
function hor( y, col )
    line( 0, y, 128, y, col )
end

__gfx__
00666600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
06555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65505551000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65055551000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
65555051000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05505510000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
77007770000077707070000077007770000077707770077007700070077077707000000000007700007077000000000000000000000000000000000000000000
07007070070070007070070007000070000070707070707070000700700070007000070000000700070007000000000000000000000000000000000000000000
07007070000077707770000007000770000077707700707070000700777077007000000000000700070007000000000000000000000000000000000000000000
07007070070000700070070007000070000070007070707070700700007070007000070000000700070007000000000000000000000000000000000000000000
77707770000077700070000077707770000070007070770077707000770077707770000000007770700077700000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000e4e00000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000e1100000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000e43ee0000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000e6a610000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000e43b85e000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000eb1b819000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000e46bb311e00000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000e73383e5ac0000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000e4b1383ea9e0000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000e7761a83611ac000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000e4b3ba836159e000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000e7763ba8361a1ac00000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000e4b613a838ea19e00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000e77b313b838e159ac0000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000e4763b3b838e151aec000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000e74b61b3b83861a19ac000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000e47b31bab8386ea51aec00000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000e74b6313ab8386e1519ac00000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000e747b63b3ab8786e1a59aec0000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000e747631b3ab8786e1a519ac0000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000e747b631b3ab8736e1a519aec000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000e747b631b3ab87386e1a519ac000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000e747b631b36ab87386e1a519aec00000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000e747b631b3ab787386e1a519abec0000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000e7471b631b3ab787386e1ae519aec0000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000ee747b6531b3ab787386ee1a519abec000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000e74e7b6319b3ab7873866e1a5169aec000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000ee747ba631b93ab8e738a6e1ae519abec00000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000e74e7b6531b93ab8e738a6e1ea5169aec00000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000ee7471b6331b36ab8e73986ee1a5119abec0000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000e74e7ba6319b36ab8e73986ee1ae5196ae6c000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000ee747db65319b36ab8e739866e1ea51d9abec000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000e72471b6371b93a3b8e739866e1ca51196ae6c00000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000ee74e7ba6331b93a3b8e7398a6ee1ae5169abec00000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000e872471b65319b93a3b8e7438a6ee1ae51196aeac0000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000ee74e7ba65319b37a3b8e7438f6ee1ea51169abec0000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000e87247dba63719b37a3b8e7438f66e1cae51d96aeac000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000e724e71b65331b937a3b8e7438f66ee1ae51196abe6c00000000000000000000000000000000000000000
000000000000000000000000000000000000000000e87247dba65331b936a0b8e7439866ee1ea511096aeac00000000000000000000000000000000000000000
000000000000000000000000000000000000000000e724e70ba63719b936ab08e7439866ee10ae51d96abe6c0000000000000000000000000000000000000000
00000000000000000000000000000000000000000e0724e7ba653719b936ab08e74398a6e01cae511690aeac0000000000000000000000000000000000000000
00000000000000000000000000000000000000000e724e7dba653319b93a3b78e74398a66ee1ae501d96abe6c000000000000000000000000000000000000000
0000000000000000000000000000000000000000e0724e71ba65331b037a3b78e74398066ee1eae511690aeac000000000000000000000000000000000000000
000000000000000000000000000000000000000e872407dba603719b937a3b78e74398f66ee10ae511096abe0c00000000000000000000000000000000000000
000000000000000000000000000000000000000ee724e70ba653019b937a3b78e74398f66e01cae501d96a0be6c0000000000000000000000000000000000000
00000000000000000000000000000000000000e87240e71b0653319b930a3b78e74308f660ee1eae511696abe0c0000000000000000000000000000000000000
00000000000000000000000000000000000000ee724e7dba6037310b936a3b78e743098a60ee10ae511d96a0be6c000000000000000000000000000000000000
0000000000000000000000000000000000000e87204e71ba653719b0936a3b78e743098a66ee1cae5011696abeac000000000000000000000000000000000000
0000000000000000000000000000000000000ee724e7dba0653019b0376a3b78e740398066ee1cea0511096a0be6c00000000000000000000000000000000000
000000000000000000000000000000000000e87204e70ba6053319b9376a0b78e740398066e0e1eae511d696abeac00000000000000000000000000000000000
000000000000000000000000000000000000ee724e7d1ba6537319b937a30b78e7403980660ee10ae5011096a0be6c0000000000000000000000000000000000
00000000000000000000000000000000000e07204e70ba06530190b937a30b78e740398f660ee1cae0511d960abea6c000000000000000000000000000000000
0000000000000000000000000000000000e8e7240e71ba6053019b0930a30b78e740398fa66ee1ceae5011696a0be0c000000000000000000000000000000000
0000000000000000000000000000000000e07204e7d1ba6537319b0930a30b78e740398fa66e0e10ae50110960abea6c00000000000000000000000000000000
000000000000000000000000000000000e8e7240e70ba06537319b0930a30b78e740398fa66e0e10ae0511d696a0be0c00000000000000000000000000000000
000000000000000000000000000000000e07204e7d1ba60530190b9376a3b078087430980660ee1ceae50110960abea6c0000000000000000000000000000000
00000000000000000000000000000000e8e7240e70ba060530190b9376a3b078087430980660ee1ceae0511d696a0be0c0000000000000000000000000000000
00000000000000000000000000000000e07204e7d0ba065373190b9376a3b078087430980660e0e10ae0511d0960abea6c000000000000000000000000000000
0000000000000000000000000000000e8e7240e7d1ba60537319b09306a3b078087430980a66e0e10eae50110696a0be0c000000000000000000000000000000
000000000000000000000000000000e8072040e70ba060530190b09306a3b07808743098fa66e0e1ceae0511d6960abea0c00000000000000000000000000000
000000000000000000000000000000e0e7240e7d1ba065370190b0930a03b07808743098fa660ee1c0ae050110960a0be06c0000000000000000000000000000
00000000000000000000000000000e8072040e701ba605373190b9030a30b07808743098fa660e0e10a0e5011d6960abea0c0000000000000000000000000000
00000000000000000000000000000e0e7240e7d0ba0605303190b9370a30b07808740398f0660e0e10eae0511d0960a0be06c000000000000000000000000000
0000000000000000000000000000e8072040e701ba065030109b09370a30b07808740398f0606e0e1ceae0501106960abea0c000000000000000000000000000
0000000000000000000000000000e0e7204e7d0b0a605370190b09376a30b0780874039080a66e0e1c0ae05011d0960a0bea6c00000000000000000000000000
000000000000000000000000000e8072040e7d1ba0605373190b09306a30b0780874030980a660ee010eae0510106960abea0c00000000000000000000000000
000000000000000000000000000e0e7204e0701ba0650303190b09306a30b0780874030980a660e0e1ceae05011d6960a0bea6c0000000000000000000000000
00000000000000000000000000e8e72040e7d0ba06053701090b90306a30b078087403098fa660e0e1c0ae05011d0906a0b0e06c000000000000000000000000
0000000000000000000000000e80e72040e701ba0605370190b093706a30b078087403098f0660e0e1c0eae0510106960a0bea0c000000000000000000000000
0000000000000000000000000e8e72040e7d01ba0605303190b09370a030b708087403098f06060ee010eae05011d0906a0b0e06c00000000000000000000000
000000000000000000000000e80e72040e7d1ba06050303190b09370a030b708087403098f0a660e0e1ceae05010106960a0bea0c00000000000000000000000
000000000000000000000000e0e72040e0701ba06053701090b09370a03b0708087403098f0a660e0e1c0a0e05011d6960a0b0e06c0000000000000000000000
00000000000000000000000e80e72040e7d0b0a06053701090b09306a30b070808740309080a660e0e1c0eae05011d06960a0bea0c0000000000000000000000
00000000000000000000000e0e72040e0701ba06050303190b090306a30b070808740309080a660e0e010eae05010106960a0b0e06c000000000000000000000
0000000000000000000000e80702040e7d01ba06053703190b090306a30b070808740309080a6060e0e1c0a0e05011d09060a0bea06c00000000000000000000
0000000000000000000000e0e72040e07d0b0a06053703190b093706a30b07080874030098f06060e0e1c0eae05011d06960a0b0e06c00000000000000000000
000000000000000000000e80702040e7d01ba060503001090b093706a30b07080874003098f06060e0e1c0eae050101d09060a0bea06c0000000000000000000
00000000000000000000e80e720400e7d0b0a060503031900b093706a30b07080870403098f0a660e0e010ea0e05011d06960a0b0e00c0000000000000000000
00000000000000000000e80702040e0701b0a06053703190b090370a030b07080870403098f0a660e00e1c0a0e050101069060a0bea06c000000000000000000
0000000000000000000e80e720040e7d01ba060503703190b090300a030b07080870403098f0a6600e0e1c0eae050011d06960a0b0ea0c000000000000000000
0000000000000000000e00702040e0700b0a060503001090b090300a030b07080870403098f0a6060e0e1c0ea0e05011d069600a0bea06c00000000000000000
000000000000000000e80e720040e7d01ba0060537031090b093706a030b070808704030908006060e0e0100a0e050101d09060a0b0ea06c0000000000000000
000000000000000000e00702040e07d01ba0600537031900b093706a030b070808704030908006060e0e01c0eae050011d069600a0bea06c0000000000000000
00000000000000000e80e720040e7d01b0a060503703190b0093706a300b078e00704030908f0a660e00e1c0eae0050101009060a0b0ea06c000000000000000
00000000000000000e00702040e07d01ba0060537001090b0903706a300b078e00704030908f0a6600e0e1c00a0e050101d069600a0bea06c000000000000000
0000000000000000e80e720040e0700b0a0600537031090b0903706a300b078e00704030098f0a6600e0e0100eae050011d069060a0b0ea06c00000000000000
000000000000000e8007020400e7d01b0a0605037031900b0903006a300b078e00704030098f0a6060e0e01c0eae00501010069600a0bea00c00000000000000
000000000000000e80e720040e07d01ba00605030031900b090300a030b0078e00704030098f0a6060e00e1c0ea0e050011d069060a0b0ea06c0000000000000
00000000000000e80e7020400e7d00b0a0600537001090b0093700a030b0078e00704030098f006060e00e1c00a0e050011d009060a00b0e006c000000000000
00000000000000e80e720040e07d01b0a0605037031090b0093706a030b0078e00704030090800a6600e0e01c0eae0050101d069060a0b0ea06c000000000000
0000000000000e80e7020400e7d001ba00605037031090b0903706a030b0078e00704003090800a6600e0e01c0ea0e050011d009060a00b0e006c00000000000
0000000000000e00e720040e07d01b0a06005370031900b0903706a030b0078e007040030908f0a6060e00e1c00a0e05001010069600a0b0ea06c00000000000
000000000000e80e7020400e07001ba006005370010900b0903706a030b0078e008740030908f0a6060e00e1c00eae0050101d069060a00b0e006c0000000000
00000000000e800e7200400e7d00b0a00605037031090b00903006a030b0078e008740030908f0a6060e00e01c0ea0e050011d0069600a0b0ea00c0000000000
00000000000e80e7020400e07d01b0a06005030031090b00937006a300b0078e008740030908f0060600e0e01c0ea0e0050101d069060a00b0e006c000000000
0000000000e800e7200400e7d001ba006005370031900b00937006a300b0078e008740030098f00a6600e0e01c00eae0050101d0069600a0b0ea00c000000000
0000000000e80e7020040e07d01b0a006050370010900b09037006a300b0078e008740030098f00a6600e00e1c00ea0e05001010069060a00b0ea06c00000000
000000000e800e7200400e07001b0a060050370310900b0903700a0300b0708e008740030098f00a6060e00e01c0ea0e0050101d0690600a0b0ea006c0000000
000000000e80e7020040e07d001ba006005370031090b00903706a0300b0708e008740030090800a60600e0e01c00a0e0050011d0069060a00b0ea06c0000000
00000000e800e7200400e07d01b0a006050370031900b00903706a0300b0708e0087040300908f0a60600e0e01c00ea0e0500101d0690600a0b0ea006c000000
00000000e00e7020040e07d001b0a060050370010900b00903006a0300b0708e0087040300908f0a60600e00e1c00ea0e0050101d0069600a00b0ea06c000000
0000000e800e7200400e07d01b0a0060050370310900b00937006a0300b0708e0087040300908f00a6600e00e01c0ea0e0050010100690600a0b0ea006c00000
000000e800e70200400e7d001b0a0060503700310900b09037006a0300b0708e0087040300908f00a6060e00e01c00eae00500101d0069600a00b0ea00c00000
000000e800e7200400e07d001b0a060050370031090b009037006a030b00708e0087040300908f00a60600e0e01c00ea0e0050101d00690600a0b0ea006c0000
00000e800e70200400e07001b0a0060050370010900b009037006a030b00708e0087040030908f00a60600e00e1c00ea0e00500101d0690600a00b0ea006c000
00000e800e7200400e07d001b0a0060053700310900b009037006a300b00708e0087040030098f00a60600e00e01c00eae00500101d00690600a0b0ea006c000
0000e800e70200400e07d001ba00600503700310900b00903706a0300b00708e0087040030090800a60600e00e01c00ea0e0050011d00690600a00b0ea006c00
0000e800e7200400e07d001b0a00600503700310900b00937006a0300b00708e00870400300908f00a6600e00e01c00ea0e00500101d00690600a0b0ea006c00
000e800e70200400e07d001b0a0060050370010900b009037006a0300b00708e00870400300908f00a60600e00e1c00ea0e00500101d00690600a00b0ea006c0
000e800e7200400e07d001b0a00600503700310900b009037006a0300b00708e00870400300908f00a60600e00e01c00ea0e00500101d00690600a0b0ea006c0
00e800e70200400e07d001b0a00600503700310900b009037006a0300b00708e00870400300908f00a60600e00e01c00ea0e00500101d00690600a00b0ea006c
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00eee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

