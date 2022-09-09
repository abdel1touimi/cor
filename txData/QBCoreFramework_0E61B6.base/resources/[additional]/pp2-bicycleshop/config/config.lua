Config = Config or {}

Config.BicycleShop = {
  { -- shop 1
    name = 'bicycle1',
    VehicleSpawn = vector4(140.42, -575.55, 43.87, 74.4),
    coords = vector3(142.48, -575.99, 43.87),
    showBlip = true,
    blipData = {
      sprite = 226,
      display = 4,
      scale = 0.65,
      colour = 25,
      title = "Bicycle Shop1"
    },
    ped = {
      model = 'a_m_y_roadcyc_01',
      label = 'Open bicycles list',
      coords = vector4(142.48, -575.99, 42.80, 204.27),
      scenario = 'WORLD_HUMAN_STAND_MOBILE',
    },
  },
  -- { -- shop 2
  --   name = 'bicycle2',
  --   VehicleSpawn = vector4(161.08, -573.06, 43.89, 214.01),
  --   coords = vector3(154.42, -567.89, 42.9),
  --   showBlip = true,
  --   blipData = {
  --     sprite = 226,
  --     display = 4,
  --     scale = 0.65,
  --     colour = 25,
  --     title = "Bicycle Shop2"
  --   },
  --   ped = {
  --     model = 'a_m_y_roadcyc_01',
  --     label = 'Open bicycles list',
  --     coords = vector4(154.42, -567.89, 43.9, 358.82),
  --     scenario = 'WORLD_HUMAN_STAND_MOBILE',
  --   },
  -- },
}

Config.Bicycles = {
  --- Cycles
	['bmx'] = {
		['name'] = 'BMX',
    ['brand'] = 'Bike',
		['model'] = 'bmx',
		['price'] = 160,
		['category'] = 'cycles',
		['hash'] = `bmx`,
		['shop'] = 'pdm',
	},
	['cruiser'] = {
		['name'] = 'Cruiser',
    ['brand'] = 'Bike',
		['model'] = 'cruiser',
		['price'] = 510,
		['category'] = 'cycles',
		['hash'] = `cruiser`,
		['shop'] = 'pdm',
	},
	['fixter'] = {
		['name'] = 'Fixter',
    ['brand'] = 'Bike',
		['model'] = 'fixter',
		['price'] = 225,
		['category'] = 'cycles',
		['hash'] = `fixter`,
		['shop'] = 'pdm',
	},
	['scorcher'] = {
		['name'] = 'Scorcher',
    ['brand'] = 'Bike',
		['model'] = 'scorcher',
		['price'] = 280,
		['category'] = 'cycles',
		['hash'] = `scorcher`,
		['shop'] = 'pdm',
	},
	['tribike'] = {
		['name'] = 'Tri Bike',
    ['brand'] = 'Bike',
		['model'] = 'tribike',
		['price'] = 500,
		['category'] = 'cycles',
		['hash'] = `tribike`,
		['shop'] = 'pdm',
	},
	['tribike2'] = {
		['name'] = 'Tri Bike 2',
    ['brand'] = 'Bike',
		['model'] = 'tribike2',
		['price'] = 700,
		['category'] = 'cycles',
		['hash'] = `tribike2`,
		['shop'] = 'pdm',
	},
	['tribike3'] = {
		['name'] = 'Tri Bike 3',
    ['brand'] = 'Bike',
		['model'] = 'tribike3',
		['price'] = 520,
		['category'] = 'cycles',
		['hash'] = `tribike3`,
		['shop'] = 'pdm',
	},
}