extends State
class_name PlayerStateStun

@export var stun_duration: float = 0.5
@export var pulse_frequency: float = 10.0  # How many times per second to pulse
@export var next_state: State

var timer: float = 0.0
var previous_state: State

func init() -> void:
	player.player_damaged.connect(on_player_damaged)

func enter() -> void:
	timer = stun_duration
	player.velocity = Vector2.ZERO
	player.direction = Vector2.ZERO  # Reset input direction
	player.UpdateAnimation("idle")  # Use idle animation during stun

func exit() -> void:
	# Reset modulation when exiting stun state
	player.sprite.modulate = Color.WHITE

func process(delta: float) -> State:
	timer -= delta
	
	# Force velocity to zero during stun
	player.velocity = Vector2.ZERO
	player.direction = Vector2.ZERO
	
	# Calculate pulse modulation
	var pulse = (sin(timer * pulse_frequency * PI) + 1.0) / 2.0  # Creates a 0 to 1 wave
	var red_color = Color(1, 0, 0)  # Pure red
	var white_color = Color(1, 1, 1)  # White
	player.sprite.modulate = red_color.lerp(white_color, pulse)
	
	if timer <= 0:
		return next_state
	return self

func physics_process(_delta: float) -> State:
	# Keep player from moving during stun
	player.velocity = Vector2.ZERO
	return self

func set_previous_state(state: State) -> void:
	previous_state = state
	next_state = previous_state  # Return to the previous state after stun

func on_player_damaged(_current_hp: int) -> void:
	previous_state = player.state_machine.current_state
	next_state = previous_state
	player.state_machine.change_state(self) 