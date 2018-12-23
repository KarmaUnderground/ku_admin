ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNUICallback('get_players', function()
    ESX.TriggerServerCallback("ku_admin:getPlayers", function(players)
        SendNUIMessage({
            action = "ku_admin_set_players",
            players = players
        })
    end)
end)