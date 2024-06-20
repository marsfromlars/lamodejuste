pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function _init()
    black,dark_blue,purple,dark_green,brown,dark_gray,gray,white,red,orange,yellow,green,blue,lavender,pink,beige=0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
    game_splash,game_loop = 0,1
    game=game_splash
    show_splash()
    linux=create_bunny("linux",50,70,false,0)
    kitty=create_bunny("kitty",50,70,true,1)
end

function create_bunny(name,x,y,dir,sprite_index)
    local bunny={}
    bunny.name=name
    bunny.x=x
    bunny.y=y
    bunny.dir=dir
    bunny.sprite_index=sprite_index
    bunny.draw=function()
        spr(sprite_index,x,y,1,1,dir,false)
    end
    bunny.move=function()
        if rnd(100)>50 then x+=1 else x-=1 end
        if rnd(100)>50 then y+=1 else y-=1 end
    end
    return bunny
end

-->8
function _update() 
    if game == game_splash then
        if t() > 1 then game=game_loop end
    else
        linux.move()
        kitty.move()
    end
end

-->8
function _draw()
    if game == game_loop then
        cls(green)
        linux.draw()
        kitty.draw()
    end
end

function show_splash()
    cls(beige)
    x,y=128/2-2*5,60
    print("buns",x,y,black)
    y+=7
    x=128/2-8*5
    print("(C) 2024",x,y,dark_gray)
    x+=35
    colors={}
    c=0
    line(x,y+c,x+3,y+c,blue)
    c+=1
    line(x,y+c,x+3,y+c,green)
    c+=1
    line(x,y+c,x+3,y+c,yellow)
    c+=1
    line(x,y+c,x+3,y+c,pink)
    c+=1
    line(x,y+c,x+3,y+c,red)
    x+=5
    print("lamosoft",x,y,dark_gray)
end

__gfx__
00f0f000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00f0f000001010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ffff000011110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
f0f0f000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffff00111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ffffff0011111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0ffffff7011111110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
fffffff0111111100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000