extends BaseData
class_name RevenueSourceData

enum Schedule {
	Monthly,
	Quarterly,
	Yearly
}

@export var name : String ## Revenue source name.
@export var description : String ## Short description for the revenue source.
@export var payout_schedule : Schedule ## Revenue payout schedule. Either Monthly, Quarterly, Yearly.
@export var revenue : Dictionary[int,RevenueData] ## Monthly revenue for source.
@export var recoup : RecoupData = RecoupData.new()
@export var shares : Array[int] ## Array of rev share ids 
