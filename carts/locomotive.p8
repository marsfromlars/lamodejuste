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
    duck1.loops = 3
    duck1.speed = 10
    duck1.bounce = false

    dottie = create_animation()
    dottie.y = 21
    dottie.images = { 16, 17, 18, 19, 20, 21, 22, 23 }
    dottie.speed = 40
    dottie.bounce = true

end

function _update()
     duck1:update()
     dottie:update()
end

function _draw()
    cls()
    duck1:draw()
    dottie:draw()
end

-->8
-- sprite

function create_sprite()

    local sprite = {
        x = 0,
        y = 0,
        images = {},
        imageAnimation = nil
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
        loops = 3, -- -1 = infinite
        timer = global.fps,
        direction = 1,
        -- for more on easing functions see: https://easings.net/
        easing = { 0, 0.087, 0.174, 0.259, 0.342, 0.423, 0.5, 0.574, 0.643, 0.707, 0.766, 0.819, 0.866, 0.906, 0.94, 0.966, 0.985, 0.996 }
    }

    function animation:update()
        self.timer -= self.speed
        if self.timer < 0 then 
            printh( self.current )
            self.timer = global.fps
            self.current += self.direction
            if self.current > #self.images then
                if self.bounce then
                    self.direction = -self.direction
                    self.current = #self.images - 1
                else
                    self.current = 1
                end
            end
            if self.current < 1 then
                if self.bounce then
                    self.direction = -self.direction
                    self.current = 2
                else
                    self.current = #self.images
                end
            end
        end
    end

    function animation:draw()
        spr(self.images[self.current], self.x, self.y)
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b00000000b00000000b00000000b00000000b00000000b00000000b00000000b0000000000000000000000000000000000000000000000000000000000000000
