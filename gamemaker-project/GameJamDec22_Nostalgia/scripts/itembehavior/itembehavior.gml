function collectItem(item){
    script_execute(item.pickupFunction)
    ds_list_add(global.collectedItems, item.id)
    instance_destroy(item)
}

function itemInit() {
    if (ds_list_find_index(global.collectedItems, id)) != -1 {
        instance_destroy()
    }
}