extends "res://global/save_state/TapeCollection.gd"


func get_snapshot():
	var tape_snaps = []
	for tape in tapes_by_name:
		var snapshot = tape.get_snapshot()		
		if snapshot["form"].begins_with("res://mods/"):
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
				tape_snap.form = tape_snap.custom_form	
				print("converted custom tape back to custom form")	
		if tape.set_snapshot(tape_snap, version):
			add_tape(tape)
		else :
			return false
	return true
