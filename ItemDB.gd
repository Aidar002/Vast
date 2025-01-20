extends Node

# Словарь с данными о предметах
var items: Dictionary = {
	"health_potion": {
		"name": "Зелье лечения",
		"description": "Восстанавливает 20 HP.",
		"is_equippable": false,
		"effect": "heal"
	},
	"mana_potion": {
		"name": "Зелье маны",
		"description": "Восстанавливает 20 маны.",
		"is_equippable": false,
		"effect": "restore_mana"
	},
	"frost_potion": {
		"name": "Морозное зелье",
		"description": "Замораживает врага на 1 ход.",
		"is_equippable": false,
		"effect": "freeze_enemy"
	},
	"rage_potion": {
		"name": "Зелье ярости",
		"description": "Увеличивает урон на 50% на 3 хода.",
		"is_equippable": false,
		"effect": "increase_damage_temporarily"
	},
	"wooden_sword": {
		"name": "Деревянный меч",
		"description": "Увеличивает урон на 5.",
		"is_equippable": true,
		"effect": "increase_damage"
	},
	"iron_sword": {
		"name": "Железный меч",
		"description": "Увеличивает урон на 10.",
		"is_equippable": true,
		"effect": "increase_damage"
	},
	"steel_sword": {
		"name": "Стальной меч",
		"description": "Увеличивает урон на 15.",
		"is_equippable": true,
		"effect": "increase_damage"
	},
	"ancient_sword": {
		"name": "Древний меч",
		"description": "Увеличивает урон на 20.",
		"is_equippable": true,
		"effect": "increase_damage"
	},
	"chainmail": {
		"name": "Кольчуга",
		"description": "Увеличивает максимальное HP на 30.",
		"is_equippable": true,
		"effect": "increase_max_hp"
	},
	"shadow_cloak": {
		"name": "Плащ теней",
		"description": "Увеличивает шанс уклонения на 20%.",
		"is_equippable": true,
		"effect": "increase_evasion"
	},
	"grenade": {
		"name": "Граната",
		"description": "Наносит 30 урона всем врагам в бою.",
		"is_equippable": false,
		"effect": "aoe_damage"
	},
	"smoke_bomb": {
		"name": "Дымовая шашка",
		"description": "Позволяет сбежать из боя без последствий.",
		"is_equippable": false,
		"effect": "escape_battle"
	},
	"power_stone": {
		"name": "Камень силы",
		"description": "Увеличивает силу на 1 при использовании.",
		"is_equippable": false,
		"effect": "increase_strength"
	},
	"health_amulet": {
		"name": "Амулет здоровья",
		"description": "Постепенно восстанавливает 5 HP каждый ход в бою.",
		"is_equippable": true,
		"effect": "regenerate_hp"
	},
	"mana_ring": {
		"name": "Кольцо маны",
		"description": "Постепенно восстанавливает 5 маны каждый ход в бою.",
		"is_equippable": true,
		"effect": "regenerate_mana"
	},
	"phoenix_feather": {
		"name": "Перо феникса",
		"description": "Автоматически воскрешает вас один раз в бою.",
		"is_equippable": true,
		"effect": "auto_revive"
	}
}

# Функция для получения данных о предмете по его ID
func get_item(item_id: String) -> Dictionary:
	if items.has(item_id):
		return items[item_id].duplicate(true)
	else:
		print("Предмет с ID ", item_id, " не найден.")
		return {}
