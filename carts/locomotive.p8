pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- locomotive game engine
-- (c) 2024 lamosoft

function _init()

    global = {
        fps = 30
    }
    print( "locomotive game engine" )
    print( "(c) lamosoft" )

    duck1 = create_animation()
    duck1.y = 20
    duck1.images = { 0, 1, 2 }
    duck1.loop_forever = true
    duck1.speed = 3

end

function _update()
     duck1:update()
end

function _draw()
    cls()
    duck1:draw()
end

-->8
-- sprite

function create_sprite()

    local sprite = {
        x = 0,
        y = 0
    }

    return sprite

end

-->8
-- animation

function create_animation()

    local animation = {
        images = {},
        current = 1,
        speed = 5,
        bounce = false,
        loops = 1,
        loop_forever = false,
        timer = global.fps,
        direction = 1
    }

    function animation:update()
        printh( self.current )
        self.timer -= self.speed
        if self.timer < 0 then 
            self.timer = global.fps
            self.current += self.direction
            if self.current > #self.images or self.current < 0 then
                if self.bounce then
                    self.direction = -self.direction
                end
            end
            if not self.bounce then
                if self.direction > 0 and self.current > #self.images then
                    self.current = 1
                elseif self.direction < 0 and self.current < 1 then
                    self.current = #self.images
                end
            end
        end
    end

    function animation:draw()
        spr(self.images[self.current], 0, 0)
    end

    return animation

end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000003a000003a000003a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000330000003000000300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3003300b3003300b300030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3333300b3333300b333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0b333b000b333b000b333b0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00b9b00000b9b00000b9b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00909000000900000000900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
