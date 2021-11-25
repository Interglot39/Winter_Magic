RegisterCommand("magic2", function()
	TriggerEvent("winter_magic:magicTeleport")
end, false)

RegisterNetEvent("winter_magic:magicTeleport")
AddEventHandler("winter_magic:magicTeleport", function()
	local pId = PlayerPedId()  
	local pIdCoords = GetEntityCoords(pId)
	local distance = nil
	local coordsEscena = nil 
	local size = nil
	local learning = true
	while learning do 
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
			coordsEscena = pEscena
		elseif IsControlJustReleased(0, 73) or IsControlJustReleased(0, 177) then
			learning = false
		end
	end
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
				progressBar(tiempo, "Casting spell")
				local dict = "rcmbarry"
				TaskTurnPedToFaceCoord(pId, coordsEscena.x, coordsEscena.y, coordsEscena.z, 1000)
				Citizen.SetTimeout(900, function()
					RequestAnimDict2(dict, function()
						TaskPlayAnim(pId, dict, "bar_1_attack_idle_aln", 1.0, 1.0, -1, 7, 0.0, false, false, false)
						Citizen.SetTimeout(1400, function()
							local boneCoords = nil
							boneCoords = GetPedBoneCoords(pId, 11816, -0.9, 1.0, 0.0) -- Pain in the ass
							TriggerServerEvent("winter_magic:particleS", boneCoords)
						end)
					end)
					Citizen.SetTimeout(tiempo - 600, function() doing = false end)
				end)
			end
		end
		SetEntityCoords(pId, coordsEscena.x, coordsEscena.y, coordsEscena.z, 0.0, 0.0, 0.0, false)
	end
end)

RegisterNetEvent("winter_magic:particleC")
AddEventHandler("winter_magic:particleC", function(boneCoords)
	local pIdCoords = GetEntityCoords(PlayerPedId())
	local distance = #(boneCoords - pIdCoords)
		if distance <= 30 then
			SendNUIMessage({sound = "thunder", volume = 0.2})
		end
		if distance <= 300 then
			Citizen.SetTimeout(500, function()
				UseParticleFxAssetNextCall("core")
				StartParticleFxLoopedAtCoord("exp_xs_ray", boneCoords.x, boneCoords.y, boneCoords.z, 0.0, 0.0, 0.0, 0.8, false, false, false)
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

function getCoordsScene()
    local Cam = GetGameplayCamCoord()
    local _, Hit, Coords, _, Entity = GetShapeTestResult(StartExpensiveSynchronousShapeTestLosProbe(Cam, getCoordsFromCam(Config.Distance, Cam), -1, PlayerPedId(), 4))
    return Coords
end

function getCoordsFromCam(distance, coords)
    local rotation = GetGameplayCamRot()
    local adjustedRotation = vector3((math.pi / 180) * rotation.x, (math.pi / 180) * rotation.y, (math.pi / 180) * rotation.z)
    local direction = vector3(-math.sin(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.cos(adjustedRotation[3]) * math.abs(math.cos(adjustedRotation[1])), math.sin(adjustedRotation[1]))
    return vector3(coords[1] + direction[1] * distance, coords[2] + direction[2] * distance, coords[3] + direction[3] * distance)
end

function progressBar(time, text) 
	if Config.ProgressBar then
		exports['pogressBar']:drawBar(time, text)
	end
end