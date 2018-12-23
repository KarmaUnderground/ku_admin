$(function() {
    window.addEventListener('message', function(event){
        switch(event.data.action){
            case "ku_admin_show_menu":
                $.post('http://ku_admin/get_players');
                break;
            case "ku_admin_close_menu":
                $(".dd_actions_player").removeClass("animated rollIn rollOut")
                break;
            case "ku_admin_set_players":
                build_players_datatable($(event.data.players));
                break;
        }
    })

    function build_players_datatable(players) {
        //alert(window);
        //alert(GetPlayerPed);
        //alert(window.LoadResourceFile('ku_admin', 'ui/index.html'));

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

        $('.nav-tabs .nav-item .nav-link[href="#players"]').click(function(){
            $.post('http://ku_admin/get_players');
        });
    }
});