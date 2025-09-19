RegisterCommand("admingivecar", function()
    SetNuiFocus(true, true)
    SendNUIMessage({ action = "open" })
end)

RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)


RegisterNUICallback("spawnCar", function(data, cb)
    TriggerServerEvent("dx-admingivecar:spawn", data)
    cb("ok")
end)

RegisterNetEvent("dx-admingivecar:spawnCar", function(data)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)

    local model = joaat(data.model)
    if not IsModelInCdimage(model) then
        return print("Model bulunamadı:", data.model)
    end

    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, GetEntityHeading(ped), true, false)
    SetPedIntoVehicle(ped, veh, -1)

    SetVehicleNumberPlateText(veh, data.plate)

    if data.color1 then
        SetVehicleCustomPrimaryColour(veh, data.color1.r, data.color1.g, data.color1.b)
    end

    SetEntityAsNoLongerNeeded(veh)
    SetModelAsNoLongerNeeded(model)

    TriggerEvent("chat:addMessage", { args = { "^2DX AdminGiveCar", "Araç spawnlandı ve kaydedildi! Plaka: "..data.plate } })
end)
