function splitString(str, divider){
	var len = string_length(str);
	
	var subStr = "";
	var arrIndex = 0;
	var arr;
	for (var i = 1; i <= len; i++)
	{
		var char = string_char_at(str, i);
		if (char != divider)
		{
			//add char to substring
			subStr += char;
		}
		else
		{
			//ensure substring is not empty. 
			if(string_length(subStr) > 0)
			{
				//add substring to array
				arr[arrIndex] = subStr;
				arrIndex++;
				//clear substring
				subStr = "";
			}
		}
	}
		//Add final substring to array
		if(string_length(subStr) > 0)
		{
			arr[arrIndex] = subStr;
		}
	return arr;
}

function getSpriteForRoomVersion(baseName) {
    if isGreenRoom() {
		return asset_get_index(baseName + "_green")
	}
	else {
		return asset_get_index(baseName + "_main")
	}
}

function isGreenRoom() {
	roomName = room_get_name(room)
    roomPrefix = splitString(roomName, "_")[0]
	if (roomPrefix = "green") {
		return true
	}
	return false
}

function destroyPersistentObject(objId) {
	ds_list_add(global.destroyedObjects, objId)
}