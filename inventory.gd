extends Control

var nonequiped_inventory:= [1, 2] #массив для хранения предметов(наш инвентарь)

var equipped_slots:= { #это наша экипированное снаряжение
	'weapon': null,
	'armor': null,
	'amulet': null,
}

var items_config:= { #Все предметы, что есть в игре
	1: {'name': 'Деревянная палка', 'type': 'weapon', 'damage': 1, 'durability': '20'},
	2: {'name': 'Дырявая кожанная броня', 'type': 'armor', 'armor': 2, 'durability': '40'},
	3: {'name': 'Заточенный деревянный кол', 'type': 'weapon', 'damage': 3, 'durability': '15'},
	4: {'name': 'Стеклянный амулет', 'type': 'amulet', 'damage': 1, 'durability': '15'},
	
}

var selected_item: String = ""  # Выбранный предмет
