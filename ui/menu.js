$(function() {
    let players = null;
    //let players = $({"identifier":"1234","license":"asdf","money":"sdfg","name":"jfgb","job":"rgssdf","job_grade":"aqwefas","position":"jhgdgfb","bank":"dfghdgf","permission_level":"dhdgbh","group":"jfhjdfg"});
    //$('body').show();
    //build_players_datatable();

    $(".header .col.quit").click(function(event){
        close_menu();
    });

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

        $('.content .row.panels').css('height', ($('.container').height() - header_height - menu_height - footer_height-7) + 'px');

        $('body').css('zoom', (factor * 100) + '%');

        $('.container').css('top', ((document.documentElement.clientHeight - ($('.container').outerHeight() * factor)) / 2) + 'px');        
    }

    function close_menu() {
        $('body').hide();
        $.post('http://ku_admin/menu_closed', JSON.stringify({}));
        $(".dd_actions_player").removeClass("animated rollIn rollOut")
    }

    function build_players_datatable() {
        let table = $('.panels #players table');
        let player_table_rows = table.find('tbody');

        player_table_rows.find('tr').remove();

        let row = null;
        players.each(function(index, player) {
            row  = "<tr>";
            row += "<td><button class=\"actions_player\">actions</button></td>";
            row += "<td>" + player.identifier + "</td>";
            row += "<td>" + player.name + "</td>";
            row += "<td>" + player.permission_level + "</td>";
            row += "<td>" + player.group + "</td>";
            row += "<td>" + player.job + "</td>";
            row += "<td>" + player.job_grade + "</td>";
            row += "<td>" + player.money + "</td>";
            row += "<td>" + player.bank + "</td>";
            row += "<td>" + player.license + "</td>";
            row += "</tr>";

            player_table_rows.append(row);
        });

        $(".actions_player").on('click', function(){
            $(".dd_actions_player").show();
            $(this).parent().append($(".dd_actions_player"));
            $(".dd_actions_player").addClass("animated rollIn").one("webkitAnimationEnd mozAnimationEnd oAnimationEnd animationend", function(){
                $(this).removeClass("animated rollIn");
            });
        });
    
        $(".dd_actions_player li").on('click', function(){
            $(".dd_actions_player").addClass("animated fadeOut").one("webkitAnimationEnd mozAnimationEnd oAnimationEnd animationend", function(){
                $(this).removeClass("animated fadeOut");
                $(".dd_actions_player").hide();
            });
        });    
    }

    window.addEventListener('message', function(event){
        if (event.data.action == "ku_admin_show_menu") {
            $('.container').show();
        }
        switch(event.data.action){
            case "ku_admin_show_menu":
                show_menu();
                $.post('http://ku_admin/get_players');
                break;
            case "ku_admin_close_menu":
                close_menu();
                break;
            case "ku_admin_set_players":
                players = $(event.data.players);
                build_players_datatable();
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

    $('.nav-tabs .nav-item .nav-link[href="#players"]').click(function(){
        $.post('http://ku_admin/get_players');
    });

    $('.nav-tabs .nav-item .nav-link[href="#skills"]').click(function(){
        //alert("skills");
    });

    $('.nav-tabs .nav-item .nav-link[href="#careers"]').click(function(){
        //alert("careers");
    });
})