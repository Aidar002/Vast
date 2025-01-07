extends Control
#
#var inventory:= [] #массив для хранения предметов(наш инвентарь)
#
#var equipped_slots:= { #это наша экипированное снаряжение
	#'weapon': null,
	#'armor': null,
	#'amulet': null,
#}
#
#var items_config:= { #Все предметы, что есть в игре
	#"Деревянная палка": {'type': 'weapon', 'damage': 1, 'durability': '20'},
	#"Дырявая кожанная броня": {'type': 'armor', 'armor': 2, 'durability': '40'},
	#"Заточенный деревянный кол": {'type': 'weapon', 'damage': 3, 'durability': '15'},
	#"Стеклянный амулет": {'type': 'amulet', 'damage': 1, 'durability': '15'},
	#
#}
#
#var equipped_items = {
	#"оружие": null,  # Слот для оружия
	#"броня": null    # Слот для брони
#}
#
#var player_stats = {"урон": 10, "защита": 5}  # Базовые характеристики игрока
#var items = {
	#"Меч": {"тип": "оружие", "урон": 10},
	#"Броня": {"тип": "броня", "защита": 5}
#}
#var selected_item: String = ""  # Выбранный предмет
#
#@onready var inventory_label = $Control/InventoryLabel
#@onready var item_list = $Control/ItemList  # Список предметов
#@onready var equip_button = $Control/EquipButton  # Кнопка экипировки
#@onready var unequip_button = $Control/UnequipButton  # Кнопка снятия
#@onready var stats_label = $Control/StatsLabel  # Отображение характеристик
#
## Инициализация
#func _ready():
	#update_inventory()
	#update_stats()
	#equip_button.connect("pressed", self._on_equip_button_pressed)
	#unequip_button.connect("pressed", self._on_unequip_button_pressed)
	#item_list.connect("item_selected", self._on_item_selected)
#
## Добавление предмета в инвентарь
#func add_item(item):
	#inventory.append(item)
	#print("Добавлен предмет:", item)
	#update_inventory()
#
## Удаление предмета из инвентаря
#func remove_item(item):
	#if item in inventory:
		#inventory.erase(item)
		#print("Удалён предмет:", item)
		#update_inventory()
#
## Обновление отображения инвентаря
#func update_inventory():
	#item_list.clear()  # Очищаем список
	#for item in inventory:
		#item_list.add_item(item)  # Добавляем предметы в список
	#if inventory.size() > 0:
		#inventory_label.text = "Инвентарь:"
	#else:
		#inventory_label.text = "Инвентарь пуст."
#
## Обновление характеристик игрока
#func update_stats():
	#stats_label.text = "Урон: %d, Защита: %d" % [player_stats["урон"], player_stats["защита"]]
#
## Экипировка предмета
#func equip_item(item):
	#if item in inventory:
		#var item_type = items[item]["тип"]  # Получаем тип предмета
		#if item_type in equipped_items:     # Проверяем, есть ли такой слот
			#if equipped_items[item_type] == null:  # Проверяем, пуст ли слот
				#equipped_items[item_type] = item  # Надеваем предмет
				#if item_type == "оружие":
					#player_stats["урон"] += items[item]["урон"]  # Увеличиваем урон
				#elif item_type == "броня":
					#player_stats["защита"] += items[item]["защита"]  # Увеличиваем защиту
				#print("Надето:", item, "в слот", item_type)
				#remove_item(item)  # Удаляем предмет из инвентаря
				#update_stats()
			#else:
				#print("Слот", item_type, "уже занят предметом:", equipped_items[item_type])
		#else:
			#print("Нет подходящего слота для предмета:", item)
	#else:
		#print("Предмета нет в инвентаре.")
#
## Снятие предмета
#func unequip_item(slot):
	#if slot in equipped_items:
		#var item = equipped_items[slot]
		#if item != null:
			#if items[item]["тип"] == "оружие":
				#player_stats["урон"] -= items[item]["урон"]  # Уменьшаем урон
			#elif items[item]["тип"] == "броня":
				#player_stats["защита"] -= items[item]["защита"]  # Уменьшаем защиту
			#add_item(item)  # Возвращаем предмет в инвентарь
			#equipped_items[slot] = null  # Освобождаем слот
			#print("Снят предмет:", item, "из слота", slot)
			#update_stats()
		#else:
			#print("Слот", slot, "пуст.")
	#else:
		#print("Нет такого слота:", slot)
#
## Обработка выбора предмета в списке
#func _on_item_selected(index: int):
	#selected_item = item_list.get_item_text(index)  # Получаем выбранный предмет
	#print("Выбран предмет:", selected_item)
#
## Обработка нажатия на кнопку "Экипировать"
#func _on_equip_button_pressed():
	#if selected_item != "":
		#equip_item(selected_item)
		#selected_item = ""  # Сбрасываем выбор
	#else:
		#print("Предмет не выбран.")
#
## Обработка нажатия на кнопку "Снять"
#func _on_unequip_button_pressed():
	#if selected_item != "":
		#var item_type = items[selected_item]["тип"]
		#unequip_item(item_type)
		#selected_item = ""  # Сбрасываем выбор
	#else:
		#print("Предмет не выбран.")
