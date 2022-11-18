print("^2Serrulata-Studios ^7v^41^7.^40^7.^40 ^7- ^2SS-Rental^7")

Config = {}
-- Add Multiple Vehicles 
Config.vehicleList = {
    { name = "Bison", model = "bison", price = 300 },
    { name = "Futo", model = "Futo", price = 250 },
    { name = "dilettante", model = "dilettante", price = 200 },
}

Config.Locations = { 
    ["rentalstations"] = {
        [1] = {label = "Rental Stations", coords = vector3(-40.66, -1674.58, 29.48)} -- Blip locations 
    },

    ["box"] = {
        [1] = vector3(-40.66, -1674.58, 29.48) -- Player Interaction QB-Target / ox_target
    },
}

Config.VehicleSpawn = {
	[1] = { 
		vehiclespawn = {
			coords = vector3(-50.71, -1688.0, 29.48), -- Vehilce Spawn Nearset Rental Station
			heading = 272.43,
		},
	},
}
