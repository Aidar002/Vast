extends Control
class_name main

enum target {Head, Body, Legs}
enum STATE {find_money, meet_mob, sphere, slime_spawn, desert_spawn, forest_spawn}
var states = [
	{'name': STATE.find_money, 'probability': 5},
	{'name': STATE.meet_mob, 'probability': 5},
	{'name': STATE.sphere, 'probability': 10},
	{'name': STATE.slime_spawn, 'probability': 20},
	{'name': STATE.desert_spawn, 'probability': 20},
	{'name': STATE.forest_spawn, 'probability': 40},
]
#инвентарь
@onready var inventory = %inventory
@onready var item_list = $inventory/ItemList
#

@onready var output = %Output

@onready var current_mob:Dictionary
@onready var current_location:String

static var player:= {
	'hp': 100,
	'max_hp': 100,
	'alive': true,
	'damage': 40,
	'money': 0,
	'expirience': 0,
	'lvl': 1,
	'strength': 1,
	'agility': 1,
	'intelligence': 1,
}
@onready var lvl_config:Dictionary = {
	1: 5,
	2: 15,
	3: 35,
	4: 65,
	5: 100,
}
	
@onready var attack = %Attack
@onready var defence = %Defence
@onready var go_next = %GoNext
@onready var fight = %Fight
@onready var up_level = %UpLevel
@onready var buy_sth = %BuySth

@onready var strength = %Strength
@onready var agility = %Agility
@onready var intelligence = %Intelligence
#для локации слаймов
@onready var slime_in = $SlimeSpawn/SlimeIn
@onready var slime_out = $SlimeSpawn/SlimeOut
@onready var attack_again = $SlimeSpawn/AttackAgainSlime
#для локации пустыни
@onready var attack_again_desert = $Desert/AttackAgainDesert
@onready var desert_in = $Desert/DesertIn
@onready var desert_out = $Desert/DesertOut
#для локации леса
@onready var attack_again_forest = $Forest/AttackAgainForest
@onready var forest_in = $Forest/ForestIn
@onready var forest_out = $Forest/ForestOut




func _ready():
	randomize()
	hide_all()
	go_adventure()
	inventory.update_inventory_ui()
	
func random_event():
	var random_value = randf() * 100
	var cumulative_probability = 0
	
	for state in states:
		cumulative_probability += state['probability']
		if random_value <= cumulative_probability:
			return state['name']
		
	return null

func go_adventure():
	output.text = "путешествуете по миру..."
	await get_tree().create_timer(2).timeout
	var current_state = random_event()
	match current_state:
		STATE.find_money:
			player['money'] += 1
			output.text = 'нашли монетку(+1). всего {balance}'.format({'balance': player['money']})
			go_next.visible = true
		STATE.meet_mob:
			current_mob = MobsDb.get_mob(MobsDb.mobs.keys().pick_random())
			output.text = "видите {name}, что будете делать?".format({'name': current_mob['name']})
			go_next.visible = true
			fight.visible = true
		STATE.sphere:
			state_sphere()
		STATE.slime_spawn:
			slime_spawn()
		STATE.desert_spawn:
			desert_spawn()
		STATE.forest_spawn:
			forest_spawn()
			
			
func meet_mob():
	go_next.visible = false
	fight.visible = false
	output.text = "напали на {name}. Ваш ход".format({'name': current_mob['name']})
	defence.visible = false
	attack.visible = true
	
func _on_attack_head_button_up():
	attack_process(target.Head, 'голову')
func _on_attack_body_pressed():
	attack_process(target.Body, 'корпус')
func _on_attack_legs_pressed():
	attack_process(target.Legs, 'ноги')
func _on_defence_head_pressed():
	defence_process(target.Head, 'голову')
func _on_defence_body_pressed():
	defence_process(target.Body, 'корпус')
func _on_defence_legs_pressed():
	defence_process(target.Legs, 'ноги')

func _on_go_next_pressed():
	go_next.visible = false
	fight.visible = false
	go_adventure()

func attack_process(p_target, p_attack_direction):
	attack.visible = false
	defence.visible = false
	var enemy_defence = randi_range(0, 2)
	if p_target == enemy_defence:
		output.text = 'ударили в {body_part}. {name} заблокировал вашу атаку.'.format({'name': current_mob['name'], 'body_part': p_attack_direction})
	else:
		current_mob['hp'] -= player['damage']
		if current_mob['hp'] <=0:
			player['expirience'] += current_mob['expirience']
			output.text = 'ударили в {body_part} и нанесли {damage} урона и убили {name}. Получено {expirience} опыта, поздравляем'.format({'damage': player['damage'], 'name': current_mob['name'], 'expirience': current_mob['expirience'],'body_part': p_attack_direction })
			_on_monster_defeated()
			match current_location:
				"slime_spawn":
					attack_again.visible = true
					slime_out.visible = true
				"desert":
					attack_again_desert.visible = true
					desert_out.visible = true
				"forest":
					attack_again_forest.visible = true
					forest_out.visible = true
				_:
					go_next.visible = true
			return
		else:
			output.text = "Ударили в {body_part} и нанесли {damage} урона {name}, у него осталось {hp} энергии жизни".format({'damage': player['damage'], 'hp': current_mob['hp'], 'name': current_mob['name'], 'body_part': p_attack_direction})
	defence.visible = true
	
	
