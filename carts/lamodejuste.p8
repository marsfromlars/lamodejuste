pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
    cls()
    print( "starting up" )
    pos = 0
    dir, step = 1, 3
    charw, charh = 5, 7
    midx, midy = 64, 64
    white, black, red = 7, 0, 8
    up, down, action, action2 = 2, 3, 5, 4
    menu = {"fan","flags"}
    selected = 1
    prog_menu, prog_fan, prog_flags = 0, 1, 2
    prog = prog_menu
    flag_created = false
end

-->8
function _update() 
    if btnp( action ) then 
        if prog != prog_menu then
            prog = prog_menu
            return
        end
    end
    if prog == prog_menu then
        update_menu()
    elseif prog == prog_fan then
        update_fan()
    elseif prog == prog_flags then
        update_flags()
    end
end

function update_menu() 
    if btnp( up ) then selected = selected - 1 end
    if btnp( down ) then selected = selected + 1 end
    if btnp( action ) then 
        prog = selected 
        cls()
        flag_created = false
    end
    if selected < 1 then
        selected = #menu
    elseif selected > #menu then
        selected = 1
    end
end

function update_fan()
    color = 1+flr(rnd(15))
    pos += step
    if pos > 127 or pos < 0 then
        dir = -dir
        step = dir * ( 2 + flr(rnd(10)) )
        pos = max( 0, pos )
        pos = min( 127, pos )
    end
end

function update_flags()
    if btnp( action2 ) then flag_created = false end
end

-->8
function _draw()
    if prog == prog_menu then
        draw_menu()
    elseif prog == prog_fan then
        draw_fan()
    elseif prog == prog_flags then
        draw_flags()
    end
    draw_status()
end

function draw_status()
    rectfill(0,0,127,7,0)
    print( flr(time()).." prog/sel: "..prog.."/"..selected, 0, 0, white )
end

function draw_menu()
    w = 10 * charw + 1
    h = 5 * charh + 1
    x = midx - w/2
    y = midy - h/2
    rectfill(x,y,x+w,y+h,black)
    rect(x,y,x+w,y+h,white)
    for i = 1, min(5,#menu) do
        yrow = y+((i-1)*charh)+2
        textcolor = white
        if i == selected then
            rectfill(x+1,yrow-1,x+w-1,yrow+charh-2,red)
            textcolor = black
        end
        print(menu[i],x+2,yrow,textcolor)
    end
end

function draw_fan()
    rectfill(0,120,127,127,0)
    -- cls()
    print( pos, pos, 120, color )    
    line(64,7,pos,118,color)
end

function draw_flags()
    if not flag_created then
        cls()
        top = 10
        bot = 120
        h = (bot-top)/3
        rectfill(0,top,127,top+h,flr(rnd(16)))
        rectfill(0,top+h,127,top+2*h,flr(rnd(16)))
        rectfill(0,top+2*h,127,top+3*h,flr(rnd(16)))
        print( "press 🅾️ for next flag", 0, 121, white )
        flag_created = true
    end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
