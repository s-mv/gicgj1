extends Node2D

@onready var label = $Label	
@onready var name_input = $NameInput
@onready var monster = $Monster

var player_name = ""
var texts = [
	"There is a monster living up the dark valleys of this world.",
	"It has no name, and it lives on and on. It stands undefeated.",
	"Until now..."
]
var text_index = -1
var typing = false
var current_full_text = ""

func _ready():
	label.text = "Enter your name: "
	name_input.visible = true
	name_input.grab_focus()
	name_input.connect("text_submitted", _on_name_entered)

func _on_name_entered(text):
	player_name = text.strip_edges()
	if player_name == "":
		return  # Ensure name is not empty
	name_input.visible = false
	show_next_text()

func show_next_text():
	text_index += 1
	if text_index < texts.size():
		type_text(texts[text_index])
	else:
		transform_to_player()

func type_text(full_text):
	typing = true
	current_full_text = full_text
	label.text = ""

	for i in range(full_text.length()):
		if not typing:
			label.text = full_text  # Instantly complete the text
			break
		label.text += full_text[i]
		await get_tree().create_timer(0.05).timeout  # Adjust speed as needed
	typing = false
	await get_tree().create_timer(1.5).timeout
	show_next_text()

func _input(event):
	if typing and event is InputEventMouseButton and event.pressed:
		typing = false  # Skip typing effect and show full text instantly
		label.text = current_full_text

func transform_to_player():
	monster.texture = load("res://img/player0.png")
	label.text = "You are "
	label.push_color(Color("red"))
	label.add_text(player_name)
	label.pop()
	label.add_text(".")
	await get_tree().create_timer(2).timeout
	label.text = "It is your destiny to defeat the monster."
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://scenes/game.tscn")