func defence_process(p_target, p_defence_direction):
	var enemy_attack = randi_range(0, 2)
	if p_target == enemy_attack:
		output.text = 'Отбили атаку в {body_part}.'.format({'body_part': p_defence_direction})
	else:
		player['hp'] -= current_mob['damage']
		if player['hp'] <= 0:
			hide_all()
			output.text = 'Погибаете. Бог хаоса ошибся.'
			return
		else:
			output.text = "{name} наносит {damage} урона. Осталось {hp} энергии жизни".format({'name': current_mob['name'], 'damage': current_mob['damage'], 'hp': player['hp']})
			
	defence.visible = false
	attack.visible = true

func _on_monster_defeated():
	for drop in current_mob['drops']:
		if randf() <= drop['chance']:  # Проверяем шанс выпадения
			var item_id = drop['item_id']
			inventory.add_to_inventory(item_id)  # Добавляем предмет в инвентарь
			output.text += "\nВы получили предмет: " + ItemDb.get_item(item_id)["name"]

func state_sphere():
	output.text = "Перед глазами появилась сфера. Чувство эйфории захватывает. знаете, что можете сделать что-то невероятное"
	go_next.visible = true
	up_level.visible = true
	buy_sth.visible = true
	
func level_up():
	hide_all()
	if player['expirience'] >= lvl_config[player['lvl']]:
		output.text = "что выберите?"
		strength.visible = true
		agility.visible = true
		intelligence.visible = true
	else: 
		output.text = "не хватает опыта"
		go_next.visible = true

func hide_all():
	go_next.visible = false
	fight.visible = false
	attack.visible = false
	defence.visible = false
	up_level.visible = false
	buy_sth.visible = false
	strength.visible = false
	agility.visible = false
	intelligence.visible = false
	slime_in.visible = false
	slime_out.visible = false
	attack_again.visible = false
	attack_again_desert.visible = false
	desert_out.visible = false
	desert_in.visible = false
	forest_in.visible = false
	forest_out.visible = false
	attack_again_forest.visible = false
	
func upgrade_player(p_stat):
	player['expirience'] -= lvl_config[player['lvl']]
	player[p_stat] += 1
	output.text = "вы стали лучше"
	hide_all()
	go_next.visible = true
	
func _on_strength_pressed():
	upgrade_player('strength')


func _on_agility_pressed():
	upgrade_player('agility')


func _on_intelligence_pressed():
	upgrade_player('intelligence')

func slime_spawn():
	output.text = 'Видите пещеру со слизнями. Войти?'
	slime_in.visible = true
	slime_out.visible = true
	
func _on_slime_out_pressed():
	hide_all()
	current_location = ''
	go_adventure()
	
func _on_slime_in_pressed():
	hide_all()
	current_location = "slime_spawn"  # Устанавливаем ID локации
	var location_data = LocationDb.get_location(current_location)  # Получаем данные о локации
	
	# Выбираем случайного моба из локации
	var mob_id = location_data["mobs"].pick_random()
	current_mob = MobsDb.get_mob(mob_id)  # Получаем данные о мобе
	output.text = 'Пещера кишит слаймами, один из них нападает'
	meet_mob()

func _on_attack_again_pressed():
	hide_all()
	var location_data = LocationDb.get_location(current_location)  # Получаем данные о локации
	# Выбираем случайного моба из локации
	var mob_id = location_data["mobs"].pick_random()
	current_mob = MobsDb.get_mob(mob_id)  # Получаем данные о мобе
	output.text = 'на вас нападает монстр'
	meet_mob()

func desert_spawn():
	output.text = 'Видите песчаные барханы. Исследовать?'
	desert_in.visible = true
	desert_out.visible = true

func _on_desert_in_pressed():
	hide_all()
	current_location = "desert"  # Устанавливаем ID локации
	var location_data = LocationDb.get_location(current_location)  # Получаем данные о локации
	# Выбираем случайного моба из локации
	var mob_id = location_data["mobs"].pick_random()
	current_mob = MobsDb.get_mob(mob_id)  # Получаем данные о мобе
	output.text = 'Пустыня жаждет эмбиента'
	meet_mob()

func _on_desert_out_pressed():
	hide_all()
	current_location = ''
	go_adventure()

func forest_spawn():
	output.text = 'Перед вами растилается темный и дремучий лес, желаете войти?'
	forest_in.visible = true
	forest_out.visible = true

func _on_forest_in_pressed():
	hide_all()
	current_location = "forest"  # Устанавливаем ID локации
	var location_data = LocationDb.get_location(current_location)  # Получаем данные о локации
	# Выбираем случайного моба из локации
	var mob_id = location_data["mobs"].pick_random()
	current_mob = MobsDb.get_mob(mob_id)  # Получаем данные о мобе
	output.text = 'Лес зовет вас'
	meet_mob()

func _on_forest_out_pressed():
	hide_all()
	current_location = ''
	go_adventure()
