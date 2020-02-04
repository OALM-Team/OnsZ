var map = null
var icons = [];
var currentLocationMarker = null;
var currentMode = "mini";

icons["atm"] = L.icon({
    iconUrl: './icons/atm.png',
    iconSize: [20, 20],
    iconAnchor: [0, 0]
});

function WorldToMapImgX(worldX)
{
    return (worldX + 234002.2054794521) / 241.041095890411;
}

function WorldToMapImgY(worldY)
{
    return 1943 - (worldY + 231101.3928571428) / 242.5535714285714;
}

function SwitchMode(mode) {
    var container = document.getElementById("map-window");
    var mapContent = container.querySelector(".window-content")

    switch(mode) {
        case "mini":
            container.style.position = "fixed";
            container.style.top = "";
            container.style.bottom = "20px";
            container.style.left = "20px";
            container.style.width = "200px";
            mapContent.style.height = "180px";
            mapContent.style.borderRadius = "500px";
            container.querySelector(".window-header").style.display = "none";
        break;

        case "big":
            container.style.position = "";
            container.style.top = "";
            container.style.bottom = "";
            container.style.left = "";
            container.style.width = "50%";
            mapContent.style.height = "500px";
            mapContent.style.borderRadius = "";
            container.querySelector(".window-header").style.display = "block";
        break;
    }
    currentMode = mode;
    setTimeout(() => {
        map.invalidateSize();
    }, 500)
}

function setPlayerLocation(x,y) {
    currentLocationMarker.setLatLng([WorldToMapImgY(y), WorldToMapImgX(x)])
    if(currentMode=="mini") {
        map.setView([WorldToMapImgY(y), WorldToMapImgX(x)])
    }
}

$(() => {
    //$("#map-canvas").draggable();
    map = L.map('map-canvas', {
        crs: L.CRS.Simple,
        center: [WorldToMapImgY(205554), WorldToMapImgX(163779)],
        zoom: 0,
        minZoom: -2,
        zoomControl: false
    });
    $('.leaflet-control-attribution').hide()
    var bounds = [[0,0], [1943,2000]];
    var image = L.imageOverlay('./map.jpg', bounds).addTo(map);
    //L.marker([WorldToMapImgY(205554), WorldToMapImgX(163779)], {icon: icons["atm"]}).addTo(map);
    currentLocationMarker = L.marker([WorldToMapImgY(0), WorldToMapImgX(0)], { 
        icon: L.divIcon({
        className: 'pulse',
        html: '',
        iconSize: [15, 15],
        iconAnchor: [0, 0]
    }) 
    }).addTo(map);
    setTimeout(() => {
        SwitchMode("mini");
    }, 300)
    //L.marker([WorldToMapImgY(79290), WorldToMapImgX(127967)], {icon: icons["atm"]}).addTo(map);
    //map.invalidateSize();
})