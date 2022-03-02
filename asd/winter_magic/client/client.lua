

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

local megatable = {
	
	  {
		DictionaryName = "core_snow",
		EffectNames = {
		  "wheel_fric_snow",
		  "cs_mich1_spade_dirt_throw",
		  "scrape_snow",
		  "lens_snow",
		  "bul_snow",
		  "bang_snow",
		  "wheel_fric_snow_Bike",
		  "wheel_fric_snow_loose",
		  "cs_mich1_spade_dirt_impact",
		  "cs_mich1_spade_dirt_trail",
		  "wheel_spin_snow",
		  "veh_roof_snow",
		  "ped_wade_snow",
		  "ped_foot_snow",
		  "wheel_fric_snow_LOD"
		},
	  },
	  {
		DictionaryName = "cut_agencyheist",
		EffectNames = {
		  "sp_petrolcan_splash_CS",
		  "cs_agency_toaster_smoke",
		  "cs_weap_petrol_can"
		},
	  },
	  {
		DictionaryName = "cut_amb_tv",
		EffectNames = {
		  "cs_amb_tv_peeing",
		  "liquid_splash_pee",
		  "cs_mich1_lighter_flame",
		  "cs_amb_tv_book_burn",
		  "cs_amb_tv_sauna_steam",
		  "cs_mich1_lighter_sparks"
		},
	  },
	  {
		DictionaryName = "cut_armenian1",
		EffectNames = {
		  "cs_arm2_muz_smg",
		  "cs_ped_foot_dusty"
		},
	  },
	  {
		DictionaryName = "cut_armenian2",
		EffectNames = {
		  "eject_minigun",
		  "eject_auto",
		  "muz_assault_rifle",
		  "cs_bike_exhaust",
		  "blood_entry",
		  "eject_pistol",
		  "muz_smg",
		  "muz_pistol",
		  "veh_exhaust_car"
		},
	  },
	  {
		DictionaryName = "cut_bigscore",
		EffectNames = {
		  "cs_dry_ice_point",
		  "cs_dry_ice_freezer_floor",
		  "cs_dry_ice_freezer_door"
		},
	  },
	  {
		DictionaryName = "cut_carsteal1",
		EffectNames = {
		  "cs_wheel_fric_sand_Bike",
		  "veh_exhaust_car"
		},
	  },
	  {
		DictionaryName = "cut_carsteal5",
		EffectNames = {
		  "cs_car2_bang_blood",
		  "veh_exhaust_car"
		},
	  },
	  {
		DictionaryName = "cut_chinese1",
		EffectNames = {
		  "cs_ch1_bourbon_pour",
		  "cs_dry_ice_point",
		  "cs_ch1_veh_exhaust_car",
		  "cs_head_kick_blood",
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_dry_ice_freezer_floor",
		  "cs_dry_ice_freezer_door",
		  "cs_cig_exhale_nose",
		  "cs_ch1_head_bang_blood"
		},
	  },
	  {
		DictionaryName = "cut_exile1",
		EffectNames = {
		  "ent_amb_sparking_wires_sm_sp",
		  "cs_ex1_plane_spark_L",
		  "cs_ex1_plane_spark_R",
		  "ent_amb_peeing",
		  "liquid_splash_pee",
		  "bul_carmetal",
		  "bullet_shotgun_tracer",
		  "cs_ex1_plane_debris_trail",
		  "cs_ex1_wing_smoulder",
		  "eject_shotgun",
		  "cs_ex1_plane_break_L",
		  "muz_shotgun",
		  "cs_ex1_plane_impacts",
		  "cs_ex1_sparking_wires_sm",
		  "cs_ex1_plane_break_R",
		  "cs_ex1_elec_malfunction",
		  "muz_pistol",
		  "cs_ex1_cargo_fire"
		},
	  },
	  {
		DictionaryName = "cut_exile2",
		EffectNames = {
		  "cs_exile2_gas_liquid_pour",
		  "wheel_fric_sand",
		  "cs_fridge_door_cold_mist",
		  "cs_ex2_jeep_crash",
		  "sp_petrolcan_splash_CS",
		  "cs_exile2_iron_steam",
		  "scr_ex2_jeep_engine_fire",
		  "cs_weap_petrol_can"
		},
	  },
	  {
		DictionaryName = "cut_exile3",
		EffectNames = {
		  "cs_ex3_wheel_spin",
		  "cs_ex1_water_body",
		  "cs_ex1_water_box",
		  "cs_ex3_sand_dust",
		  "cs_ex1_water_arms",
		  "cs_ex3_water_drips"
		},
	  },
	  {
		DictionaryName = "cut_extreme",
		EffectNames = {
		  "cs_extr_bang_dirt",
		  "cs_ped_foot_dusty"
		},
	  },
	  {
		DictionaryName = "cut_family1",
		EffectNames = {
		  "cs_cig_smoke_stub_out",
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_fam6_hair_snip",
		  "cs_mich1_lighter_flame",
		  "cs_cig_exhale_nose",
		  "cs_fam1_bourbon_pour",
		  "cs_mich1_lighter_sparks",
		  "veh_exhaust_car"
		},
	  },
	  {
		DictionaryName = "cut_family2",
		EffectNames = {
		  "cs_cig_smoke_stub_out",
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke_inhale",
		  "cs_cig_smoke",
		  "cs_fam2_radio_splash",
		  "cs_fam2_foot_sand",
		  "cs_fam2_ped_splash",
		  "ped_water_drips",
		  "cs_cig_exhale_nose",
		  "cs_fam2_ped_water_splash",
		  "cs_water_splash_jetski"
		},
	  },
	  {
		DictionaryName = "cut_family3",
		EffectNames = {
		  "cs_fam3_drool_drip",
		  "cs_cig_smoke",
		  "cs_fam3_brk_pot_plant",
		  "cs_fam3_cig_exhale_mouth",
		  "cs_mich1_lighter_flame",
		  "cs_cig_exhale_nose",
		  "cs_mich1_lighter_sparks"
		},
	  },
	  {
		DictionaryName = "cut_family4",
		EffectNames = {
		  "cs_fam4_fridge_door",
		  "cs_fam4_juice_pour",
		  "cs_fam4_water_pour",
		  "cs_fam4_juice_spit",
		  "cs_fam4_juice_splash",
		  "cs_fam4_shot_chandelier",
		  "cs_fam4_whiskey_splash",
		  "wheel_decal_water_deep",
		  "cs_fam4_liquid_broccoli",
		  "cs_fam4_juice_shot",
		  "cs_fam4_whiskey_pour",
		  "water_splash_veh_wade",
		  "muz_pistol"
		},
	  },
	  {
		DictionaryName = "cut_family5",
		EffectNames = {
		  "cs_fam5_water_splash_ped_out",
		  "cs_fam5_water_splash_ped",
		  "cs_alien_light_bed",
		  "cs_fam5_bourbon_pour",
		  "cs_alien_hand_light",
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_fam5_water_splash_ped_in",
		  "ped_breath_water",
		  "cs_fam4_whiskey_splash",
		  "cs_mich1_lighter_flame",
		  "cs_cig_exhale_nose",
		  "cs_fam5_ped_water_drips",
		  "cs_fam5_water_splash_ped_wade",
		  "ped_underwater_trails",
		  "cs_fam5_michael_pool_splash",
		  "cs_mich1_lighter_sparks"
		},
	  },
	  {
		DictionaryName = "cut_fbi2",
		EffectNames = {
		  "cs_fib2_blood_hand",
		  "veh_downwash",
		  "ped_foot_dirt_dry"
		},
	  },
	  {
		DictionaryName = "cut_fbi3",
		EffectNames = {
		  "cs_wheel_fric_sand_Bike",
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_mich1_lighter_flame",
		  "cs_cig_exhale_nose",
		  "cs_mich1_lighter_sparks",
		  "cs_fib3_syringe"
		},
	  },
	  {
		DictionaryName = "cut_fbi4",
		EffectNames = {
		  "cs_water_stone_throw"
		},
	  },
	  {
		DictionaryName = "cut_fbi5a",
		EffectNames = {
		  "cs_fbi5a_blood_entry",
		  "wheel_fric_sand",
		  "cs_fbi5a_muz_pistol",
		  "ped_talk_water",
		  "cs_trev1_dusty_kick",
		  "ped_water_drips"
		},
	  },
	  {
		DictionaryName = "cut_fbi5b",
		EffectNames = {
		  "ped_foot_dusty",
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_cig_exhale_nose"
		},
	  },
	  {
		DictionaryName = "cut_finale1",
		EffectNames = {
		  "veh_exhaust_hidden",
		  "cs_wheel_fric_sand_Bike",
		  "cs_finale2_dust_cloud",
		  "cs_finale1_car_explosion_surge_spawn",
		  "cs_fin_car_radiator_smoke",
		  "cs_finale1_car_splash_impact",
		  "cs_fin_bul_carmetal",
		  "cs_cig_exhale_mouth",
		  "cs_finale1_car_splash",
		  "cs_fbi5a_muz_pistol",
		  "cs_cig_exhale_mouth_finale",
		  "cs_cig_smoke",
		  "wheel_fric_dirt_dry",
		  "cs_fin_car_impact",
		  "bang_carmetal",
		  "cs_mich1_lighter_flame",
		  "cs_fin_car_cliff_debris",
		  "veh_exhaust_truck",
		  "cs_finale1_car_explosion",
		  "cs_cig_exhale_nose",
		  "cs_finale_car_explosion_splashes_spawn",
		  "exp_grd_rpg_spawn",
		  "cs_fin_bang_carmetal",
		  "cs_finale3_punch_blood",
		  "cs_mich1_lighter_sparks",
		  "cs_water_splash_jetski",
		  "veh_exhaust_car"
		},
	  },
	  {
		DictionaryName = "cut_franklin0",
		EffectNames = {
		  "cs_franklin0_scrape_bike",
		  "wheel_burnout",
		  "wheel_fric_hard_Bike",
		  "cs_franklin0_dog_shake",
		  "cs_franklin0_dog_drool",
		  "veh_exhaust_car"
		},
	  },
	  {
		DictionaryName = "cut_franklin1",
		EffectNames = {
		  "cs_frank1_coke_sniff",
		  "cs_frank1_coke_impact",
		  "cs_franklin1_dry_wall",
		  "cs_frank1_coke_drip",
		  "cs_water_splash_jetski"
		},
	  },
	  {
		DictionaryName = "cut_jewelheist",
		EffectNames = {
		  "cs_jewel_door_smoke",
		  "cs_jh_bourbon_pour",
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_jewel_grenade_burst",
		  "cs_cig_exhale_nose",
		  "scr_jewel_haze"
		},
	  },
	  {
		DictionaryName = "cut_jh_trev",
		EffectNames = {
		  "cs_jh_bourbon_pour",
		  "cs_trev1_crackpipe_smoke",
		  "cs_head_kick_blood",
		  "cs_trev1_beer_bottle",
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_trev1_dusty_kick",
		  "cs_trev1_lighter_sparks",
		  "cs_trev1_trailer_wash",
		  "cs_trev1_lighter_flame",
		  "cs_cig_exhale_nose"
		},
	  },
	  {
		DictionaryName = "cut_josh_4",
		EffectNames = {
		  "scr_josh3_house_smoked"
		},
	  },
	  {
		DictionaryName = "cut_lamar1",
		EffectNames = {
		  "cs_lemar_blood_entry",
		  "blood_entry",
		  "cs_cig_smoke_lamar",
		  "muz_pistol"
		},
	  },
	  {
		DictionaryName = "cut_lester1a",
		EffectNames = {
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_mich1_lighter_flame",
		  "cs_cig_exhale_nose",
		  "cs_lest1_cig_smoke",
		  "cs_mich1_lighter_sparks"
		},
	  },
	  {
		DictionaryName = "cut_lester1b",
		EffectNames = {
		  "scr_blood_head_entry",
		  "cs_lest1_phone_exp",
		  "scr_exp_phone_head",
		  "scr_camera_flash",
		  "scr_blood_head_exit"
		},
	  },
	  {
		DictionaryName = "cut_martin1",
		EffectNames = {
		  "cs_sol1_plane_wreck_smoke",
		  "scr_sol1_plane_wreck",
		  "cs_martin1_wheel_dust"
		},
	  },
	  {
		DictionaryName = "cut_michael1",
		EffectNames = {
		  "cs_mich1_pick_dirt_impact",
		  "cs_cig_smoke_stub_out",
		  "cs_mich1_spade_dirt_throw",
		  "cs_mich1_tool_dirt_impact",
		  "cs_cig_exhale_mouth",
		  "cs_ped_foot_snow",
		  "cs_cig_smoke",
		  "cs_mich1_breath",
		  "cs_mich1_pick_dirt_trail",
		  "bul_carmetal",
		  "veh_exhaust_vulkan",
		  "cs_mich1_spade_dirt_impact",
		  "cs_mich1_spade_dirt_trail",
		  "eject_pistol",
		  "cs_cig_exhale_nose",
		  "muz_pistol"
		},
	  },
	  {
		DictionaryName = "cut_michael2",
		EffectNames = {
		  "eject_auto",
		  "cs_bul_concrete",
		  "muz_assault_rifle",
		  "cs_mich2_blood_nose",
		  "liquid_splash_blood",
		  "cs_ped_foot_snow",
		  "cs_mich_bul_carmetal",
		  "cs_mich2_mud_flower",
		  "cs_chaingun_muz",
		  "eject_pistol",
		  "muz_pistol",
		  "cs_mich2_blood_head_leak"
		},
	  },
	  {
		DictionaryName = "cut_minute2",
		EffectNames = {
		  "eject_auto",
		  "muz_assault_rifle",
		  "cs_mich3_blood_entry",
		  "ped_foot_dusty",
		  "cs_mich3_blood_exit",
		  "cs_rc_minuteman1_spit",
		  "eject_pistol",
		  "cs_mich3_head_shot",
		  "muz_pistol"
		},
	  },
	  {
		DictionaryName = "cut_omega2",
		EffectNames = {
		  "cs_omega2_ambient_smoke",
		  "cs_omega2_ufo"
		},
	  },
	  {
		DictionaryName = "cut_paletoscore",
		EffectNames = {
		  "cs_paleto_vomit",
		  "scr_paleto_banknotes",
		  "cs_cbh_heli_gas_sign",
		  "cs_cbh_heli_roof",
		  "wheel_fric_sand",
		  "cs_cig_exhale_mouth",
		  "cs_paleto_blowtorch",
		  "ent_amb_peeing",
		  "cs_cig_smoke",
		  "liquid_splash_pee",
		  "bul_carmetal",
		  "bullet_shotgun_tracer",
		  "cs_paleto_bowl_steam",
		  "cs_paleto_torch",
		  "muz_minigun_alt",
		  "eject_shotgun",
		  "muz_shotgun",
		  "cs_cig_exhale_nose",
		  "liquid_splash_water",
		  "cs_paleto_gate_kick",
		  "cs_cbh_heli_smoke",
		  "muz_minigun",
		  "veh_exhaust_car"
		},
	  },
	  {
		DictionaryName = "cut_portoflsheist",
		EffectNames = {
		  "cs_pls_sub_water_drips",
		  "cs_pls_head_bang_blood",
		  "cs_pls_ped_splash",
		  "cs_pls_tea_pour",
		  "cs_ped_foot_dusty"
		},
	  },
	  {
		DictionaryName = "cut_prologue",
		EffectNames = {
		  "cs_prologue_brad_blood",
		  "eject_auto",
		  "cs_pro_wheel_snow",
		  "scr_prol_ped_slush",
		  "cs_pro_train_sparks",
		  "cs_pro_muz_shotgun",
		  "cs_cig_exhale_mouth",
		  "cs_prologue_tree_crash",
		  "cs_ped_foot_snow",
		  "cs_prologue_michael_shot",
		  "cs_cig_smoke",
		  "cs_pro_car_train_impact",
		  "cs_prologue_train_crash",
		  "cs_cig_exhale_mouth_prologue",
		  "cs_pro_car_crash_snow",
		  "cs_pro_blood_exit",
		  "wheel_fric_snow_loose",
		  "cs_pro_ped_breath",
		  "wheel_burnout_snow",
		  "cs_pro_car_impact",
		  "cs_pro_muz_assault_rifle",
		  "cs_cig_smoke_prologue",
		  "cs_cig_exhale_nose",
		  "cs_prologue_tire_mist",
		  "ped_wade_snow",
		  "cs_pro_bul_carmetal",
		  "cs_pro_glass_smash",
		  "veh_exhaust_car"
		},
	  },
	  {
		DictionaryName = "cut_rcbarry1",
		EffectNames = {
		  "cs_doobie_smoke",
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke_inhale",
		  "cs_cig_smoke",
		  "cs_mich1_lighter_flame",
		  "cs_mich1_lighter_sparks"
		},
	  },
	  {
		DictionaryName = "cut_rcbarry2",
		EffectNames = {
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke"
		},
	  },
	  {
		DictionaryName = "cut_rcdale1",
		EffectNames = {
		  "cs_camera_flash",
		  "cs_rcdale1_bourbon_pour"
		},
	  },
	  {
		DictionaryName = "cut_rcepsilon",
		EffectNames = {
		  "cs_rcepsilon_cola_can",
		  "liquid_splash_paint",
		  "liquid_spray_paint"
		},
	  },
	  {
		DictionaryName = "cut_rcnigel2",
		EffectNames = {
		  "cs_camera_flash",
		  "veh_panel_shut_car"
		},
	  },
	  {
		DictionaryName = "cut_rcpaparazzo1",
		EffectNames = {
		  "cs_rcpap3_makeup",
		  "cs_rcpap1_camera",
		  "cs_rcpap3_litter"
		},
	  },
	  {
		DictionaryName = "cut_solomon1",
		EffectNames = {
		  "cs_sol2_coffee_steam",
		  "ped_foot_dusty",
		  "muz_pistol",
		  "scr_sol1_plane_smoke"
		},
	  },
	  {
		DictionaryName = "cut_solomon3b",
		EffectNames = {
		  "cs_sol3b_tarmac_exp",
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_cig_exhale_nose",
		  "cs_sol3b_camera"
		},
	  },
	  {
		DictionaryName = "cut_solomon5",
		EffectNames = {
		  "cs_sol5_blood_head_shot",
		  "muz_pistol"
		},
	  },
	  {
		DictionaryName = "cut_test",
		EffectNames = {
		  "exp_hydrant",
		  "fire_petroltank_car",
		  "cs_cig_exhale_mouth",
		  "exp_hydrant_decals_sp",
		  "cs_cig_smoke",
		  "cs_pls_head_bang_blood",
		  "cs_mich1_lighter_flame",
		  "cs_cig_exhale_nose",
		  "cs_mich1_lighter_sparks"
		},
	  },
	  {
		DictionaryName = "cut_trevor1",
		EffectNames = {
		  "water_splash_ped_wade",
		  "veh_exhaust_hidden",
		  "cs_trev1_blood_pool",
		  "cs_trev1_crackpipe_smoke",
		  "cs_head_kick_blood",
		  "water_splash_ped_out",
		  "water_splash_ped_in",
		  "cs_trev1_ankle_water",
		  "cs_trev1_beer_bottle",
		  "cs_trev1_ped_water_splash",
		  "cs_trev1_wheel_spin_sand",
		  "cs_trev1_wheel_fric_sand_Bike",
		  "cs_trev1_dusty_kick",
		  "ped_breath_water",
		  "cs_trev1_lighter_sparks",
		  "wheel_fric_dirt_dry",
		  "water_splash_ped",
		  "veh_exhaust_truck",
		  "cs_trev1_trailer_wash",
		  "cs_meth_pipe_smoke",
		  "ped_water_drips",
		  "cs_trev1_lighter_flame",
		  "ped_underwater_trails",
		  "veh_exhaust_car"
		},
	  },
	  {
		DictionaryName = "cut_trevor2",
		EffectNames = {
		  "muz_assault_rifle",
		  "ped_foot_dusty"
		},
	  },
	  {
		DictionaryName = "cut_trevor3",
		EffectNames = {
		  "cs_trev5_water_pour",
		  "cs_trev3_dusty_body",
		  "cs_trev3_soap_suds",
		  "cs_trev5_door_splinter"
		},
	  },
	  {
		DictionaryName = "cut_trevor4",
		EffectNames = {
		  "cs_trev4_blood_splatter"
		},
	  },
	  {
		DictionaryName = "cut_trevor5",
		EffectNames = {
		  "cs_trev5_door_splinter"
		},
	  },
	  {
		DictionaryName = "des_apartment_block",
		EffectNames = {
		  "ent_ray_heli_aprtmnt_trail"
		},
	  },
	  {
		DictionaryName = "des_bi_plane",
		EffectNames = {
		  "ent_ray_ex1_plane_spark_R",
		  "ent_ray_ex1_plane_break_L",
		  "ent_ray_ex1_plane_spark_L",
		  "ent_ray_ex1_plane_break_R"
		},
	  },
	  {
		DictionaryName = "des_bigjobdrill",
		EffectNames = {
		  "ent_ray_big_drill_start_sparks",
		  "ent_ray_big_drill_start",
		  "sp_fbi_collapse_debris",
		  "ent_ray_big_drill_ibt",
		  "ent_ray_big_drill_trail",
		  "ent_ray_big_drill_ground_dust",
		  "ent_ray_big_drill_cloud",
		  "ent_ray_big_drill_sparks",
		  "ent_ray_big_drill_loop"
		},
	  },
	  {
		DictionaryName = "des_car_show_room",
		EffectNames = {
		  "ent_ray_arm3_sparking_wires",
		  "ent_ray_arm3_paper",
		  "ent_ray_arm3_wood_splinter",
		  "ent_ray_arm3_window_break"
		},
	  },
	  {
		DictionaryName = "des_farmhouse",
		EffectNames = {
		  "ent_ray_ch2_farm_CS_lights",
		  "ent_ray_ch2_farm_exp",
		  "ent_ray_ch2_farm_exp_porch_window",
		  "ent_ray_ch2_farm_fire_light",
		  "ent_ray_ch2_farm_dust_terrain"
		},
	  },
	  {
		DictionaryName = "des_fib_ceiling",
		EffectNames = {
		  "ent_ray_fbi5a_ceiling_impacts",
		  "ent_ray_fbi5a_ceiling_sprinkler",
		  "sp_agency_sparking_wires",
		  "ent_ray_fbi5a_ceiling_cable",
		  "ent_ray_fbi5a_ceiling_debris",
		  "ent_ray_fbi5a_sparking_wires"
		},
	  },
	  {
		DictionaryName = "des_fib_door",
		EffectNames = {
		  "ent_ray_fbi_door_exp"
		},
	  },
	  {
		DictionaryName = "des_fib_floor",
		EffectNames = {
		  "ent_ray_fbi5a_ramp_explosion",
		  "ent_ray_fbi5a_ramp_fragment",
		  "ent_ray_fbi5a_ramp_dust_impact",
		  "ent_ray_fbi5a_ramp_metal_imp"
		},
	  },
	  {
		DictionaryName = "des_fib_glass",
		EffectNames = {
		  "ent_ray_fbi2_window_break",
		  "ent_ray_fbi2_glass_drop"
		},
	  },
	  {
		DictionaryName = "des_fibstairs",
		EffectNames = {
		  "ent_ray_fbi5a_stairs_dust_fill",
		  "ent_ray_fbi5a_stairs_fragment",
		  "ent_ray_fbi5a_stairs_silt_fall"
		},
	  },
	  {
		DictionaryName = "des_finale",
		EffectNames = {
		  "ent_ray_finale1_liquid_petrol",
		  "ent_ray_finale1_liquid_nitro"
		},
	  },
	  {
		DictionaryName = "des_french_doors",
		EffectNames = {
		  "ent_ray_fam3_glass_break"
		},
	  },
	  {
		DictionaryName = "des_fruit_bowl",
		EffectNames = {
		  "ent_ray_fam4_fruit_bowl"
		},
	  },
	  {
		DictionaryName = "des_gas_station",
		EffectNames = {
		  "ent_ray_paleto_gas_plume_L",
		  "ent_ray_paleto_gas_explosion",
		  "ent_ray_paleto_gas_window_break",
		  "ent_ray_paleto_gas_dust_terrain",
		  "ent_ray_paleto_gas_plume",
		  "ent_ray_paleto_gas_debris_trails",
		  "ent_ray_paleto_gas_exp_tiles"
		},
	  },
	  {
		DictionaryName = "des_hospitaldoors",
		EffectNames = {
		  "ent_ray_hospital_glass"
		},
	  },
	  {
		DictionaryName = "des_methtrailer",
		EffectNames = {
		  "ent_ray_meth_dust_terrain",
		  "ent_ray_meth_explosion"
		},
	  },
	  {
		DictionaryName = "des_pro_tree_crash",
		EffectNames = {
		  "ent_ray_pro_tree_crash",
		  "ent_ray_pro_tree_crash_snow_slush",
		  "ent_ray_pro_tree_crash_snow"
		},
	  },
	  {
		DictionaryName = "des_prologue_door",
		EffectNames = {
		  "sp_prologue_debris",
		  "ent_ray_pro_door_sparks",
		  "ent_ray_pro_door_sprinkler",
		  "ent_ray_pro_door_light_glass",
		  "ent_ray_pro1_water_splash_spawn",
		  "ent_ray_pro_door_ceiling_debris",
		  "ent_ray_pro_door_embers",
		  "ent_ray_pro_door_fireball_light",
		  "ent_ray_pro_door_steam"
		},
	  },
	  {
		DictionaryName = "des_scaffolding",
		EffectNames = {
		  "ent_ray_scaf_explosion",
		  "ent_ray_fam3_dust_motes",
		  "ent_ray_scaf_spark_bursts",
		  "exp_grd_petrol_pump_spawn",
		  "ent_ray_scaf_dust_clouds",
		  "ent_ray_scaf_wood_frags",
		  "ent_ray_scaf_fire_trails"
		},
	  },
	  {
		DictionaryName = "des_shipwreck",
		EffectNames = {
		  "ent_ray_shipwreck_exp_underwater",
		  "ent_ray_shipwreck_exp",
		  "ent_ray_shipwreck_fire_window",
		  "ent_ray_shipwreck_splash_L",
		  "ent_ray_shipwreck_pipe_impacts",
		  "ent_ray_shipwreck_exp_window",
		  "ent_ray_shipwreck_water_churn",
		  "ent_ray_shipwreck_splash_S",
		  "ent_ray_shipwreck_container_trail",
		  "ent_ray_shipwreck_smoke_plume",
		  "ent_ray_shipwreck_sparks",
		  "ent_ray_shipwreck_wood_debris"
		},
	  },
	  {
		DictionaryName = "des_smash2",
		EffectNames = {
		  "ent_ray_fbi4_sparks_point",
		  "ent_ray_fbi4_truck_slam",
		  "ent_ray_fbi4_wall_dust",
		  "ent_ray_fbi4_sparks_line",
		  "ent_ray_fbi4_wall_debris",
		  "ent_ray_fbi4_terrain_dust",
		  "ent_ray_fbi4_wall_dust_mote"
		},
	  },
	  {
		DictionaryName = "des_stilthouse",
		EffectNames = {
		  "ent_ray_fam3_creaking_dust",
		  "ent_ray_fam3_terrain_dust",
		  "ent_ray_fam3_concrete_frags",
		  "ent_ray_fam3_wood_frags",
		  "ent_ray_fam3_falling_leaves",
		  "ent_ray_fam3_dust_linger",
		  "ent_ray_fam3_windows",
		  "ent_ray_fam3_deck_fracture",
		  "ent_ray_fam3_wall_glass",
		  "ent_ray_fam3_dust_cloud",
		  "ent_ray_fam3_dust_trails"
		},
	  },
	  {
		DictionaryName = "des_tanker_crash",
		EffectNames = {
		  "ent_ray_tanker_exp_sp",
		  "ent_ray_tanker_exp",
		  "exp_grd_petrol_pump_spawn",
		  "ent_ray_tanker_exp_spawn",
		  "sp_fire_trail_tanker_exp"
		},
	  },
	  {
		DictionaryName = "des_trailerpark",
		EffectNames = {
		  "ent_ray_trailerpark_dust_terrain",
		  "ent_ray_trailerpark_window",
		  "ent_ray_trailerpark_fires",
		  "ent_ray_trailerpark_explosion_L"
		},
	  },
	  {
		DictionaryName = "des_train_crash",
		EffectNames = {
		  "ent_ray_train_water_wash",
		  "ent_ray_train_sparks",
		  "ent_ray_train_debris_splash",
		  "ent_ray_train_dust_silt",
		  "ent_ray_meth_dust_settle",
		  "ent_ray_train_debris2",
		  "ent_ray_train_glass",
		  "ent_ray_train_debris_water_splash",
		  "ent_ray_train_debris",
		  "scr_trev1_crash_dust",
		  "ent_ray_train_debris_splash_spawn",
		  "ent_ray_train_falling_debris",
		  "ent_ray_train_impact",
		  "ent_ray_train_splash",
		  "ent_ray_train_sparks_trails",
		  "ent_ray_train_smoke"
		},
	  },
	  {
		DictionaryName = "des_tv_smash",
		EffectNames = {
		  "ent_sht_electrical_box_sp",
		  "ent_ray_fam2_tv_smash"
		},
	  },
	  {
		DictionaryName = "des_vaultdoor",
		EffectNames = {
		  "ent_ray_pro1_sprinkler_burst",
		  "ent_ray_pro1_floating_cash",
		  "ent_ray_pro1_water_splash_spawn",
		  "ent_ray_pro1_light_glass",
		  "ent_ray_pro_door_steam",
		  "ent_ray_pro1_vault_exp2",
		  "ent_ray_pro1_residual_smoke",
		  "ent_ray_pro1_sparking_wires",
		  "ent_ray_pro1_bolt_sparks",
		  "ent_ray_pro1_wall_smashed",
		  "ent_ray_pro1_ceiling_debris",
		  "ent_ray_pro1_concrete_impacts",
		  "ent_ray_pro1_floor_sparks"
		},
	  },
	  {
		DictionaryName = "scr_agencyheist",
		EffectNames = {
		  "scr_fbi_mop_drips",
		  "scr_agency3a_door_hvy_trig",
		  "scr_fbi_build_exp_spawn",
		  "scr_fbi_ext_blaze",
		  "scr_fbi_falling_debris",
		  "scr_agency_atrium_glass",
		  "scr_agency3a_door_hvy_stat",
		  "scr_fbi_ext_rooftop",
		  "scr_fbi_exp_building",
		  "sp_fire_trail",
		  "scr_fbi_mop_squeeze",
		  "scr_env_agency3a_arrive_deb",
		  "env_smoke_fbi_stairs",
		  "scr_fbi_dd_breach_smoke",
		  "scr_fbi_shaft_falling_debris"
		},
	  },
	  {
		DictionaryName = "scr_agencyheistb",
		EffectNames = {
		  "scr_agency3b_blding_smoke",
		  "scr_agency3b_wood_splinter",
		  "scr_fbi5b_fragment",
		  "scr_agency3b_linger_smoke",
		  "scr_agency3b_heli_expl",
		  "scr_agency_atrium_silt",
		  "scr_agency_atrium_glass",
		  "scr_agency3b_proj_rpg_trail",
		  "sp_fbi_collapse_debris",
		  "scr_agency3b_shot_chopper",
		  "proj_grenade_trail",
		  "sp_ent_sparking_wires",
		  "scr_env_agency3b_smoke",
		  "scr_agency3b_heli_spawn",
		  "scr_fbi5b_silt_fall",
		  "scr_agency_door_haze",
		  "ent_amb_fbi_live_wires",
		  "scr_agency_heli_slide_dust",
		  "scr_agency3b_heli_exp_trail",
		  "scr_agency3b_elec_box"
		},
	  },
	  {
		DictionaryName = "scr_amb_chop",
		EffectNames = {
		  "ent_anim_dog_poo",
		  "liquid_splash_pee",
		  "ent_anim_dog_peeing"
		},
	  },
	  {
		DictionaryName = "scr_armenian1",
		EffectNames = {
		  "cs_water_boat_prop",
		  "cs_water_boat_Jetmax_bow",
		  "scr_arm1_wheel_skid"
		},
	  },
	  {
		DictionaryName = "scr_armenian2",
		EffectNames = {},
	  },
	  {
		DictionaryName = "scr_armenian3",
		EffectNames = {
		  "ent_anim_leaf_blower"
		},
	  },
	  {
		DictionaryName = "scr_barbershop",
		EffectNames = {
		  "scr_barbers_haircut"
		},
	  },
	  {
		DictionaryName = "scr_bigscore",
		EffectNames = {
		  "scr_bigscore_peeing",
		  "liquid_splash_pee",
		  "scr_bigscore_ramp_sparks",
		  "scr_bigscore_rpg_trail",
		  "scr_bigscore_tyre_spiked"
		},
	  },
	  {
		DictionaryName = "scr_carsteal3",
		EffectNames = {
		  "scr_carsteal3_tyre_spikes",
		  "scr_carsteal4_tyre_spiked",
		  "scr_carsteal3_eject"
		},
	  },
	  {
		DictionaryName = "scr_carsteal4",
		EffectNames = {
		  "scr_carsteal4_trailer_scrape",
		  "scr_carsteal5_car_muzzle_flash",
		  "scr_carsteal4_tyre_spikes",
		  "scr_carsteal4_wheel_burnout",
		  "scr_carsteal5_tyre_spiked"
		},
	  },
	  {
		DictionaryName = "scr_carwash",
		EffectNames = {
		  "ent_amb_car_wash_jet_soap",
		  "ent_amb_car_wash",
		  "ent_amb_car_wash_jet",
		  "ent_amb_car_wash_steam"
		},
	  },
	  {
		DictionaryName = "scr_chinese2",
		EffectNames = {
		  "scr_chin1_freezer_gust",
		  "cs_dry_ice_freezer_door",
		  "scr_petrol_trail_fire"
		},
	  },
	  {
		DictionaryName = "scr_cncpolicestationbustout",
		EffectNames = {
		  "scr_alarm_damage_sparks"
		},
	  },
	  {
		DictionaryName = "scr_exile1",
		EffectNames = {
		  "scr_ex1_cargo_smoke",
		  "scr_ex1_dust_settle",
		  "ent_amb_sparking_wires_sm_sp",
		  "scr_ex1_plane_exp_sp",
		  "scr_ex1_cargo_engine_trail",
		  "scr_ex1_plane_exp",
		  "scr_ex1_cargo_engine_burst",
		  "scr_ex1_dust_impact",
		  "scr_ex1_heatseeker",
		  "scr_ex1_cargo_debris",
		  "scr_ex1_moving_cloud",
		  "cs_ex1_sparking_wires_sm",
		  "scr_ex1_water_exp_sp",
		  "cs_ex1_cargo_fire"
		},
	  },
	  {
		DictionaryName = "scr_exile2",
		EffectNames = {
		  "scr_ex2_rpg_trail",
		  "scr_ex2_chop_trail",
		  "scr_ex2_car_impact",
		  "scr_ex2_car_slide",
		  "scr_ex2_jeep_engine_fire"
		},
	  },
	  {
		DictionaryName = "scr_exile3",
		EffectNames = {
		  "ent_ray_train_debris_splash",
		  "scr_ex3_engine_fire",
		  "cs_fam5_water_splash_ped_out",
		  "cs_fam5_water_splash_ped_in",
		  "water_splash_ped",
		  "scr_ex3_container_smoke",
		  "ent_ray_train_debris_splash_spawn",
		  "scr_ex3_water_dinghy_wash",
		  "ent_ray_train_falling_debris",
		  "cs_fam5_water_splash_ped_wade",
		  "ent_ray_train_splash",
		  "cs_fam5_michael_pool_splash"
		},
	  },
	  {
		DictionaryName = "scr_family1",
		EffectNames = {
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "scr_fam1_blood_headshot",
		  "scr_fam1_veh_smoke",
		  "cs_cig_exhale_nose"
		},
	  },
	  {
		DictionaryName = "scr_family3",
		EffectNames = {
		  "scr_fam3_wheelspin_dirt",
		  "ent_ray_fam3_dust_settle"
		},
	  },
	  {
		DictionaryName = "scr_family4",
		EffectNames = {
		  "scr_fam4_truck_vent",
		  "scr_fam4_trailer_sparks"
		},
	  },
	  {
		DictionaryName = "scr_family5",
		EffectNames = {
		  "scr_trev_puke",
		  "scr_trev_puke_splash_grd",
		  "scr_puke_in_car",
		  "scr_fam_door_smoke",
		  "scr_fam_bong_smoke"
		},
	  },
	  {
		DictionaryName = "scr_family6",
		EffectNames = {
		  "cs_fam6_hair_snip"
		},
	  },
	  {
		DictionaryName = "scr_familyscenem",
		EffectNames = {
		  "scr_trev_amb_puke",
		  "scr_trev_puke",
		  "scr_trev_puke_splash_grd",
		  "scr_puke_in_car",
		  "scr_fam_door_smoke",
		  "scr_tracey_puke",
		  "scr_pts_gardner_watering",
		  "cs_mich1_lighter_flame",
		  "scr_pts_vomit_water",
		  "scr_meth_pipe_smoke",
		  "scr_pts_headsplash_trev",
		  "liquid_splash_water",
		  "scr_fam_bong_smoke",
		  "scr_pts_footsplash",
		  "scr_pts_headsplash",
		  "scr_fam_moonshine_pour",
		  "scr_pts_digging",
		  "cs_mich1_lighter_sparks",
		  "scr_pts_flush"
		},
	  },
	  {
		DictionaryName = "scr_fbi1",
		EffectNames = {
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "scr_fbi1_litter",
		  "cs_cig_exhale_nose",
		  "scr_fbi_autopsy_blood"
		},
	  },
	  {
		DictionaryName = "scr_fbi3",
		EffectNames = {
		  "scr_fbi3_dirty_wtr_splash_sp",
		  "scr_fbi3_elec_smoulder",
		  "cs_cig_exhale_mouth",
		  "scr_fbi3_blood_extraction",
		  "cs_cig_smoke",
		  "scr_fbi3_dirty_water_pour",
		  "scr_fbi3_blood_throwaway",
		  "scr_fbi3_blood_mouth",
		  "cs_cig_exhale_nose",
		  "scr_fbi3_elec_sparks"
		},
	  },
	  {
		DictionaryName = "scr_fbi4",
		EffectNames = {
		  "scr_fbi4_trucks_crash",
		  "exp_fbi4_doors_post",
		  "exp_fbi4_doors"
		},
	  },
	  {
		DictionaryName = "scr_fbi5a",
		EffectNames = {
		  "scr_bio_cutter_nozzle",
		  "muz_assault_rifle",
		  "scr_bio_cutter_flame",
		  "scr_bio_grille_cutting",
		  "scr_fbi5_dry_ice",
		  "water_splash_ped_bubbles",
		  "scr_tunnel_vent_bubbles",
		  "ped_talk_water",
		  "bul_carmetal",
		  "scr_fbi5a_flare",
		  "scr_bio_flare",
		  "scr_bio_grille_break",
		  "scr_fbi5_ped_water_splash",
		  "scr_bio_grille_singed"
		},
	  },
	  {
		DictionaryName = "scr_fbi5b",
		EffectNames = {
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_cig_exhale_nose"
		},
	  },
	  {
		DictionaryName = "scr_finale1",
		EffectNames = {
		  "scr_fin_trev_car_impact",
		  "scr_fin_env_trev_sky",
		  "scr_fin_fire_petrol_trev",
		  "muz_pistol"
		},
	  },
	  {
		DictionaryName = "scr_finale2",
		EffectNames = {
		  "scr_finale2_blood_entry"
		},
	  },
	  {
		DictionaryName = "scr_fm_mp_missioncreator",
		EffectNames = {
		  "ent_anim_cig_exhale_mth_car",
		  "scr_mp_generic_dst",
		  "ent_anim_cig_exhale_nse",
		  "scr_mp_drug_dst",
		  "scr_sh_cig_exhale_nose",
		  "ent_anim_cig_smoke",
		  "scr_sh_cig_smoke",
		  "scr_mp_elec_dst",
		  "ent_amb_shower",
		  "ent_amb_shower_steam",
		  "scr_sh_lighter_flame",
		  "scr_sh_cig_exhale_mouth",
		  "ent_anim_cig_exhale_mth",
		  "ent_anim_cig_exhale_nse_car",
		  "scr_mp_dust_cloud",
		  "scr_sh_lighter_sparks",
		  "scr_sh_bong_smoke",
		  "ent_anim_cig_smoke_car",
		  "scr_crate_drop_beacon"
		},
	  },
	  {
		DictionaryName = "scr_franklin0",
		EffectNames = {
		  "scr_franklin0_chop_trail"
		},
	  },
	  {
		DictionaryName = "scr_hunting",
		EffectNames = {
		  "ent_amb_insect_plane"
		},
	  },
	  {
		DictionaryName = "scr_jewelheist",
		EffectNames = {
		  "scr_jewel_fog_volume",
		  "cs_bike_exhaust",
		  "scr_jewel_cab_smash",
		  "scr_jewel_haze",
		  "scr_jew_bike_burnout"
		},
	  },
	  {
		DictionaryName = "scr_josh3",
		EffectNames = {
		  "scr_josh3_light_explosion",
		  "scr_josh3_fires",
		  "exp_grd_petrol_pump_spawn",
		  "scr_josh3_explosion",
		  "scr_josh3_exp_debris",
		  "scr_josh3_house_smoked"
		},
	  },
	  {
		DictionaryName = "scr_lamar1",
		EffectNames = {
		  "scr_lamar1_door_breach",
		  "scr_lamar1_fire_spread",
		  "scr_lamar1_fire_spread1",
		  "scr_env_agency3b_smoke"
		},
	  },
	  {
		DictionaryName = "scr_lester1a",
		EffectNames = {
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke",
		  "cs_cig_exhale_nose"
		},
	  },
	  {
		DictionaryName = "scr_martin1",
		EffectNames = {
		  "scr_sol1_plane_tail_fire",
		  "scr_sol1_fire_trail",
		  "scr_sol1_sniper_impact",
		  "ent_amb_elec_crackle_sp",
		  "sp_scr_sol1_fire_drip_trail",
		  "scr_sol1_plane_smoke_loop",
		  "scr_sol1_plane_crash_dust",
		  "scr_sol1_plane_wreck",
		  "scr_sol1_plane_engine_fire",
		  "scr_sol1_fire_drip",
		  "scr_sol1_fire_spot",
		  "scr_sol1_plane_elec_crackle",
		  "scr_sol1_plane_smoke"
		},
	  },
	  {
		DictionaryName = "scr_michael2",
		EffectNames = {
		  "scr_mich2_spark_impact",
		  "scr_abattoir_ped_sliced",
		  "cs_cig_exhale_mouth",
		  "scr_mich2_blood_stab",
		  "cs_cig_smoke",
		  "scr_abattoir_ped_minced",
		  "scr_acid_bath_splash",
		  "scr_pts_headsplash",
		  "scr_mich3_heli_fire"
		},
	  },
	  {
		DictionaryName = "scr_minigamegolf",
		EffectNames = {
		  "scr_golf_ball_trail",
		  "scr_golf_strike_bunker",
		  "scr_golf_landing_thick_grass",
		  "scr_golf_strike_thick_grass",
		  "scr_golf_tee_perfect",
		  "scr_golf_strike_fairway_bad",
		  "scr_golf_strike_fairway",
		  "scr_golf_hit_branches",
		  "scr_golf_landing_bunker",
		  "scr_golf_landing_water"
		},
	  },
	  {
		DictionaryName = "scr_minigamepilot",
		EffectNames = {
		  "scr_stuntplane_trail"
		},
	  },
	  {
		DictionaryName = "scr_minigamestuntplane",
		EffectNames = {
		  "scr_stuntplane_trail"
		},
	  },
	  {
		DictionaryName = "scr_minigametennis",
		EffectNames = {
		  "scr_tennis_ball_trail"
		},
	  },
	  {
		DictionaryName = "scr_mp_cig",
		EffectNames = {
		  "ent_anim_cig_exhale_mth_car",
		  "ent_anim_cig_exhale_nse",
		  "ent_anim_cig_smoke",
		  "ent_anim_cig_exhale_mth",
		  "ent_anim_cig_exhale_nse_car",
		  "ent_anim_cig_smoke_car"
		},
	  },
	  {
		DictionaryName = "scr_mp_controller",
		EffectNames = {
		  "scr_mp_generic_dst",
		  "ent_anim_cig_exhale_nse",
		  "scr_mp_drug_dst",
		  "ent_anim_cig_smoke",
		  "scr_mp_elec_dst",
		  "ent_anim_cig_exhale_mth"
		},
	  },
	  {
		DictionaryName = "scr_mp_creator",
		EffectNames = {
		  "scr_mp_intro_plane_exhaust",
		  "scr_mp_splash",
		  "scr_mp_plane_landing_tyre_smoke",
		  "scr_mp_dust_cloud"
		},
	  },
	  {
		DictionaryName = "scr_mp_house",
		EffectNames = {
		  "scr_sh_cig_exhale_nose",
		  "scr_sh_cig_smoke",
		  "ent_amb_shower",
		  "ent_amb_shower_steam",
		  "scr_sh_lighter_flame",
		  "scr_sh_cig_exhale_mouth",
		  "scr_mp_int_fireplace_sml",
		  "scr_sh_lighter_sparks",
		  "scr_sh_bong_smoke"
		},
	  },
	  {
		DictionaryName = "scr_nicehseheist2c",
		EffectNames = {},
	  },
	  {
		DictionaryName = "scr_obfoundrycauldron",
		EffectNames = {
		  "scr_obfoundry_cauldron_steam"
		},
	  },
	  {
		DictionaryName = "scr_oddjobassassinmulti",
		EffectNames = {},
	  },
	  {
		DictionaryName = "scr_oddjobbusassassin",
		EffectNames = {
		  "scr_ojbusass_bus_impact"
		},
	  },
	  {
		DictionaryName = "scr_oddjobtaxi",
		EffectNames = {
		  "scr_ojtaxi_hotbox_window",
		  "scr_ojtaxi_hotbox_trail",
		  "scr_ojtaxi_hotbox_door"
		},
	  },
	  {
		DictionaryName = "scr_oddjobtowtruck",
		EffectNames = {
		  "scr_ojtt_train_sparks"
		},
	  },
	  {
		DictionaryName = "scr_oddjobtraffickingair",
		EffectNames = {
		  "scr_drug_grd_train_exp",
		  "scr_boat_trails_sp",
		  "scr_ojdg4_water_exp",
		  "scr_drug_grd_plane_exp",
		  "scr_ojdg4_train_fire",
		  "scr_drug_traffic_flare_L",
		  "scr_crate_drop_flare",
		  "scr_ojdg4_boat_wreck_fire",
		  "scr_mp_intro_plane_exhaust",
		  "scr_ojdg4_boat_exp",
		  "scr_boat_exp_sp",
		  "scr_crate_drop_beacon"
		},
	  },
	  {
		DictionaryName = "scr_oddjobtraffickingground",
		EffectNames = {
		  "scr_drug_traffic_flare_L",
		  "scr_ojdg5_barrels_smoke",
		  "scr_drug_traffic_flare",
		  "scr_ojdg5_barrels"
		},
	  },
	  {
		DictionaryName = "scr_paintnspray",
		EffectNames = {
		  "scr_respray_smoke"
		},
	  },
	  {
		DictionaryName = "scr_paletoscore",
		EffectNames = {
		  "scr_paleto_roof_impact",
		  "scr_trev_puke",
		  "scr_paleto_fire_trail",
		  "scr_paleto_banknotes",
		  "scr_alarm_damage_sparks",
		  "scr_paleto_box_spawned",
		  "scr_trev_puke_splash_grd",
		  "cs_paleto_blowtorch",
		  "scr_paleto_heli_plume",
		  "ent_amb_peeing",
		  "liquid_splash_pee",
		  "scr_paleto_doorway_smoke",
		  "cs_rbhs_int_delap_dust",
		  "scr_paleto_box_sparks"
		},
	  },
	  {
		DictionaryName = "scr_paradise2_trailer",
		EffectNames = {
		  "scr_para_kick_blood",
		  "scr_prologue_door_blast"
		},
	  },
	  {
		DictionaryName = "scr_player_timetable_scene",
		EffectNames = {
		  "scr_pts_vomit_water",
		  "ent_dst_pineapple",
		  "scr_pts_glass_bottle",
		  "scr_pts_headsplash",
		  "scr_pts_guitar_break",
		  "scr_pts_digging"
		},
	  },
	  {
		DictionaryName = "scr_playerlamgraff",
		EffectNames = {
		  "scr_lamgraff_paint_spray"
		},
	  },
	  {
		DictionaryName = "scr_pm_plane_promotion",
		EffectNames = {
		  "scr_stuntplane_trail",
		  "scr_property_leaflet_drop"
		},
	  },
	  {
		DictionaryName = "scr_portoflsheist",
		EffectNames = {
		  "scr_bio_flare",
		  "scr_pls_sub_water_drips",
		  "scr_bigscore_rpg_trail"
		},
	  },
	  {
		DictionaryName = "scr_prologue",
		EffectNames = {
		  "sp_prologue_debris",
		  "scr_prologue_vault_haze",
		  "scr_prologue_vault_fog",
		  "scr_pro_door_snow",
		  "ent_ray_pro_door_embers",
		  "ent_ray_pro1_vault_exp_lit",
		  "scr_prologue_door_blast",
		  "scr_pro_car_steam",
		  "scr_pro_door_splinters",
		  "scr_prologue_ceiling_debris"
		},
	  },
	  {
		DictionaryName = "scr_rcbarry1",
		EffectNames = {
		  "scr_alien_teleport",
		  "scr_alien_beam",
		  "scr_alien_charging",
		  "scr_alien_disintegrate",
		  "scr_alien_impact",
		  "scr_alien_impact_bul"
		},
	  },
	  
	  {
		DictionaryName = "scr_rcextreme2",
		EffectNames = {
		  "scr_rcext2_cargo_smoke",
		  "scr_extrm4_water_blood",
		  "scr_rcext2_ramp_scrape",
		  "scr_extrm2_moving_cloud",
		  "scr_extrm4_water_splash"
		},
	  },
	  {
		DictionaryName = "scr_rcmrsavb2",
		EffectNames = {},
	  },
	  {
		DictionaryName = "scr_rcnigel2",
		EffectNames = {
		  "scr_rcn2_debris_trail",
		  "scr_rcn2_ceiling_debris"
		},
	  },
	  {
		DictionaryName = "scr_rcpaparazzo1",
		EffectNames = {
		  "scr_mich4_firework_burst_spawn",
		  "scr_rcpap1_smoke_vent",
		  "scr_mich4_firework_trailburst",
		  "scr_rcpap1_champ_slosh",
		  "scr_mich4_firework_starburst",
		  "scr_rcpap1_camera",
		  "scr_rcpap1_champ_burst",
		  "scr_mich4_firework_trail_spawn",
		  "scr_mich4_firework_trailburst_spawn",
		  "scr_mich4_firework_sparkle_spawn"
		},
	  },
	  {
		DictionaryName = "scr_rcbarry2",
		EffectNames = {
		  "scr_clown_death",
		  "eject_clown",
		  "scr_exp_clown",
		  "scr_clown_appears",
		  "sp_clown_appear_trails",
		  "scr_exp_clown_trails",
		  "scr_clown_bul",
		  "muz_clown"
		},
	  },
	  {
		DictionaryName = "scr_reburials",
		EffectNames = {
		  "scr_burial_dirt"
		},
	  },
	  {
		DictionaryName = "scr_recartheft",
		EffectNames = {
		  "scr_wheel_burnout"
		},
	  },
	  {
		DictionaryName = "scr_reconstructionaccident",
		EffectNames = {
		  "scr_reconstruct_pipe_impact",
		  "scr_sparking_generator",
		  "scr_reconstruct_pipefall_debris",
		  "sp_sparking_generator"
		},
	  },
	  {
		DictionaryName = "scr_recrash_rescue",
		EffectNames = {
		  "scr_recrash_rescue_fire"
		},
	  },
	  {
		DictionaryName = "scr_safehouse",
		EffectNames = {
		  "scr_sh_cig_exhale_nose",
		  "scr_sh_cig_smoke",
		  "scr_sh_lighter_flame",
		  "scr_sh_cig_exhale_mouth",
		  "scr_sh_lighter_sparks",
		  "scr_sh_bong_smoke"
		},
	  },
	  {
		DictionaryName = "scr_solomon3",
		EffectNames = {
		  "scr_trev4_747_engine_heathaze",
		  "scr_trev4_747_blood_impact",
		  "scr_trev4_trailer_fire",
		  "scr_trev4_747_engine_debris",
		  "scr_trev4_747_engine_damage",
		  "scr_trev4_747_exhaust_plane_misfire",
		  "scr_trev4_747_blood_splash"
		},
	  },
	  {
		DictionaryName = "scr_trevor1",
		EffectNames = {
		  "ent_ray_meth_dust_settle",
		  "scr_trev1_trailer_wires",
		  "scr_trev1_trailer_boosh",
		  "scr_trev1_crash_dust",
		  "sp_ent_sparking_wires",
		  "scr_trev1_trailer_splash",
		  "scr_trev1_wheelspin_dirt"
		},
	  },
	  {
		DictionaryName = "scr_trevor2",
		EffectNames = {
		  "scr_trev2_heli_wreck",
		  "scr_trev2_heli_exp",
		  "scr_trev2_flare_L",
		  "scr_rotor_blade_blood"
		},
	  },
	  {
		DictionaryName = "scr_trevor3",
		EffectNames = {
		  "scr_trev3_trailer_expolsion",
		  "exp_grd_vehicle_spawn",
		  "scr_trev3_c4_explosion",
		  "scr_trev3_trailer_plume",
		  "ent_ray_trev3_trailer_light"
		},
	  },
	  {
		DictionaryName = "proj_indep_firework",
		EffectNames = {
		  "scr_indep_firework_grd_burst",
		  "scr_indep_launcher_sparkle_spawn",
		  "scr_indep_firework_air_burst",
		  "proj_indep_flare_trail"
		},
	  },
	  {
		DictionaryName = "scr_dlc_independence",
		EffectNames = {
		  "proj_indep_flare_trail"
		},
	  },
	  {
		DictionaryName = "scr_indep_fireworks",
		EffectNames = {
		  "scr_indep_firework_sparkle_spawn",
		  "scr_indep_firework_starburst",
		  "scr_indep_firework_shotburst",
		  "scr_indep_firework_trailburst",
		  "scr_indep_firework_trailburst_spawn",
		  "scr_indep_firework_burst_spawn",
		  "scr_indep_firework_trail_spawn",
		  "scr_indep_firework_fountain"
		},
	  },
	  {
		DictionaryName = "scr_indep_parachute",
		EffectNames = {
		  "mp_parachute_smoke_indep"
		},
	  },
	  {
		DictionaryName = "scr_indep_wheelsmoke",
		EffectNames = {
		  "wheel_fric_hard_tank_indep",
		  "wheel_fric_hard_Bike_indep",
		  "wheel_fric_hard_indep",
		  "wheel_burnout_indep"
		},
	  },
	  {
		DictionaryName = "wpn_indep_firework",
		EffectNames = {
		  "muz_indep_firework"
		},
	  },
	  {
		DictionaryName = "wpn_musket",
		EffectNames = {
		  "muz_musket_ng"
		},
	  },
	  {
		DictionaryName = "wpn_amrifle",
		EffectNames = {
		  "eject_sniper_amrifle"
		},
	  },
	  {
		DictionaryName = "scr_pilot_school_mp",
		EffectNames = {
		  "scr_veh_plane_gen_damage"
		},
	  },
	  {
		DictionaryName = "scr_apartment_mp",
		EffectNames = {
		  "exp_yacht_defence_plane",
		  "scr_apa_jacuzzi_wade",
		  "scr_finders_flare",
		  "scr_apa_jacuzzi_steam_sp",
		  "proj_yacht_defence_trail",
		  "scr_apa_jacuzzi_steam",
		  "muz_yacht_defence",
		  "scr_finders_package_flare",
		  "scr_apa_jacuzzi_drips"
		},
	  },
	  {
		DictionaryName = "veh_mounted_turret_limo",
		EffectNames = {
		  "eject_mounted_turret_limo"
		},
	  },
	  {
		DictionaryName = "weap_revolver",
		EffectNames = {
		  "eject_revolver"
		},
	  },
	  {
		DictionaryName = "cut_arena",
		EffectNames = {
		  "cs_arena_car_exhaust"
		},
	  },
	  {
		DictionaryName = "cut_bigscr",
		EffectNames = {
		  "cs_bigscr_eject_shotgun",
		  "cs_bigscr_muz_shotgun",
		  "cs_bigscr_muz_ar",
		  "cs_bigscr_beer_spray",
		  "cs_bigscr_eject_auto",
		  "cs_bigscr_cig_smoke",
		  "cs_bigscr_muz_smg",
		  "cs_bigscr_cig_exhale_mouth",
		  "cut_bigscr_vomit"
		},
	  },
	  {
		DictionaryName = "scr_xs_celebration",
		EffectNames = {
		  "scr_xs_money_rain",
		  "scr_xs_money_rain_celeb",
		  "scr_xs_confetti_burst",
		  "scr_xs_champagne_spray",
		  "scr_xs_beer_chug"
		},
	  },
	  {
		DictionaryName = "scr_xs_dr",
		EffectNames = {
		  "scr_xs_dr_emp"
		},
	  },
	  {
		DictionaryName = "scr_xs_pits",
		EffectNames = {
		  "scr_xs_sf_pit",
		  "scr_xs_fire_pit",
		  "scr_xs_sf_pit_long",
		  "scr_xs_fire_pit_long"
		},
	  },
	  {
		DictionaryName = "scr_xs_props",
		EffectNames = {
		  "scr_xs_exp_mine_sf",
		  "scr_xs_ball_explosion",
		  "scr_xs_oil_jack_fire",
		  "scr_xs_guided_missile_trail"
		},
	  },
	  {
		DictionaryName = "veh_xs_vehicle_mods",
		EffectNames = {
		  "exp_xs_mine_spike",
		  "exp_xs_mine_kinetic",
		  "exp_xs_mine_tar",
		  "veh_nitrous",
		  "exp_xs_mine_emp",
		  "veh_xs_electrified_rambar",
		  "exp_xs_mine_slick"
		},
	  },
	  {
		DictionaryName = "weap_xs_vehicle_weapons",
		EffectNames = {
		  "bullet_tracer_xs_vehicle_remote_mg_sf",
		  "muz_xs_turret_flamethrower_looping",
		  "muz_xs_vehicle_remote_mg_sf",
		  "muz_xs_turret_flamethrower_looping_sf"
		},
	  },
	  {
		DictionaryName = "weap_xs_weapons",
		EffectNames = {
		  "bullet_tracer_xs_sr",
		  "proj_xs_sr_raygun_trail",
		  "muz_xs_sr_carbine",
		  "muz_xs_sr_raygun",
		  "muz_xs_sr_minigun"
		},
	  },
	  {
		DictionaryName = "cut_humane_fin",
		EffectNames = {
		  "exp_hum_fin_heli_sp",
		  "ped_foot_dusty",
		  "exp_hum_fin_heli_spawn",
		  "sp_hum_fin_heli_fire_trail",
		  "exp_hum_fin_heli",
		  "wheel_fric_hard_dusty",
		  "veh_exhaust_car"
		},
	  },
	  {
		DictionaryName = "cut_humane_key",
		EffectNames = {
		  "bul_concrete",
		  "bul_carmetal",
		  "blood_entry",
		  "eject_pistol",
		  "muz_pistol"
		},
	  },
	  {
		DictionaryName = "cut_narcotic_bike",
		EffectNames = {
		  "cs_dst_impotent_rage_toy"
		},
	  },
	  {
		DictionaryName = "cut_narcotic_fin",
		EffectNames = {
		  "cs_nar_fin_trevor_splash",
		  "cs_nar_fin_trevor_arm_drips",
		  "cs_fam5_water_splash_ped_out",
		  "cs_fam2_ped_splash",
		  "eject_pistol",
		  "muz_pistol",
		  "bul_dirt"
		},
	  },
	  {
		DictionaryName = "cut_pacific_fin",
		EffectNames = {
		  "bul_wood_splinter",
		  "water_boat_wash",
		  "water_boat_prop",
		  "wheel_fric_hard",
		  "cs_pac_fin_skid_smoke",
		  "water_boat_dinghy_bow"
		},
	  },
	  {
		DictionaryName = "cut_prison_break",
		EffectNames = {
		  "cs_cig_exhale_mouth",
		  "cs_cig_smoke_inhale",
		  "cs_cig_smoke",
		  "cs_cig_exhale_nose"
		},
	  },
	  {
		DictionaryName = "fm_mission_controler",
		EffectNames = {
		  "scr_drill_overheat",
		  "scr_drill_debris",
		  "scr_drill_out"
		},
	  },
	  {
		DictionaryName = "scr_biolab_heist",
		EffectNames = {
		  "scr_heist_biolab_flare_underwater",
		  "scr_heist_biolab_flare"
		},
	  },
	  {
		DictionaryName = "scr_carrier_heist",
		EffectNames = {
		  "scr_heist_carrier_elec_fire_sp",
		  "scr_heist_carrier_elec_fire"
		},
	  },
	  {
		DictionaryName = "scr_mp_tankbattle",
		EffectNames = {
		  "exp_grd_tankshell_mp"
		},
	  },
	  {
		DictionaryName = "scr_ornate_heist",
		EffectNames = {
		  "scr_heist_ornate_metal_drip",
		  "scr_heist_ornate_banknotes",
		  "scr_heist_ornate_metal_drip_sp",
		  "scr_heist_ornate_thermal_burn"
		},
	  },
	  {
		DictionaryName = "scr_prison_break_heist_station",
		EffectNames = {
		  "scr_brk_metal_lock"
		},
	  },
	  {
		DictionaryName = "veh_mounted_turrets_car",
		EffectNames = {
		  "bullet_tracer_turret",
		  "eject_mounted_turret_technical",
		  "muz_mounted_turret",
		  "eject_mounted_turret"
		},
	  },
	  {
		DictionaryName = "veh_mounted_turrets_heli",
		EffectNames = {
		  "bullet_tracer_valkyrie",
		  "muz_valkyrie",
		  "muz_valkyrie_turret",
		  "eject_mounted_turret",
		  "eject_valkyrie"
		},
	  },
	  {
		DictionaryName = "wpn_flare",
		EffectNames = {
		  "proj_heist_flare_trail"
		},
	  },
	  {
		DictionaryName = "cut_hs3f",
		EffectNames = {
		  "cut_hs3f_dust_motes",
		  "cut_hs3f_blood_entry",
		  "cut_hs3f_exp_vault",
		  "cut_hs3f_exp_tunnel",
		  "cut_hs3f_esc_skid_smoke",
		  "cut_hs3f_muz_pistol",
		  "sp_cut_hs3f_exp_vault_r",
		  "cut_hs3f_muz_smg",
		  "cut_hs3f_cig_smoke",
		  "cut_hs3f_ceiling_debris",
		  "sp_cut_hs3f_ceiling_debris",
		  "cut_hs3f_tunnel_collapse",
		  "sp_cut_hs3f_exp_vault"
		},
	  },
	  {
		DictionaryName = "scr_ch_finale",
		EffectNames = {
		  "scr_ch_cockroach_bag_drop",
		  "scr_ch_finale_laser",
		  "scr_ch_finale_hit_art",
		  "scr_ch_finale_drill_sparks",
		  "scr_ch_finale_vault_haze",
		  "scr_ch_finale_laser_sparks",
		  "scr_ch_finale_hit_gold",
		  "scr_ch_finale_drill_out",
		  "scr_ch_finale_fusebox_overload",
		  "scr_ch_finale_bug_infestation",
		  "scr_ch_finale_camera_stun",
		  "scr_ch_hl_flare",
		  "scr_ch_hl_package_flare",
		  "scr_ch_finale_poison_gas",
		  "scr_ch_finale_drill_sparks_nodecal",
		  "scr_ch_finale_hit_diamond",
		  "scr_ch_finale_thermal_burn",
		  "scr_ch_finale_drill_overheat"
		},
	  },
	  {
		DictionaryName = "weap_ch_vehicle_weapons",
		EffectNames = {
		  "muz_ch_tank_flamethrower",
		  "muz_ch_tank_rocket",
		  "bullet_tracer_ch_tank_laser",
		  "muz_ch_tank_laser",
		  "muz_ch_tank_mg",
		  "bullet_tracer_ch_tank_mg"
		},
	  },
	  {
		DictionaryName = "weap_ch_weapons",
		EffectNames = {
		  "weap_ch_hazcan_splash_sp",
		  "weap_ch_hazcan"
		},
	  },
	  {
		DictionaryName = "scr_ie_export",
		EffectNames = {
		  "scr_ie_export_fire_ring",
		  "scr_ie_export_package_flare",
		  "scr_ie_export_flare"
		},
	  },
	  {
		DictionaryName = "scr_ie_svm_phantom2",
		EffectNames = {
		  "scr_ie_bul_coc_bag"
		},
	  },
	  {
		DictionaryName = "scr_ie_svm_technical2",
		EffectNames = {
		  "scr_dst_cocaine"
		},
	  },
	  {
		DictionaryName = "scr_ie_tw",
		EffectNames = {
		  "scr_impexp_tw_rpg_trail",
		  "scr_impexp_tw_take_zone"
		},
	  },
	  {
		DictionaryName = "scr_ie_vv",
		EffectNames = {
		  "scr_ie_vv_vehicle_damage",
		  "scr_ie_vv_muzzle_flash"
		},
	  },
	  {
		DictionaryName = "scr_impexp_jug",
		EffectNames = {
		  "scr_impexp_jug_outfit_swap",
		  "scr_ie_jug_mask_flame",
		  "scr_ie_jug_mask_steam"
		},
	  },
	  {
		DictionaryName = "scr_impexp_ploughed",
		EffectNames = {
		  "scr_impexp_dst_crate"
		},
	  },
	  {
		DictionaryName = "veh_impexp_rocket",
		EffectNames = {
		  "veh_rocket_boost"
		},
	  },
	  {
		DictionaryName = "veh_impexp_ruiner",
		EffectNames = {
		  "veh_ruiner_hop"
		},
	  },
	  {
		DictionaryName = "weap_ie_vehicle_mg",
		EffectNames = {
		  "muz_ie_vehicle_mg",
		  "bullet_tracer_ie_vehicle_mg"
		},
	  },
	  {
		DictionaryName = "scr_sm",
		EffectNames = {
		  "scr_sm_hl_package_flare",
		  "scr_sm_hl_flare",
		  "scr_dst_inflatable",
		  "scr_sm_con_ped_light"
		},
	  },
	  {
		DictionaryName = "scr_sm_counter",
		EffectNames = {
		  "scr_sm_counter_chaff"
		},
	  },
	  {
		DictionaryName = "scr_sm_trans",
		EffectNames = {
		  "scr_sm_con_trans",
		  "scr_sm_con_trans_fp",
		  "scr_sm_trans_smoke"
		},
	  },
	  {
		DictionaryName = "scr_weap_bombs",
		EffectNames = {
		  "scr_bomb_cluster",
		  "scr_bomb_standard",
		  "scr_bomb_gas"
		},
	  },
	  {
		DictionaryName = "veh_sm_pyro",
		EffectNames = {
		  "veh_exhaust_afterburner_molotok",
		  "veh_exhaust_afterburner_pyro"
		},
	  },
	  {
		DictionaryName = "veh_sm_starling",
		EffectNames = {
		  "veh_exhaust_starling",
		  "veh_vent_plane_starling",
		  "veh_afterburner_starling"
		},
	  },
	  {
		DictionaryName = "veh_sm_vig",
		EffectNames = {
		  "muz_sm_vehicle_mg",
		  "veh_rocket_boost_vig",
		  "bullet_tracer_sm_vehicle_mg"
		},
	  },
	  {
		DictionaryName = "weap_sm_barrage",
		EffectNames = {
		  "proj_rpg_barrage_trail"
		},
	  },
	  {
		DictionaryName = "weap_sm_bom",
		EffectNames = {
		  "veh_vent_plane_bom",
		  "eject_sm_bom_twinmg",
		  "muz_sm_bom_cannon",
		  "bullet_tracer_turret_sm",
		  "muz_sm_bom_twinmg"
		},
	  },
	  {
		DictionaryName = "weap_sm_mogul",
		EffectNames = {
		  "muz_sm_mogul_turret_mg",
		  "bullet_tracer_turret_mogul"
		},
	  },
	  {
		DictionaryName = "weap_sm_tula",
		EffectNames = {
		  "veh_seabreeze_turbulance_water",
		  "muz_sm_tula_mg",
		  "muz_sm_tula_turret_mg",
		  "veh_vent_plane_tula",
		  "bullet_tracer_turret_tula",
		  "eject_sm_tula_turret_minigun",
		  "veh_tula_turbulance_water",
		  "eject_sm_tula_turret_mg"
		},
	  },
	  {
		DictionaryName = "pat_heist",
		EffectNames = {
		  "scr_heist_ornate_thermal_burn_patch"
		},
	  },
	  {
		DictionaryName = "scr_director_mode",
		EffectNames = {
		  "ent_anim_cig_exhale_mth_car",
		  "ent_anim_cig_exhale_nse_car",
		  "ent_anim_cig_smoke_car"
		},
	  },
	  {
		DictionaryName = "scr_ar_planes",
		EffectNames = {
		  "scr_ar_trail_smoke_slow",
		  "scr_ar_trail_smoke"
		},
	  },
	  {
		DictionaryName = "scr_as_target",
		EffectNames = {
		  "scr_as_target_shot_extra_small",
		  "scr_as_target_shot_medium",
		  "scr_as_target_shot_large",
		  "scr_as_target_shot_small"
		},
	  },
	  {
		DictionaryName = "scr_as_trans",
		EffectNames = {
		  "scr_as_trans_smoke"
		},
	  },
	  {
		DictionaryName = "scr_as_trap",
		EffectNames = {
		  "scr_as_trap_zone_circle",
		  "scr_as_trap_zone_rectangle"
		},
	  },
	  {
		DictionaryName = "veh_sm_car_small",
		EffectNames = {
		  "veh_sm_car_small_backfire"
		},
	  },
	  {
		DictionaryName = "scr_ba_bb",
		EffectNames = {
		  "scr_ba_bb_flare",
		  "scr_ba_bb_package_flare",
		  "scr_ba_bb_leaflet_drop",
		  "scr_ba_bb_plane_smoke_trail"
		},
	  },
	  {
		DictionaryName = "scr_ba_bomb",
		EffectNames = {
		  "scr_ba_bomb_destroy"
		},
	  },
	  {
		DictionaryName = "scr_ba_club",
		EffectNames = {
		  "scr_ba_club_drink_pour",
		  "scr_ba_club_drink_pour_splash",
		  "scr_ba_club_champagne_spray",
		  "scr_ba_club_smoke_machine",
		  "scr_ba_club_smoke"
		},
	  },
	  {
		DictionaryName = "veh_ba_blimp3",
		EffectNames = {
		  "exp_blimp3_11",
		  "exp_blimp3_1",
		  "exp_blimp3_10",
		  "exp_blimp3_2",
		  "exp_blimp3_17",
		  "exp_blimp3_15",
		  "exp_blimp3_16",
		  "exp_blimp3_7",
		  "exp_blimp3_14",
		  "exp_blimp3_13",
		  "exp_blimp3_8",
		  "exp_blimp3_9",
		  "exp_blimp3_19",
		  "exp_blimp3_3",
		  "exp_blimp3_18",
		  "exp_blimp3_4",
		  "exp_blimp3_5",
		  "exp_blimp3_6",
		  "exp_blimp3_12",
		  "exp_blimp3_0"
		},
	  },
	  {
		DictionaryName = "veh_ba_oppressor2",
		EffectNames = {
		  "veh_ba_oppressor_turbulance_default",
		  "veh_ba_oppressor_turbulance_foliage",
		  "veh_ba_oppressor_turbulance_water",
		  "veh_ba_oppressor_turbulance_sand",
		  "veh_ba_oppressor_engine_glow",
		  "exp_grd_ba_opp2_cannon",
		  "veh_ba_oppressor_turbulance_dirt"
		},
	  },
	  {
		DictionaryName = "veh_ba_strikeforce",
		EffectNames = {
		  "veh_exhaust_strikeforce"
		},
	  },
	  {
		DictionaryName = "weap_ba_vehicle_weapons",
		EffectNames = {
		  "eject_ba_vehicle_remote_minigun",
		  "eject_ba_vehicle_remote_mg",
		  "muz_ba_vehicle_front_mg",
		  "muz_ba_vehicle_remote_missile",
		  "muz_ba_vehicle_remote_minigun",
		  "muz_ba_vehicle_remote_mg",
		  "proj_ba_remote_gl_trail",
		  "bullet_tracer_ba_vehicle_remote_mg"
		},
	  },
	  {
		DictionaryName = "scr_bike_adversary",
		EffectNames = {
		  "scr_adversary_ped_light_good",
		  "scr_adversary_wheel_lightning",
		  "scr_adversary_weap_smoke",
		  "scr_adversary_weap_glow",
		  "scr_adversary_ped_light_bad",
		  "scr_adversary_gunsmith_weap_smoke",
		  "scr_adversary_judgement_lens_dirt",
		  "scr_adversary_trail_lightning",
		  "scr_adversary_foot_flames",
		  "scr_adversary_gunsmith_weap_change",
		  "scr_adversary_judgement_ash",
		  "scr_adversary_slipstream_formation",
		  "scr_adversary_ped_glow",
		  "scr_adversary_slipstream"
		},
	  },
	  {
		DictionaryName = "scr_bike_business",
		EffectNames = {
		  "scr_bike_meth_propylene_pour",
		  "scr_bike_meth_sodium_pour",
		  "scr_bike_cfid_camera_flash",
		  "scr_bike_coc_cocaine_box_pour",
		  "scr_bike_weed_fog",
		  "scr_bike_spraybottle_spray",
		  "scr_bike_coc_cocaine_scoop_pour",
		  "scr_bike_weed_fog_upgrade",
		  "scr_bike_meth_meth_scoop_pour"
		},
	  },
	  {
		DictionaryName = "scr_bike_contact",
		EffectNames = {
		  "scr_contact_sniper_kill"
		},
	  },
	  {
		DictionaryName = "scr_bike_contraband",
		EffectNames = {
		  "scr_bike_truck_weed_smoke",
		  "scr_bike_truck_weed_smoke_cabin"
		},
	  },
	  {
		DictionaryName = "veh_sanctus",
		EffectNames = {
		  "veh_sanctus_exhaust",
		  "veh_sanctus_backfire",
		  "veh_sanctus_exhaust_start"
		},
	  },
	  {
		DictionaryName = "weap_minismg",
		EffectNames = {
		  "eject_minismg",
		  "eject_minismg_fp"
		},
	  },
	  {
		DictionaryName = "weap_pipebomb",
		EffectNames = {
		  "proj_pipebomb_smoke"
		},
	  },
	  {
		DictionaryName = "proj_indep_firework_v2",
		EffectNames = {
		  "scr_firework_indep_burst_rwb",
		  "scr_firework_indep_spiral_burst_rwb",
		  "scr_xmas_firework_sparkle_spawn",
		  "scr_firework_indep_ring_burst_rwb",
		  "scr_xmas_firework_burst_fizzle",
		  "scr_firework_indep_repeat_burst_rwb"
		},
	  },
	  {
		DictionaryName = "proj_xmas_firework",
		EffectNames = {
		  "scr_firework_xmas_ring_burst_rgw",
		  "scr_firework_xmas_burst_rgw",
		  "scr_firework_xmas_repeat_burst_rgw",
		  "scr_firework_xmas_spiral_burst_rgw",
		  "scr_xmas_firework_sparkle_spawn"
		},
	  },
	  {
		DictionaryName = "proj_xmas_snowball",
		EffectNames = {
		  "exp_air_snowball",
		  "proj_snowball_fuse",
		  "exp_grd_snowball",
		  "proj_snowball_trail"
		},
	  },
	  {
		DictionaryName = "cut_iaaj",
		EffectNames = {
		  "bullet_tracer_xm_thruster_mg",
		  "muz_xm_thruster_mg",
		  "veh_thruster_jet",
		  "veh_xm_thruster_afterburner"
		},
	  },
	  {
		DictionaryName = "cut_sil",
		EffectNames = {
		  "cs_xm_lighter_flame",
		  "cs_xm_cig_exhale_mouth",
		  "cs_xm_cig_smoke",
		  "cs_xm_lighter_sparks",
		  "cs_xm_pred_cloak_full",
		  "cs_xm_pred_minigun_muz_flash",
		  "cs_xm_pred_cloak_startup"
		},
	  },
	  {
		DictionaryName = "cut_silj",
		EffectNames = {
		  "bullet_tracer_xm_thruster_mg",
		  "muz_xm_thruster_mg",
		  "cs_xm_muz_pistol",
		  "veh_thruster_jet",
		  "veh_xm_thruster_afterburner",
		  "cs_xm_prop_stromberg",
		  "cs_xm_eject_pistol",
		  "cs_xm_strom_underwater_trail"
		},
	  },
	  {
		DictionaryName = "scr_xm_aq",
		EffectNames = {
		  "scr_xm_aq_final_kill_plane_delta",
		  "scr_xm_aq_final_kill_thruster",
		  "scr_xm_aq_final_kill_plane_sweep",
		  "scr_xm_aq_final_kill_plane"
		},
	  },
	  {
		DictionaryName = "scr_xm_farm",
		EffectNames = {
		  "scr_xm_dst_elec_crackle",
		  "scr_xm_dst_elec_crackle_sp"
		},
	  },
	  {
		DictionaryName = "scr_xm_heat",
		EffectNames = {
		  "scr_xm_heat_camo"
		},
	  },
	  {
		DictionaryName = "scr_xm_ht",
		EffectNames = {
		  "scr_xm_ht_flare",
		  "scr_xm_ht_package_flare"
		},
	  },
	  {
		DictionaryName = "scr_xm_orbital",
		EffectNames = {
		  "scr_xm_orbital_blast"
		},
	  },
	  {
		DictionaryName = "scr_xm_para",
		EffectNames = {
		  "scr_xm_para_car_smoke"
		},
	  },
	  {
		DictionaryName = "scr_xm_riotvan",
		EffectNames = {
		  "scr_xm_riotvan_fire_back",
		  "scr_xm_riotvan_extinguish",
		  "scr_xm_riotvan_fire_front"
		},
	  },
	  {
		DictionaryName = "scr_xm_spybomb",
		EffectNames = {
		  "scr_xm_spybomb_plane_smoke_trail"
		},
	  },
	  {
		DictionaryName = "scr_xm_stealcar",
		EffectNames = {
		  "scr_xm_stealcar_cargo_exhaust"
		},
	  },
	  {
		DictionaryName = "scr_xm_submarine",
		EffectNames = {
		  "scr_xm_submarine_surface_explosion",
		  "exp_underwater_mine",
		  "scr_xm_submarine_explosion",
		  "scr_xm_submarine_surface_splashes",
		  "scr_xm_stromberg_scanner"
		},
	  },
	  {
		DictionaryName = "veh_akula",
		EffectNames = {
		  "muz_xm_akula_mg_turret",
		  "eject_xm_akula_mg_turret",
		  "bullet_tracer_xm_akula_mg_turret"
		},
	  },
	  {
		DictionaryName = "veh_avenger",
		EffectNames = {
		  "veh_xm_avenger_downwash_default",
		  "veh_xm_avenger_downwash_sand",
		  "veh_xm_avenger_downwash_vegetation",
		  "veh_xm_avenger_downwash_dirt",
		  "veh_xm_vent_plane_avenger",
		  "veh_xm_avenger_downwash_water"
		},
	  },
	  {
		DictionaryName = "veh_barrage",
		EffectNames = {
		  "eject_xm_barrage_mg_turret_rear",
		  "eject_xm_barrage_mg_turret",
		  "eject_xm_barrage_minigun_turret",
		  "muz_xm_barrage_minigun_turret",
		  "bullet_tracer_xm_barrage_turret",
		  "muz_xm_barrage_mg_turret"
		},
	  },
	  {
		DictionaryName = "veh_chernobog",
		EffectNames = {
		  "muz_xm_cherno"
		},
	  },
	  {
		DictionaryName = "veh_deluxo",
		EffectNames = {
		  "veh_xm_deluxo_turbulance_water",
		  "veh_xm_deluxo_turbulance_default",
		  "veh_xm_deluxo_glide_haze",
		  "veh_xm_deluxo_engine_glow",
		  "veh_xm_deluxo_turbulance_dirt",
		  "veh_xm_deluxo_turbulance_foliage",
		  "veh_xm_deluxo_turbulance_sand"
		},
	  },
	  {
		DictionaryName = "veh_khanjali",
		EffectNames = {
		  "proj_xm_khanjali_grenade_trail",
		  "bullet_tracer_xm_khanjali_mg",
		  "muz_xm_khanjali_mg",
		  "muz_xm_khanjali_railgun",
		  "proj_xm_khanjali_railgun_trail",
		  "muz_xm_khanjali_railgun_charge",
		  "eject_xm_khanjali_mg"
		},
	  },
	  {
		DictionaryName = "veh_stromberg",
		EffectNames = {
		  "muz_xm_strom_mg",
		  "veh_xm_strom_underwater_trail",
		  "proj_torpedo_trail",
		  "exp_underwater_torpedo",
		  "muz_torpedo",
		  "veh_prop_stromberg"
		},
	  },
	  {
		DictionaryName = "veh_thruster",
		EffectNames = {
		  "bullet_tracer_xm_thruster_mg",
		  "muz_xm_thruster_mg",
		  "veh_xm_thruster_wreck_fire",
		  "veh_xm_thruster_downwash_foliage",
		  "veh_xm_thruster_downwash_sand",
		  "veh_thruster_jet",
		  "veh_xm_thruster_downwash",
		  "veh_xm_thruster_engine_damage",
		  "muz_xm_thruster_rpg",
		  "veh_xm_thruster_afterburner",
		  "veh_xm_thruster_downwash_dirt",
		  "veh_xm_thruster_downwash_water",
		  "proj_xm_thruster_rpg_trail"
		},
	  },
	  {
		DictionaryName = "veh_volatol",
		EffectNames = {
		  "veh_vent_plane_volatol",
		  "muz_xm_volatol_twinmg",
		  "scr_xm_volatol_turret_camera"
		},
	  },
	  {
		DictionaryName = "weap_xm_revolver",
		EffectNames = {
		  "muz_xm_revolver",
		  "eject_xm_revolver"
		},
	  },
	  {
		DictionaryName = "weap_xm_shotgun_rounds",
		EffectNames = {
		  "tracer_xm_shotgun_inc",
		  "eject_shotgun_exp",
		  "eject_shotgun_exp_fp",
		  "eject_shotgun_hp",
		  "eject_shotgun_hp_fp",
		  "eject_shotgun_ap_fp",
		  "eject_shotgun_ap",
		  "eject_shotgun_inc_fp",
		  "eject_shotgun_inc"
		},
	  },
	  {
		DictionaryName = "scr_adversary",
		EffectNames = {
		  "scr_emp_prop_light"
		},
	  },
	  {
		DictionaryName = "scr_exec_ambient_fm",
		EffectNames = {
		  "scr_ped_foot_banknotes"
		},
	  },
	  {
		DictionaryName = "scr_powerplay",
		EffectNames = {
		  "scr_powerplay_beast_vanish",
		  "scr_powerplay_beast_appear",
		  "sp_powerplay_beast_appear_trails"
		},
	  },
	  {
		DictionaryName = "scr_salvage",
		EffectNames = {
		  "scr_salvage_flare"
		},
	  },
	  {
		DictionaryName = "scr_sell",
		EffectNames = {
		  "scr_vehicle_damage_smoke"
		},
	  },
	  {
		DictionaryName = "scr_tplaces",
		EffectNames = {
		  "scr_tplaces_team_swap",
		  "scr_tplaces_team_swap_nocash"
		},
	  },
	  {
		DictionaryName = "cut_gr_intro",
		EffectNames = {
		  "cs_gr_muz_assault_rifle"
		},
	  },
	  {
		DictionaryName = "scr_gr_bunk",
		EffectNames = {
		  "scr_gr_bunk_drill_spark",
		  "scr_gr_bunk_clean_debris",
		  "scr_gr_bunk_lathe_metal_shards",
		  "scr_gr_bunk_mill_hose_spray",
		  "scr_gr_bunk_clean_blow_debris",
		  "scr_gr_bunk_mill_metal_shards",
		  "scr_gr_bunk_drill_smoke"
		},
	  },
	  {
		DictionaryName = "scr_gr_def",
		EffectNames = {
		  "scr_gr_def_package_flare",
		  "scr_gr_sw_engine_smoke",
		  "scr_gr_def_flare",
		  "scr_gr_warp_in"
		},
	  },
	  {
		DictionaryName = "weap_gr_vehicle_weapons",
		EffectNames = {
		  "proj_gr_moc_cannon_trail",
		  "muz_mounted_turret_tampa_minigun",
		  "muz_mounted_turret_dune_minigun_fp",
		  "bullet_tracer_opp_fp",
		  "proj_mounted_turret_mortar",
		  "eject_mounted_turret_dune_minigun",
		  "eject_mounted_turret_twinmg",
		  "eject_mounted_turret_dune_mg",
		  "eject_mounted_turret_insurgent3_minigun",
		  "muz_mounted_turret_dune_minigun",
		  "muz_mounted_turret_apc_mg",
		  "eject_mounted_turret_tampa_minigun",
		  "eject_mounted_turret_quadmg",
		  "muz_gr_vehicle_mg",
		  "muz_mounted_turret_dune_mg",
		  "muz_gr_vehicle_opp",
		  "bullet_tracer_turret_gr",
		  "muz_mounted_turret_twinmg_trailer",
		  "bullet_tracer_turret_gr_tampa",
		  "muz_mounted_turret_apc",
		  "muz_mounted_turret_twinmg",
		  "muz_mounted_turret_apc_missile"
		},
	  },
	  {
		DictionaryName = "weap_gr_weapons",
		EffectNames = {
		  "bullet_tracer_gr_tintable"
		},
	  },
	  {
		DictionaryName = "cut_hs4",
		EffectNames = {
		  "cut_hs4_cig_exhale_mouth",
		  "cut_hs4_champagne_spray",
		  "cut_hs4_cctv_animal_rip",
		  "cut_hs4_cig_smoke",
		  "cut_hs4_cctv_blood_pool",
		  "cut_hs4_cctv_animal_maul",
		  "cut_hs4_cctv_animal_bite",
		  "cut_hs4_plane_exhaust",
		  "cut_hs4_plane_exhaust_velum",
		  "cut_hs4_champagne_pour",
		  "cut_hs4_plane_land_disturb_dust",
		  "cut_hs4_winky_exhaust",
		  "cut_hs4_camera_flash",
		  "cut_hs4_wrench_bang_metal",
		  "cut_hs4_plane_land_wheel_skid"
		},
	  },
	  {
		DictionaryName = "cut_hs4f",
		EffectNames = {
		  "cut_hs4f_sub_propeller",
		  "cut_hs4f_app_exhaust_plane",
		  "cut_hs4f_scuba_breath",
		  "cut_hs4f_exp_gate",
		  "cut_hs4f_photo_burn",
		  "cut_hs4f_flipper_bubbles"
		},
	  },
	  {
		DictionaryName = "scr_ih_club",
		EffectNames = {
		  "scr_ih_club_sparkler"
		},
	  },
	  {
		DictionaryName = "scr_ih_col",
		EffectNames = {
		  "scr_ih_col_poster_spraytag"
		},
	  },
	  {
		DictionaryName = "scr_ih_fin",
		EffectNames = {
		  "scr_ih_fin_glass_cutter_overheat",
		  "scr_ih_fin_cutter_nozzle",
		  "scr_ih_fin_torch_flame",
		  "scr_ih_fin_grille_singed",
		  "scr_ih_fin_glass_cutter_cut",
		  "scr_ih_fin_torch_lock_break",
		  "scr_ih_fin_cutter_flame",
		  "scr_ih_fin_grille_cutting",
		  "scr_ih_fin_torch_lock_cutting",
		  "scr_ih_fin_torch_nozzle",
		  "scr_ih_fin_explosive_charge",
		  "scr_ih_fin_grille_break",
		  "scr_ih_fin_torch_lock_singed"
		},
	  },
	  {
		DictionaryName = "scr_ih_sub",
		EffectNames = {
		  "scr_ih_sub_water_drips",
		  "scr_ih_sub_propeller",
		  "scr_ih_sub_surface",
		  "scr_ih_sub_missile_launch",
		  "scr_ih_sub_pool_door"
		},
	  },
	  {
		DictionaryName = "veh_ih_alk",
		EffectNames = {
		  "veh_ih_exhaust_afterburner_alk"
		},
	  },
	  {
		DictionaryName = "weap_ih_gpistol",
		EffectNames = {
		  "muz_ih_gpistol",
		  "eject_ih_gpistol_fp",
		  "eject_ih_gpistol"
		},
	  },
	  {
		DictionaryName = "weap_ih_patrolboat",
		EffectNames = {
		  "muz_ih_turret_patrolboat",
		  "eject_ih_turret_patrolboat",
		  "eject_ih_turret_patrolboat_twinmg",
		  "bullet_tracer_ih_patrolboat"
		},
	  },
	  {
		DictionaryName = "weap_ih_vehicle_ann2",
		EffectNames = {
		  "eject_heli_gun_ann"
		},
	  },
	  {
		DictionaryName = "scr_lowrider",
		EffectNames = {
		  "scr_lowrider_flare"
		},
	  },
	  {
		DictionaryName = "weap_dbshotgun",
		EffectNames = {
		  "eject_dbshotgun_fp",
		  "eject_dbshotgun"
		},
	  },
	  {
		DictionaryName = "scr_mp_cig_plane",
		EffectNames = {
		  "ent_anim_lighter_sparks_plane",
		  "ent_anim_cig_exhale_mth_plane",
		  "ent_anim_lighter_flame_plane",
		  "ent_anim_cig_smoke_plane",
		  "ent_anim_cig_exhale_nse_plane"
		},
	  },
	  {
		DictionaryName = "scr_sr_adversary",
		EffectNames = {
		  "scr_sr_lg_take_zone",
		  "scr_sr_lg_weapon_highlight",
		  "scr_sr_dst_cardboard"
		},
	  },
	  {
		DictionaryName = "scr_sr_tr",
		EffectNames = {
		  "scr_sr_tr_car_change",
		  "scr_sr_tr_player_glow"
		},
	  },
	  {
		DictionaryName = "scr_stunts",
		EffectNames = {
		  "scr_stunts_fire_ring",
		  "scr_stunts_shotburst",
		  "scr_stunts_bomb_fuse",
		  "scr_stunts_shotburst_spawn",
		  "scr_stunts_bomb_fuse_sp"
		},
	  },
	  {
		DictionaryName = "scr_sum_gy",
		EffectNames = {
		  "scr_sum_gy_felon_fire_back",
		  "scr_sum_gy_water_bomb_trail",
		  "scr_sum_gy_gauntlet_fire_back",
		  "scr_sum_gy_exp_water_bomb",
		  "scr_sum_gy_tempesta_fire_back",
		  "scr_sum_gy_felon_fire_front",
		  "scr_sum_gy_tempesta_fire_front",
		  "scr_sum_gy_gauntlet_fire_front",
		  "scr_sum_gy_mule4_fire_front",
		  "scr_sum_gy_mule4_fire_back"
		},
	  },
	  {
		DictionaryName = "scr_sum_ow",
		EffectNames = {
		  "scr_sum_ow_race_repair_smoke"
		},
	  },
	  {
		DictionaryName = "scr_sum_q3",
		EffectNames = {
		  "scr_sum_q3_block_destroy",
		  "scr_sum_q3_block_destroy_charge"
		},
	  },
	  {
		DictionaryName = "cut_tn",
		EffectNames = {
		  "cut_tn_shop_drug_dust",
		  "cut_tn_swat_van_skid_smoke",
		  "cut_tn_punch_mouth_blood",
		  "cut_tn_punch_blood_drips",
		  "cut_tn_meet_burnout_smoke"
		},
	  },
	  {
		DictionaryName = "scr_tn_ia",
		EffectNames = {
		  "scr_tn_ia_dig_dirt_left",
		  "scr_tn_ia_dig_dirt_right",
		  "scr_tn_ia_dig_dirt_forward"
		},
	  },
	  {
		DictionaryName = "scr_tn_meet",
		EffectNames = {
		  "scr_tn_meet_sandbox_burnout_smoke",
		  "scr_tn_meet_cig_exhale_mouth",
		  "scr_tn_meet_cig_exhale_nose",
		  "scr_tn_meet_cig_smoke",
		  "scr_tn_meet_phone_camera_flash"
		},
	  },
	  {
		DictionaryName = "scr_tn_phantom",
		EffectNames = {
		  "scr_tn_phantom_flames"
		},
	  },
	  {
		DictionaryName = "scr_tn_pr",
		EffectNames = {
		  "scr_tn_pr_cig_smoke"
		},
	  },
	  {
		DictionaryName = "scr_tn_slick",
		EffectNames = {
		  "scr_tn_exp_mine_slick_nodecal"
		},
	  },
	  {
		DictionaryName = "scr_tn_tr",
		EffectNames = {
		  "scr_exp_train_brake",
		  "scr_tn_tr_door_explosion",
		  "scr_tn_tr_door_smoke",
		  "scr_tn_tr_angle_grinder_sparks"
		},
	  },
	  {
		DictionaryName = "cut_mpcas",
		EffectNames = {
		  "cut_mpcas_eject_pistol",
		  "cut_mpcas_bul_brick",
		  "cut_mpcas_champagne_spray",
		  "cut_mpcas_wine_pour",
		  "cut_mpcas_muz_pistol",
		  "cut_mpcas_blood_entry",
		  "cut_mpcas_muz_smg",
		  "cut_mpcas_champagne_pour",
		  "cut_mpcas_helicopter_downwash",
		  "cut_mpcas_eject_smg"
		},
	  },
	  {
		DictionaryName = "cut_mpsui",
		EffectNames = {
		  "cut_mpsui_champagne_spray"
		},
	  },
	  {
		DictionaryName = "cut_vw_casino_doors",
		EffectNames = {
		  "cs_vw_vehicle_smoke",
		  "cs_vw_casino_door_smash"
		},
	  },
	  {
		DictionaryName = "scr_vw_finale",
		EffectNames = {
		  "scr_vw_finale_heli_smoke"
		},
	  },
	  {
		DictionaryName = "scr_vw_oil",
		EffectNames = {
		  "scr_vw_oil_tanker_explosion"
		},
	  }
  
}

