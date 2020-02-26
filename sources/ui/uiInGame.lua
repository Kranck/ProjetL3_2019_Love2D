require('var')


local earth_sprite = love.graphics.newImage(TEXTUREDIR..'Earth_Block.png')
local bar_width = 6 * (TILESIZE)


return function (ui, blocks, teams)
    if ui:windowBegin('Blocks', (WINDOW_WIDTH - bar_width)/2, 32, bar_width, 40) then
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

	-- variables pour l'affichage de la vie des équipes
	local team_bar_height = 32 * TEAM_NB

	if ui:windowBegin('Teams', 40, 720 - team_bar_height -40, 200, team_bar_height) then
		x, y, width, height = ui:windowGetContentRegion()
		for i, t in ipairs(teams) do
			local team_life = 0
			for _, perso in ipairs(t.personnages) do
				team_life = team_life + perso.getHP()
			end
			team_life = team_life * CHAR_NB * CHAR_HP / 100 
			ui:layoutRow('dynamic', (100 - team_life) * width, 1)
			ui:button(nil, t.color)
		end
        
	end
	ui:windowEnd()
end
