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
