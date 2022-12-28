function hudInit() {
    maxMessageTimer = 25
    messageTimer = 0
    playerText = ""
}

function drawJumpMeter(){
    // check that the player is charging a jump
    jumpForce = obj_player.jumpForce
    if jumpForce == 0 {
        return
    }

    // draw the meter representing the charged jump force
    xStart = obj_player.x - 40
    yStart = obj_player.y 
    xEnd   = xStart - 10
    yEnd   = yStart - 100
    jumpForce = obj_player.jumpForce

    draw_set_color(c_red)
    draw_roundrect(xEnd, yStart - (jumpForce * 20), xStart, yStart, false)
    draw_set_color(c_black)
    draw_roundrect(xEnd, yEnd, xStart, yStart, true)
}

function drawDebugInfo() {
    draw_set_color(c_black)
    startX = camera_get_view_x(view_camera[0])
    startY = camera_get_view_y(view_camera[0])
    draw_text(startX + 5, startY + 5, "x: " + string(obj_player.xSpeed) + " y: " + string(obj_player.ySpeed) + " speed: " + string(obj_player.moveSpeed))
}

function drawTextAbovePlayer() {
    if messageTimer > 0 {
        messageTimer--
        draw_set_color(c_black)
        startX = obj_player.x - 10
        startY = obj_player.y - 100
        draw_text(startX, startY, playerText)
    }
}