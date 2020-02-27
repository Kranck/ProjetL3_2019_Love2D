require('var')

local widget_width  = 0.7 * WINDOW_WIDTH
local widget_height = 0.8 * WINDOW_HEIGHT

local widget_width_padding  = 0.15 * WINDOW_WIDTH
local widget_height_padding = 0.1  * WINDOW_HEIGHT 

local style = {}

return function (ui)
    if ui:windowBegin('Weapons Menu', widget_width_padding,
    widget_height_padding, widget_width, widget_height * 0.6) then
        
	end
	ui:windowEnd()
end
