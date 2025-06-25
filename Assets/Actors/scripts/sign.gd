class_name TalkTile extends Area2D

@export var object_data: TalkableObjectData

func interact(player: Player):
	$TalkableArea._interact(object_data, player)
