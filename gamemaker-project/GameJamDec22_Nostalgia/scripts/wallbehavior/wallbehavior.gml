function wallInit(){
    sprite_index = getSpriteForRoomVersion("spr_wall")
}

function wallUpdate(){
    depth = -y
}

function updateCrackedWallSprite() {
    if isGreenRoom() {
        sprite_index = spr_gate_cracked
    }
    else {
        sprite_index = spr_gate
    }
}