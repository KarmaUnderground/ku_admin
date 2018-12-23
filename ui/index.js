$(function() {
    $(".header .col.quit").click(function(event){
        close_menu();
    });

    function build_tabs(data) {
        for (tab in data.tabs) {
            for (template in data.tabs[tab].templates) {
                data.tabs[tab].templates[template] = Mustache.render(data.tabs[tab].templates[template], data.tabs[tab]);
            }
        }

        let tpl = $('#main_tpl').html();
        let result = Mustache.render(tpl, data);
        $('.container').html(result);

        $('.nav.nav-tabs a').first().addClass('active');
        $('.panels div.panel').first().addClass('active');
        $('.panels div.panel').first().addClass('show');
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

    window.addEventListener('message', function(event){
        switch(event.data.action){
            case "ku_admin_show_menu":
                show_menu();
                break;
            case "ku_admin_close_menu":
                close_menu();
                break;
            case "ku_admin_set_tabs":
                build_tabs(event.data.tabs);
                break;
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) { // Escape key
            close_menu();
        }
    };

    function log_info(msg) {
        $('.row.panels .col').html(msg);
    }

    /*
    $('.nav-tabs .nav-item .nav-link[href="#skills"]').click(function(){
        //alert("skills");
    });

    $('.nav-tabs .nav-item .nav-link[href="#careers"]').click(function(){
        //alert("careers");
    });
    */
})