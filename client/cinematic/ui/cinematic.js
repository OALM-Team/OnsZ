CallEvent("Survival:Cinematic:GetText", findGetParameter("text"))

function setText(text) {
    document.getElementById("cinematic-text").innerHTML = text;
}

function fadeOut() {
    document.getElementById("container").animate([
        // keyframes
        { opacity: '1' }, 
        { opacity: '0' }
      ], { 
        // timing options
        duration: 2100
      });
}