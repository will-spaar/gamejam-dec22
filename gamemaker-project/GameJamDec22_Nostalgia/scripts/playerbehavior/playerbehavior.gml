function playerInit() {
    // initialize variables - zero speed, facing right, default sprite
    sprite_index = spr_player
    image_speed = 2
    spriteRotation = 0
    goodAngleThreshold = 25
    xDir = 1

    xSpeed = 0
    ySpeed = 0
    maxXSpeed = 18
    maxYSpeed = 18
    moveSpeed = 0

    gravForce = 0.55
    jumpForce = 0

    onGround = 1
    moveSlope = 0

    global.paused = 0
}

function playerUpdate() {
    if global.paused {
        image_speed = 0
        key_escape = keyboard_check_pressed(vk_escape)
        if key_escape {
            global.paused = 0
        }
        return
    }
    // get player inputs
    playerControls()

    // bounce off walls and stay on top of floors
    playerCollisions()

    // check horizontal direction
    if xSpeed > 0 {
        xDir = 1
    }
    if xSpeed < 0 {
        xDir = -1
    }
    
    if !onGround {
        // low gravity at apex of jump
        if abs(ySpeed) < 0.5 {
            gravForce = 0.05
            obj_hud.jumpStateText = "Hang"
        }

        // low gravity while rising
        else if ySpeed < 0 {
            gravForce = 0.2
            obj_hud.jumpStateText = "Rise"
        }

        // high gravity while falling
        else {
            obj_hud.jumpStateText = "Fall"
            gravForce = 0.55
        }
    }

    // if the player is in the air, apply gravity
    if !place_meeting(x, y + 1, obj_wall) {
        ySpeed += gravForce
    }

    // limit speed
    xSpeed = max(xSpeed, -maxXSpeed)
    xSpeed = min(xSpeed, maxXSpeed)
    ySpeed = max(ySpeed, -maxYSpeed)
    ySpeed = min(ySpeed, maxYSpeed)

    // if we are supposed to be on the ground, stick to the ground
    if onGround {
        while !place_meeting(x, y + 1, obj_wall) {
            y += 1
        }
    }

    // check if the player is directly on top of a solid object
    if place_meeting(x, y + 1, obj_wall)
    {
        collidingObj = instance_place(x, y + 1, obj_wall) 
        floorAngle = collidingObj.angle
        if onGround == 0 {
            checkAngleOnLanding()
        }
        spriteRotation = floorAngle
        moveSlope = collidingObj.slope
        onGround = 1
        adjustSpeedOnSlope()
    }

    // move player
    x += xSpeed
    y += ySpeed
	
	// if outside the level boundaries, restart the level
	if x > room_width || x < 0 {
		room_restart()
	}
	if y > room_height {
		room_restart()
	}
}

function playerControls() {
    key_right = keyboard_check(ord("D"))
    key_left = keyboard_check(ord("A"))
    key_space = keyboard_check(vk_space)
	key_shift = keyboard_check(vk_shift)
    key_space_released = keyboard_check_released(vk_space)
    key_escape = keyboard_check_pressed(vk_escape)

    // pause the game
    if key_escape {
        global.paused = 1
    }

    // if on the ground, allow the player to jump control horizontal speed
    if onGround {
        if !(abs(xSpeed) < 0.2 && ySpeed != 0) {
            if key_right && xSpeed < (maxXSpeed / 2) {
                if xDir == -1 {
                    xSpeed += 0.4
                }
                else {
                    xSpeed += 0.08
                }
            }

            if key_left && xSpeed > (-maxXSpeed / 2){
                if xDir == 1 {
                    xSpeed -= 0.4
                }
                else {
                    xSpeed -= 0.08
                }
            }
        }

        if key_space {
            jumpForce += 0.06
            jumpForce = min(jumpForce, 4)
        }

        if key_space_released {
            playerJump()
        }
    }

    // if not on the ground, allow the player to rotate
    else {
		rotationSpeed = 1
		if key_shift {
			rotationSpeed = 7
		}
        if key_right {
            spriteRotation -= rotationSpeed
        }
        if key_left {
            spriteRotation += rotationSpeed
        }
    }
}

