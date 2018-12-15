ESX = nil

local Keys = { ["J"] = 169, ["LEFTSHIFT"] = 21, ["LEFTCTRL"] = 3 }
local xPlayer = nil
local menu_is_open = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    SetNuiFocus(false)
    xPlayer = ESX.GetPlayerData()
end)

-- **********************************
-- Menu control
-- **********************************
Citizen.CreateThread(function()
    while true do
        if IsControlJustReleased(0, 311) then -- Press K
            menu_is_open = true

            ESX.SetTimeout(250, function()
                SetNuiFocus(true, true)
            end)
        
            SendNUIMessage({
                action = "ku_admin_show_menu"
            })
        end

        if menu_is_open then
			DisableControlAction(0, 1,    true) -- LookLeftRight
			DisableControlAction(0, 2,    true) -- LookUpDown
			DisableControlAction(0, 25,   true) -- Input Aim
			DisableControlAction(0, 106,  true) -- Vehicle Mouse Control Override

			DisableControlAction(0, 24,   true) -- Input Attack
			DisableControlAction(0, 140,  true) -- Melee Attack Alternate
			DisableControlAction(0, 141,  true) -- Melee Attack Alternate
			DisableControlAction(0, 142,  true) -- Melee Attack Alternate
			DisableControlAction(0, 257,  true) -- Input Attack 2
			DisableControlAction(0, 263,  true) -- Input Melee Attack
			DisableControlAction(0, 264,  true) -- Input Melee Attack 2

			DisableControlAction(0, 12,   true) -- Weapon Wheel Up Down
			DisableControlAction(0, 14,   true) -- Weapon Wheel Next
			DisableControlAction(0, 15,   true) -- Weapon Wheel Prev
			DisableControlAction(0, 16,   true) -- Select Next Weapon
			DisableControlAction(0, 17,   true) -- Select Prev Weapon
        end
        Citizen.Wait(10)
    end
end)

RegisterNUICallback('menu_closed', function(data)
    menu_is_open = false
    SetNuiFocus(false)
end)

RegisterNUICallback('get_players', function()
    ESX.TriggerServerCallback("ku_admin:getPlayers", function(players)
        SendNUIMessage({
            action = "ku_admin_set_players",
            players = players
        })
    end)
end)
