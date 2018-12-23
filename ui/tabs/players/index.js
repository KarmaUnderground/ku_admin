$(function() {
    window.addEventListener('message', function(event){
        switch(event.data.action){
            case "ku_admin_close_menu":
                $(".dd_actions_player").removeClass("animated rollIn rollOut")
                break;
            case "ku_admin_players_refresh_panel":
                $.post('http://ku_admin/getPlayers');
                break;
            case "ku_admin_set_players":
                build_players_datatable(event.data.players);
                break;
        }
    })

    function build_players_datatable(data) {
        let tpl = $('#player_table_tpl').html();
        let result = Mustache.render(tpl, data);
        $('#player_table').html(result);

        //alert(window);
        //alert(GetPlayerPed);

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
});