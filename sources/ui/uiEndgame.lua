require('var')

local widget_width  = 0.2 * WINDOW_WIDTH
local widget_height = 0.2 * WINDOW_HEIGHT

local widget_width_padding  = (WINDOW_WIDTH - widget_width)/2
local widget_height_padding = (WINDOW_HEIGHT - widget_height)/2 

local mat_font = love.graphics.newFont(15)
local default_font = love.graphics.getFont()

return function (ui, msg)
    x, y, width, height = ui:windowGetContentRegion()
    if ui:windowBegin('Fin de partie', widget_width_padding, widget_height_padding, widget_width, widget_height) then
        love.graphics.setFont(mat_font)
        ui:layoutRow('dynamic', 30, 1) 
        ui:label(msg, 'centered', "#FFFFFF")
		love.graphics.setFont(default_font)
	end
	ui:windowEnd()
end 