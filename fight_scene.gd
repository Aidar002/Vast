extends Control

enum target {Head, Body, Legs}
enum STATE {find_money, meet_mob, sphere}
var states = [
	{'name': STATE.find_money, 'probability': 40},
	{'name': STATE.meet_mob, 'probability': 50},
	{'name': STATE.sphere, 'probability': 10}
]

#@onready var inventory = %inventory

@onready var output = %Output
@onready var slime:= {'name': 'слайм', 'hp': 10, 'alive': true, 'damage': 2, 'expirience': 5}
@onready var drog:= {'name': 'дрог', 'hp': 15, 'alive': true, 'damage': 3, 'expirience': 5}
@onready var monsters = [slime, drog]
@onready var current_mob:Dictionary
@onready var player:= {
	'hp': 20,
	'alive': true,
	'damage': 20,
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






func _ready():
	randomize()
	hide_all()
	go_adventure()

func random_event():
	var random_value = randf() * 100
	var cumulative_probability = 0
	
	for state in states:
		cumulative_probability += state['probability']
		if random_value <= cumulative_probability:
			return state['name']
		
	return null

func go_adventure():
	output.text = "вы путешествуете по миру..."
	await get_tree().create_timer(2).timeout
	var current_state = random_event()
	match current_state:
		STATE.find_money:
			player['money'] += 1
			output.text = 'вы нашли монетку(+1). У вас всего {balance}'.format({'balance': player['money']})
			go_next.visible = true
		STATE.meet_mob:
			current_mob = monsters.pick_random()
			output.text = "вы видите {name}, что будете делать?".format({'name': current_mob['name']})
			go_next.visible = true
			fight.visible = true
		STATE.sphere:
			state_sphere()
			
			
func meet_mob():
	go_next.visible = false
	fight.visible = false
	output.text = "вы напали на {name}. Ваш ход".format({'name': current_mob['name']})
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
		output.text = 'Вы ударили в {body_part}. {name} заблокировал вашу атаку.'.format({'name': current_mob['name'], 'body_part': p_attack_direction})
	else:
		current_mob['hp'] -= player['damage']
		if current_mob['hp'] <=0:
			player['expirience'] += current_mob['expirience']
			output.text = 'Вы ударили в {body_part} и нанесли {damage} урона и убили {name}. Получено {expirience} опыта, поздравляем'.format({'damage': player['damage'], 'name': current_mob['name'], 'expirience': current_mob['expirience'],'body_part': p_attack_direction })
			go_next.visible = true
			return
		else:
			output.text = "Вы ударили в {body_part} и нанесли {damage} урона {name}, у него осталось {hp} энергии жизни".format({'damage': player['damage'], 'hp': current_mob['hp'], 'name': current_mob['name'], 'body_part': p_attack_direction})
	defence.visible = true
	
	
func defence_process(p_target, p_defence_direction):
	var enemy_attack = randi_range(0, 2)
	if p_target == enemy_attack:
		output.text = 'Вы отбили атаку в {body_part}.'.format({'body_part': p_defence_direction})
	else:
		player['hp'] -= current_mob['damage']
		if player['hp'] <= 0:
			hide_all()
			output.text = 'Вы погибаете. Бог хаоса ошибся в вас.'
			return
		else:
			output.text = "{name} наносит вам {damage} урона. У вас осталось {hp} энергии жизни".format({'name': current_mob['name'], 'damage': current_mob['damage'], 'hp': player['hp']})
			
	defence.visible = false
	attack.visible = true
	
func state_sphere():
	output.text = "Перед глазами появилась сфера. Чувство эйфории захватывает. Вы знаете, что можете сделать что-то невероятное"
	go_next.visible = true
	up_level.visible = true
	buy_sth.visible = true
	
func level_up():
	hide_all()
	if player['expirience'] >= lvl_config[player['lvl']]:
		output.text = "что вы выберите?"
		strength.visible = true
		agility.visible = true
		intelligence.visible = true
	else: 
		output.text = "у вас не хватает опыта"
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
