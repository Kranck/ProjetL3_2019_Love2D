require('var')

local default_font = love.graphics.getFont()
local huge = love.graphics.newFont(30)

local widget_width  = 0.2 * WINDOW_WIDTH
local widget_height = 0.47 * WINDOW_HEIGHT

local widget_width_padding  = (WINDOW_WIDTH - widget_width)/2
local widget_height_padding = (WINDOW_HEIGHT - widget_height)/2 

local style = {
	['window'] = {
		['padding'] = {x = 7, y = 20},
		['rounding'] = 50,
	}
}

return function (ui, terrain)
	ui:stylePush(style)
    if ui:windowBegin('Main Menu', widget_width_padding, widget_height_padding, widget_width, widget_height) then
        ui:layoutRow('dynamic', 32, 1)
		love.graphics.setFont(huge)
		if ui:button("QUITTER LE JEU") then
            love.event.quit()
		end
        ui:layoutRow('dynamic', 5, 1)
		ui:spacing(1)
        ui:layoutRow('dynamic', 32, 1)
		CHAR_NB = ui:property('Personnages', 2, CHAR_NB, 10, 1, 0.2)
        ui:layoutRow('dynamic', 5, 1)
		ui:spacing(1)
        ui:layoutRow('dynamic', 32, 1)
		TEAM_NB = ui:property('Equipes', 2, TEAM_NB, 6, 1, 0.2)
        ui:layoutRow('dynamic', 5, 1)
		ui:spacing(1)
        ui:layoutRow('dynamic', 32, 1)
		CHAR_HP = ui:property('Vie', 50, CHAR_HP, 200, 10, 0.1)
        ui:layoutRow('dynamic', 5, 1)
		ui:spacing(1)
        ui:layoutRow('dynamic', 32, 1)
		TOUR_TIME = ui:property('Temps', 10, TOUR_TIME, 60, 1, 0.2)
        ui:layoutRow('dynamic', 5, 1)
		ui:spacing(1)
        ui:layoutRow('dynamic', 32, 1)
		if ui:button("LANCER LA PARTIE") then
            love.keyboard.setKeyRepeat(true)
            PLAY = PLAY_TYPE_TABLE.normal
			return Terrain:New(HEIGHT, WIDTH)
		end
		love.graphics.setFont(default_font)
	end
	ui:windowEnd()
	ui:stylePop()
	ui:windowSetFocus('Main Menu')
	return terrain
end
