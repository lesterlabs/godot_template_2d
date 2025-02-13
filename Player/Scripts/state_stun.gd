extends State
class_name PlayerStateStun

@export var stun_duration: float = 0.5
@export var pulse_frequency: float = 10.0  # How many times per second to pulse
@export var next_state: State
@onready var idle_state: State_Idle = $"../Idle"

var timer: float = 0.0
var previous_state: State

func Init() -> void:
	# Add a print to debug
	print("Stun state initializing")
	print("Player reference exists: ", player != null)
	
	if player:
		# Check if signal is already connected to avoid duplicates
		if not player.player_damaged.is_connected(on_player_damaged):
			player.player_damaged.connect(on_player_damaged)
			print("Stun state connected to player_damaged signal")

func Enter() -> void:
	print("Player stunned")
	timer = stun_duration
	player.velocity = Vector2.ZERO
	player.direction = Vector2.ZERO  # Reset input direction
	player.UpdateAnimation("idle")  # Use idle animation during stun

func Exit() -> void:
	# Reset modulation when exiting stun state
	player.sprite.modulate = Color.WHITE

func Process(delta: float) -> State:
	timer -= delta
	
	# Force velocity to zero during stun
	player.velocity = Vector2.ZERO
	
	# Calculate pulse modulation
	var pulse = (sin(timer * pulse_frequency * PI) + 1.0) / 2.0  # Creates a 0 to 1 wave
	var red_color = Color(1, 0, 0)  # Pure red
	var white_color = Color(1, 1, 1)  # White
	player.sprite.modulate = red_color.lerp(white_color, pulse)
	
	if timer <= 0:
		return next_state
	return self

func Physics(_delta: float) -> State:
	# Keep player from moving during stun
	player.velocity = Vector2.ZERO
	return self

func SetPreviousState(state: State) -> void:
	previous_state = state
	next_state = previous_state  # Return to the previous state after stun

func on_player_damaged() -> void:
	next_state = idle_state
	player.state_machine.ChangeState(self) 
