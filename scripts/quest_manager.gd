extends Node

signal quest_updated
signal quest_completed

enum QuestState {
	NOT_STARTED,
	ACTIVE,
	READY_TO_DELIVER,
	COMPLETED
}

var quest_state: QuestState = QuestState.NOT_STARTED
var required_crystals: int = 3
var collected_crystals: int = 0


# Iniciar la misión
func start_quest() -> void:
	if quest_state != QuestState.NOT_STARTED:
		return

	quest_state = QuestState.ACTIVE
	collected_crystals = 0
	quest_updated.emit()


# Recoger un cristal
func collect_crystal() -> void:
	if quest_state != QuestState.ACTIVE:
		return

	collected_crystals += 1

	if collected_crystals >= required_crystals:
		quest_state = QuestState.READY_TO_DELIVER

	quest_updated.emit()


# Completar la misión
func complete_quest() -> void:
	if quest_state != QuestState.READY_TO_DELIVER:
		return

	quest_state = QuestState.COMPLETED
	quest_updated.emit()
	quest_completed.emit()
