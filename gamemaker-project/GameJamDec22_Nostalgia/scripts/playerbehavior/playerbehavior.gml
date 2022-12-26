function playerInit(){
    moveSpeed = 4
    roomName = room_get_name(room)
    roomPrefix = splitString(roomName, "_")[0]
    roomSuffix = splitString(roomName, "_")[1]
    if (roomPrefix == "green") {
        sprite_index = spr_player_green
    }
    else {
        sprite_index = spr_player
    }

    if (variable_global_exists("xPos")) {
        x = global.xPos
        y = global.yPos
    }
}

function playerUpdate(){
    playerDefineControls()
    xDir = key_right_held - key_left_held
    yDir = key_down_held - key_up_held
    if key_space_pressed {
        playerSwitchRoomVersion()
    }

    // move character
	xSpeed  = moveSpeed * xDir
    ySpeed  = moveSpeed * yDir
    x       += xSpeed
    y       += ySpeed
}

function playerDefineControls(){
    #region hold keys
    key_up_held     = keyboard_check(ord("W"))
    key_left_held   = keyboard_check(ord("A"))
    key_down_held   = keyboard_check(ord("S"))
    key_right_held  = keyboard_check(ord("D"))
    #endregion

    #region press keys
    key_up_pressed     = keyboard_check_pressed(ord("W"))
    key_left_pressed   = keyboard_check_pressed(ord("A"))
    key_down_pressed   = keyboard_check_pressed(ord("S"))
    key_right_pressed  = keyboard_check_pressed(ord("D"))
    key_space_pressed  = keyboard_check_pressed(vk_space)
    #endregion

    #region release keys
    key_up_released     = keyboard_check_released(ord("W"))
    key_left_released   = keyboard_check_released(ord("A"))
    key_down_released   = keyboard_check_released(ord("S"))
    key_right_released  = keyboard_check_released(ord("D"))
    #endregion
}

function playerSwitchRoomVersion() {
    if (roomPrefix == "green")
    {
        newRoomPrefix = "main"
    }
    else {
        newRoomPrefix = "green"
    }
    newRoomName = newRoomPrefix + "_" + roomSuffix
    newRoomIndex = asset_get_index(newRoomName)
    global.xPos = x
    global.yPos = y
    room_goto(newRoomIndex)
}