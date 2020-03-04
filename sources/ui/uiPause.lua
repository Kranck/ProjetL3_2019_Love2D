require('var')

local default_font = love.graphics.getFont()
local huge = love.graphics.newFont(30)

local widget_width  = 0.2 * WINDOW_WIDTH
local widget_height = 0.35 * WINDOW_HEIGHT

local widget_width_padding  = (WINDOW_WIDTH - widget_width)/2
local widget_height_padding = (WINDOW_HEIGHT - widget_height)/2 

local style = {
	['window'] = {
		['padding'] = {x = 7, y = 20},
		['rounding'] =50,
	}
}

return function (ui, terrain)
	ui:stylePush(style)
    if ui:windowBegin('Pause Menu', widget_width_padding, widget_height_padding, widget_width, widget_height) then
        ui:layoutRow('dynamic', 32, 1)
		love.graphics.setFont(huge)
		if ui:button("REPRENDRE") then
            love.keyboard.setKeyRepeat(true) -- Re-enable Key Repeat
            PLAY = PLAY_TYPE_TABLE.normal
		end
        ui:layoutRow('dynamic', 5, 1)
		ui:spacing(1)
        ui:layoutRow('dynamic', 32, 1)
		if ui:button("MENU PRINCIPAL") then
			PLAY = PLAY_TYPE_TABLE.menu
		end
        ui:layoutRow('dynamic', 5, 1)
		ui:spacing(1)
        ui:layoutRow('dynamic', 32, 1)
		if ui:button("RECOMMENCER") then
            love.keyboard.setKeyRepeat(true) -- Re-enable Key Repeat
            PLAY = PLAY_TYPE_TABLE.normal
			return Terrain:New(HEIGHT, WIDTH)
		end
        ui:layoutRow('dynamic', 10, 1)
		ui:spacing(1)
        ui:layoutRow('dynamic', 32, {0.3, 0.7})
		ui:label("SENSI", 'centered', '#FFFFFF')
		SENSI = ui:slider(20, SENSI, 120, 5)
		love.graphics.setFont(default_font)
	end
	ui:windowEnd()
	ui:stylePop()
	ui:windowSetFocus('Pause Menu')
	return terrain
end
