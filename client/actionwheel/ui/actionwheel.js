var ele = document.querySelector('#circle-menu1');
var cmenu = CMenu(ele)
            .config({
                totalAngle: 360,
                spaceDeg: 1,
                background: "#323232",
                backgroundHover: "#123321",
                percent: 0.32,//%
                diameter: 300,//px
                position: 'top',
                horizontal: true,
                animation: "into",
                menus: [
                    {
                        title: 'Inventaire',
                        href: '#7'
                    },
                    {
                        title: '',
                        href: '#7'
                    },
                    {
                        title: '',
                        href: '#7'
                    },
                    {
                        title: '',
                        href: '#8'
                    }
                ]
            });

cmenu.styles({
    top: '200px',
    left: '600px'
}).show();