function playerCollisions() {
    // don't allow the player to be inside a solid object
    while place_meeting(x, y, obj_wall) {
        y -= 1
    }

    // check if there is a wall below us
    if !(place_meeting(x, y + 10, obj_wall))
    {
        onGround = 0
        jumpForce = 0
    }

    // check if we are about to hit a wall
    if place_meeting(x + xSpeed, y, obj_wall) {
        collidingObj = instance_place(x + xSpeed, y, obj_wall) 

        // only bounce off vertical walls, not slopes
        if !(object_get_parent(collidingObj.object_index) == obj_wall_angle)
        {
            playerCollideWall()
        }
     }

    #region possibly unused tail/nose sliding code
    // // slow down while nose or tail grinding
    // if place_meeting(x, y + 1, obj_wall) {
    //     collidingObj = instance_place(x, y + 1, obj_wall)
    //     if abs(image_angle - collidingObj.angle) > 0 {
    //         show_debug_message("grinding to a halt")
    //         xSpeed -= (0.1 * sign(xSpeed))

    //         // stop nose or tail grinding if on the ground and speed is low
    //         if abs(xSpeed) < 1 && place_meeting(x, y + 1, obj_wall) {
    //         image_angle = collidingObj.angle       
    //         while (!place_meeting(x, y + 1, obj_wall)) {
    //             y += 1
    //         }
    //         ySpeed = 0
    //     }
    // }  
    // }
    #endregion
	
	// check if we are at the goal
	if place_meeting(x, y, obj_goal)
	{
		room_goto_next()
	}

}

function playerCollideWall() {
    // finish slope before bouncing
    if place_meeting(x, y + 1, obj_wall_angle) {
        return
    }
    // bounce slightly off the wall and reduce speed
    while (!place_meeting(x + sign(xSpeed), y, obj_wall)) {
        x += sign(xSpeed)
    }
        xSpeed = -xSpeed / 4
}

function drawPlayerSprite() {
    xPos = x
    yPos = y

    // mirror the sprite if moving left
    if xSpeed > 0 {
        image_xscale = 1
    }
    else {
        image_xscale = -1
    }

    // adjust the location of the player sprite based on the slope the player is currently riding
    // shallow slope
    if abs(spriteRotation) == 22.5 {
        xPos = x + (4 * sign(spriteRotation))
        yPos = y + 4
    }

    // medium slope
    if abs(spriteRotation) == 36.87 {
        xPos = x + (5 * sign(spriteRotation))
        yPos = y + 5
    }

    // steep slope
    if abs(spriteRotation) == 45 {
        xPos = x + (6 * sign(spriteRotation))
        yPos = y + 6
    }

    draw_sprite_ext(sprite_index, image_index, xPos, yPos, image_xscale, image_yscale, spriteRotation, c_white, 1)
}

function adjustSpeedOnSlope() {
    // are we going uphill or downhill?
    downhill = -sign(xDir * moveSlope)

    if downhill {
        moveSpeed = abs(xSpeed) + abs(ySpeed)
        moveSpeed += (abs(moveSlope) / 60)
        ySpeed = (abs(moveSlope) * abs(xSpeed))
        xSpeed = (moveSpeed - ySpeed) * xDir
    }

    if !downhill {
        moveSpeed = abs(xSpeed) + abs(ySpeed)
        moveSpeed -= (abs(moveSlope) / 8)
        ySpeed = -abs(moveSlope * xSpeed)
        xSpeed = (moveSpeed - abs(ySpeed)) * xDir
    }
}

function checkAngleOnLanding() {
    // When the player is tilted to the right, the angle is negative. Left is positive
    // Slopes - down to the right is negative, up to the right is positive
	speedBoost = 1
	if spriteRotation > 180
	{
		playerAngle = 360 - spriteRotation
        speedBoost = 1.1
	}
	else if spriteRotation < -180
	{
		playerAngle = -360 - spriteRotation
        speedBoost = 1.1
	}
	else
	{
		playerAngle = spriteRotation
	}
	
    angleDiff = abs(playerAngle - floorAngle)
    if angleDiff < goodAngleThreshold {
        obj_hud.playerText = "NICE!"
        obj_hud.messageTimer = obj_hud.maxMessageTimer
        newXSpeed = (0.5 * ySpeed * speedBoost) * xDir
        if abs(newXSpeed) > abs(xSpeed) {
            xSpeed = newXSpeed
        }
        ySpeed = 0
    } 

    else {
        obj_hud.playerText = "BAD!"
        obj_hud.messageTimer = obj_hud.maxMessageTimer
        xSpeed = (0.1 * ySpeed) * xDir
        ySpeed = 0

    }
}

function playerJump() {
    ySpeed = -jumpForce * 1.6
    xSpeed += ((jumpForce * abs(moveSlope)) * xDir) * 0.8
    jumpForce = 0
    onGround = 0
    y += ySpeed
}