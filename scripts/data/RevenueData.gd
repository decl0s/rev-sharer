extends BaseData
class_name RevenueData ## A revenue is a transaction linked to a revenue source. It's an income.

@export var name : String ## Name of the revenue.
@export var description : String ## Description of the revenue.
@export var revenue_source : RevenueSourceData ## Revenue source linked to this revenue.
@export var transaction : TransactionData ## Transaction linked to this revenue.
@export var is_processed : bool = false ## If the transaction is processed or not. Processed makes it not count towards to be processed out totals.
