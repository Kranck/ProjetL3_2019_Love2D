require('var')

local earth_sprite = love.graphics.newImage(TEXTUREDIR..'Earth_Block.png')
local bar_width = 6 * (TILESIZE)

return function (ui, blocks)
    if ui:windowBegin('Blocks', (1280 - bar_width)/2, 32, bar_width, 40) then
		x, y, width, height = ui:windowGetContentRegion()
		-- print("window : w="..width.." h="..height, 200, 40)
		ui:layoutRow('static', TILESIZE, TILESIZE, 5)
		ui:image({earth_sprite, love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, earth_sprite:getDimensions())})
		ui:image(love.graphics.newImage(TEXTUREDIR..'Stone_Block.png'))
		ui:image(love.graphics.newImage(TEXTUREDIR..'Iron_Block.png'))
		ui:image(love.graphics.newImage(TEXTUREDIR..'Sulfure_Block.png'))
		ui:image(love.graphics.newImage(TEXTUREDIR..'Gold_Block.png'))

		ui:text(blocks.earth, x + 7, y + 22, 10, 10)
		ui:text(blocks.stone, x + 7 + TILESIZE + 4, y + 22, 10, 10)
		ui:text(blocks.iron, x + 7 + (TILESIZE + 4) * 2, y + 22, 10, 10)
		ui:text(blocks.sulfure, x + 7 + (TILESIZE + 4) * 3, y + 22, 10, 10)
		ui:text(blocks.gold, x + 7 + (TILESIZE + 4) * 4, y + 22, 10, 10)
        
	end
	ui:windowEnd()
end
