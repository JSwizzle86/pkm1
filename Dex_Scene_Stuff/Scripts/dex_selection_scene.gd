extends Control

var up_input = "ui_up"
var down_input = "ui_down"
@onready var Pokemon_list = $%Pokemon_list
const DEX_ENTRY_BUTTON = preload("res://Dex_Scene_Stuff/Scenes/DexEntryButton.tscn")
var dex_entries = []

var dex_loaded = false

func load_dex():
	for c in FakePokedex.pokedex_array:
		var d = DEX_ENTRY_BUTTON.instantiate()
		d.pokemon_data = c.pokemon_dex_data
		dex_entries.append(d)
		Pokemon_list.add_child(d)
	dex_entries[0].grab_focus()

func _process(_delta):
	if(Pokemon_list != null and !dex_loaded):
		print("dex_loaded called")
		load_dex()
		dex_loaded = true

#This is called when inputing shit so I'm using this intead of process which is always active
func _unhandled_input(event):
	var input_direction = Input.get_axis(up_input, down_input)
	


func _on_pokemon_list_ready():
	load_dex()
