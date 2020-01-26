SRCDIR = "sources/"
ASSETSDIR = "assets/"
require(SRCDIR.."Terrain")

Camera = {}
Camera.x = 0
Camera.y = 0
Camera.scaleX = 1
Camera.scaleY = 1

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

function Camera:setPosition(perso1)
    self.x = perso1.posX-(window_width/2*self.scaleX) or self.x
    self.y = perso1.posY-(window_height/2*self.scaleY) or self.y
end

function Camera:scale(sx, p)
    max_zoom = 2
    min_zoom = 1/1.2
    if sx > 1 then --Zooming
        if self.scaleX*sx/max_zoom >= 1 or self.scaleY*sx/max_zoom >= 1 then
            return
        end     
    else --Dezooming
        if self.scaleX*sx/min_zoom <= 1 or self.scaleY*sx/min_zoom <= 1 then
            return
        end 
    end
    self.scaleX = self.scaleX * sx
    self.scaleY = self.scaleY * sx

    window_width, window_height = love.graphics.getDimensions()

    self:setPosition(p)
end

function Camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or self.scaleY
end

function Camera:mousePosition()
    return love.mouse.getX(), love.mouse.getY()
    --return love.mouse.getX() * self.scaleX + self.x, love.mouse.getY() * self.scaleY + self.y
end

-- function Camera:centerAroundPersonnage(p)
--     window_width, window_height = love.graphics.getDimensions()

--     self.x = (p.posX-window_width)*self.scaleX
--     self.y = (p.posY-window_height)*self.scaleY

--     if self.x < 0 or self.y < 0 then
--         self.x=0
--         self.y=0
--     end
-- end