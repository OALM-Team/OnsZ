var configItems = []
var items = []
var grid = [];
var weapons = [];

function initGrid() {
    var i = 0;
    for (var y = 0; y < 100; y++) {
        for (var x = 0; x < 8; x++) {
            grid[i] = {
                slotId: i,
                x,
                y
            };
            i++;
        }
    }
}
initGrid();

function drawInventorySpace(id, name, space) {
    // Create container
    var inventoryList = document.getElementById("inventory-storage-list");
    var div = document.createElement("div");
    div.innerHTML = '<div class="window-header">' +
        name +
        '<div class="right">' +
            '<span id="inventory-' + id + '-space-left">0</span>/' + space +
        '</div>' +
    '</div>' +
    '<div class="window-content">' +
        '<div id="inventory-' + id + '-content" class="inventory-content">' +
            '<div id="inventory-' + id + '-content-overlay" class="inventory-content-overlay"></div>' +
            '<div id="inventory-' + id + '-content-slots"></div>' +
        '</div>' +
    '</div>';
    inventoryList.append(div)
    div.style.width = "475px";
    div.style.marginRight = "10px";
    div.style.display = "inline-block";
    div.style.verticalAlign = "top";

    // Create storage
    items[id] = []
    var container = document.getElementById("inventory-" + id + "-content-slots");
    for (var i = 0; i < space; i++) {
        container.innerHTML += '<div class="inventory-content-square" data-slot="' + i + '" data-inventory="' + id + '"></div>';
    }
    $('.inventory-content-square').droppable({
        drop: function(event, ui) {
            onDropOverSquare(ui.draggable[0], ui.draggable[0].dataset.inventoryId,
                ui.draggable[0].dataset.uid, event.target.dataset.slot, event.target.dataset.inventory, ui)
        }
    });
}

function refreshInventorySpace(id) {
    document.getElementById('inventory-' + id + '-space-left').innerText = getUnavailableSlots(id).length;
}

function onDropOverSquare(ele, inventoryId, uid, targetSlot, targetInventory, ui) {
    var selectedDropitem = items[inventoryId].find(x => x.uid == uid);
    if(canFitInThisSlot(targetInventory, targetSlot, selectedDropitem.itemId, selectedDropitem.uid)) {
        moveItem(selectedDropitem, targetInventory, targetSlot)
    }
    else {
        var relativePos = getSlotPosition(inventoryId, selectedDropitem.slot);
        selectedDropitem.ele.style.top = relativePos.y + "px";
        selectedDropitem.ele.style.left = relativePos.x + "px";
    }
}

function getSlotInDirection(slot, direction, offset = 1) {
    var posXY = grid[slot];
    var found = null;
    switch (direction) {
        case "bottom":
            found = grid.find(s => s.x == posXY.x && s.y == posXY.y + offset);
            break;
        case "top":
            found = grid.find(s => s.x == posXY.x && s.y == posXY.y - offset);
            break;
        case "right":
            found = grid.find(s => s.x == posXY.x + offset && s.y == posXY.y);
            break;
        case "left":
            found = grid.find(s => s.x == posXY.x - offset && s.y == posXY.y);
            break;
    }
    return found;
}

function getInventoryItemsConfig(_configItems) {
    configItems = _configItems

    // test
    /**
    addItem("1", "1", 0, "water")
    addItem("1", "2", 1, "water")
    addItem("1", "3", 2, "sandwish")
    //addItem("1", 2, "apple")
    addItem("1", "4", 16, "water")
    addItem("1", "5", 17, "apple")
    addItem("1", "6", 25, "apple")
    addItem("1", "7", 5, "pickaxe")
    addItem("1", "8", 10, "sandwish")

    
    addItem("2", "9", 1, "sandwish")
     */
}

function addInventoryItemsConfig(key, configItem) {
    configItems[key] = configItem;
}

function getSizeByDimension(w, h) {
    var baseSquareSize = document.getElementsByClassName("inventory-content-square")[0].clientWidth + 2;
    return {
        w: w * baseSquareSize,
        h: h * baseSquareSize
    }
}

function getSlotPosition(inventoryId, slot) {
    var slotEle = document.querySelector("#inventory-" + inventoryId + "-content-slots .inventory-content-square[data-slot='" + slot + "']")
    return {
        x: slotEle.offsetLeft,
        y: slotEle.offsetTop
    }
}

