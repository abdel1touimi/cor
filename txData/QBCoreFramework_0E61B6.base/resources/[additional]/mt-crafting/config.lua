Config = {
    ["Main"] = {
        ["handcuffs"] = { -- item name
            itemName = "handcuffs", -- item name
            label = "HANDCUFFS", -- item label
            craftingTime = 3000,
            level = 0, -- amount of level requeried
            points = 1, -- how many points you win in 1 craft
            lostpoints = 1, -- how many points you lost if fail the craft
            chance = 70, -- chance to to success craft
            items = { -- requeried items
                [1] = {
                    item = "iron",
                    amount = 10,
                },
                [2] = {
                    item = "steel",
                    amount = 10,
                },
                [3] = {
                    item = "metalscrap",
                    amount = 10,
                },
                [4] = {
                    item = "aluminum",
                    amount = 10,
                },
            }
        },
        ["weapon_hatchet"] = { -- item name
            itemName = "weapon_hatchet", -- item name
            label = "Hatchet", -- item label
            craftingTime = 5000,
            level = 10, -- amount of level requeried
            points = 2, -- how many points you win in 1 craft
            lostpoints = 1, -- how many points you lost if fail the craft
            chance = 70, -- chance to to success craft
            items = { -- requeried items
                [1] = {
                    item = "iron",
                    amount = 20,
                },
                [2] = {
                    item = "steel",
                    amount = 50,
                },
                [3] = {
                    item = "rubber",
                    amount = 10,
                },
            }
        },
        ["armor"] = { -- item name
            itemName = "armor", -- item name
            label = "Armor", -- item label
            craftingTime = 5000,
            level = 30, -- amount of level requeried
            points = 3, -- how many points you win in 1 craft
            lostpoints = 1, -- how many points you lost if fail the craft
            chance = 70, -- chance to to success craft
            items = { -- requeried items
                [1] = {
                    item = "iron",
                    amount = 20,
                },
                [2] = {
                    item = "steel",
                    amount = 50,
                },
                [3] = {
                    item = "plastic",
                    amount = 20,
                },
                [4] = {
                    item = "aluminum",
                    amount = 20,
                },
            }
        },
        ["pistol_ammo"] = { -- item name
            itemName = "pistol_ammo", -- item name
            label = "Pistol ammo", -- item label
            craftingTime = 3000,
            level = 200, -- amount of level requeried
            points = 2, -- how many points you win in 1 craft
            lostpoints = 1, -- how many points you lost if fail the craft
            chance = 70, -- chance to to success craft
            items = { -- requeried items
                [1] = {
                    item = "copper",
                    amount = 20,
                },
                [2] = {
                    item = "steel",
                    amount = 20,
                },
                [3] = {
                    item = "metalscrap",
                    amount = 20,
                },
                [4] = {
                    item = "aluminum",
                    amount = 20,
                },
            }
        },

    },
    ['MainLocation'] = {
        ['UseLocation'] = true,
        ['Location'] = vector3(1189.55, 2641.58, 38.4),
    },
    ['Logs'] = {
        ['UseLogs'] = true,
    },
}

Lang = {
    ['craftSuccess'] = 'Crafted ',
    ['craftFailed1'] = 'You failed the craft and lost ',
    ['craftFailed2'] = 'You failed the craft...',
    ['points'] = ' points...',
    ['crafting'] = 'CRAFTING ',
    ['menuHeader'] = 'Crafting Menu',
    ['errorRightItems'] = 'You do not have the right items...',
    ['targetLabel'] = 'Craft',
    ['pointsCommand1'] = 'You have ',
    ['pointsCommand2'] = ' points!',
    ['targetPoints'] = 'Check Points',
}