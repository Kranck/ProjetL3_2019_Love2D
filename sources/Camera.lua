require("var")

require(SRCDIR.."Terrain")

Camera = {}
Camera.background = love.graphics.newImage(ASSETSDIR.."bg2.png")
Camera.x = 0
Camera.y = 0
Camera.scaleX = 1
Camera.scaleY = 1
Camera.layers = {
    ['background'] = {scale = 0.9, draw = function () love.graphics.draw(Camera.background, 0, 0) end},
    ['terrain'] = {},
}

function Camera:set()
    love.graphics.push()
    love.graphics.scale(1/self.scaleX, 1/self.scaleY)
    love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
    love.graphics.pop()
end

function Camera:move(dx, dy)
    self.x = self.x + (dx or 0)
    self.y = self.y + (dy or 0)
end

function Camera:setPosition(p)
    position = p.getPos()
    self.x = position.posX - (WINDOW_WIDTH / 2 * self.scaleX) or self.x
    if self.x < 0 then
        self.x = 0
    end
    xMax = 80 * TILESIZE - (WINDOW_WIDTH*self.scaleX)
    if self.x > xMax then
        self.x = xMax
    end
    self.y = position.posY-(WINDOW_HEIGHT / 2  * self.scaleY) or self.y
    if self.y<0 then
        self.y=0
    end
    yMax = 45 * TILESIZE - (WINDOW_HEIGHT * self.scaleY)
    if self.y>yMax then
        self.y=yMax
    end
end

function Camera:scale(sx, perso)
    p = perso.getPos()
    max_zoom = 2
    min_zoom = 1/1.2
    if sx > 1 then --Zooming
        if self.scaleX * sx / max_zoom >= 1 or self.scaleY * sx / max_zoom >= 1 then
            return
        end     
    else --Dezooming
        if self.scaleX * sx / min_zoom <= 1 or self.scaleY * sx / min_zoom <= 1 then
            return
        end 
    end
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * sx

    window_width, window_height = love.graphics.getDimensions()

    self:setPosition(perso)
end

function Camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or self.scaleY
end

function Camera:mousePosition()
    return love.mouse.getX(), love.mouse.getY()
end


function Camera:setTerrain(t)
    Camera.layers['terrain'] = {draw = t.draw, scale = 1}
end

function Camera:draw()
    local bx, by = self.x, self.y
    local v
    -- draw background
    v = Camera.layers['background']
    self.x = bx * v.scale
    self.y = by * v.scale
    Camera:set()
        v.draw()
    Camera:unset()

    --draw terrain
    v = Camera.layers['terrain']
    self.x = bx * v.scale
    self.y = by * v.scale
    Camera:set()
        v.draw()
    Camera:unset()
end