function getItemSlotsClaimed(itemId, slot) {
    var template = configItems[itemId];
    var slots = []
    slots.push(parseInt(slot))
    var currentSlot = slot;
    for (var y = 0; y < template.dimensions.h; y++) {
        for (var x = 1; x < template.dimensions.w; x++) {
            if(getSlotInDirection(currentSlot, "right", x) != null) {
                slots.push(getSlotInDirection(currentSlot, "right", x).slotId);
            }
            else {
                break;
            }
        }
        if(getSlotInDirection(currentSlot, "bottom") == null) {
            break;
        }
        currentSlot = getSlotInDirection(currentSlot, "bottom").slotId
        if (template.dimensions.h - 1 != y) slots.push(currentSlot)
    }
    return slots;
}

function getItemOnSlot(inventoryId, slot) {
    items[inventoryId]
}

function getUnavailableSlots(inventoryId, uid = -1) {
    var slots = []
    for(var item of items[inventoryId]) {
        if(uid != -1) {
            if(uid == item.uid) continue;
        }
        var claimed = getItemSlotsClaimed(item.itemId, item.slot);
        slots = slots.concat(claimed)
    }
    return slots
}

function existSlot(inventoryId, slotId) {
    return document.querySelector("#inventory-" + inventoryId + "-content-slots .inventory-content-square[data-slot='" + slotId + "']") != null;
}

function canFitInThisSlot(inventoryId, slot, item, uid = -1) {
    var slotUnavailable = getUnavailableSlots(inventoryId, uid);
    var slotNeeded = getItemSlotsClaimed(item, slot);
    for(var s of slotNeeded) {
        if(slotUnavailable.indexOf(s) != -1) { // Check if the slot is empty
            return false;
        }
        if(!existSlot(inventoryId, s)) { // Check if the slot exist in the inventory
            return false;
        }
    }
    var template = configItems[item];
    if(slotNeeded.length != (template.dimensions.w * template.dimensions.h)) {
        return false;
    }
    return true;
}

function addItem(inventoryId, uid, slot, item, redraw = false) {
    var template = configItems[item];
    var size = getSizeByDimension(template.dimensions.w, template.dimensions.h)
    var relativePos = getSlotPosition(inventoryId, slot);
    if (items[inventoryId] == null) {
        items[inventoryId] = []
    }

    // Create element
    var ele = document.createElement("div")
    ele.innerHTML = '<div title="' + template.desc + '" style="width: 80%; height: 80%; position: absolute; top: 50%; left: 50%; transform: translateY(-50%) translateX(-50%);"><img src="./icons/' + item + '.png" style="width: 100%; height: 100%;"></div>';
    ele.style.position = "absolute";
    ele.style.height = size.h + "px";
    ele.style.width = size.w + "px";
    ele.style.top = relativePos.y + "px";
    ele.style.left = relativePos.x + "px";
    ele.style.zIndex = "50";
    ele.dataset.uid = uid;
    ele.dataset.inventoryId = inventoryId;
    ele.classList.add("item-object")
    var container = document.getElementById("inventory-" + inventoryId + "-content-overlay");
    container.append(ele);

    if(!redraw) {
        items[inventoryId].push({
            uid: uid,
            itemId: item,
            slot: slot,
            inventoryId: inventoryId,
            ele: ele
        })
    }

    var prevEle = document.createElement("div")
    prevEle.classList.add("item-object")
    container.append(prevEle);
    prevEle.style.position = "absolute";
    prevEle.style.height = size.h + "px";
    prevEle.style.width = size.w + "px";
    prevEle.style.top = relativePos.y + "px";
    prevEle.style.left = relativePos.x + "px";
    prevEle.style.background = "green";
    prevEle.style.opacity = "0.1s";
    prevEle.style.display = "none";

    $(ele).draggable({
        cursor: 'move',
        ghost: false,
        helper: "",
        opacity: "0.8",
        start: (event, ui) => {
            prevEle.style.display = "block";
            ele.style.transition = "0s";
            ele.style.pointerEvents = "none";
        },
        drag: (event, ui) => {
            var offset = $(ele).offset();
            var baseSquareSize = document.getElementsByClassName("inventory-content-square")[0].clientWidth + 2;
            var xPos = offset.left + (size.w / 2);
            var yPos = offset.top + (size.h / 2);
            for(var s of document.querySelectorAll("#inventory-" + inventoryId + "-content-slots .inventory-content-square")) {
                var square = $(s).offset();
                if(xPos > square.left && xPos < square.left + baseSquareSize && yPos > square.top && yPos < square.top + baseSquareSize) {
                    var slotId = $(s).data("slot");
                    var relativePrevPos = getSlotPosition(inventoryId, slotId);
                    prevEle.style.top = relativePrevPos.y + "px";
                    prevEle.style.left = relativePrevPos.x + "px";
                }
            }
            
        },
        stop: (event, ui) => {
            prevEle.style.display = "none";
            ele.style.transition = "0.3s";
            ele.style.pointerEvents = "all";
        },
        revert : "invalid"
    }); 

    $(ele).tooltip({
        track: false,
    });

    $(ele).contextmenu(function() {
        if(template.is_ammo) {
            showContextMenu("#context-menu-item-ammo", $(ele), (choice) => {
                if(choice == "throw") {
                    CallEvent("Survival:Inventory:RequestThrowItem", inventoryId, uid)
                } else if(choice == "recharge-ammo-1") {
                    CallEvent("Survival:Inventory:RequestUseAmmo", 1, inventoryId, uid)
                } else if(choice == "recharge-ammo-2") {
                    CallEvent("Survival:Inventory:RequestUseAmmo", 2, inventoryId, uid)
                }else if(choice == "recharge-ammo-3") {
                    CallEvent("Survival:Inventory:RequestUseAmmo", 3, inventoryId, uid)
                }
            })
        }
        else if(template.is_outfit) {
            showContextMenu("#context-menu-item-clothe", $(ele), (choice) => {
                if(choice == "throw") {
                    CallEvent("Survival:Inventory:RequestThrowItem", inventoryId, uid)
                } 
                else if(choice == "tear") {
                    CallEvent("Survival:Inventory:RequestTearItem", inventoryId, uid)
                }
                else if(choice == "use") {
                    CallEvent("Survival:Inventory:RequestUseItem", inventoryId, uid)
                }
            })
        }
        else {
            showContextMenu("#context-menu-item", $(ele), (choice) => {
                if(choice == "throw") {
                    CallEvent("Survival:Inventory:RequestThrowItem", inventoryId, uid)
                } else if(choice == "use") {
                    CallEvent("Survival:Inventory:RequestUseItem", inventoryId, uid)
                }
            })
        }
    });

    refreshInventorySpace(inventoryId)
} 

