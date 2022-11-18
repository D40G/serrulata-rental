![Serrulata Studios Banner](https://i.imgur.com/wG4hycs.gif)


# Installation

* Download the script and put it in the [resource] folder.

Add the following code to your server.cfg/resouces.cfg
```
ensure ss-rental
```

# Dependencies
* [qb-menu](https://github.com/qbcore-framework/qb-menu)

# Put this line on shared.lua in your core.

```
["rentalpapers"]				 = {["name"] = "rentalpapers", 					["label"] = "Rental Papers", 			["weight"] = 50, 		["type"] = "item", 		["image"] = "rentalpapers.png", 		["unique"] = true, 		["useable"] = false, 	["shouldClose"] = false, 	["combinable"] = nil, 	["description"] = "This car was taken out through car rental."},
```

# Inventory image
![rentalpapers](https://i.imgur.com/GI0FjPG.png)

- Add the rentalpapers.png to your - inventory -> html -> images

# Adding the RentalPapers to qb-inventory

* Go to qb-inventory -> html -> js -> app.js and between lines 500-600 add the following code

```lua

          } else if (itemData.name == "rentalpapers") {
            $(".item-info-title").html('<p>' + itemData.label + '</p>')
            $(".item-info-description").html('<p><strong>Plate: </strong><span>'+ itemData.info.label + '</span></p>');

```
