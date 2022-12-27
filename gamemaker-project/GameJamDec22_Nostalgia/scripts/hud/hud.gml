function addBattery()
{
    batteryAmt = 30
    global.battery += batteryAmt
    if global.battery > 100 {
        global.battery = 100
    }
}

function subtractBattery(batteryAmt)
{
    global.battery -= batteryAmt
    if global.battery < 0 {
        global.battery = 0
        roomName = room_get_name(room)
        roomSuffix = splitString(roomName, "_")[1]
        show_debug_message(roomName)
        currentRoom = "main_" + roomSuffix
        showEmptyBattery(currentRoom)
    }
}

function drawHUD(){
    if isGreenRoom() {
        draw_text(5, 5, string(global.battery) + "%")
    }
}

function batteryUpdate()
{
    if isGreenRoom() {
        global.batteryTimer -= 1
        if global.batteryTimer <= 0 {
            global.batteryTimer = global.maxBatteryTimer
            subtractBattery(1)
        }
    }
}

function gameStart() {
    global.maxBatteryTimer = 20
    global.batteryTimer = global.maxBatteryTimer
    global.battery = 5
    global.keys = 0
    global.collectedItems = ds_list_create()
    global.destroyedObjects = ds_list_create()
    room_goto(main_room1)
}

function collectKey() {
    global.keys += 1
}

function useKey() {
    global.keys -= 1
}

function showEmptyBattery(currentRoom)
{
    global.previousRoom = currentRoom
    room_goto(no_battery)
}