ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNUICallback('getPlayers', function()
    ESX.TriggerServerCallback("ku_admin:getPlayers", function(data)
        SendNUIMessage({
            action = "ku_admin_set_players",
            players = data
        })
    end)
end)

RegisterNUICallback('getPlayerData', function(data)
    ESX.TriggerServerCallback("ku_admin:getPlayerData", function(data)
        SendNUIMessage({
            action = "ku_admin_set_player_edit_modal",
            information = data
        })
    end, data.identifier)
end)

RegisterNUICallback('savePlayerData', function(data)
    ESX.TriggerServerCallback("ku_admin:savePlayerData", function(data)
        SendNUIMessage({
            action = "ku_admin_saved_player_edit_modal",
            information = data
        })
    end, data.changes)
end)