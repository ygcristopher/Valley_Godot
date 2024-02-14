extends Area2D
class_name DoorComponent

var _player_ref: Character = null
@export_category("Variables")
@export var _teleport_position: Vector2

@export_category("Objects")
@export var _animation: AnimationPlayer = null

func _on_body_entered(body) -> void:
	if body is Character:
		_player_ref = body
		_animation.play("open")
		print("A")


func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "open":
		_player_ref.global_position = _teleport_position
	pass # Replace with function body.