-- Debug Commands
print("HELLO", Config.Debug)
if Config.Debug then 
	print("HELLO222", Config.Debug)
	RegisterCommand("tableTest", function()
		local boneCoords = nil
		local pId = PlayerPedId()
		local pIdCoords = GetEntityCoords(pId)
		local size = 0.05
		boneCoords = GetPedBoneCoords(pId, 11816, 0.0, 1.0, 0.0) 
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				DrawMarker(28, boneCoords.x, boneCoords.y, boneCoords.z + 0.6, 0, 0, 0, 0, 0, 0, size, size, size, 0, 150, 200, 255, false, false, 0, false)
			end
		end)
		local size2 = 2.0
		local stop = false
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(0)
				if IsControlJustReleased(0,38) then
					stop = not stop
				end
			end
		end)
		local attempt = 0
		for k,v in pairs(megatable) do
			RequestNamedPtfxAsset(v.DictionaryName)
			while not HasNamedPtfxAssetLoaded(v.DictionaryName) and attempt <= 250 do
				Citizen.Wait(1)
				attempt = attempt + 1
			end
			attempt = 0
			for _,name in pairs(v.EffectNames) do
				print(v.DictionaryName, name, boneCoords, size2)
				UseParticleFxAssetNextCall(v.DictionaryName)
				local primer = StartParticleFxLoopedAtCoord(name, boneCoords.x, boneCoords.y, boneCoords.z, 0.0, 0.0, 0.0, size2, false, false, false)
				Citizen.Wait(2000)
				while stop do
					Citizen.Wait(0)
				end
				StopParticleFxLooped(primer, 0)
			end
		end
	end, false)

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
