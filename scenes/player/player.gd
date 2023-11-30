extends CharacterBody2D

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
var is_jumping: bool = false
var gravity: Variant = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var direction: Vector2 = Vector2(Input.get_axis("ui_left", "ui_right"), 0)
	
	# Handle horizontal movement
	velocity.x = direction.x * SPEED

	# Ensure that the character flips only when there's actual input
	if direction.x != 0:
		$AnimatedSprite2D.flip_h = direction.x < 0

	# Reset jumping state and animation when on floor
	if is_on_floor():
		is_jumping = false  # Character is not jumping when on the ground
		if direction.x == 0:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("run")
	else:
		# Play the 'jumpfalling' animation if moving downwards, regardless of left/right movement
		if velocity.y > 0:
			$AnimatedSprite2D.play("jumpfalling")

	# Handle Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		$AnimatedSprite2D.play("jump")

	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Apply velocity and movement
	self.velocity = velocity  # This sets the CharacterBody2D's velocity
	move_and_slide()  # This now requires no arguments
