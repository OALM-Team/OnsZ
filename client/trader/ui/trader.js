function addItem(itemId, name, desc, price) {
    var div = document.createElement("div");
    div.classList.add("item-line"); 
    const content = '<div class="item-image">' +
        '<img src="../../inventory/ui/icons/' + itemId + '.png" />' +
    '</div>' +
    '<div class="item-desc">' +
        '<div class="item-title">' + name + '</div>' +
        '<div class="item-desc-text">' + desc + '</div>' +
    '</div>' +
    '<div class="item-buy-button" onclick="javascript: requestBuy(\'' + itemId + '\')">' +
        'Acheter pour <img src="../../inventory/ui/icons/capsule_1.png" width="20" />x' + price +
    '</div>';
    div.innerHTML = content;
    document.getElementById("items-container").append(div);
}

function requestBuy(itemId) {
    CallEvent("Survival:Trader:RequestTraderBuy", itemId)
}

$(() => {
    CallEvent("Survival:Trader:RequestTraderConfig")
})