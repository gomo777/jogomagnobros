extends CharacterBody2D
class_name EnemyBase

var SPEED = 1700.0
const JUMP_VELOCITY = -400.0
@onready var anim = $anim
@export var enemy_score := 100

var sprite
var ground_detector
var wall_detector
var texture
var direction := -1
var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var can_spawn = false
var spawn_instance : PackedScene = null
var spawn_instance_position

func _apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		
func movement(delta):
	velocity.x = direction * SPEED * delta
	move_and_slide()

func flip_enemy():
	direction *= -1
	sprite.scale.x *= -1

func flip_direction():
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	
	if direction == 1:
		sprite.flip_h = true
	else:
		sprite.flip_h = false

func kill_ground_enemy(_anim_name: StringName) -> void:
	kill_and_score()

func kill_air_enemy() -> void:
	kill_and_score()

func kill_and_score():
	Globals.score += enemy_score
	if can_spawn:
		spawn_new_enemy()
		get_parent().queue_free()
	else:
		queue_free()

func spawn_new_enemy():
	var instance_scene = spawn_instance.instantiate()
	get_tree().root.add_child(instance_scene)
	instance_scene.global_position = spawn_instance_position.global_position

func stop_movement():
	SPEED = 0
	velocity = Vector2.ZERO
