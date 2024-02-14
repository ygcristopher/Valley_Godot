extends CharacterBody2D
class_name Character

var _state_machine
var _is_attacking: bool = false

@export_category("Variáveis")
@export var _move_speed: float = 64.0
@export var _friction: float = 0.2
@export var _acceleration: float = 0.2
@export_category("Objetos")
@export var _animation_tree: AnimationTree = null
@export var _attack_timer: Timer = null


func _ready() -> void:
	_animation_tree.active = true
	_state_machine = _animation_tree["parameters/playback"]

func _physics_process(_delta: float) -> void:
	move()
	attack()
	animate()
	move_and_slide()

func move() -> void:
	var _direction: Vector2 = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	if _direction != Vector2.ZERO:
		_animation_tree["parameters/idle/blend_position"] = _direction
		_animation_tree["parameters/walk/blend_position"] = _direction
		_animation_tree["parameters/attack/blend_position"] = _direction

		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _acceleration)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _acceleration)
		return
	else:
		velocity.x = lerp(velocity.x, _direction.normalized().x * _move_speed, _friction)
		velocity.y = lerp(velocity.y, _direction.normalized().y * _move_speed, _friction)

	velocity = _direction.normalized() * _move_speed
func attack() -> void:
	if Input.is_action_just_pressed("attack") and not _is_attacking:
		set_physics_process(false)
		_attack_timer.start()
		_is_attacking = true
		
func animate() -> void:
	if _is_attacking:
		_state_machine.travel("attack")
		return
		
	if velocity.length() > 5:
		_state_machine.travel("walk")
		return
		
	_state_machine.travel("idle")


func _on_attack_timer_timeout() -> void:
	set_physics_process(true)
	_is_attacking = false


func _on_attack_area_body_entered(body) -> void:
	if body.is_in_group("enemy"):
		body.update.health(randi_range(1,5))

