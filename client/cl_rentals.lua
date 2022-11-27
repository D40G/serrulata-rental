QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent("Serrulata-rental:vehiclelist", function()
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
                event = "Serrulata-rental:attemptvehiclespawn",
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

RegisterNetEvent("Serrulata-rental:attemptvehiclespawn", function(vehicle)
  TriggerServerEvent("Serrulata-rental:attemptPurchase",vehicle.id, vehicle.price)
end)

RegisterNetEvent("Serrulata-rental:attemptvehiclespawnfail", function()
  QBCore.Functions.Notify(Lang:t('error.nomoney'), "error")
end)

RegisterNetEvent("Serrulata-rental:giverentalpaperClient", function(model, plate, name)
  local info = {
    data = "Model : "..tostring(model).." | Plate : "..tostring(plate)..""
  }
  TriggerServerEvent('QBCore:Server:AddItem', "rentalpapers", 1, info)
end)

RegisterNetEvent("Serrulata-rental:returnvehicle", function()
  local car = GetVehiclePedIsIn(PlayerPedId(),true)

  if car ~= 0 then
    local plate = GetVehicleNumberPlateText(car)
    local vehname = string.lower(GetDisplayNameFromVehicleModel(GetEntityModel(car)))
    if string.find(tostring(plate), "LM2") then
      QBCore.Functions.TriggerCallback('Serrulata-rental:server:hasrentalpapers', function(HasItem)
        if HasItem then
          TriggerServerEvent('Serrulata-rental:server:removepapers')
          TriggerServerEvent('Serrulata-rental:server:payreturn',vehname)
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

RegisterNetEvent("Serrulata-rental:vehiclespawn", function(data, cb)
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
  TriggerServerEvent("Serrulata-rental:giverentalpaperServer",model ,plateText)

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
              event = "Serrulata-rental:vehiclelist",
              icon = "fas fa-circle",
              label = "Rent vehicle",
            },
            {
                event = "Serrulata-rental:returnvehicle",
                icon = "fas fa-circle",
                label = "Return Vehicle (Receive Back 50% of original price)",
            },
          },
        distance = 1.5
      })
  end
end)


AddEventHandler('onResourceStart', function(resource)
   if resource == GetCurrentResourceName() then
    print("^2Serrulata-Studios ^7v^41^7.^40^7.^40 ^7- ^2Serrulata-Rental^7")
   end
end)

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
      print('Serrulata-rental Stopped')
      exports['qb-target']:RemoveZone("box")
   end
end)