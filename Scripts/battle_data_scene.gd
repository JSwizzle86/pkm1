extends Control

var pokemon_data : Pokemon_Dex_Data

#References to sprite data
@onready var background_image = $BackgroundImage
@onready var footprint_sprite = $Footprint_Sprite
@onready var mini_sprite = $Mini_Sprite
@onready var high_res_sprite = $High_Res_Sprite
@onready var typing_1_sprite = $%Typing_1_Sprite
@onready var typing_2_sprite = $%Typing_2_Sprite

#references to dex stuff
@onready var dnum_name = %Dnum_Name
@onready var title = %Title
@onready var height = %Height
@onready var width = %Width
@onready var description = %Description


#References to input data


#Sprites for each typing | You'll have to add the textures yourself.
#SET EACH TO A TEXTURE2D BEFORE ADDING THE RESPECTIVE TYPE SPRITE
#It's just going to read the type combo and place them inside of a type container.
#if you don't like stretching. Try changing the hbox to a vbox

@export var type_sprites : Dictionary = {
	#type name : Texture
	"Normal":null,
	"Water":null,
	"Fire":null,
	"Grass":null,
	"Electric":null,
	"Fighting":null,
	"Dark":null,
	"Psychic":null,
	"Rock":null,
	"Flying":null,
	"Ground":null,
	"Dragon":null,
	"Fairy":null,
	"Bug":null,
	"Ice":null,
	"Ghost":null
}

func set_sprites():
	footprint_sprite.texture = pokemon_data.footprint_sprite
	mini_sprite.texture = pokemon_data.mini_sprite
	high_res_sprite.texture = pokemon_data.high_res_sprite

func set_dex_data():
	dnum_name.text = "No."+str(pokemon_data.dex_number)+" : "+pokemon_data.pokemon_name
	title.text = pokemon_data.pokemon_kind+ " Pokemon" #Accent Egu can suck me
	var converted_height = (pokemon_data.height_feet * 0.3048) + (pokemon_data.height_inches * 0.0254) 
	height.text = "HT: "+str(pokemon_data.height_feet) + "'" + str(pokemon_data.height_inches) + "(" + str(converted_height) + ".m)"#do the metric conversions idfk
	var converted_weight = (pokemon_data.weight * 0.4535924)
	height.text = "WT: " + str(pokemon_data.weight) + "lb" + "(" + str(converted_weight) + ".kg)"
	description.text = pokemon_data.pokedex_description

func open():
	set_sprites()

func scrub_data():
	dnum_name.text = ""
	title.text = ""
	pass
