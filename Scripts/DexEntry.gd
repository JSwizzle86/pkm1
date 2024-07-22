extends HBoxContainer

@onready var pokemon_name = %PokemonName
@onready var dex_number = %DexNumber
@onready var pokemon_sprite = $MarginContainer/PokemonSprite

var pokemon_data : Pokemon_Dex_Data

func when_created():
	pokemon_name = pokemon_data.pokemon_name
	pokemon_sprite = pokemon_data.overworld_sprite
	dex_number = "#"+str(pokemon_data.dex_number)
