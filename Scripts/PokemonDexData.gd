extends Resource

class_name Pokemon_Dex_Data

@export_category("Sprites")
@export var high_res_sprite : Texture2D
@export var footprint_sprite : Texture2D
@export var overworld_sprite : Texture2D

#whatever ID
@export var dex_number : int = 0
@export var height_feet : float = 0.0
@export var height_inches : float = 0.0
@export var weight : float = 0.0 #in pounds
@export var pokemon_name : String = "Pokemon"

@export var pokedex_description = "This Miscellaneous Pokemon Pokes Your fucking eyes out"
@export var pokemon_kind = "Poking" #The BLANK pokemon
@export var type = ["Normal"]
