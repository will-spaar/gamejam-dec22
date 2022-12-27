function drawJumpMeter(){
    // check that the player is charging a jump
    jumpForce = obj_player.jumpForce
    if jumpForce == 0 {
        return
    }

    xStart = obj_player.x - 40
    yStart = obj_player.y 
    xEnd   = xStart - 10
    yEnd   = yStart - 100
    jumpForce = obj_player.jumpForce

    draw_set_color(c_red)
    draw_roundrect(xEnd, yStart - (jumpForce * 10), xStart, yStart, false)
    draw_set_color(c_black)
    draw_roundrect(xEnd, yEnd, xStart, yStart, true)
}