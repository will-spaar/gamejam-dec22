function playerInit() {
    // initialize variables - zero speed, facing right, default sprite
    sprite_index = spr_player
    xDir = 1
    image_speed = 1
    xSpeed = 0
    maxXSpeed = 5
    ySpeed = 0
    gravForce = 0.3
    jumpForce = 0
}

function playerUpdate() {
    playerControls()
    updatePlayerSprite()

    // if the player is near the ground, make pixel-perfect contact
    if place_meeting(x, y + ySpeed, obj_wall) {
        while (!place_meeting(x, y + 1, obj_wall)) {
            y += 1
        }
        ySpeed = 0
    }

    // if the player is in the air, apply gravity
    if !place_meeting(x, y + 1, obj_wall) {
        ySpeed += gravForce
    }

    // reduce speed while nose or tail grinding
    if image_angle != 0 && place_meeting(x, y + 1, obj_wall) {
        xSpeed -= (0.1 * sign(xSpeed))
    }

    // stop nose or tail grinding if on the ground and speed is low
    if abs(xSpeed) < 1 && place_meeting(x, y + 1, obj_wall) {
        image_angle = 0        
        while (!place_meeting(x, y + 1, obj_wall)) {
            y += 1
        }
        ySpeed = 0
    }

    // limit horizontal speed
    xSpeed = max(xSpeed, -maxXSpeed)
    xSpeed = min(xSpeed, maxXSpeed)

    // move the player
    x += xSpeed
    y += ySpeed
}

function playerControls() {
    key_right = keyboard_check(ord("D"))
    key_left = keyboard_check(ord("A"))
    key_space = keyboard_check(vk_space)
    key_space_released = keyboard_check_released(vk_space)
    key_right_pressed = keyboard_check_pressed(ord("D"))
    key_left_pressed = keyboard_check_pressed(ord("A"))
    key_up_pressed = keyboard_check_pressed(ord("W"))

    if place_meeting(x, y + 1, obj_wall) {
        if key_right {
            xSpeed += 0.2
        }

        if key_left {
            xSpeed -= 0.2
        }

        if key_space {
            jumpForce += 0.3
            jumpForce = min(jumpForce, 10)
        }

        if key_space_released {
            ySpeed = -jumpForce
            jumpForce = 0
        }
    }
    else {
        if key_right_pressed {
            image_angle -= 45
        }
        if key_left_pressed {
            image_angle += 45
        }
    }
}

function updatePlayerSprite() {
    if xSpeed > 0 {
        image_xscale = 1
    }
    else {
        image_xscale = -1
    }
}