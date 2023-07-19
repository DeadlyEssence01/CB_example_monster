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
	
