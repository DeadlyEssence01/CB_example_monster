extends ContentInfo

var tapecollection_ext: Resource = preload("res://mods/de_example_monster/snapshots/TapeCollections_Ext.gd")
var party_ext: Resource = preload("res://mods/de_example_monster/snapshots/Party_Ext.gd")


func init_content() -> void:
	#Fix save files before they break!
	tapecollection_ext.take_over_path("res://global/save_state/TapeCollection.gd")
	party_ext.take_over_path("res://global/save_state/Party.gd")
	
	TranslationServer.add_translation(preload("mod_strings.en.translation"))
	_load_monsters("traffikrabdos")
	_load_traffikrabdos_spawn()


#Add monster to the game from the mod folder.
func _load_monsters(monster_name) -> void:
	yield (SceneManager.preloader, "singleton_setup_completed")
	var monster = load("res://mods/de_example_monster/" + monster_name + ".tres")
	MonsterForms.basic_forms[monster_name] = monster
	MonsterForms.by_name.append(monster)
	MonsterForms.by_index.append(monster)


func _load_traffikrabdos_spawn() -> void:
	#Load the spawn region we want to modify. 
	var spawn_region = preload("res://data/monster_spawn_profiles/harbourtown_beach.tres")
	#Create a new MonsterFormSpawnConfig, a file that tells the game how to spawn a monster.
	var spawn_config = spawn_region.MonsterFormSpawnConfig.new()
	#Load our monster.tres file and set it to the monster form of the spawn config. If you're loading your monster in from your mod folder, this should be the path to your monster.tres file.
	spawn_config.monster_form = preload("res://mods/de_example_monster/traffikrabdos.tres")
	#optional
	spawn_config.world_monster = preload("res://mods/de_example_monster/Traffikrabdos_world.tscn")
	#optional - High numbers spawn more often than lower numbers.
	spawn_config.weight = 0.33
	#optional - Earliest hour it will spawn.
	#spawn_config.hour_min = 0
	#optional - Latest hour it will spawn
	#spawn_config.hour_max = 24
	#Add the configuration we just set, to the spawn region we loaded earlier.
	spawn_region.configs.push_back(spawn_config)
