function clearPlayerList() {
    document.getElementById("players-list").innerHTML = "";
}

function addPlayerList(p) {
    document.getElementById("players-list").innerHTML += '<div class="line-item">' +
        '<div class="line-item-id">' +
            p.id +
        '</div>' +
        p.name +
    '</div>';
}

function setScoreboardState(state) {
    if(state == 1) {
        document.getElementById("scoreboard").style.display = "block";
    } else {
        document.getElementById("scoreboard").style.display = "none";
    }
}

$(() => {
    //setInterval(() => {
    //    CallEvent("Survival:Scoreboard:RequestPlayers")
    //}, 5000)
})