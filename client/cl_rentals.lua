QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("ss-rental:vehiclelist", function()
  for i = 1, #Config.vehicleList do
        	local MenuOptions = {
        		{
        			header = "Vehicle Rental",
        			isMenuHeader = true
        		},
        	}

        	for k, v in pairs(Config.vehicleList) do
          
          
        		MenuOptions[#MenuOptions+1] = {
        			header = "<h8>"..v.name.."</h>",
              txt = "$"..v.price..".00",
        			params = {
                event = "ss-rental:attemptvehiclespawn",
                args = {
                  id = v.model,
                  price = v.price
                }
        			}
        		}
        	end
        	exports['qb-menu']:openMenu(MenuOptions)
      end
end)

RegisterNetEvent("ss-rental:attemptvehiclespawn", function(vehicle)
  TriggerServerEvent("ss-rental:attemptPurchase",vehicle.id, vehicle.price)
end)

RegisterNetEvent("ss-rental:attemptvehiclespawnfail", function()
  QBCore.Functions.Notify(Lang:t('error.nomoney'), "error")
end)

RegisterNetEvent("ss-rental:giverentalpaperClient", function(model, plate, name)
  local info = {
    data = "Model : "..tostring(model).." | Plate : "..tostring(plate)..""
  }
  TriggerServerEvent('QBCore:Server:AddItem', "rentalpapers", 1, info)
end)

RegisterNetEvent("ss-rental:returnvehicle", function()
  local car = GetVehiclePedIsIn(PlayerPedId(),true)

  if car ~= 0 then
    local plate = GetVehicleNumberPlateText(car)
    local vehname = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(car)))
    if string.find(tostring(plate), "LM2") then
      QBCore.Functions.TriggerCallback('ss-rental:server:hasrentalpapers', function(HasItem)
        if HasItem then
          TriggerServerEvent('ss-rental:server:removepapers')
          TriggerServerEvent('ss-rental:server:payreturn',vehname)
          DeleteVehicle(car)
          DeleteEntity(car)
        else
          QBCore.Functions.Notify(Lang:t('error.nopapers'), "error")
        end
      end)
    else
      QBCore.Functions.Notify(Lang:t('error.norented'), "error")
    end

  else
    QBCore.Functions.Notify(Lang:t('error.nonearbyvehicle'), "error")
  end
end)

RegisterNetEvent("ss-rental:vehiclespawn", function(data, cb)
  local model = data

  local closestDist = 10000
  local closestSpawn = nil
  local pcoords = GetEntityCoords(PlayerPedId())
  
  for i, v in ipairs(Config.VehicleSpawn) do
      local dist = #(v.vehiclespawn.coords - pcoords)
  
      if dist < closestDist then
          closestDist = dist
          closestSpawn = v.vehiclespawn
      end
  end

  RequestModel(model)
  while not HasModelLoaded(model) do
      Citizen.Wait(0)
  end
  SetModelAsNoLongerNeeded(model)

  local veh = CreateVehicle(model, closestSpawn.coords.x, closestSpawn.coords.y, closestSpawn.coords.z, closestSpawn.heading, true)
  Citizen.Wait(100)
  SetEntityAsMissionEntity(veh, true, true)
  SetModelAsNoLongerNeeded(model)
  SetVehicleOnGroundProperly(veh)
  SetVehicleNumberPlateText(veh, "LM2"..tostring(math.random(1000, 9999)))
  local plate = GetVehicleNumberPlateText(veh)
  TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))

  local plateText = GetVehicleNumberPlateText(veh)
  TriggerServerEvent("ss-rental:giverentalpaperServer",model ,plateText)

  local timeout = 10
  while not NetworkDoesEntityExistWithNetworkId(veh) and timeout > 0 do
      timeout = timeout - 1
      Wait(1000)
  end
end)

CreateThread(function()
  for _, rental in pairs(Config.Locations["rentalstations"]) do
      local blip = AddBlipForCoord(rental.coords.x, rental.coords.y, rental.coords.z)
      SetBlipSprite(blip, 326)
      SetBlipAsShortRange(blip, true)
      SetBlipScale(blip, 0.5)
      SetBlipColour(blip, 5)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(rental.label)
      EndTextCommandSetBlipName(blip)
  end
end)

local function RemoveBlip()
  for _, rental in pairs(Config.Locations["rentalstations"]) do
    local blip = AddBlipForCoord(rental.coords.x, rental.coords.y, rental.coords.z)
    RemoveBlip(blip)
  end
end

CreateThread(function()
  for _, rental in pairs(Config.Locations["box"]) do
      exports['qb-target']:AddBoxZone("box" .. _, vector3(rental.x, rental.y, rental.z), 1.5, 1, {
          name = "box" .. _,
          debugPoly = false,
          heading = -20,
          minZ = rental.z - 2,
          maxZ = rental.z + 2,
      }, {
          options = {
            {
              event = "ss-rental:vehiclelist",
              icon = "fas fa-circle",
              label = "Rent vehicle",
            },
            {
                event = "ss-rental:returnvehicle",
                icon = "fas fa-circle",
                label = "Return Vehicle (Receive Back 50% of original price)",
            },
          },
        distance = 1.5
      })
  end
end)

local function RemoveZone()
  exports['qb-target']:RemoveZone("box")
end

AddEventHandler('onResourceStart', function(resourceName) 
  if (GetCurrentResourceName() ~= resourceName) then
    print('ss-rental Started')
  end
end)

AddEventHandler('onResourceStop', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    RemoveBlip()
    RemoveZone() 
  end
end)