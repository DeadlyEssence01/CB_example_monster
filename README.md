## Creating your First Monster

This guide will act as a stand-in "Part 3" of the wiki's "Monster Making Guide", and be an example for setting up your own creatures - with a compatibility friendly approach.

This guide is going to assume that you've already downloaded Godot, and set up your [Modding Environment](https://wiki.cassettebeasts.com/wiki/Modding:Mod_Developer_Guide).

To create a monster you'll want to decide if you're going to stay within vanilla specifications, or branch out. [Part 1 of the Monster Making Guide](https://wiki.cassettebeasts.com/wiki/Modding:Monster_Making_Guide_Part_1) has the information on conceptualizing a creature, and setting it up to work within the Cassette Beasts' world, as well as making your art. 

Next, you'll want to work on setting up your [Fusion Form, as shown in Part 2.](https://wiki.cassettebeasts.com/wiki/Modding:Monster_Making_Guide_Part_2)

*This guide does not yet cover implementing your own fusion parts.*


## Adding Your Monster to CB.
This is probably the easiest part!

### What You'll need 
1. Battle sprite .png and .json
1. World sprite .png and .json (optional)
1. Battle cry .wav (optional)
1. Tape sticker image .png (optional)

You'll need to create a:
1. A list of move tags to use
1. A list of initial moves
1. A bio for the bestiary


Assuming you already have a folder for your monster mod in your CB modding environment - make sure all of your files are in your mod folder. You can put them in subfolders if you'd like to organize them.

If you don't already, you'll want to add a metadata.tres file to your mod folder, don't bother filling out the information yet. The Modding Environment Guide at the top explains how to add a metadata.tres, if you don't know how. In order to preserve compatibility with other mods that change the monster spawn configuration you'll want to create a new script file in your folder, it should extend from `ContentInfo`. You may name it whatever you want, the example monster mod names this file `mod.gd`. Now open metadata.tres in the editor. The file will open in the rightmost "Inspector" window. At the bottom there is a "Script" which shows `ContentInfo`. Drag your script to that spot. Now you may fill out your mod information in the `metadata.tres`. Filling out the information prior to changing the script the metadata file uses, causes all your information to be reset.

Now that we have that set up, let's get a new Monster.tres file set up. If you have a monster in mind that you'd like yours to mimic, you can go to `data/monster_forms` and copy, paste and rename the .tres file of the monster you'd like to replicate. Otherwise, you can start fresh with a new monster template, (this method is slightly more tedious). To do that, right click on the `monster_forms` folder, and click "add resource". Type in "MonsterForm" and select `MonsterForm (MonsterForm.gd)` from the list. Name it the name of your monster. i.e. `traffikrabdos.tres`. 
(NOTE: If you want to not break saves by using the code listed at the end of this guide, prefix your monster's file name with `mods_`. i.e. `mods_traffikrabdos.tres`, otherwise there will be a mod to fix saves.)

Now, double click the monster's tres file. In this file there are a bunch of sections to fill out with information about your monster. I am not going to walk you through each one, but I will cover a few. You may look at the monsters in `data/monster_forms` or the `traffikrabdos.tres` in the example monster mod, to see what kind of information goes where. 

1. Name: Traffikrabdos uses translation strings instead of just putting "traffikrabdos" in it's name field. You may either write out everything in the editor plainly i.e. "Traffikrabdos", or you may use a translation csv file. Open `mod_strings.csv` in the example to see how it works. The added benefit of having all of your strings there is that you can modify all the text that will show up in your mod in one place, the downside is you'll need to make sure to reference the keys exactly or your text wont show, (and register your translations string file with the game - which I will show you how to do).
1. Swap Colors: this is an array (aka list) of colors that monster has, so the game knows which colors to swap out for bootlegs.
1. Named Positions. Try to fill out the named positions on your monster so that moves show up correctly. If you hover over the various fields in your pixel editor like Aseprite, you should be able to get the x and y coordinate for that position, usually shown in the bottom left of the pixel editor.
	1. if you started with a blank monsterform.tres file, you wont see any predefined keys. You'll want to add a string key called "attack" and add a vector 2, with the x and y position of where an attack should originate from. Then add "decoy", "eye, and "hit" with their respective positions.
1. Elemental Types: A size array of 1 will allow you one typing, you may  have dual typings if you wish, and presumably more. You'll want to drag an elemental type from the editor in `data/elemental_types` to the 0 entry of the array of elemental types. To make something dual typing, simply increase the size of the array to 2, and add the second element.
1. Tape Sticker Texture: should be a png file of what you'd like the tape sticker to look like.
1. Battle Sprite Path: Make sure to put the path to your battle sprite's json. If you right click a the battle sprite json in the Godot editor you can "Copy Path" and then paste it to fill that information in.
1. Description: This is a short description of your monster. Traffikrabdos' is "a double coned crab".
1. Move Tags: This section is a bit weird, as monsters get moves based on their tags. All moves have tags, and whatever tag you give a monster will determine what move set it gets. [You may look through moves, and their associated tags on the wiki.](https://wiki.cassettebeasts.com/wiki/Data:Moves) Eventually, I may be able to release a doc with all the tags list and the moves associated with them, instead of having to search for tags and click through each move.
1. Tape Upgrades: This is an array. Tapes get up to 5 stars so you can have up to 5 upgrades. 0 is the upgrade given at 1 star, 1 is the upgrade given at 2 stars, etc. If you created an empty `Monster_Form` resource, then you will need to increase the size to 5, and in each `[empty]` slot you'll want to find and click `New TapeUpgradeMove`, this will allow you to optionally add a new slot on upgrade, and a new sticker. You can drag and drop stickers into the `sticker` slot from `data/battle_moves`.
1. Bestiary Index: this should be -1 for all modded monsters.
1. Bestiary Bios: This is broken up into 2 sections (Your array should be size 2). The first is the default bio your monster shows. The second is the additional bio information unlocked by getting the monster to 5 stars. 

Once you've filled all that out, your monster is *almost* done. Congrats! You've made it this far.

We have three more things to cover: 
1. Making the game recognize your monster (add it to the bestiary, make it available through give_tape commands, etc).
1. Adding your monster to the spawn config in a compatibility friendly way.
1. Save files.

### Optional: World Sprite TSCN
If you'd like your monster to spawn on the overworld, you'll at minimum need to copy a preexisting .tscn file located in `world/monsters` to your mod folder. Rename the file something obvious like `monster_form_world.tscn` the file name doesn't really matter. Open up the file, and rename the root node to the name of your monster. After that you'll want to drag your world sprite .json file into the editor onto the "Sprite" node. A new node named "Sprite" will appear. If you left padding and borders to 1 in your export file for the world sprite, you may need to move your world sprite down a little in the editor for the monster to be standing on the ground correctly. Use the existing monster's feet as a reference. Delete the original creature's image node under the "Sprite" node. You can rename the "Sprite" node you created from the .json to be your monster's name. Save the .tscn and you're done! 


### Making the Game Recognize Your Monster

This is where the things start to get a little divergent. 
First, I'm going to talk about getting your monster recognized by the game. This guide has thus far defaulted to having you add a monster to the `monster_forms` directory directly. This is the most straight forward way. However, you may want to keep all of your mod files in your mod folder, this is also possible but requires a bit more finesse (and extra work!).

To take the easy way, you've already added your monster to the `monster_forms` directory. Great. Open your `metadata.tres` file and we'll go to "Modified Files" in the inspector. Increase the array to size 1, and drag your monster's .tres file to the modified file slot. Now, when you export your mod, the game will recognize your monster and the rest is magic.

To take the hard way, and keep all of your monsters in your mod folder you'll first want to move your monster.tres from the `monster_forms` folder to where you'd like it to reside in your mod folder. Next we're going to have to do some coding. 

Start by making sure your `mod.gd` file looks like this:

```gdscript
func init_content():
	load_monsters()


func load_monster(monster_name):
	yield (SceneManager.preloader, "singleton_setup_completed")
	var custom_monster = load("res://mods/de_example_monster/" + monster_name + ".tres") #change this path to be your mod folder
	MonsterForms.basic_forms["custom_monster"] = custom_monster
	MonsterForms.by_name.append(custom_monster)
	MonsterForms.by_index.append(custom_monster)
```



### Spawn Config
This is how you set up where you want your monster to spawn, whether in the overworld or as a support battler.

First, figure out the name of the region(s) you want it to spawn in. Now we need to find the spawn profile for that region(s). Spawn profiles are found in `data/monster_spawn_profiles`. I added traffikrabdos to `harbourtown_beach.tres`, so he will spawn on the beach chunks. Make sure to check what chunks the region covers, you may need to add more than one spawn config to cover all the areas you'd like it to spawn.

Let's go ahead and open up the script, `mod.gd` from the example project, if you named it the same as the example. Depending on your script set up, you will either have a blank script file that has "extends ContentInfo" at the top, or you'll have some basic functions / comments added in. We don't really need anything from the functions or comments, but we will keep the extends at the top. As the modding guide explains, we want to set up our information in the `init_content()` function.


```gdscript
extends ContentInfo


#Function we should call to set up mod data.
func init_content() -> void:
	#Add our translation strings to the Translation Server, if we made a mod_strings.csv and imported it into the editor.
	TranslationServer.add_translation(preload("mod_strings.en.translation"))

	#load_monster function can be here if you're loading monsters from the mod folder.

	#Load the spawn region we want to modify. 
	var spawn_region = preload("res://data/monster_spawn_profiles/harbourtown_beach.tres")

	#Create a new MonsterFormSpawnConfig, a file that tells the game how to spawn a monster.
	var spawn_config = spawn_region.MonsterFormSpawnConfig.new()

	#Load our monster.tres file and set it to the monster form of the spawn config. This should be the path to your monster.tres file.
	#spawn_config.monster_form = preload("res://data/monster_forms/traffikrabdos.tres") #this is an example of a monster_forms modded monster
	spawn_config.monster_form = preload("res://mods/de_example_monster/traffikrabdos.tres") #this is for a mod folder modded monster.

	#optional
	spawn_config.world_monster = preload("res://mods/de_example_monster/Traffikrabdos_world.tscn") #this should be the path to your monster's world .tscn

	#optional - High numbers spawn more often than lower numbers.
	spawn_config.weight = 1 

	#optional - Earliest hour it will spawn.
	#spawn_config.hour_min = 0

	#optional - Latest hour it will spawn
	#spawn_config.hour_max = 24

	#Add the configuration we just set, to the spawn region we loaded earlier.
	spawn_region.configs.push_back(spawn_config)
```

Now, when the game loads, our translation strings will load in, and our spawn config will be set.


### Save Files - Optional
Adding new monsters to the game, and then removing the mod that adds them breaks the save file. There are currently two ways to fix this. 1. Requesting the player download [this mod that doesn't exist yet]() the mod will fix broken saves, or by using the code below [(based on code from NCrafter)](https://github.com/ninaforce13/CassetteBeasts-CustomMonsterTest/blob/main/Custom%20Monster/TapeCollections_Ext.gd) to make your mod not break the save to begin with. 

The code pasted below does not yet fix a save if a modded monsters is given to Frankie.  NCrafter is updating the GitHub repository and updates to this guide will soon follow. 


In `mod.gd` you'll need to add the below code prior to `func init_content() -> void:` and replace your folder name with your mod's folder name.

```gdscript
var tapecollection_ext: Resource = preload("res://mods/de_example_monster/snapshots/TapeCollections_Ext.gd")
var party_ext: Resource = preload("res://mods/de_example_monster/snapshots/Party_Ext.gd")
var choose_frankie_ext: Resource = preload("res://mods/de_example_monster/snapshots/ChooseFrankieTape_Ext.gd")
var frankie_tape_config_ext: Resource = preload("res://mods/de_example_monster/snapshots/FrankieTapeConfig_Ext.gd")

```

Then, you can either download the four files from NCrafter's github repository, `TapeCollections_Ext.gd`, `Party_Ext.gd`, `ChooseFrankieTape_Ext.gd`, and `FrankieTapeConfig.gd` and put them in the base folder of your mod, or copy the code below. The scripts are here in case the github is unavailable at some point.


**If you're loading your monster form in through the `monster_forms` directory you need to have a prefix on all of your monsters.tres files of "mod_".**

Create a script called `TapeCollections_Ext.gd` and make it extend `"res://global/save_state/TapeCollection.gd"`.
In that script it should look like this:

```gdscript
extends "res://global/save_state/TapeCollection.gd"


func get_snapshot():
	var tape_snaps = []
	for tape in tapes_by_name:
		var snapshot = tape.get_snapshot()		
		if snapshot["form"].begins_with("res://mods/") or snapshot["form"].begins_with("res://data/monster_forms/mods_"):
			snapshot["custom_form"] = snapshot["form"]
			snapshot["form"] =  "res://data/monster_forms/traffikrab.tres"
			print("caught custom mon in storage")
		tape_snaps.push_back(snapshot)
	return {
		"tapes":tape_snaps
	}

func set_snapshot(snap, version:int)->bool:
	clear()
	for tape_snap in snap.tapes:
		var tape = MonsterTape.new()
		if tape_snap.has("custom_form"):
			if tape_snap.custom_form != "":
				var form = load(tape_snap.custom_form) as MonsterForm
				if form:									
					tape_snap.form = tape_snap.custom_form	
					print("converted custom tape back to custom form")	
		if tape.set_snapshot(tape_snap, version):
			add_tape(tape)
		else :
			return false
	return true
```

Next, we need to create another script called `Party_Ext.gd` and it will need to extend `"res://global/save_state/Party.gd"`.
That script should look like:

```gdscript
extends "res://global/save_state/Party.gd"


func get_snapshot():
	var partners_snap = {}
	for partner in partners:
		if unlocked_partners.has(partner.partner_id) or partner.partner_id == current_partner_id:
			partners_snap[partner.partner_id] = partner.get_snapshot()
	var playersnap = player.get_snapshot()
	for snapshot in playersnap.tapes:		
		if snapshot["form"].begins_with("res://mods/") or snapshot["form"].begins_with("res://data/monster_forms/mods_"):
			snapshot["custom_form"] = snapshot["form"]
			snapshot["form"] =  "res://data/monster_forms/traffikrab.tres"		
			print("caught custom mon in party")
	return {
		"fusion_meter":fusion_meter.get_snapshot(), 
		"player":playersnap, 
		"current_partner_id":current_partner_id, 
		"unlocked_partners":unlocked_partners.duplicate(), 
		"partners":partners_snap, 
		"max_tapes":max_tapes
	}

func set_snapshot(snap, version:int)->bool:
	partners.clear()
	for i in range(source_partners.size()):
		var p = source_partners[i].duplicate()
		partners.push_back(p)
	start_new_file()
	for tape_snap in snap.player.tapes:
		if tape_snap.has("custom_form"):
			if tape_snap.custom_form != "":
				var form = load(tape_snap.custom_form) as MonsterForm
				if form:									
					tape_snap.form = tape_snap.custom_form					
					print("converted custom form in party")		
	fusion_meter.set_snapshot(snap.get("fusion_meter"), version)
	if not get_player().set_snapshot(snap.player, version):
		return false
	
	if snap.has("unlocked_partners"):
		unlocked_partners = snap.unlocked_partners.duplicate()
	else :
		unlocked_partners = ["kayleigh"]
	
	if snap.has("partners"):
		for id in snap.partners.keys():
			var p = get_partner_by_id(id)
			if p != null:
				if not p.set_snapshot(snap.partners[id], version):
					return false
		for id in snap.partners.keys():
			var p = get_partner_by_id(id)
			if p != null:
				get_parent().stats.get_stat("relationship_level").set_count(id, p.relationship_level)
	
	if snap.has("current_partner_id"):
		set_current_partner_id(snap.current_partner_id)
	else :
		set_current_partner_id(default_partner_id)
	
	if version < 2:
		max_tapes = snap.max_size
	else :
		max_tapes = snap.max_tapes
	
	return true
	
```

For `ChooseFrankieTape_Ext.gd:`, extends: `"res://cutscenes/sidequests/frankie/ChooseFrankieTape.gd"`.
```gdscript
extends "res://cutscenes/sidequests/frankie/ChooseFrankieTape.gd"

func _run():
	var tapes = SaveState.party.get_tapes()
	var tape = yield (MenuHelper.show_choose_tape_menu(tapes, Bind.new(self, "_tape_filter")), "completed")
	if not tape:
		return false
	
	assert (tape.form != null)
	blackboard.species_name = tape.form.name
	blackboard.species_description = tape.form.description
	
	var msg = Loc.trf(confirm_message, {species_name = tape.get_name()})
	if not yield (MenuHelper.confirm(msg), "completed"):
		return false
	
	SaveState.party.remove_tape(tape)
	for i in range(tape.get_max_stickers()):
		var sticker = tape.peel_sticker(i)
		if sticker:
			SaveState.inventory.add_item(sticker)
	
	tape.hp.set_to(1, 1)
	var snap = tape.get_snapshot()
	if snap["form"].begins_with("res://mods/") or snap["form"].begins_with("res://data/monster_forms/mods_"):
		snap["custom_form"] = snap["form"]
		snap["form"] =  "res://data/monster_forms/traffikrab.tres"
		print("Intercepted Frankie Tape. Adding hotfix")	
	snap.version = SaveState.CURRENT_VERSION
	SaveState.other_data[data_key] = snap
	
	return true
```

For `FrankieTapeConfig_Ext.gd:`, extends `"res://world/quest_scenes/FrankieTapeConfig.gd"`
```gdscript
extends "res://world/quest_scenes/FrankieTapeConfig.gd"

func _generate_tape(rand:Random, defeat_count:int)->MonsterTape:
	var result = ._generate_tape(rand, defeat_count)
	
	var snap = SaveState.other_data.get(data_key).duplicate()
	if snap:
		if snap.has("custom_form"):
			if snap.custom_form != "":
				var form = load(snap.custom_form) as MonsterForm
				if form:									
					snap.form = snap.custom_form						
					print("converted custom tape back to custom form")			
		result.set_snapshot(snap, snap.get("version", 0))
	
	for threshold in evolve_defeat_counts:
		if threshold > defeat_count:
			break
		var selected_evo = null
		for evo in result.form.evolutions:
			if not evo.is_secret:
				selected_evo = evo
		if selected_evo:
			result.evolve(selected_evo)
	
	return result
```


**Do not modify these scripts to be personal to your mod, if you do, any other monster mod that adds these scripts runs the chance of being overwritten by or overwriting your changes.**

If another mod is loaded after the monster mod that also changes either TapeCollections.gd or Party.gd it could break the functionality that keeps saves from breaking.


That about covers it for creating a custom monster! I look forward to seeing your creations!~


