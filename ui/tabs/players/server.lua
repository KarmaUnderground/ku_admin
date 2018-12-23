ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('ku_admin:registerUIAdminTabs', GetCurrentResourceName(), {
    players = {
        label = _U('players'),
        root = 'ui/tabs/players',
        main_file = 'index.html',
        files = {
            'index.html',
            'index.js',
            'index.css',
            'components/player_edit_modal.html',
            'components/player_edit_modal.js',
            'components/player_edit_modal.css',
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
            --skin = result[i]['skin'],
            job = result[i]['job'],
            job_grade = result[i]['job_grade'],
            --loadout = result[i]['loadout'],
            position = result[i]['position'],
            bank = result[i]['bank'],
            permission_level = result[i]['permission_level'],
            group = result[i]['group'],
            --phone_number = result[i]['phone_number'],
            --firstname = result[i]['firstname'],
            --lastname = result[i]['lastname'],
            --dateofbirth = result[i]['dateofbirth'],
            --sex = result[i]['sex'],
            --height = result[i]['height'],
            --id = result[i]['id']
        })
    end

    cb(users)
end)