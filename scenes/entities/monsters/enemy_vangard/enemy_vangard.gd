extends CharacterBody2D


const SPEED: int = 150
const KNOCKBACK_FORCE: int = 100

# Enemy attack lên player
const PLAYER_DAMAGE: float = 15.0
const ATTACK_DISTANCE: float = 45.0
const ATTACK_COOLDOWN: float = 1.0

var is_alive: bool = true
var health: int = 100
var target: Node2D = null

# Player trong vùng trong: luôn bị phát hiện.
var player_in_inner_range: Node2D = null

# Player trong vùng ngoài: chỉ bị phát hiện nếu torch bật.
var player_in_torch_range: Node2D = null

var attack_cooldown_remaining: float = 0.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	if not is_alive:
		return

	if attack_cooldown_remaining > 0.0:
		attack_cooldown_remaining -= delta

	# Kiểm tra lại target mỗi physics frame.
	# Nhờ vậy bật/tắt F ngay trong vùng ngoài sẽ có hiệu lực tức thì.
	update_target()

	if target:
		_attack(delta)
		try_damage_player()
	else:
		_stop_chasing()


func update_target() -> void:
	# Ưu tiên vùng trong.
	# Dù torch ON hay OFF, player vẫn bị đuổi.
	if is_instance_valid(player_in_inner_range):
		target = player_in_inner_range
		return

	# Vùng ngoài chỉ phát hiện player khi torch đang bật.
	if is_instance_valid(player_in_torch_range):
		var player_torch_on = player_in_torch_range.get("torch_on")

		if player_torch_on == true:
			target = player_in_torch_range
			return

	target = null


func _attack(_delta: float) -> void:
	# Calculate direction using global_position
	# to handle node hierarchy accurately.
	var direction = \
		(target.global_position - global_position).normalized()

	velocity = direction * SPEED
	move_and_slide()

	animated_sprite_2d.play("attack")


func try_damage_player() -> void:
	if not is_instance_valid(target):
		return

	var distance_to_player := global_position.distance_to(
		target.global_position
	)

	if distance_to_player > ATTACK_DISTANCE:
		return

	if attack_cooldown_remaining > 0.0:
		return

	if target.has_method("take_damage"):
		target.take_damage(PLAYER_DAMAGE)
		attack_cooldown_remaining = ATTACK_COOLDOWN

		print("ENEMY HIT PLAYER")


func _stop_chasing() -> void:
	if velocity != Vector2.ZERO:
		velocity = Vector2.ZERO
		animated_sprite_2d.play("idle")


func take_damage(
	damage: int,
	attacker_position: Vector2
) -> void:
	health -= damage
	print(health)

	if health <= 0:
		_die()
	else:
		# Calculate knockback direction using global_position.
		var knockback_direction = \
			(global_position - attacker_position).normalized()

		var target_position = \
			global_position \
			+ knockback_direction * KNOCKBACK_FORCE

		# Smooth knockback animation using Tween.
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.tween_property(
			self,
			"global_position",
			target_position,
			0.5
		)


func _die() -> void:
	is_alive = false
	target = null
	player_in_inner_range = null
	player_in_torch_range = null

	velocity = Vector2.ZERO
	animated_sprite_2d.play("die")

	# Disable collisions safely.
	$CollisionShape2D.set_deferred("disabled", true)

	$VisionRange/CollisionShape2D.set_deferred(
		"disabled",
		true
	)

	$TorchDetectionRange/CollisionShape2D.set_deferred(
		"disabled",
		true
	)


# INNER RANGE
# Player bước vào đây thì luôn bị phát hiện.
func _on_vision_range_body_entered(body: Node2D) -> void:
	if body.name == "PlayerLilith" \
	or body.is_in_group("player"):
		player_in_inner_range = body


func _on_vision_range_body_exited(body: Node2D) -> void:
	if body == player_in_inner_range:
		player_in_inner_range = null


# OUTER TORCH RANGE
# Player chỉ bị phát hiện nếu torch đang bật.
func _on_torch_detection_range_body_entered(
	body: Node2D
) -> void:
	if body.name == "PlayerLilith" \
	or body.is_in_group("player"):
		player_in_torch_range = body


func _on_torch_detection_range_body_exited(
	body: Node2D
) -> void:
	if body == player_in_torch_range:
		player_in_torch_range = null
