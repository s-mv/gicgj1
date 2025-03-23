extends Node2D

@onready var title = $Title
@onready var label = $ClickToPlay
@onready var sound = $AudioStreamPlayer

var tween: Tween
var has_skipped = false
var transition_complete = false

func _ready():
	sound.play(2)
	label.visible = false
	move_to_center()

func move_to_center():
	tween = create_tween()
	var target_position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
	title.position = Vector2(target_position.x, 0)
	tween.tween_property(title, "position", target_position, 4.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	if not has_skipped:
		transition_complete = true
		show_click_to_play()
		wave_motion()

func wave_motion():
	var wave_tween = create_tween().set_loops()
	var wave_height = 20  # Adjust wave height
	var wave_speed = 2.0   # Adjust wave speed

	wave_tween.tween_property(title, "position:y", title.position.y - wave_height, wave_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	wave_tween.tween_property(title, "position:y", title.position.y + wave_height, wave_speed).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func show_click_to_play():
	label.visible = true

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if tween and tween.is_running():
			has_skipped = true
			tween.kill()
			title.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
			transition_complete = true
			show_click_to_play()
			wave_motion()
		elif transition_complete:
			start_game()

func start_game():
	get_tree().change_scene_to_file("res://scenes/cutscene.tscn")
