require('var')


local earth_sprite = love.graphics.newImage(TEXTUREDIR..'Earth_Block.png')
local bar_width = 6 * (TILESIZE)

local progress_style = {
	['progress'] = {
		['cursor normal'] = nil,
		['cursor hover'] = nil,
		['cursor active'] = nil,
		['padding'] = {x = 0, y = 0},
		['border'] = 1,
		['border color'] = '#2d2d2d' -- default window color
	},
}


local default_font = love.graphics.getFont()
local mat_font = love.graphics.newFont(15)
local timer_font = love.graphics.newFont(30)


return function (ui, blocks, teams, dt)
    if ui:windowBegin('Blocks', (WINDOW_WIDTH - bar_width)/2, 32, bar_width, 40) then
		x, y, width, height = ui:windowGetContentRegion()
		-- print("window : w="..width.." h="..height, 200, 40)
		ui:layoutRow('static', TILESIZE, TILESIZE, 5)
		ui:image({earth_sprite, love.graphics.newQuad(0, 0, TILESIZE, TILESIZE, earth_sprite:getDimensions())})
		ui:image(love.graphics.newImage(TEXTUREDIR..'Stone_Block.png'))
		ui:image(love.graphics.newImage(TEXTUREDIR..'Iron_Block.png'))
		ui:image(love.graphics.newImage(TEXTUREDIR..'Sulfure_Block.png'))
		ui:image(love.graphics.newImage(TEXTUREDIR..'Gold_Block.png'))
		
		love.graphics.setFont(mat_font)
		love.graphics.setColor(0, 0, 0)
			ui:text(blocks.earth, x + 8, y + 19, 10, 10)
			ui:text(blocks.stone, x + 8 + TILESIZE + 4, y + 19, 10, 10)
			ui:text(blocks.iron, x + 8 + (TILESIZE + 4) * 2, y + 19, 10, 10)
			ui:text(blocks.sulfure, x + 8 + (TILESIZE + 4) * 3, y + 19, 10, 10)
			ui:text(blocks.gold, x + 8 + (TILESIZE + 4) * 4, y + 19, 10, 10)
		love.graphics.setColor(1, 1, 1) -- => white / default color
		love.graphics.setFont(default_font)
        
	end
	ui:windowEnd()

	-- variables pour l'affichage de la vie des équipes
	local team_bar_height = (32+4) * TEAM_NB

	if ui:windowBegin('Teams', 40, WINDOW_HEIGHT - team_bar_height -30, 200, team_bar_height) then
		x, y, width, height = ui:windowGetContentRegion()
		ui:layoutRow('dynamic', 30, 1)
		for i, t in ipairs(teams) do
			local team_life = 0
			for _, perso in ipairs(t.getPersonnages()) do
				team_life = team_life + perso.getHP()
			end
			-- Change the style of thhe progress bar to adapt it to the team color
			progress_style.progress['cursor normal'] = t.getColor()
			progress_style.progress['cursor hover'] = t.getColor()
			progress_style.progress['cursor active'] = t.getColor()

			ui:stylePush(progress_style)
				ui:progress(team_life, CHAR_NB * CHAR_HP, false)
			ui:stylePop()
			-- Debug draw info about team life
			ui:text(team_life.." / "..CHAR_NB * CHAR_HP, x + width/3 + 2 , y + 34*i - 24, 100, 10)
		end
	end
	ui:windowEnd()

	local timer_style = {
		['window'] = {
			['padding'] = {x = 5, y = 10},
		},
	}
	-- Affichage du timer
	if ui:windowBegin('Timer', WINDOW_WIDTH - 100, WINDOW_HEIGHT - 80, 60, 40) then
		love.graphics.setFont(timer_font)
		ui:stylePush(timer_style)
			ui:layoutRow('dynamic', 30, 1)
			ui:label(""..math.ceil( TOUR_TIME - dt ), 'centered', '#FFFFFF')
		ui:stylePop()
		love.graphics.setFont(default_font)
	end
	ui:windowEnd()

end
