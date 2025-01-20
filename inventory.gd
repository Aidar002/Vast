extends Control

@onready var inventory_list = $ItemList
@onready var inventory: Array = ["health_potion", 'wooden_sword']  # Массив предметов (храним ID предметов)

# Добавить предмет в инвентарь
func add_to_inventory(item_id: String):
	inventory.append(item_id)
	update_inventory_ui()

# Обновить интерфейс инвентаря
func update_inventory_ui():
	inventory_list.clear()  # Очищаем список
	for item_id in inventory:
		var item_data = ItemDb.get_item(item_id)  # Получаем данные о предмете
		inventory_list.add_item(item_data["name"])  # Добавляем предмет в ItemList

# Обработчик выбора предмета
func _on_inventory_list_item_selected(index: int):
	var item_id = inventory[index]  # Получаем ID выбранного предмета
	var item_data = ItemDb.get_item(item_id)  # Получаем данные о предмете
	
	if item_data["is_equippable"]:
		equip_item(item_id)  # Надеваем/снимаем предмет
	else:
		use_item(item_id)  # Используем зелье
		inventory.remove_at(index)  # Удаляем зелье из инвентаря
	update_inventory_ui()  # Обновляем интерфейс

# Использование предмета
func use_item(item_id: String):
	var item_data = ItemDb.get_item(item_id)
	match item_data["effect"]:
		"heal":
			main.player["hp"] += 20
			if main.player["hp"] > main.player["max_hp"]:
				main.player["hp"] = main.player["max_hp"]
			print("Использовано зелье лечения. Ваше HP: ", main.player["hp"])
		_:
			print("Эффект предмета не реализован.")

# Надевание/снятие предмета
func equip_item(item_id: String):
	var item_data = ItemDb.get_item(item_id)
	match item_data["effect"]:
		"increase_damage":
			if item_data.get("is_equipped", false):
				main.player["damage"] -= 5
				item_data["is_equipped"] = false
				print("Вы сняли ", item_data["name"], ". Ваш урон: ", main.player["damage"])
			else:
				main.player["damage"] += 5
				item_data["is_equipped"] = true
				print("Вы надели ", item_data["name"], ". Ваш урон: ", main.player["damage"])
		_:
			print("Эффект предмета не реализован.")
