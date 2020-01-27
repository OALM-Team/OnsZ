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

    $(".context-menu-item").each((e, item) => {
        $(item).click(() => {
            if(_callbackContextMenu != null) {
                _callbackContextMenu($(item).data("choice"))
                _callbackContextMenu = null;
                _currentContextMenu.hide();
                _currentContextMenu = null;
            }
        })
    })

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
}

(function (obj) {
    ue.game = {};
    ue.game.callevent = function (name, ...args) {
        if (typeof name != "string") {
            return;
        }

        if (args.length == 0) {
            obj.callevent(name, "")
        } else {
            let params = []
            for (let i = 0; i < args.length; i++) {
                params[i] = args[i];
            }
            obj.callevent(name, JSON.stringify(params));
        }
    };
})(ue.game);
CallEvent = ue.game.callevent;