extends RefCounted
## Public row comparison. Missing numeric values always last, in either direction.
const KEYS = ["contact_id","center_id","assessment","confidence","severity","remaining","operational_status"]
static func sorted_rows(rows: Array, column: int, ascending: bool) -> Array:
	var result := rows.duplicate(true)
	var key: String = KEYS[column]
	result.sort_custom(func(a,b):
		var av: Variant = a.get(key)
		var bv: Variant = b.get(key)
		if (av == null) != (bv == null): return av != null
		var comparison := 0
		if av != null and bv != null:
			if av is String: comparison = av.nocasecmp_to(str(bv))
			elif av < bv: comparison = -1
			elif av > bv: comparison = 1
		if comparison == 0: return int(a.contact_id) < int(b.contact_id)
		return comparison < 0 if ascending else comparison > 0)
	return result
