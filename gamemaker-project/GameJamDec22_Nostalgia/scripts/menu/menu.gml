function menuInit(){
	selectionIndex = 0
	options = []
	flyOffTimer = 0
	flyInTimer = 0
	xOffset = 0
	menuList = "Title"
}

function loadFonts() {
	global.timerFont = font_add("bookItalic.otf", 400, false, false, 32, 128)
	global.messageFont = font_add("bookItalic.otf", 300, false, false, 32, 128)
	global.menuFont = font_add("bookItalic.otf", 72, false, false, 32, 128)
}

function menuUpdate() {
	menuControls()
	menuAnimation()
}

function menuControls() {
	key_down = keyboard_check_pressed(ord("S"))
	key_up   = keyboard_check_pressed(ord("W"))
	key_select = keyboard_check_pressed(vk_space)

	if !flyOffTimer {
		if key_down {
			selectionIndex++
		}
		if key_up {
			selectionIndex--
		}
		if selectionIndex < 0 {
			selectionIndex = array_length(options) - 1
		}
		if selectionIndex >= array_length(options)
		{
			selectionIndex = 0
		}
		if key_select {
			confirmSelection()
		}
	}
}

function confirmSelection() {
	option = options[selectionIndex]
	if option == "Level Select" {
		flyOffTimer = 20
		nextMenu = "Level Select"
	}

	else if option == "How to Play" {
		flyOffTimer = 20
		nextMenu = "How To Play"
	}
	else if option == "Quit" {
 		game_end()
	}

	else if option == "Back" {
		flyOffTimer = 20
		nextMenu = "Title"
	}

	else if option == "Level 1" {
		room_goto(Level1)
	}

	else if option == "Level 2" {
		room_goto(Level2)
	}
	

	else if option == "Level 3" {
		room_goto(Level3)
	}

	
	else if option == "Level 4" {
		room_goto(Level4)
	}

	
	else if option == "Level 5" {
		room_goto(Level1)
	}
}

function drawSelection() {
	xStart = x
	yStart = y

	yStart = y + (60 * selectionIndex)
	xEnd = xStart + 350
	yEnd = yStart
	
	draw_rectangle(xStart, yStart, xStart + 5, yStart + 5, false)
	draw_rectangle(xEnd, yEnd, xEnd + 5, yEnd + 5, false)
}

function drawOptions() {
	if menuList == "Title" {
		options = ["Level Select", "How to Play", "Quit"]
		xStart = 50
		yStart = 500
	}

	if menuList == "Level Select" {
		options = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Back"]
		xStart = 50
		yStart = 400
	}

	draw_set_font(global.menuFont)
	for (var i = 0; i < array_length_1d(options); i += 1)
	{
		draw_set_color(c_black)
		if selectionIndex == i {
			draw_set_color(c_white)
		}
		yOffset = i * 100
		draw_text(xStart + xOffset, yStart + yOffset, options[i]);
	}
}

function menuAnimation() {
	if flyOffTimer > 0 {
		xOffset -= 30
		flyOffTimer--
		if flyOffTimer <= 0 {
			menuList = nextMenu
			flyInTimer = 20
			xOffset = -600
		}
	}

	if flyInTimer > 0 {
		xOffset += 30
		flyInTimer--
		if flyInTimer <= 0 {
			flyInTimer = 0
			xOffset = 0
		}
	}
}