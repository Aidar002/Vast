extends Node


# Словарь с данными о локациях
var locations: Dictionary = {
	"slime_spawn": {
		"name": "Пещера слаймов",
		"mobs": ["slime", "drog"]  # Мобы в этой локации
	},
	"desert": {
		"name": "Пустыня",
		"mobs": ["scorpion", "desert_spirit"]  # Мобы в этой локации
	},
	"forest": {
		"name": "Лесная чаща",
		"mobs": ["forest_wolf", "forest_troll"]  # Мобы в этой локации
	},
	"mountain_pass": {
		"name": "Горный перевал",
		"mobs": ["mountain_orc", "snow_yeti"]  # Мобы в этой локации
	},
	"abandoned_castle": {
		"name": "Заброшенный замок",
		"mobs": ["skeleton_warrior", "ghost"]  # Мобы в этой локации
	}
}

# Функция для получения данных о локации по её ID
func get_location(location_id: String) -> Dictionary:
	if locations.has(location_id):
		return locations[location_id]
	else:
		print("Локация с ID ", location_id, " не найдена.")
		return {}
