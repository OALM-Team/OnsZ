var configItems = []
var items = []

function drawInventorySpace(id, space) {
    var container = document.getElementById("inventory-" + id + "-content-slots");
    for(var i = 0; i < space; i++) {
        container.innerHTML += '<div class="inventory-content-square" data-slot="' + i + '"></div>';
    }
}

function getSlotInDirection(slot, direction) {
    if(direction == "bottom") {
        return slot + 6
    }
}

function getInventoryItemsConfig(_configItems) {
    configItems = _configItems
}

function getSizeByDimension(w,h) {
    var baseSquareSize = document.getElementsByClassName("inventory-content-square")[0].clientWidth + 2;
    return { w: w * baseSquareSize, h: h * baseSquareSize }
}

function getSlotPosition(inventoryId, slot) {
    var slotEle = document.querySelector("#inventory-" + inventoryId + "-content-slots .inventory-content-square[data-slot='" + slot + "']")
    return { x: slotEle.offsetLeft, y: slotEle.offsetTop }
}

function addItem(inventoryId, slot, item) {
    var template = configItems[item];
    var size = getSizeByDimension(template.dimensions.w, template.dimensions.h)
    var relativePos = getSlotPosition(inventoryId, slot);

    // Create element
    var ele = document.createElement("div")
    ele.innerHTML = '<div style="width: 90%; height: 90%; margin-left: auto;     vertical-align: middle;"><img src="./icons/' + item + '.png" style="width: 100%; height: 100%;"></div>';
    ele.style.position = "absolute";
    ele.style.height = size.h + "px";
    ele.style.width = size.w + "px";
    ele.style.top = relativePos.y + "px";
    ele.style.left = relativePos.x + "px";
    ele.classList.add("item-object")
    var container = document.getElementById("inventory-" + inventoryId + "-content-overlay");
    container.append(ele);
}

drawInventorySpace("1", 20)
getInventoryItemsConfig({"water":{"name":"Bouteille d'eau","desc":"Une simple bouteille d'eau","dimensions":{"w":1,"h":2}}, "apple":{"name":"Pomme","desc":"Une pomme juteuse","dimensions":{"w":1,"h":1}}})
addItem("1", 0, "water")
addItem("1", 1, "water")
addItem("1", 2, "apple")
CallEvent("Survival:Inventory:RequestInventoryData")