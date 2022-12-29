function menuInit(){
	selection = 0
	options = ["start", "level select", "quit"]
}

function menuUpdate() {
	menuControls()
}

function menuControls() {
	key_down = keyboard_check_pressed(ord("S"))
	key_up   = keyboard_check_pressed(ord("W"))
	key_select = keyboard_check_pressed(vk_space)
	if key_down {
		selection++
	}
	if key_up {
		selection--
	}
	if selection < 0 {
		selection = array_length(options) - 1
	}
	if selection >= array_length(options)
	{
		selection = 0
	}
	if key_select {
		confirmSelection()
	}
}

function confirmSelection() {
	option = options[selection]
	if option == "quit" {
		game_end()
	}
	if option == "start" {
 		room_goto(TestLevel)
	}
}

function drawSelection() {
	xStart = x
	yStart = y

	yStart = y + (60 * selection)
	xEnd = xStart + 350
	yEnd = yStart
	
	draw_rectangle(xStart, yStart, xStart + 5, yStart + 5, false)
	draw_rectangle(xEnd, yEnd, xEnd + 5, yEnd + 5, false)
}