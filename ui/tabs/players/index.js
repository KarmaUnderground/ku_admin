let action_player_selected = null;
let changes = {};

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
            case "ku_admin_set_player_edit_modal":
                render_edit_player_modal(event.data.information);
                break;
            case "ku_admin_saved_player_edit_modal":
                window.dispatchEvent(new MessageEvent('message', {data: {action: "ku_admin_players_refresh_panel"}}));
                break;
        }
    })
});

function build_players_datatable(data) {
    let tpl = _.template($('#ku_admin_players_table_tpl').html());
    let result = tpl(data);

    window.clean($('#ku_admin_players_table'));

    $('#ku_admin_players_table').html("");
    $('#ku_admin_players_table').html(result);

    $(".details_player").off();
    $(".details_player").on('click', function(){
        action_player_selected = $(this).attr("player_id");

        show_edit_player_modal(action_player_selected);
        /*
        $(".dd_actions_player").show();
        $(this).parent().append($(".dd_actions_player"));
        $(".dd_actions_player").addClass("animated rollIn").one("webkitAnimationEnd mozAnimationEnd oAnimationEnd animationend", function(){
            $(this).removeClass("animated rollIn");
        });
        */
    });

    /*
    $(".dd_actions_player li").off();
    $(".dd_actions_player li").on('click', function(){
        action_player_selected = null;

        $(".dd_actions_player").addClass("animated fadeOut").one("webkitAnimationEnd mozAnimationEnd oAnimationEnd animationend", function(){
            $(this).removeClass("animated fadeOut").hide();
            $("body").append($(this));
        });
    });

    $(".dd_actions_player li a.action_details").off();
    $(".dd_actions_player li a.action_details").on('click', function(){
        show_edit_player_modal(action_player_selected);
    });

    $(".dd_actions_player li a.action_teleport_to").off();
    $(".dd_actions_player li a.action_teleport_to").on('click', function(){
        alert("action_teleport_to")
    });

    $(".dd_actions_player li a.action_promote_admin").off();
    $(".dd_actions_player li a.action_promote_admin").on('click', function(){
        alert("action_promote_admin")
    });

    $(".dd_actions_player li a.action_ban").off();
    $(".dd_actions_player li a.action_ban").on('click', function(){
        alert("action_ban")
    });
    */
}

function show_edit_player_modal(player) {
    $.post('http://ku_admin/getPlayerData', JSON.stringify({
        identifier: player
    }));
}

function render_edit_player_modal(data) {
    let tpl, result;

    // Because the template contains templates, render once to get the templates and then ...
    tpl = _.template($('#player_edit_modal_tpl').html());
    result = tpl(data);

    // ... Render again with the result that contains the templates... Clear? Maybe not! :)
    tpl = _.template(result);
    result = tpl(data);

    window.clean($('#ku_admin_players_table .player_edit_modal'));
    $('#ku_admin_players_table .player_edit_modal').html(result);

    open_edit_player_modal(data);
}

function open_edit_player_modal(data){
    $('#ku_admin_players_table table').addClass("animated fadeOut").one("webkitAnimationEnd mozAnimationEnd oAnimationEnd animationend", function(){
        $(this).removeClass("animated fadeOut").hide();
    });

    $('#ku_admin_players_table .player_edit_modal').addClass("animated fadeIn").one("webkitAnimationEnd mozAnimationEnd oAnimationEnd animationend", function(){
        $(this).removeClass("animated fadeIn");
    }).show();

    $('#ku_admin_players_table .player_edit_modal .quit').click(close_edit_player_modal);
    $('#ku_admin_players_table .player_edit_modal .dropdown-item').click(dropdown_item_selected);
    $('#ku_admin_players_table .player_edit_modal input').change(input_change);
    $('#ku_admin_players_table .player_edit_modal button.trash').click(delete_item);

    $('#player_edit_modal_save').click(function() { save_player_item(data) });

    let header_height = $('#ku_admin_players_table .player_edit_modal .header').outerHeight(true);
    let footer_height = $('#ku_admin_players_table .player_edit_modal .footer').outerHeight(true);

    $('#ku_admin_players_table .player_edit_modal .panel').css('height', ($('#ku_admin_players_table .player_edit_modal').height() - header_height - footer_height - 6) + 'px');
}

function close_edit_player_modal(){
    $('#ku_admin_players_table .player_edit_modal').addClass("animated fadeOut").one("webkitAnimationEnd mozAnimationEnd oAnimationEnd animationend", function(){
        $(this).removeClass("animated fadeOut").hide();
    });

    $('#ku_admin_players_table table').addClass("animated fadeIn").one("webkitAnimationEnd mozAnimationEnd oAnimationEnd animationend", function(){
        $(this).removeClass("animated fadeIn");
    }).show();
}

function refresh_job_grades(job) {
    let job_grades_dropdown = $('.dropdown-menu[db_element="job_grades"]');
    let has_grade = false;

    $('#ku_admin_players_table .player_edit_modal .dropdown-menu[db_element="job_grades"]').find('a').each(function() {
        if($(this).attr('job') == job) {
            if(!has_grade) {
                $('#' + job_grades_dropdown.attr('input')).attr('value', $(this).attr('value'));
                $('#' + job_grades_dropdown.attr('input')).change();
                has_grade = true;
            }
            $(this).show();
        }
        else {
            $(this).hide();
        }
    });
}

function dropdown_item_selected() {
    let dropdown = $(this).parent();
    let value = $(this).attr('value');
    let input = $('#' + dropdown.attr('input'));

    switch(dropdown.attr('db_element')) {
        case 'jobs':
            refresh_job_grades(value);
            break;
    }

    input.attr('value', value);
    input.change();
}

function delete_item(el) {
    input_change(el);
    $(el.currentTarget).closest('.col-xs-2').remove();
}

function input_change(el) {
    let self = $(el.currentTarget);
    let value = self.val();

    if (self.attr('max') != undefined && parseInt(self.val()) > parseInt(self.attr('max'))) {
        self.val(parseInt(self.attr('max')));
    }
    
    if (self.attr('min') && parseInt(self.val()) < parseInt(self.attr('min'))) {
        self.val(parseInt(self.attr('min')));
    }

    if(self.attr("db_table") == "users" && self.attr("db_field") == "loadout") {
        let selected = JSON.parse(decodeURI(self.attr('item')));
        let items = [];

        self.closest('.block').find('input').each(function(){
            item = JSON.parse(decodeURI($(this).attr('item')));

            if(selected.name == item.name) {
               item.ammo = value; 
            }

            items.push(item);
        });

        value = JSON.stringify(items).replace(new RegExp("'", 'g'), "''");
    }

    changes[self.attr("id")] = {
        db_action: self.attr("db_action"),
        db_table: self.attr("db_table"),
        db_field: self.attr("db_field"),
        db_where: self.attr("db_where") ? self.attr("db_where") : "1 = 1" ,
        value: value
    }

    $('#ku_admin_players_table .player_edit_modal #player_edit_modal_save').prop('disabled', false);
}

function save_player_item() {
    $.post('http://ku_admin/savePlayerData', JSON.stringify({
        changes: changes
    }));

    changes = {};
}