function moveItem(item, toInventory, toSlot) {
    if(!canFitInThisSlot(toInventory, toSlot, item.itemId, item.uid)) {
        return;
    }
    var oldInventory = item.inventoryId;

    var fromContainer = document.getElementById("inventory-" + item.inventoryId + "-content-overlay");
    var targetContainer = document.getElementById("inventory-" + toInventory + "-content-overlay");
    if(item.inventoryId != toInventory) {
        item.ele.remove()
        targetContainer.append(item.ele)
        items[item.inventoryId].splice(items[item.inventoryId].indexOf(item), 1)
        if(CallEvent != null) CallEvent("Survival:Inventory:RequestChangeInventorySlotItem", item.inventoryId, toInventory, item.uid, toSlot)
        item.inventoryId = toInventory;
        item.ele.dataset.inventoryId = toInventory;
        items[item.inventoryId].push(item)
    }
    else {
        CallEvent("Survival:Inventory:RequestChangeSlotItem", item.inventoryId, item.uid, toSlot)
    }
    var relativePos = getSlotPosition(item.inventoryId, toSlot);
    item.ele.style.top = relativePos.y + "px";
    item.ele.style.left = relativePos.x + "px";
    item.slot = toSlot;
    refreshInventorySpace(oldInventory)
    refreshInventorySpace(toInventory)
}

function removeItem(inventoryId, uid) {
    var item = items[inventoryId].find(x => x.uid == uid);
    item.ele.remove()
    items[inventoryId].splice(items[inventoryId].indexOf(item), 1)
}

function resetEquipment() {
    var container = document.querySelectorAll("[data-equip-type] .equipment-container");
    for(const c of container) {
        c.style.display = "none";
    }
}

function receiveEquipment(data) {
    var container = document.querySelector("[data-equip-type='" + data.type + "'] .equipment-container");
    container.style.display = "block";
    container.querySelector("img").src = './icons/' + data.itemId + '.png';

    $(container).contextmenu(function() {
        showContextMenu("#context-menu-item-equipment", $(container), (choice) => {
            if(choice == "unequip") {
                CallEvent("Survival:Inventory:RequestUnequipOutfit", data.type)
            }
        })
    });
}

function clearWeapon() {
    weapons = []
    document.getElementById("context-menu-item-ammo").innerHTML = "";
    var div = document.createElement("div");
    div.classList.add("context-menu-item")
    div.innerText = "Jeter";
    div.dataset.choice = "throw";
    document.getElementById("context-menu-item-ammo").append(div)
}

function addWeapon(slot, weaponName) {
    weapons.push({slot, weaponName})
    var div = document.createElement("div");
    div.classList.add("context-menu-item")
    div.innerText = "Recharger " + weaponName;
    div.dataset.choice = "recharge-ammo-"+slot;
    document.getElementById("context-menu-item-ammo").prepend(div)
    //document.getElementById("context-menu-item-ammo").innerHTML += '<div class="context-menu-item"></div>';
}

$(function(){
    CallEvent("Survival:Inventory:RequestInventoryData")
});
