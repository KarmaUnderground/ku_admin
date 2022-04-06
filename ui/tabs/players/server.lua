ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function get_started_resources()
    local resources = {
        -- Karma Underground
        'ku_skills',
        'ku_markers',
        'ku_careers',

        -- Essentials
        'es_extended',
        'esx_identity',
        'esx_phone',
        'esx_jobs',
        'esx_addonaccount',
    }

    for index, resource in ipairs(resources) do
        if not (GetResourceState(resource) == 'started') then
            table.remove(resources, index)
        end
    end

    return resources
end

TriggerEvent('ku_admin:registerUIAdminTabs', GetCurrentResourceName(), {
    players = {
        label = _U('players'),
        root = 'ui/tabs/players',
        main_file = 'index.html',
        files = {
            'index.html',
            'index.js',
            'index.css',
            'components/player_edit_modal/index.html',
            'components/player_edit_modal/index.css',

            'components/player_edit_modal/blocks/esx/player.html',
            'components/player_edit_modal/blocks/esx/character.html',
            'components/player_edit_modal/blocks/esx/work.html',
            'components/player_edit_modal/blocks/esx/position.html',
            'components/player_edit_modal/blocks/esx/money.html',
            'components/player_edit_modal/blocks/esx/inventory.html',
            'components/player_edit_modal/blocks/esx/loadout.html',
            'components/player_edit_modal/blocks/esx/apparence.html',

            'components/player_edit_modal/blocks/ku/skills.html'
        }
    }
})

ESX.RegisterServerCallback('ku_admin:getPlayers', function(source, cb)
    local users = {}
    local result = MySQL.Sync.fetchAll('select * from `users`;')

    for i=1, #result, 1 do
        table.insert(users, {
            identifier = result[i]['identifier'],
            license = result[i]['license'],
            money = result[i]['money'],
            name = result[i]['name'],
            job = result[i]['job'],
            job_grade = result[i]['job_grade'],
            position = result[i]['position'],
            bank = result[i]['bank'],
            permission_level = result[i]['permission_level'],
            group = result[i]['group'],
        })
    end

    cb({players = users})
end)

ESX.RegisterServerCallback('ku_admin:savePlayerData', function(source, cb, changes)
    local q = ""
    for key, change in pairs(changes) do
        if change.db_action == "update" then
            q = ("UPDATE `%s` SET `%s` = '%s' WHERE %s"):format(change.db_table, change.db_field, change.value, change.db_where)
        elseif change.db_action == "delete" then
            q = ("DELETE FROM `%s` WHERE %s"):format(change.db_table, change.db_where)
        end
        print(q)
        MySQL.Sync.execute(q)
    end

    cb({})
end)

function in_array(items, item)
    for key, value in pairs(items) do
        if value == item then return true end
    end
    return false
end

function format_groups(groups)
    local response = {}
    for k,v in pairs(groups) do
        table.insert(response, k)
    end

    return response
end

ESX.RegisterServerCallback('ku_admin:getPlayerData', function(source, cb, identifier)
    local data = {}
    data.assets = {}
    data.resources = get_started_resources()

    if in_array(data.resources, 'es_extended') then
        Citizen.CreateThread(function() data.assets.jobs = MySQL.Sync.fetchAll('SELECT * FROM `jobs`') end)
        Citizen.CreateThread(function() data.assets.job_grades = MySQL.Sync.fetchAll('SELECT * FROM `job_grades`') end)

        Citizen.CreateThread(function() data.assets.items = MySQL.Sync.fetchAll('SELECT * FROM `items`') end)

        Citizen.CreateThread(function() TriggerEvent('es:getAllGroups', function(groups) data.assets.groups = format_groups(groups) end) end)

        data.player = {}

        Citizen.CreateThread(function() data.player.information = MySQL.Sync.fetchAll('SELECT * FROM `users` WHERE `identifier` = @Identifier', {['@Identifier'] = identifier})[1] end)
        Citizen.CreateThread(function() data.player.skills = MySQL.Sync.fetchAll('SELECT s.name, us.tries, s.skill_rate FROM `user_skills` AS us INNER JOIN `skills` AS s ON s.`name` = us.`name` WHERE `identifier` = @Identifier', {['@Identifier'] = identifier}) end)
        Citizen.CreateThread(function() data.player.inventory = MySQL.Sync.fetchAll('SELECT `item`, `count`, `limit` FROM `user_inventory` ui INNER JOIN `items` i ON ui.`item` = i.`name` WHERE ui.`count` > 0 AND ui.`identifier` = @Identifier', {['@Identifier'] = identifier}) end)

        local accounts_query = "" ..
            "SELECT 'cash' as `label`, " ..
            "       'users' as `db_table`, " ..
            "       'money' as `db_field`, " ..
            "       'identifier' as `p_key`, " ..
            "       `money` as `amount` " ..
            "FROM `users` " ..
            "WHERE `identifier` = @Identifier " ..
            "UNION " ..
            "SELECT 'bank' as `label`, " ..
            "       'users' as `db_table`, " ..
            "       'bank' as `db_field`, " ..
            "       'identifier' as `p_key`, " ..
            "       `bank` as `amount` " ..
            "FROM `users` " ..
            "WHERE `identifier` = @Identifier " ..
            "UNION " ..
            "SELECT `name` as `label`, " ..
            "       'user_accounts' as `db_table`, " ..
            "       'money' as `db_field`, " ..
            "       'identifier' as `p_key`, " ..
            "       `money` as `amount` " ..
            "FROM `user_accounts` " ..
            "WHERE `identifier` = @Identifier "

        if in_array(data.resources, 'esx_addonaccount') then
            accounts_query = accounts_query ..
            "UNION " ..
            "SELECT `account_name` as `label`, " ..
            "       'addon_account_data' as `db_table`, " ..
            "       'money' as `db_field`, " ..
            "       'owner' as `p_key`, " ..
            "       `money` as `amount` " ..
            "FROM `addon_account_data` " ..
            "WHERE `owner` = @Identifier"
        end
        Citizen.CreateThread(function() data.player.accounts = MySQL.Sync.fetchAll(accounts_query, {['@Identifier'] = identifier}) end)
    end

    Citizen.CreateThread(function()
        while data.assets.jobs == nil or
              data.assets.job_grades == nil or
              data.assets.items == nil or
              data.assets.groups == nil or
              data.player.information == nil or
              data.player.accounts == nil or
              data.player.inventory == nil or
              data.player.skills == nil
        do Wait(0) end

        data.player.information.position = json.decode(data.player.information.position)
        data.player.information.loadout = json.decode(data.player.information.loadout)
        
        cb(data)
    end)
end)