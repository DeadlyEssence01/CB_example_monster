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
