pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
-- scratch
-- (c) 2024 lamosoft

function create_ball()
    local ball = {
        xpos = 60,
        ypos = 60,

        -- without the colon syntax, must mention self argument explicitly
        move = function(self, newx, newy)
            self.xpos = newx
            self.ypos = newy
        end
    }
    return ball
end

ball = create_ball()

-- using the colon, ball is passed as self automatically
ball:move(100, 120)

-- using the dot, must pass self explicitly
ball.move(ball, 101, 120)

print( ball.xpos )