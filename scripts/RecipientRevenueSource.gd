extends Resource
class_name RecipientRevShare

@export var id : int ## Unique identifier for a rev share.
@export var revenue_source : RevenueSourceData ## Revenue source linked to this share.
@export var linked_recipient : RecipientData ## Recipient source linked to this share.
@export var percentage : float ## Share of revenue.
@export var layer : int = 1 ## At which layer the recipient gets their rev share from. Eg: Layer 0 is from base revenue. Layer 1 takes their share from Layer 0's leftovers and so on.
@export var recoup : float ## Amount of money required to recoup before the final split is in effect.
@export var recoup_percentage : float ## Share of revenue before recoup is recouped.
@export_range(1,12,1) var start_month : int = 1 ## Start month where recipient starts calculating rev share. It's inclusive. Someone starting rev share in January will add January's total to be paid.
@export var start_year : int ## Start year where recipient starts calculating rev share.
@export_range(1,12,1) var end_month : int  = 1 ## End month where recipient stops calculating rev share. It's inclusive. Someone stopping rev share in January will add January's total to be paid.
@export var end_year : int = 9999 ## End date where recipient stops calculating rev share.

@export var archived : bool = false
