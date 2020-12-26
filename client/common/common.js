function findGetParameter(parameterName) {
    var result = null,
        tmp = [];
    location.search
        .substr(1)
        .split("&")
        .forEach(function (item) {
          tmp = item.split("=");
          if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
        });
    return result;
}

var currentMousePos = { x: -1, y: -1 };
$(() => {
    $(document).mousemove(function(event) {
        currentMousePos.x = event.pageX;
        currentMousePos.y = event.pageY;
    });


    $(document).mouseup(function(e) 
    {
        if(_currentContextMenu == null) return;
        var container = _currentContextMenu;
        if (!container.is(e.target) && container.has(e.target).length === 0) 
        {
            container.hide();
        }
    });
})

var _callbackContextMenu = null;
var _currentContextMenu = null;
function showContextMenu(id, attach, callback) {
    _currentContextMenu = $(id);
    $(id).css("position", "fixed");
    $(id).css("display", "block");
    $(id).css("top", currentMousePos.y + "px");
    $(id).css("left", currentMousePos.x + "px");
    _callbackContextMenu = callback;

    
    $(".context-menu-item").each((e, item) => {
        $(item).off( "click", "**" );
        $(item).click(() => {
            if(_callbackContextMenu != null) {
                _callbackContextMenu($(item).data("choice"))
                _callbackContextMenu = null;
                _currentContextMenu.hide();
                _currentContextMenu = null;
            }
        })
    })
}
