

RegisterNetEvent("winter_magic:levitate")
AddEventHandler("winter_magic:levitate", function()
	local dict = "rcmcollect_paperleadinout@"
	local pId = PlayerPedId()
	local pIdCoords = GetEntityCoords(pId)
	RequestAnimDict2(dict, function()
		local newZ = 0		
		newZ = pIdCoords.z - 0.68
		for i = 1, Config.LevitateHeight/0.01, 1 do
			newZ = newZ + 0.01 
			SetEntityCoords(pId, pIdCoords.x, pIdCoords.y, newZ, 0.0, 0.0, 0.0, false)
			Citizen.Wait(25)
		end
		TaskPlayAnim(pId, dict, "meditiate_idle", 1.0, 1.0, -1, 37, 0.0, false, false, false)	
		FreezeEntityPosition(pId, true)
	end)
	Citizen.Wait(50)
	Citizen.SetTimeout(Config.LevitateTime, function()
		pId = PlayerPedId()
		ClearPedTasks(pId)
	end) 
	while IsEntityPlayingAnim(pId, dict, "meditiate_idle", 1) do
		FreezeEntityPosition(pId, true)
		if IsControlJustReleased(0,38) then
			pId = PlayerPedId()
			ClearPedTasks(pId)
		end
		Citizen.Wait(0)
	end
	FreezeEntityPosition(pId, false)
end)

RegisterNetEvent("winter_magic:magicFlamethrower")
AddEventHandler("winter_magic:magicFlamethrower", function()
	local pId = PlayerPedId()
	local animDict = "rcmbarry"
	local animName = "bar_1_attack_idle_aln"
	local cooldown = false
    local uses = 0
	RequestAnimDict2(animDict, function()
		TaskPlayAnim(pId, animDict, animName, 1.0, 1.0, -1, 50, 0.0, false, false, false)
	end)
	Citizen.Wait(50)	
	SetPlayerInvincible(PlayerPedId(), true) 
	while IsEntityPlayingAnim(pId, animDict, animName, 1) and uses < Config.FlameUses do
		if IsControlJustReleased(0,38) and not cooldown then
            print("uses",uses)
            uses = uses + 1
			pId = PlayerPedId()
			cooldown = true
			TriggerServerEvent("winter_magic:particleFlamesS", GetEntityCoords(pId))
            Citizen.Wait(4000)
            cooldown = false
		end	
		Citizen.Wait(0)
	end
    ClearPedTasks(pId)  
end)

RegisterNetEvent("winter_magic:particleFlamesC")
AddEventHandler("winter_magic:particleFlamesC", function(pIdCoords2, pSource)
	local pIdCoords = GetEntityCoords(PlayerPedId())
	local distance = #(pIdCoords2 - pIdCoords)
    if distance <= 30 then
        SendNUIMessage({sound = "flame", volume = 0.2})
    end
    if distance <= 300 then
        UseParticleFxAssetNextCall("core")
        local particles = StartParticleFxLoopedOnEntityBone("ent_sht_flame", GetPlayerPed(GetPlayerFromServerId(pSource)), 0.0, 1.0, 0.3, 180.0, 270.0, 270.0, 11816, Config.FlameThrowerSize, false, false, false)
        Citizen.SetTimeout(4900, function() StopParticleFxLooped(particles, 0) end)
    end
end)

RegisterNetEvent("winter_magic:magicTeleport")
AddEventHandler("winter_magic:magicTeleport", function()
	local pId = PlayerPedId()  
	local pIdCoords = GetEntityCoords(pId)
	local distance = nil
	local coordsEscena = getCoordsBall() 
	local size = nil
	local learning = true
	if coordsEscena ~= vector3(0,0,0) then
		local done = false
		local doing = true
		local tiempo = 3000
		size = 0.5
		while doing do
			Citizen.Wait(0)
			DrawMarker(42, coordsEscena.x, coordsEscena.y, coordsEscena.z + 0.6, 0, 0, 0, 0, 0, 0, size, size, size, 0, 150, 200, 255, true, false, 0, true)
			if not done then
				pId = PlayerPedId()
				done = true 
				exports['pogressBar']:drawBar(tiempo, "Casting spell")
				local dict = "rcmbarry"
				TaskTurnPedToFaceCoord(pId, coordsEscena.x, coordsEscena.y, coordsEscena.z, 1000)
				Citizen.SetTimeout(900, function()
					RequestAnimDict2(dict, function()
						TaskPlayAnim(pId, dict, "bar_1_attack_idle_aln", 1.0, 1.0, -1, 7, 0.0, false, false, false)
						Citizen.SetTimeout(1400, function()
							local boneCoords = nil
							boneCoords = GetPedBoneCoords(pId, 11816, -0.9, 1.0, 0.0) -- Pain in the ass
							TriggerServerEvent("winter_magic:particleS", boneCoords, "core", "exp_xs_ray", 1.0, nil, "thunder")
						end)
					end)
					Citizen.SetTimeout(tiempo - 600, function() doing = false end)
				end)
			end
		end
		SetEntityCoords(pId, coordsEscena.x, coordsEscena.y, coordsEscena.z, 0.0, 0.0, 0.0, false)
	end
end)

