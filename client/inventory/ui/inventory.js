var configItems = []

function drawInventorySpace(id, space) {
    var container = document.getElementById("inventory-" + id + "-content");
    for(var i = 0; i < space; i++) {
        container.innerHTML += '<div class="inventory-content-square"></div>';
    }
}

function getInventoryItemsConfig(_configItems) {
    configItems = _configItems
}

drawInventorySpace("1", 20)
getInventoryItemsConfig({"water":{"name":"Bouteille d'eau","desc":"Une simple bouteille d'eau","dimensions":{"w":1,"h":2}}})
CallEvent("Survival:Inventory:RequestInventoryData")