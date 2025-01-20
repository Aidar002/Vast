extends Node

# Словарь с диалогами и локациями
var dialogs: Dictionary = {
	"village": {
		"text": "Ты прибываешь в деревню Авантюристов...",
		"options": [
			{"text": "Отправиться в гильдию авантюристов", "action": "go_to_guild"},
			{"text": "Осмотреть деревню", "action": "explore_village"},
			{"text": "Поговорить с местными жителями", "action": "talk_to_locals"},
			{"text": "Отправиться в лес", "action": "go_to_forest"}
		]
	},
	"guild": {
		"text": "Ты входишь в гильдию авантюристов...",
		"options": [
			{"text": "Зарегистрироваться", "action": "register_in_guild"},
			{"text": "Вернуться в деревню", "action": "go_to_village"}
		]
	},
	"forest": {
		"text": "Ты входишь в густой лес...",
		"options": [
			{"text": "Исследовать лес", "action": "explore_forest"},
			{"text": "Вернуться в деревню", "action": "go_to_village"}
		]
	}
}

# Ссылка на основной скрипт (fight_scene.gd)
var main_scene: Node

# Инициализация
func setup(main: Node):
	main_scene = main

# Показать диалог
func show_dialog(dialog_key: String):
	main_scene.hide_all()  # Используем функцию hide_all из основного скрипта
	var dialog = dialogs[dialog_key]
	main_scene.output.text = dialog["text"]  # Используем output из основного скрипта
	
	# Очищаем старые кнопки (если они есть)
	for child in main_scene.get_node("DialogOptions").get_children():
		child.queue_free()
	
	# Создаем кнопки для вариантов действий
	for option in dialog["options"]:
		var button = Button.new()
		button.text = option["text"]
		button.connect("pressed", Callable(self, "_on_dialog_option_selected").bind(option["action"]))
		main_scene.get_node("DialogOptions").add_child(button)

# Обработка выбора игрока
func _on_dialog_option_selected(action: String):
	match action:
		"go_to_guild":
			show_dialog("guild")  # Переход в гильдию
		"explore_village":
			main_scene.output.text = "Ты осматриваешь деревню. Здесь есть магазины, таверна и дома местных жителей."
		"talk_to_locals":
			main_scene.output.text = "Ты разговариваешь с местными жителями. Они рассказывают тебе о местных легендах и опасностях."
		"register_in_guild":
			main_scene.output.text = "Ты зарегистрировался в гильдии авантюристов. Теперь ты можешь получать задания!"
		"go_to_village":
			show_dialog("village")  # Возврат в деревню
		"go_to_forest":
			show_dialog("forest")  # Переход в лес
		"explore_forest":
			main_scene.output.text = "Ты исследуешь лес и натыкаешься на стаю волков!"
			# Можно начать бой с волками
