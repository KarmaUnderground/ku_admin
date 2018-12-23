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