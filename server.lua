local QBCore = nil
local ESX = nil
local vehicleTable = 'owned_vehicles' 

CreateThread(function()
    if GetResourceState('es_extended') == 'started' then
        ESX = exports["es_extended"]:getSharedObject()
        vehicleTable = 'owned_vehicles'
        print("^2[DX AdminGiveCar]^7 ESX detected, using table: owned_vehicles")
    elseif GetResourceState('qb-core') == 'started' then
        QBCore = exports['qb-core']:GetCoreObject()
        vehicleTable = 'player_vehicles'
        print("^2[DX AdminGiveCar]^7 QBCore detected, using table: player_vehicles")
    else
        print("^1[DX AdminGiveCar]^7 Framework not found! Script will run standalone, but DB insert may fail.")
    end
end)


local function sendDiscordLog(adminName, targetName, targetId, vehicle, plate)
    if not Config.Webhook or Config.Webhook == "" then
        print("^1[DX AdminGiveCar]^7 Webhook ayarlanmamış, log gönderilmiyor.")
        return
    end

    local embed = {
        {
            ["title"] = "🚔 DX AdminGiveCar",
            ["description"] = string.format("**Admin:** %s\n**Oyuncu:** %s (ID: %s)\n**Araç:** %s\n**Plaka:** %s", adminName, targetName, targetId, vehicle, plate),
            ["color"] = 3447003, -- mavi
            ["footer"] = {
                ["text"] = os.date("%Y-%m-%d %H:%M:%S")
            }
        }
    }

    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, "POST", json.encode({ embeds = embed }), { ["Content-Type"] = "application/json" })
end

RegisterNetEvent("dx-admingivecar:spawn", function(data)
    local src = source

    if not IsPlayerAceAllowed(src, "dxadmingivecar.use") then
        print(("Yetkisiz giriş: %s denedi!"):format(GetPlayerName(src)))
        return
    end

    local target = tonumber(data.playerId) or src
    if not GetPlayerName(target) then
        TriggerClientEvent("chat:addMessage", src, { args = { "^1DX AdminGiveCar", "Hedef oyuncu bulunamadı!" } })
        return
    end

    local identifier
    if ESX then
        local xPlayer = ESX.GetPlayerFromId(target)
        identifier = xPlayer.identifier
    elseif QBCore then
        local Player = QBCore.Functions.GetPlayer(target)
        identifier = Player.PlayerData.citizenid
    else
        identifier = GetPlayerIdentifier(target, 0)
    end

    local plate = (data.plate ~= "" and data.plate) or ("DX"..math.random(1111,9999))
    local props = json.encode({
        model = joaat(data.model),
        plate = plate,
        color1 = data.color1 or { r = 255, g = 255, b = 255 }
    })

    if ESX then
        MySQL.insert('INSERT INTO owned_vehicles (owner, plate, vehicle, stored) VALUES (?, ?, ?, ?)', {
            identifier, plate, props, 0
        })
    elseif QBCore then
        MySQL.insert('INSERT INTO player_vehicles (citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?)', {
            identifier, data.model, joaat(data.model), props, plate, "none", 0
        })
    end

    TriggerClientEvent("dx-admingivecar:spawnCar", target, {
        model = data.model,
        plate = plate,
        color1 = data.color1
    })


    if QBCore then
        TriggerClientEvent("vehiclekeys:client:SetOwner", target, plate)
    elseif ESX then
        TriggerEvent('esx_vehiclelock:givekey', target, plate)
    end

    sendDiscordLog(GetPlayerName(src), GetPlayerName(target), target, data.model, plate)

    TriggerClientEvent("chat:addMessage", src, { args = { "^2DX AdminGiveCar", "Başarıyla "..GetPlayerName(target).." (ID: "..target..") için araç verildi!" } })
    print(("Admin %s oyuncuya [%s] araç verdi: %s [%s]"):format(GetPlayerName(src), identifier, data.model, plate))
end)
