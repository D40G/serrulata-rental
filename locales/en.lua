local Translations = {
    error = {
        nomoney = 'No Enough Money',
        nopapers = 'I cannot take a vehicle without its papers.',
        norented = 'This is not a rented vehicle.',
        nonearbyvehicle = 'I dont see any rented vehicle, make sure its nearby.'

    },
    success = {
        hasbeen = 'has been rented for $ ',
        hasreturn = 'You have returned your rented vehicle and received $'
    },
}

Lang = Lang or Locale:new({
    phrases = Translations,
    warnOnMissing = true
})