extends Component
class_name MovementComponent

enum MovementType {
	Spin,
	Circular,
	Random,
}

@export var type : MovementType
@export var speed : float = 40.0
@export var steps : int = 0
@export var random : bool = false
