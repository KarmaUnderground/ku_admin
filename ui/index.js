$(function() {
    window.global_tabs = {};

    window.clean = function (dom){
        dom.children().each(function(){
            $(this).off();
            clean($(this));
        });
        dom.html("");
    }

    window.addEventListener('message', function(event){
        switch(event.data.action){
            case "ku_admin_close_menu":
                close_menu();
                break;
            case "ku_admin_show_menu":
                build_tabs(event.data.tabs);
                show_menu();
                break;
        }
    })

    $(".header .col.quit").click(function(event){
        close_menu();
    });

    function build_tabs(data) {
        window.clean($('.nav-tabs'));
        window.clean($('.panels'));

        for (tab in data.tabs) {
            window.global_tabs[data.tabs[tab].resource + '_' + data.tabs[tab].name] = data.tabs[tab];
        }

        let tpl = _.template($('#main_tpl').html());
        let result = tpl(data);

        $('.container').html(result);

        $('.nav.nav-tabs a').click(function() {
            window.dispatchEvent(new MessageEvent('message', {data: {action: window.global_tabs[$(this).attr('tab_id')].refresh_function}}));
        });

        $('.nav.nav-tabs a').first().addClass('active');
        $('.panels div.panel').first().addClass('active');
        $('.panels div.panel').first().addClass('show');

        $('.nav.nav-tabs a').first().click();

        $('.header .quit').click(function(){close_menu();});
    }

    function show_menu() {
        $('body').show();
        $('body').css('zoom', '100%');

        // Because my resolution was 1900px wide when I designed the screen!
        let factor = document.documentElement.clientWidth / 1900;

        let header_height = $('.header').outerHeight(true);
        let menu_height = $('.menu').outerHeight(true);
        let footer_height = $('.footer').outerHeight(true);

        $('.container').css('width', '1000px');
        $('.container').css('height', '750px');

        $('.content .panels').css('height', ($('.container').height() - header_height - menu_height - footer_height-7) + 'px');
        $('.content .panels .panel').css('height','100%');

        $('body').css('zoom', (factor * 100) + '%');

        $('.container').css('top', ((document.documentElement.clientHeight - ($('.container').outerHeight() * factor)) / 2) + 'px');
    }

    function close_menu() {
        $('body').hide();
        $.post('http://ku_admin/menu_closed', JSON.stringify({}));
    }

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            close_menu();
        }
    };
})