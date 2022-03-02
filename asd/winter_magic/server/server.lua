RegisterNetEvent("winter_magic:particleS")
AddEventHandler("winter_magic:particleS", function(boneCoords, partDict, particles, size, duration, sound, timeout)
    TriggerClientEvent("winter_magic:particleC", -1, boneCoords, partDict, particles, size, duration, sound, timeout)
end)

RegisterNetEvent("winter_magic:particleFlamesS")
AddEventHandler("winter_magic:particleFlamesS", function(pIdCoords2)
    local pSource = source
    TriggerClientEvent("winter_magic:particleFlamesC", -1, pIdCoords2, pSource)
end)

RegisterNetEvent("winter_magic:reviveOrbS")
AddEventHandler("winter_magic:reviveOrbS", function(pIdCoords2, timeout)
    local pSource = source
    TriggerClientEvent("winter_magic:reviveOrbC", -1, pIdCoords2, timeout)
end)

RegisterNetEvent("winter_magic:healOrbC")
AddEventHandler("winter_magic:healOrbC", function(pIdCoords2, timeout)
    local pSource = source
    TriggerClientEvent("winter_magic:healOrbC", -1, pIdCoords2, timeout)
end)

Citizen.CreateThread(function()
    if Config.ESX then
        ESX = nil
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

        while not ESX do Citizen.Wait(500) end

        ESX.RegisterUsableItem('tpOrb', function(source)
            local pSource = source
            local xPlayer = ESX.GetPlayerFromId(pSource)
            TriggerClientEvent("winter_magic:magicTeleport", pSource)
            xPlayer.removeInventoryItem(item, 1)
        end)

        ESX.RegisterUsableItem('tpOrb2', function(source)
            local pSource = source
            local xPlayer = ESX.GetPlayerFromId(pSource)
            TriggerClientEvent("winter_magic:magicTeleportFlame", pSource)
            xPlayer.removeInventoryItem(item, 1)
        end)

        ESX.RegisterUsableItem('tpOrb3', function(source)
            local pSource = source
            local xPlayer = ESX.GetPlayerFromId(pSource)
            TriggerClientEvent("winter_magic:magicTeleportSmoke", pSource)
            xPlayer.removeInventoryItem(item, 1)
        end)

        ESX.RegisterUsableItem('fireball', function(source)
            local pSource = source
            local xPlayer = ESX.GetPlayerFromId(pSource)
            TriggerClientEvent("winter_magic:magicFlamethrower", pSource)
            xPlayer.removeInventoryItem(item, 1)
        end)

        ESX.RegisterUsableItem('levitateOrb', function(source)
            local pSource = source
            local xPlayer = ESX.GetPlayerFromId(pSource)
            TriggerClientEvent("winter_magic:levitate", pSource)
            xPlayer.removeInventoryItem(item, 1)
        end)

        ESX.RegisterUsableItem('healOrb', function(source)
            local pSource = source
            local xPlayer = ESX.GetPlayerFromId(pSource)
            TriggerClientEvent("winter_magic:healOrbC", pSource)
            xPlayer.removeInventoryItem(item, 1)
        end)

        ESX.RegisterUsableItem('reviveOrb', function(source)
            local pSource = source
            local xPlayer = ESX.GetPlayerFromId(pSource)
            TriggerClientEvent("winter_magic:reviveOrbC", pSource)
            xPlayer.removeInventoryItem(item, 1)
        end)
    end
end)