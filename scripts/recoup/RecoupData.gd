extends Resource
class_name RecoupData ## Data class for recoup.

@export var id : int ## Unique identifier of a recoup. 
@export var revenue_source : RevenueSourceData ## Revenue source linked to this recoup.
@export var recipients : Array[RecipientData] ## All recipients linked to this recoup.
@export var transactions : Array[TransactionData] ## All transactions linked to this recoup.

@export var archived : bool = false
