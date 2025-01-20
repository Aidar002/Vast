extends Node

var mobs: Dictionary = {
	"slime": {
		"name": "слайм",
		"hp": 10,
		"damage": 2,
		"expirience": 5,
		"drops": [
			{"item_id": "health_potion", "chance": 0.5},
			{"item_id": "wooden_sword", "chance": 0.1}
		]
	},
	"drog": {
		"name": "дрог",
		"hp": 15,
		"damage": 3,
		"expirience": 5,
		"drops": [
			{"item_id": "iron_sword", "chance": 0.3}
		]
	},
	"forest_wolf": {
		"name": "Лесной волк",
		"hp": 25,
		"damage": 8,
		"expirience": 12,
		"drops": [
			{"item_id": "health_potion", "chance": 0.4},
			{"item_id": "power_stone", "chance": 0.2}
		]
	},
	"forest_troll": {
		"name": "Лесной тролль",
		"hp": 50,
		"damage": 12,
		"expirience": 20,
		"drops": [
			{"item_id": "rage_potion", "chance": 0.5},
			{"item_id": "chainmail", "chance": 0.1}
		]
	},
	"mountain_orc": {
		"name": "Горный орк",
		"hp": 40,
		"damage": 15,
		"expirience": 25,
		"drops": [
			{"item_id": "steel_sword", "chance": 0.1},
			{"item_id": "grenade", "chance": 0.3}
		]
	},
	"snow_yeti": {
		"name": "Снежный йети",
		"hp": 60,
		"damage": 18,
		"expirience": 30,
		"drops": [
			{"item_id": "frost_potion", "chance": 0.6},
			{"item_id": "shadow_cloak", "chance": 0.1}
		]
	},
	"skeleton_warrior": {
		"name": "Скелет-воин",
		"hp": 30,
		"damage": 10,
		"expirience": 15,
		"drops": [
			{"item_id": "health_amulet", "chance": 0.1},
			{"item_id": "smoke_bomb", "chance": 0.4}
		]
	},
	"ghost": {
		"name": "Призрак",
		"hp": 20,
		"damage": 5,
		"expirience": 10,
		"drops": [
			{"item_id": "mana_potion", "chance": 0.3},
			{"item_id": "mana_ring", "chance": 0.1}
		]
	}
}

# Функция для получения данных о мобе по его ID
func get_mob(mob_id: String) -> Dictionary:
	if mobs.has(mob_id):
		return mobs[mob_id].duplicate(true)
	else:
		print("Моб с ID ", mob_id, " не найден.")
		return {}
