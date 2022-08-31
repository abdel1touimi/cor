local Translations = {
    error = {
        testdrive_alreadyin = "Already in test drive",
        testdrive_return = "This is not your test drive vehicle",
        Invalid_ID = "Invalid Player Id Supplied",
        playertoofar = "This player is not close enough",
        notenoughmoney = "Not enough money",
        minimumallowed = "Minimum payment allowed is $",
        overpaid = "You overpaid",
        alreadypaid = "Vehicle is already paid off",
        notworth = "Vehicle is not worth that much",
        downtoosmall = "Down payment too small",
        exceededmax = "Exceeded maximum payment amount",
        repossessed = "Your vehicle with plate %{plate} has been repossessed",
        buyerinfo = "Couldn\'t get buyer info",
        notinveh = "You must be in the vehicle you want to transfer",
        vehinfo = "Couldn\'t get vehicle info",
        notown = "You don\'t own this vehicle",
        buyertoopoor = "The buyer doesn\'t have enough money",
        nofinanced = "You don't have any financed vehicles",
        financed = "This vehicle is financed",
    },
    success = {
        purchased = "Congratulations on your purchase!",
        earned_commission = "You earned $ %{amount} in commission",
        gifted = "You gifted your vehicle",
        received_gift = "You were gifted a vehicle",
        soldfor = "You sold your vehicle for $",
        boughtfor = "You bought a vehicle for $",
    },
    menus = {
        vehHeader_header = "Vehicle Options",
        vehHeader_txt = "Interact with the current vehicle",
        financed_header = "Financed Vehicles",
        finance_txt = "Browse your owned vehicles",
        returnTestDrive_header = "Finish Test Drive",
        goback_header = "Go Back",
        veh_price = "Price: $",
        veh_platetxt = "Plate: ",
        veh_finance = "Vehicle Payment",
        veh_finance_balance = "Total Balance Remaining",
        veh_finance_currency = "$",
        veh_finance_total = "Total Payments Remaining",
        veh_finance_reccuring = "Recurring Payment Amount",
        veh_finance_pay = "Make a payment",
        veh_finance_payoff = "Payoff vehicle",
        veh_finance_payment = "Payment Amount ($)",
        submit_text = "Submit",
        test_header = "Test Drive",
        finance_header = "Finance Vehicle",
        swap_header = "Swap Vehicle",
        swap_txt = "Change currently selected vehicle",
        financesubmit_downpayment = "Down Payment Amount - Min ",
        financesubmit_totalpayment = "Total Payments - Max ",
        --Free Use
        freeuse_test_txt = "Test drive currently selected vehicle",
        freeuse_buy_header = "Buy Vehicle",
        freeuse_buy_txt = "Purchase currently selected vehicle",
        freeuse_finance_txt = "Finance currently selected vehicle",
        --Managed
        managed_test_txt = "Allow player for test drive",
        managed_sell_header = "Sell Vehicle",
        managed_sell_txt = "Sell vehicle to Player",
        managed_finance_txt = "Finance vehicle to Player",
        submit_ID = "Server ID (#)",
    },
    general = {
        testdrive_timer = "Test Drive Time Remaining:",
        vehinteraction = "Vehicle Interaction",
        testdrive_timenoti = "You have %{testdrivetime} minutes remaining",
        testdrive_complete = "Vehicle test drive complete",
        paymentduein = "Your vehicle payment is due within %{time} minutes",
        command_transfervehicle = "Gift or sell your vehicle",
        command_transfervehicle_help = "ID of buyer",
        command_transfervehicle_amount = "Sell amount (optionnal)",
    }
}
Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
