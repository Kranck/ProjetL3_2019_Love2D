require('var')
local nuklear = require 'nuklear'

return function (ui, msg)
    local mat_font = love.graphics.newFont(15)
    local default_font = love.graphics.getFont()
    x, y, width, height = ui:windowGetContentRegion()
    if ui:windowBegin('Fin de partie', 0, 0, WIDTH, HEIGHT) then
        love.graphics.setFont(mat_font)
        ui:label(msg, 'centered', nuklear.colorRGBA(1, 1, 1))
		love.graphics.setFont(default_font)
	end
	ui:windowEnd()
end 