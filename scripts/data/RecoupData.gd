class_name RecoupData ## Data class for recoup.
extends BaseData

@export var revenue_source : RevenueSourceData ## Revenue source linked to this recoup.
@export var recipients : Array[RecipientData] ## All recipients linked to this recoup.
@export var transactions : Array[TransactionData] ## All transactions linked to this recoup.
