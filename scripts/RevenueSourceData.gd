extends Resource
class_name RevenueSourceData

enum Schedule {
	Monthly,
	Quarterly,
	Yearly
}

@export var id : int ## Unique ID for the revenue source.
@export var name : String ## Revenue source name.
@export var payout_schedule : Schedule ## Revenue payout schedule. Either Monthly, Quarterly, Yearly.
@export var revenue : Dictionary[float,Dictionary] ## Monthly revenue for source.

#func Get recipients attached.

#func Get total % allocated.
