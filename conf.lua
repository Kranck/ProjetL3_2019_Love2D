function love.conf(t)
	t.console = true

	t.window.title = "JMH Battleground"
	t.window.width = 1280
	t.window.height = 720

	t.modules.touch = false
	t.modules.thread = false
	t.modules.physics = false
	t.modules.joystic = false
end