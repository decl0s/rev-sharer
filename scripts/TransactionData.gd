extends Resource
class_name TransactionData ## Data class for transactions.

@export var id : int ## Unique identifier of a transaction. 
@export var name : String ## Name for transaction amount.
@export var description : String ## Longer description if needed.
@export var amount : float ## Amount of money this transaction amounts to.

@export var archived : bool = false
