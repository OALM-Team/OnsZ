var configItems = []
var items = []
var grid = [];

function initGrid() {
    var i = 0;
    for (var y = 0; y < 100; y++) {
        for (var x = 0; x < 6; x++) {
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

function drawInventorySpace(id, space) {
    var container = document.getElementById("inventory-" + id + "-content-slots");
    for (var i = 0; i < space; i++) {
        container.innerHTML += '<div class="inventory-content-square" data-slot="' + i + '"></div>';
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
    slots.push(slot)
    var currentSlot = slot;
    for (var y = 0; y < template.dimensions.h; y++) {
        for (var x = 1; x < template.dimensions.w; x++) {
            slots.push(getSlotInDirection(currentSlot, "right", x).slotId);
        }
        currentSlot = getSlotInDirection(currentSlot, "bottom").slotId
        if (template.dimensions.h - 1 != y) slots.push(currentSlot)
    }
    return slots;
}

function getItemOnSlot(inventoryId, slot) {
    items[inventoryId]
}

function addItem(inventoryId, slot, item) {
    var template = configItems[item];
    var size = getSizeByDimension(template.dimensions.w, template.dimensions.h)
    var relativePos = getSlotPosition(inventoryId, slot);
    if (items[inventoryId] == null) {
        items[inventoryId] = []
    }

    // Create element
    var ele = document.createElement("div")
    ele.innerHTML = '<div style="width: 80%; height: 80%; position: absolute; top: 50%; left: 50%; transform: translateY(-50%) translateX(-50%);"><img src="./icons/' + item + '.png" style="width: 100%; height: 100%;"></div>';
    ele.style.position = "absolute";
    ele.style.height = size.h + "px";
    ele.style.width = size.w + "px";
    ele.style.top = relativePos.y + "px";
    ele.style.left = relativePos.x + "px";
    ele.classList.add("item-object")
    var container = document.getElementById("inventory-" + inventoryId + "-content-overlay");
    container.append(ele);

    items[inventoryId].push({
        itemId: item,
        slot: slot
    })
}

drawInventorySpace("1", 20)
getInventoryItemsConfig({
    "water": {
        "name": "Bouteille d'eau",
        "desc": "Une simple bouteille d'eau",
        "dimensions": {
            "w": 1,
            "h": 2
        }
    },
    "apple": {
        "name": "Pomme",
        "desc": "Une pomme juteuse",
        "dimensions": {
            "w": 1,
            "h": 1
        }
    },
    "pickaxe": {
        "name": "Pioche",
        "desc": "Une pioche classique",
        "dimensions": {
            "w": 3,
            "h": 3
        }
    },
    "sandwish": {
        "name": "Sandwish",
        "desc": "Pas sûr qu'il soit toujours bon",
        "dimensions": {
            "w": 3,
            "h": 1
        }
    }
})
addItem("1", 0, "water")
addItem("1", 1, "water")
addItem("1", 2, "apple")
addItem("1", 8, "apple")
addItem("1", 3, "pickaxe")
addItem("1", 12, "sandwish")
CallEvent("Survival:Inventory:RequestInventoryData")