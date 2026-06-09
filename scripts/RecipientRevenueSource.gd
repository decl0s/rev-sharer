extends Resource
class_name RecipientRevShare

@export var revenue_source : RevenueSourceData
@export var percentage : float ## Share of revenue.
@export_range(1,12,1) var start_month : int = 1 ## Start month where recipient starts calculating rev share. It's inclusive. Someone starting rev share in January will add January's total to be paid.
@export var start_year : int ## Start year where recipient starts calculating rev share.
@export_range(1,12,1) var end_month : int  = 1 ## End month where recipient stops calculating rev share. It's inclusive. Someone stopping rev share in January will add January's total to be paid.
@export var end_year : int = 9999 ## End date where recipient stops calculating rev share.
