extends RefCounted
## Wall time identifies the real decision instant; simulation time is supplied by the authoritative owner.
static func capture() -> Dictionary:
	var unix := Time.get_unix_time_from_system()
	var zone := Time.get_time_zone_from_system()
	var bias: int = zone.bias
	var local := Time.get_datetime_string_from_unix_time(int(unix) + bias * 60)
	return {"local_datetime":local + ("+" if bias >= 0 else "-") + "%02d:%02d" % [absi(bias)/60,absi(bias)%60],"timezone":zone.name,"wall_unix":unix}