RegisterNetEvent("winter_magic:magicTeleportFlame")
AddEventHandler("winter_magic:magicTeleportFlame", function()
	local pId = PlayerPedId()  
	local pIdCoords = GetEntityCoords(pId)
	local distance = nil
	local coordsEscena = getCoordsBall() 
	local size = nil
	local learning = true
	if coordsEscena ~= vector3(0,0,0) then
		local done = false
		local doing = true
		local tiempo = 3000
		size = 0.5
		while doing do
			Citizen.Wait(0)
			DrawMarker(42, coordsEscena.x, coordsEscena.y, coordsEscena.z + 0.6, 0, 0, 0, 0, 0, 0, size, size, size, 0, 150, 200, 255, true, false, 0, true)
			if not done then
				pId = PlayerPedId()
				done = true 
				exports['pogressBar']:drawBar(tiempo, "Casting spell")
				local dict = "rcmbarry"
				TaskTurnPedToFaceCoord(pId, coordsEscena.x, coordsEscena.y, coordsEscena.z, 1000)
				Citizen.SetTimeout(900, function()
					RequestAnimDict2(dict, function()
						TaskPlayAnim(pId, dict, "bar_1_attack_idle_aln", 1.0, 1.0, -1, 7, 0.0, false, false, false)
						Citizen.SetTimeout(1800, function()
              pIdCoords = GetEntityCoords(pId)
              pIdCoords = vector3(pIdCoords.x, pIdCoords.y, pIdCoords.z - 0.5)
							TriggerServerEvent("winter_magic:particleS", pIdCoords, "core","ent_ray_meth_fires", Config.TpFireSize, 4000, "thunder")
						end)
					end)
					Citizen.SetTimeout(tiempo - 600, function() doing = false end)
				end)
			end
		end
		SetEntityCoords(pId, coordsEscena.x, coordsEscena.y, coordsEscena.z, 0.0, 0.0, 0.0, false)
	end
end)

RegisterNetEvent("winter_magic:magicTeleportSmoke")
AddEventHandler("winter_magic:magicTeleportSmoke", function()
	local pId = PlayerPedId()  
	local pIdCoords = GetEntityCoords(pId)
	local distance = nil
	local coordsEscena = getCoordsBall() 
	local size = nil
	local learning = true
	if coordsEscena ~= vector3(0,0,0) then
		local done = false
		local doing = true
		local tiempo = 3000
		size = 0.5
		while doing do
			Citizen.Wait(0)
			DrawMarker(42, coordsEscena.x, coordsEscena.y, coordsEscena.z + 0.6, 0, 0, 0, 0, 0, 0, size, size, size, 0, 150, 200, 255, true, false, 0, true)
			if not done then
				pId = PlayerPedId()
				done = true 
				exports['pogressBar']:drawBar(tiempo, "Casting spell")
				local dict = "rcmbarry"
				TaskTurnPedToFaceCoord(pId, coordsEscena.x, coordsEscena.y, coordsEscena.z, 1000)
				Citizen.SetTimeout(900, function()
					RequestAnimDict2(dict, function()
						TaskPlayAnim(pId, dict, "bar_1_attack_idle_aln", 1.0, 1.0, -1, 7, 0.0, false, false, false)
						Citizen.SetTimeout(1800, function()
              				pIdCoords = GetEntityCoords(pId)
              				pIdCoords = vector3(pIdCoords.x, pIdCoords.y, pIdCoords.z + 0.5)
							TriggerServerEvent("winter_magic:particleS", pIdCoords, "scr_rcbarry2", "scr_clown_death", 2.5, nil, "thunder", 0)
						end)
					end)
					Citizen.SetTimeout(tiempo - 600, function() doing = false end)
				end)
			end
		end
		SetEntityCoords(pId, coordsEscena.x, coordsEscena.y, coordsEscena.z, 0.0, 0.0, 0.0, false)
	end
end)

RegisterNetEvent("winter_magic:reviveOrbC")
AddEventHandler("winter_magic:reviveOrbC", function(coords, timeout)
	local pId = PlayerPedId()
	local pIdCoords = GetEntityCoords(pId)
	local distance = nil
	local close = false
	local time = true
	local waitTime = 2000
	Citizen.SetTimeout(timeout, function() time = false end)
	while time do
		Citizen.Wait(waitTime)
		pIdCoords = GetEntityCoords(PlayerPedId())
		distance = #(coords - pIdCoords)
		if distance <= Config.ReviveDistance then
			waitTime = 4
			Citizen.Wait(Config.ReviveTime)
			-- Check Dead then revive
			if distance <= Config.ReviveDistance then -- Check again when time finishes uf you are alive
				-- Add revive
			end
		else
			waitTime = 2000
		end
	end
end)

