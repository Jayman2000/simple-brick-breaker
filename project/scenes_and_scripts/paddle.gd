# SPDX-FileNotice: 🅭🄍1.0 This file was dedicated to the public domain using the CC0 1.0 Universal Public Domain Dedication <https://creativecommons.org/publicdomain/zero/1.0/>.
# SPDX-FileContributor: Jason Yundt <swagfortress@gmail.com> (2021)
# SPDX-FileContributor: Clayton14 <claytoneasley77@gmail.com> (2022)
# SPDX-FileType: SOURCE
extends Node2D


signal level_finished_balls_caught
const Ball: PackedScene = preload("res://scenes_and_scripts/ball.tscn")
const BALL_SPEED_FACTOR := 1.04  # Unit: 1
const BALL_MAX_ANGLE := deg2rad(50)  # Unit: radians clockwise from north
const MAX_SPEED := 500  # Unit: px/sec
const MOUSE_CONTROL_DISABLING_ACTIONS := ["ui_left", "ui_right"]
onready var held_balls: Array
onready var mouse_controls := false
onready var collision_rectangle: RectangleShape2D = $CollisionShape2D.shape


func grab_ball(ball: BallType) -> void:
	var ball_parent := ball.get_parent()
	if ball_parent == null:
		ball.start_being_held()
	else:
		var new_x: float = ball.global_position.x - global_position.x
		ball_parent.remove_child(ball)
		ball.start_being_held()
		ball.position.x = new_x

	# Place the Ball on the top edge of this Paddle
	ball.position.y = -collision_rectangle.extents.y - ball.radius()
	call_deferred("_finish_grabbing_ball", ball)


func _finish_grabbing_ball(ball: BallType) -> void:
	add_child(ball)
	held_balls.append(ball)


func spawn_new_ball() -> void:
	grab_ball(Ball.instance())


func _ready() -> void:
	spawn_new_ball()


func half_width() -> float:
	return collision_rectangle.extents.x / 2.0


func _physics_process(delta: float) -> void:
	var max_distance_this_tic: float = MAX_SPEED * delta  # Unit: px
	if mouse_controls:
		var distance_to_mouse: float = get_local_mouse_position().x
		if abs(distance_to_mouse) <= max_distance_this_tic:
			global_position.x = get_global_mouse_position().x
		elif distance_to_mouse < 0:
			position.x -= max_distance_this_tic
		else:
			position.x += max_distance_this_tic
	else:
		position.x += Input.get_axis("ui_left", "ui_right") * max_distance_this_tic


func _unhandled_input(event: InputEvent) -> void:
	if not mouse_controls and event.is_action_pressed("enable_mouse_controls"):
		mouse_controls = true
		# Allow the player to enable mouse controls without releasing the Ball.
		return
	else:
		for action in MOUSE_CONTROL_DISABLING_ACTIONS:
			if event.is_action_pressed(action):
				mouse_controls = false
				break

	if len(held_balls) != 0 and event.is_action_pressed("release_ball"):
		while len(held_balls) > 0:
			var held_ball: BallType = held_balls.pop_front()
			var ball_global_position: Vector2 = held_ball.global_position
			remove_child(held_ball)
			held_ball.global_position = ball_global_position
			held_ball.stop_being_held()
			get_parent().add_child(held_ball)


func all_bricks_cleared() -> bool:
	return not get_tree().has_group("Bricks")


func check_if_level_is_over() -> void:
	if len(get_tree().get_nodes_in_group("Balls")) == len(held_balls):
		emit_signal("level_finished_balls_caught")


func _on_Paddle_body_entered(body: RigidBody2D) -> void:
	if body is BallType:
		# Unit: px
		var distance_from_center: float = body.position.x - position.x
		# If center_ratio is -1, then the Ball hit the left edge of the Paddle.
		# If center_ratio is -0.5, then the Ball hit half-way between the left
		# edge and the center of the Paddle.
		# If center_ratio is 0, the the Ball hit the center of the Paddle.
		# If center_ratio is 0.5, then the Ball hit half-way between the center
		# and the left edge of the Paddle.
		# If center_ratio is 1, then the Ball hit the right edge of the Paddle.
		var center_ratio: float = distance_from_center / half_width()  # Unit: 1
		# This is needed because the Balls center could be beyound the Paddle’s.
		center_ratio = clamp(center_ratio, -1, 1)

		var new_linear_velocity: Vector2
		new_linear_velocity = Vector2.UP.rotated(BALL_MAX_ANGLE * center_ratio)
		new_linear_velocity *= body.linear_velocity.length() * BALL_SPEED_FACTOR
		body.linear_velocity = new_linear_velocity

		# If all of the bricks have been destroyed
		if all_bricks_cleared():
			# These are needed to avoid this issue:
			# <https://github.com/godotengine/godot/issues/14578>
			body.set_block_signals(true)
			grab_ball(body)
			body.set_block_signals(false)
			check_if_level_is_over()
	else:  # body is SplitBall
		get_tree().call_group("Balls", "split")
		body.queue_free()
