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

function Camera:scale(sx)
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
end

function Camera:setPosition(x, y)
    self.x = x or self.x
    self.y = y or self.y
end

function Camera:setScale(sx, sy)
    self.scaleX = sx or self.scaleX
    self.scaleY = sy or self.scaleY
end

function Camera:mousePosition()
    return love.mouse.getX(), love.mouse.getY()
    --return love.mouse.getX() * self.scaleX + self.x, love.mouse.getY() * self.scaleY + self.y
end