RegisterNetEvent("winter_magic:healOrbC")
AddEventHandler("winter_magic:healOrbC", function(coords, timeout)
	local pId = PlayerPedId()
	local pIdCoords = GetEntityCoords(pId)
	local distance = nil
	local close = false
	local time = true
	local waitTime = 2000
	Citizen.SetTimeout(timeout, function() time = false end)
	while time do
		pId = PlayerPedId()
		Citizen.Wait(waitTime)
		pIdCoords = GetEntityCoords()
		distance = #(coords - pIdCoords)
		if distance <= Config.ReviveDistance then
			waitTime = 4
			Citizen.Wait(Config.HealTimeInterval)
			if distance <= Config.ReviveDistance then -- Check again when time finishes uf you are alive
				if GetEntityHealth(pId) ~= GetEntityMaxHealth(pId) then
					SetEntityHealth(pId, GetEntityHealth(pId) + Config.HPHeal)
				end
			end
		else
			waitTime = 2000
		end
	end
end)

RegisterNetEvent("winter_magic:particleC")
AddEventHandler("winter_magic:particleC", function(boneCoords, partDict, particles, size, duration, sound, timeout)
	local pIdCoords = GetEntityCoords(PlayerPedId())
	local distance = #(boneCoords - pIdCoords)
    local particlesID = nil
	local attempt = 0
    if distance <= 30 then
        SendNUIMessage({sound = sound, volume = 0.2})
    end
	if not timeout then
		timeout = 500
	end
    if distance <= 300 then
		RequestNamedPtfxAsset(partDict)
		while not HasNamedPtfxAssetLoaded(partDict) and attempt <= 250 do
            Citizen.Wait(1)
			attempt = attempt + 1
        end
        Citizen.SetTimeout(timeout, function()
            UseParticleFxAssetNextCall(partDict)
            particlesID = StartParticleFxLoopedAtCoord(particles, boneCoords.x, boneCoords.y, boneCoords.z, 0.0, 0.0, 0.0, size, false, false, false)
		end)
    end
    if duration then
        Citizen.SetTimeout(duration, function()
            StopParticleFxLooped(particlesID, 0)
        end)
    end
end)

function RequestAnimDict2(animDict, cb) -- Not neccesary, i know but LMAO
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

function getCoordsBall()
    local learning = true
    local size = 0.5
    local pId = PlayerPedId()
    local pIdCoords = GetEntityCoords(pId)
	while learning do 
        pId = PlayerPedId()
        pIdCoords = GetEntityCoords(pId)
		Citizen.Wait(5)
		local pEscena = getCoordsScene()
		if pEscena ~= nil then 
			distance = #(pEscena - pIdCoords)
			if distance < 30 then
				size = 0.1
			elseif distance > 30 and distance  < 90 then
				size = 0.2
			else
				size = 0.4
			end
			DrawMarker(28, pEscena.x, pEscena.y, pEscena.z, 0, 0, 0, 0, 0, 0, size, size, size, 35, 150, 200, 255, false, false)
		end
		if IsControlJustReleased(0, 191) then 
			learning = false
			return pEscena
		elseif IsControlJustReleased(0, 73) or IsControlJustReleased(0, 177) then
			learning = false
		end
	end
end

function getCoordsScene()
    local Cam = GetGameplayCamCoord()
    local _, Hit, Coords, _, Entity = GetShapeTestResult(StartExpensiveSynchronousShapeTestLosProbe(Cam, getCoordsFromCam(Config.TeleportDistance, Cam), -1, PlayerPedId(), 4))
    return Coords
end

function getCoordsFromCam(distance, coords)
    local rotation = GetGameplayCamRot()
    local adjustedRotation = vector3((math.pi / 180) * rotation.x, (math.pi / 180) * rotation.y, (math.pi / 180) * rotation.z)
    local direction = vector3(-math.sin(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.cos(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.sin(adjustedRotation[1]))
    return vector3(coords[1] + direction[1] * distance, coords[2] + direction[2] * distance, coords[3] + direction[3] * distance)
end

RegisterCommand("magic2", function()
	TriggerEvent("winter_magic:magicTeleport")
end, false)

RegisterCommand("magic3", function()
	TriggerEvent("winter_magic:magicTeleportFlame")
end, false)

RegisterCommand("magic4", function()
	TriggerEvent("winter_magic:magicTeleportSmoke")
end, false)

RegisterCommand("fire", function()
	TriggerEvent("winter_magic:magicFlamethrower")
end, false)

RegisterCommand("meditate", function()
	TriggerEvent("winter_magic:levitate")
end, false)

RegisterCommand("reviveorb", function()
	TriggerEvent("winter_magic:reviveOrbC")
end, false)

RegisterCommand("healorb", function()
	TriggerEvent("winter_magic:healOrbC")
end, false)
end
