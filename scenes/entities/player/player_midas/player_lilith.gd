extends CharacterBody2D


const SPEED = 250.0
const STEALTH_SPEED = 100.0

var last_direction: Vector2 = Vector2.RIGHT
var is_attacking: bool = false
var hitbox_offset: Vector2
var strength: int = 20
var torch_on := false
var is_stealthing := false


#
# HEALTH AND WARMTH
@export var max_health: float = 100.0
@export var max_warmth: float = 100.0

@export var warmth_loss_rate: float = 7.0
@export var torch_warmth_rate: float = 0.5
@export var shelter_warmth_rate: float = 7.5
@export var freezing_damage_rate: float = 10.0

var health: float = 100.0
var warmth: float = 100.0
var is_inside_shelter: bool = false
var is_dead: bool = false
#


@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox


#
@onready var health_bar: ProgressBar = \
	$PlayerHUD/BarsContainer/HealthBar

@onready var warmth_bar: ProgressBar = \
	$PlayerHUD/BarsContainer/WarmthBar
#


func _ready() -> void:
	
	# Initialize hitbox offset:
	hitbox_offset = hitbox.position
	
	# Updated
	health = max_health
	warmth = max_warmth

	health_bar.max_value = max_health
	health_bar.value = health

	warmth_bar.max_value = max_warmth
	warmth_bar.value = warmth
	#

func _physics_process(_delta: float) -> void:
	# Disable hitbox until an attack is triggered
	hitbox.monitoring = false
	
	if Input.is_action_just_pressed("attack"):
		attack()
	
	# Skip movement if attacking
	if is_attacking:
		velocity = Vector2.ZERO
		return
	
	process_movement()
	process_animation()
	move_and_slide()


# MOVEMENT
func process_movement() -> void:
	var direction := Input.get_vector(
		"left",
		"right",
		"up",
		"down"
	)

	# Stealth chỉ hoạt động trong lúc giữ phím.
	is_stealthing = (
	Input.is_action_pressed("stealth")
	and not torch_on
)

	var current_speed := SPEED

	if is_stealthing:
		current_speed = STEALTH_SPEED

	if direction != Vector2.ZERO:
		velocity = direction * current_speed
		last_direction = direction
		update_hitbox_offset()
	else:
		velocity = Vector2.ZERO
	
# ANIMATION
func process_animation()-> void:
	if is_attacking:
		return 
	if velocity != Vector2.ZERO:
		play_animation("walk", last_direction)
	else: 
		play_animation("idle", last_direction)

func play_animation(prefix: String, dir: Vector2) -> void:
	if dir.x > 0:
		animated_sprite_2d.play(prefix + "_right") 
	elif dir.x < 0:
		animated_sprite_2d.play(prefix + "_left") 
	elif dir.y < 0:
		animated_sprite_2d.play(prefix + "_up")
	elif dir.y > 0:
		animated_sprite_2d.play(prefix + "_down")  
		
# ATTACKING
func attack() -> void:
	is_attacking = true
	hitbox.monitoring = true
	play_animation("attack", last_direction)
	print("Attack")


func _on_animated_sprite_2d_animation_finished() -> void:
	if is_attacking:
		is_attacking = false
		

# HITBOX
func update_hitbox_offset() -> void:
	var x := hitbox_offset.x
	var y := hitbox_offset.y
	
	match last_direction:
		Vector2.LEFT:
			hitbox.position = Vector2(-x, y)
		Vector2.RIGHT: 
			hitbox.position = Vector2(x, y)
		Vector2.UP:
			hitbox.position = Vector2(y, -x)
		Vector2.DOWN: 
			hitbox.position = Vector2(-y, x)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if is_attacking and body.name.begins_with("Enemy_Vangard"): 
		body.take_damage(strength, position)


func _unhandled_input(event):
	if event.is_action_pressed("torch_toggle"):
		torch_on = !torch_on
		$TorchHolder/AnimatedSprite2D.visible = torch_on
		$TorchHolder/Sprite2D.visible = torch_on
		$TorchHolder/PointLight2D.enabled = torch_on
		
		
func _process(delta: float) -> void:
	if is_dead:
		return

	process_warmth(delta)
	update_status_bars()
	
func process_warmth(delta: float) -> void:
	# Fire hoặc shelter luôn hồi Warmth nhanh nhất.
	if is_inside_shelter:
		warmth += shelter_warmth_rate * delta

	# Bật torch: Warmth ổn định hoặc hồi rất chậm.
	elif torch_on:
		warmth += torch_warmth_rate * delta

	# Tắt torch: Warmth giảm.
	else:
		warmth -= warmth_loss_rate * delta

	warmth = clamp(warmth, 0.0, max_warmth)

	# Chỉ khi Warmth chạm đáy thì Health mới giảm.
	if warmth <= 0.0:
		health -= freezing_damage_rate * delta
		health = clamp(health, 0.0, max_health)

		if health <= 0.0:
			die()

func update_status_bars() -> void:
	health_bar.value = health
	warmth_bar.value = warmth
	
	
func take_damage(damage: float) -> void:
	if is_dead:
		return

	health -= damage
	health = clamp(health, 0.0, max_health)

	print("PLAYER HEALTH: ", health)
	update_status_bars()

	if health <= 0.0:
		die()
		

func die() -> void:
	if is_dead:
		return

	is_dead = true
	health = 0.0
	velocity = Vector2.ZERO
	update_status_bars()

	print("PLAYER DIED")

	set_physics_process(false)

	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()
	
	
	
func set_inside_shelter(value: bool) -> void:
	is_inside_shelter = value
	

func is_in_stealth_mode() -> bool:
	return is_stealthing
