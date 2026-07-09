extends BaseData
class_name RecipientData ## Data class for recipients.

@export var name : String ## Name and identifier for recipients.
@export var minimum_payout : int ## Minimum amount of money to be paid out.
@export var shares : Dictionary[int,RecipientRevShare] ## Rev shares and Percentages across dates Start-End .
@export var payments : Dictionary[float,Dictionary] ## Dicitonary of Amount, Date
