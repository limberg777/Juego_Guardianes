extends Node2D

@onready var interactive_area: Area2D = $interactiveArea

var player_nearby: bool = false


func _ready() -> void:
	interactive_area.body_entered.connect(
		_on_interactive_area_body_entered
	)
	
	interactive_area.body_exited.connect(
		_on_interactive_area_body_exited
	)


func _process(_delta: float) -> void:
	if player_nearby and Input.is_action_just_pressed("interact"):
		interact()


func interact() -> void:
	print("Estado actual de la misión: ", QuestManager.quest_state)
	
	var dialogue_ui = get_tree().current_scene.get_node("DialogueUI")

	if dialogue_ui.is_open:
		return

	match QuestManager.quest_state:

		QuestManager.QuestState.NOT_STARTED:
			var dialogues: Array[String] = [
				"1.Guard, I need your help!",
				"1.1The enemies have scattered the 3 magic crystals around the city.",
				"1.2Recover them quickly and bring them back to me before they are lost forever."
			]

			dialogue_ui.show_dialogue("Han Solo", dialogues)
			QuestManager.start_quest()

		QuestManager.QuestState.ACTIVE:
			print("Cristales recogidos: ", QuestManager.collected_crystals)
			print("Cristales necesarios: ", QuestManager.required_crystals)
			var dialogues: Array[String] = [
				"2.There are still crystals missing.",
				"2.1You have only found %d of %d." % [
					QuestManager.collected_crystals,
					QuestManager.required_crystals
				]
			]

			dialogue_ui.show_dialogue("Han Solo", dialogues)

		QuestManager.QuestState.READY_TO_DELIVER:
			var dialogues: Array[String] = [
				"3.Perfect! Thank you so much for helping me.",
				"3.1You have recovered all the crystals in time.",
				"3.2Now we can activate the portal."
			]

			dialogue_ui.show_dialogue("Han Solo", dialogues)
			QuestManager.complete_quest()

		QuestManager.QuestState.COMPLETED:
			var dialogues: Array[String] = [
				"4.Thank you from the bottom of my heart for all your help!",
				"4.1The portal is finally ready to use, thanks to you.",
				"4.2May your journey be filled with wonder and adventure. Safe travels, my friend!"
			]

			dialogue_ui.show_dialogue("Han Solo", dialogues)

func _on_interactive_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = true
		interact()


func _on_interactive_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_nearby = false
