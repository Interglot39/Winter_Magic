RegisterNetEvent("winter_magic:particleS")
AddEventHandler("winter_magic:particleS", function(boneCoords)
    TriggerClientEvent("winter_magic:particleC", -1, boneCoords)
end)