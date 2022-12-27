function playerInit(){
    moveSpeed = 4
    roomName = room_get_name(room)
    roomPrefix = splitString(roomName, "_")[0]
    roomSuffix = splitString(roomName, "_")[1]
    sprite_index = getSpriteForRoomVersion("spr_player")

    if (variable_global_exists("xPos")) {
        x = global.xPos
        y = global.yPos
    }
}

function playerUpdate(){
    playerDefineControls()

    if place_meeting(x, y, obj_item) {
        item = instance_place(x, y, obj_item)
        collectItem(item)
    }
    xDir = key_right_held - key_left_held
    yDir = key_down_held - key_up_held
    if key_space_pressed {
        playerSwitchRoomVersion()
    }
    if key_shift_pressed {
        createBomb(x, y)
    }

    // move character
	xSpeed  = moveSpeed * xDir
    ySpeed  = moveSpeed * yDir

    if place_meeting(x + xSpeed, y, obj_wall) {
        while !(place_meeting(x + sign(xSpeed), y, obj_wall)) {
            x += sign(xSpeed)
        }
        xSpeed = 0
    }

    if place_meeting(x, y + ySpeed, obj_wall) {
        while !(place_meeting(x, y + sign(ySpeed), obj_wall)) {
            y += sign(ySpeed)
        }
        ySpeed = 0
    }

    x       += xSpeed
    y       += ySpeed
    depth = -y
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
    key_shift_pressed  = keyboard_check_pressed(vk_lshift)
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

    if (newRoomPrefix == "green" && global.battery <= 0)
    {
        currentRoom = roomPrefix + "_" + roomSuffix
        showEmptyBattery(currentRoom)
    }
    else
    {
        room_goto(newRoomIndex)
    }
}

function createBomb(x, y) {
    if (isGreenRoom()) {
        instance_create_layer(x, y, "Instances", obj_bomb)
    }
}

function bombInit() {
    bombTimer = 120
}

function bombUpdate() {
    bombTimer -= 1
    if bombTimer <= 0
    {
        if (distance_to_object(obj_wall_cracked) < 80) {
            instance_destroy(obj_wall_cracked, true)
        }
        instance_destroy()
    }
}