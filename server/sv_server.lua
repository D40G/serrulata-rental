QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('ss-rental:attemptPurchase')
AddEventHandler('ss-rental:attemptPurchase', function(car,price)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local cash = Player.PlayerData.money.cash
    if cash >= price then
        Player.Functions.RemoveMoney("cash",price,"rentals")
        TriggerClientEvent('ss-rental:vehiclespawn', source, car)
        TriggerClientEvent('QBCore:Notify', src, car .. Lang:t('success.hasbeen') .. price .. '', "success")
    else
        TriggerClientEvent('ss-rental:attemptvehiclespawnfail', source)
    end
end)

RegisterServerEvent('ss-rental:giverentalpaperServer')
AddEventHandler('ss-rental:giverentalpaperServer', function(model, plateText)
    local src = source
    local PlayerData = QBCore.Functions.GetPlayer(src)
    local info = {
        label = plateText
    }
    PlayerData.Functions.AddItem('rentalpapers', 1, false, info)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['rentalpapers'], "add")
end)

RegisterServerEvent('ss-rental:server:payreturn')
AddEventHandler('ss-rental:server:payreturn', function(model)
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    for k,v in pairs(Config.vehicleList) do 
        if string.lower(v.model) == model then
            local payment = v.price / 2
            Player.Functions.AddMoney("cash",payment,"rental-return")
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.hasreturn') .. payment .. '', "success")
        end
    end
end)

RegisterNetEvent('ss-rental:server:removepapers', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ItemData = Player.Functions.GetItemByName("rentalpapers")
    
    if ItemData ~= nil then
        Player.Functions.RemoveItem("rentalpapers", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["rentalpapers"], "remove")
    end
end)

QBCore.Functions.CreateCallback('ss-rental:server:hasrentalpapers', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local Item = Player.Functions.GetItemByName("rentalpapers")
    if Item ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
