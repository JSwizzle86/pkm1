extends Component
class_name MovementComponent

enum MovementType {
	Spin,
	Circular,
	Random,
}

@export var type : MovementType
@export var speed : float = 40.0
@export var run_multiplier : float = 1.5 
@export var running : bool = false
@export var steps : int = 0
@export var random : bool = false
