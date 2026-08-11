extends Node
class_name GlobalData

@export var revenue_sources : Dictionary[int,RevenueSourceData]
@export var recipients : Dictionary[int,RecipientData]
@export var recoups : Dictionary[int,RecoupData]
@export var transactions : Dictionary[int,TransactionData]
@export var revenues : Dictionary[int, RevenueData]
@export var payments : Dictionary[int, PaymentData]
@export var rev_shares : Dictionary[int,RecipientRevShare]

@export var settings : SettingData = SettingData.new() #TODO: UPDATE ON LAUNCH

func _ready() -> void:
	dev_populate_mock_revenue_sources(10)
	dev_populate_mock_recipients(10)

var mock_revenue_names : Array[String] = ["Goonipilant","Anthro Heat","Merch","Counter Strike Skins","The One","Bath Water Selling","Casino Winnings","Pyramid Scheme"]
func dev_populate_mock_revenue_sources(amount : int) -> void: ## Creates mock data for testing.
	for i : int in amount:
		var mock_revenue : RevenueSourceData = RevenueSourceData.new()
		mock_revenue.id = get_next_id(revenue_sources)
		mock_revenue.name = mock_revenue_names.pick_random() + str(i)
		mock_revenue.payout_schedule = [0,1,2].pick_random()
		mock_revenue.recoup = RecoupData.new()
		revenue_sources[mock_revenue.id] = mock_revenue

var mock_names : Array[String] = ["Alex","Marl","Ted","Alan","Ana","Julien","Martin","Nancy"]
func dev_populate_mock_recipients(amount : int) -> void: ## Creates mock data for testing.
	for i : int in amount:
		var mock_recipient : RecipientData = RecipientData.new()
		mock_recipient.id = get_next_id(recipients)
		mock_recipient.name = mock_names.pick_random() + str(i)
		mock_recipient.minimum_payout = randi_range(10,300)
		#mock_recipient.revenue_sources.append(revenue_sources.pick_random())
		recipients[mock_recipient.id] = mock_recipient

func get_next_id(dict_or_array : Variant) -> int :
	if dict_or_array is Dictionary:
		if dict_or_array.keys().is_empty() :
			return 0
		return dict_or_array.keys().max() + 1
	
	elif dict_or_array is Array:
		return dict_or_array.max() + 1
	
	return 0

# -----------------------------
# RESOURCE CREATION
# -----------------------------

func create_data(new_resource : Resource) -> int:
	if new_resource is RecipientData:
		new_resource.id = get_next_id(recipients)
		recipients[new_resource.id] = new_resource
		Sig.create_recipient()
		return new_resource.id
		
	elif new_resource is RevenueSourceData:
		new_resource.id = get_next_id(revenue_sources)
		revenue_sources[new_resource.id] = new_resource
		Sig.create_revenue_source()
		return new_resource.id
		
	elif new_resource is RecoupData:
		new_resource.id = get_next_id(recoups)
		recoups[new_resource.id] = new_resource
		Sig.create_recoup()
		return new_resource.id
		
	elif new_resource is TransactionData:
		new_resource.id = get_next_id(transactions)
		transactions[new_resource.id] = new_resource
		Sig.create_transaction()
		return new_resource.id
		
	elif new_resource is RevenueData:
		new_resource.id = get_next_id(revenues)
		revenues[new_resource.id] = new_resource
		Sig.create_revenue()
		return new_resource.id
		
	elif new_resource is PaymentData:
		new_resource.id = get_next_id(payments)
		payments[new_resource.id] = new_resource
		Sig.create_payment()
		return new_resource.id
	return -999

# -----------------------------
# ASSIGNERS
# -----------------------------

func add_rev_share_to_recipient(desired_recipient : RecipientData, desired_rev_share : RecipientRevShare) -> void:
	recipients[desired_recipient.id].shares[desired_rev_share.id] = desired_rev_share
	rev_shares[desired_rev_share.id] = desired_rev_share
	#print("Added revenue source to ", desired_recipient.name)
	print(recipients[desired_recipient.id].shares)
	Sig.add_rev_share_to_recipient()

func delete_share_from_recipient(desired_recipient : RecipientData, desired_rev_share : RecipientRevShare) -> void:
	print("Removing Revenue Source from ", desired_recipient.name)
	Global.recipients[desired_recipient.id].shares.erase(desired_rev_share.id)
	rev_shares.erase(desired_rev_share.id)
	Sig.delete_rev_share_from_recipient()

# -----------------------------
# DELETERS
# -----------------------------

func delete_data(desired_data : Resource) -> void:
	if desired_data is RecipientData:
		Global.recipients[desired_data.id].archived = true
		Sig.delete_recipient()
		
	elif desired_data is RevenueSourceData:
		Global.revenue_sources[desired_data.id].archived = true
		Sig.delete_revenue_source()
		
	elif desired_data is RecoupData:
		Global.recoups[desired_data.id].archived = true
		Sig.delete_recoup()
		
	elif desired_data is TransactionData:
		Global.transactions[desired_data.id].archived = true
		Sig.delete_transaction()
	
	elif desired_data is RevenueData:
		Global.revenues[desired_data.id].archived = true
		Sig.delete_revenue()
	
	elif desired_data is PaymentData:
		Global.payments[desired_data.id].archived = true
		Sig.delete_payment()

# -----------------------------
# GETTERS
# -----------------------------

func get_recipients_linked_to_rev(revenue_source : RevenueSourceData) -> Array[RecipientData]:
	var linked_recipients : Array[RecipientData]
	for recipient : RecipientData in recipients.values():
		if recipient.archived == false:
			for share_id : int in recipient.shares.keys():
				if share_id == revenue_source.id:
					linked_recipients.append(recipient)
					continue
	return linked_recipients

func get_available_recipients() -> Array[RecipientData]:
	var recipient_array : Array[RecipientData] = []
	
	for recipient : RecipientData in recipients.values():
		if recipient.archived == true:
				continue
		recipient_array.append(recipient)
	
	return recipient_array

func get_allocated_percentage(checked_revenue_source : RevenueSourceData) -> float: ## Returns total allocated percentage of this revenue source.
	# Check for every recipient if they have it as a revenue source.
	# If so add its percentage to total
	# Return total
	
	var allocated_percentage : float = 0
	
	for recipient : RecipientData in recipients.values():
		if recipient.archived == true: # Skip if archived
			continue
		
		var recipient_shares : Array[RecipientRevShare] = recipient.shares.values()
		
		for share : RecipientRevShare in recipient_shares:
			if share.revenue_source == checked_revenue_source:
				allocated_percentage += share.percentage
	
	return allocated_percentage

func get_total_recoup_spend(rev_source : RevenueSourceData) -> float:
	var total : float = 0
	for transaction : TransactionData in rev_source.recoup.transactions:
		if transaction.archived != true:
			total += transaction.amount
	return total

func get_total_recovered_recoup(rev_source : RevenueSourceData) -> float :
	var total : float = 0
	for transaction : TransactionData in rev_source.recoup.reimbursements:
		if transaction.archived != true:
			total += transaction.amount
	return total

func get_total_revenue(rev_source : RevenueSourceData) -> float:
	var total : float = 0
	for revenue : RevenueData in rev_source.revenue :
		if revenue.transaction.archived != true:
			total += revenue.transaction.amount
	return total

func get_rev_sources_with_unprocessed_rev() -> Array[RevenueSourceData]:
	var array : Array[RevenueSourceData] = []
	for rev_source : RevenueSourceData in revenue_sources.values() :
		for revenue : RevenueData in rev_source.revenue:
			if revenue.is_processed == false and revenue.archived == false:
				array.append(rev_source)
				continue
	var unique_array : Dictionary
	for rev_source :RevenueSourceData in array:
		unique_array[rev_source] = true
	return unique_array.keys()

func get_available_shares(desired_recipient : RecipientData) -> Array[RevenueSourceData]:
	var sources : Array[RevenueSourceData] = []
	
	# Ignore if archived.
	for source : RevenueSourceData in revenue_sources.values():
		if source.archived == true:
				continue
		sources.append(source)
	
	# Ignore if already owned
	for linked_rev_share : RecipientRevShare in desired_recipient.shares.values() :
		#print("Already owns ", linked_rev_share.revenue_source)
		sources.erase(linked_rev_share.revenue_source)
	#print("Available Revenue Sources: ", sources)
	return sources

func get_awaiting_payment_rev_sources(recipient : RecipientData) -> Array[RevenueSourceData]:
	var rev_sources_to_populate : Array[RevenueSourceData]
	for rev_source : RevenueSourceData in recipient.shares.values() :
		var unpaid_total : float = 0
		for payment : PaymentData in recipient.payments :
			if payment.rev_source == rev_source and payment.is_paid == false:
				unpaid_total += payment.transaction.amount
		if unpaid_total != 0:
			rev_sources_to_populate.append(rev_source)
	return rev_sources_to_populate

func get_total_paid(recipient : RecipientData) -> float:
	var total : float = 0
	for payment : PaymentData in recipient.payments:
		if payment.is_paid == true and payment.archived == false:
			total += payment.transaction.amount
	return total

func get_total_unpaid(recipient : RecipientData) -> float:
	var total : float = 0
	for payment : PaymentData in recipient.payments:
		if payment.is_paid == false and payment.archived == false:
			total += payment.transaction.amount
	return total

func get_unprocessed_total(rev_source : RevenueSourceData) -> float :
	var unprocessed_total : float = 0
	for revenue : RevenueData in rev_source.revenue :
		if revenue.archived == false and revenue.is_processed == false:
			unprocessed_total += revenue.transaction.amount
	return unprocessed_total

func get_layer_unprocessed_totals(rev_source : RevenueSourceData, layer : int, total_before_layer : float, unrecouped_amount : float) -> Dictionary:
	var dict : Dictionary[int,Dictionary] = {
		-1 : { ## -1 IS TOTAL
			&"pre_recoup" : 0, # before recoup has been met
			&"post_recoup" : 0, # after
			&"total_after_layer" : 0, # total
			}
			## REST IS RECIPIENT IDS
	}
	
	var pre_recoup_total : float = total_before_layer
	
	for recipient: RecipientData in get_recipients_linked_to_rev(rev_source):
		dict[recipient.id] = {
					&"pre_recoup" : 0,
					&"post_recoup" : 0,
					&"total" : 0,
				}
	
	if unrecouped_amount > 0:
		for recipient: RecipientData in get_recipients_linked_to_rev(rev_source):
			if recipient.shares[rev_source.id].layer == layer:
				var pre_recoup_share : float = total_before_layer * recipient.shares[rev_source.id].recoup_percentage
				dict[recipient.id][&"pre_recoup"] = pre_recoup_share
				pre_recoup_total -= pre_recoup_share
	
	dict[-1][&"pre_recoup"] = pre_recoup_total
	
	var post_recoup_leftover : float = total_before_layer - dict[-1][&"pre_recoup"]
	
	if post_recoup_leftover > 0:
		for recipient: RecipientData in get_recipients_linked_to_rev(rev_source):
			if recipient.shares[rev_source.id].layer == layer:
				var post_recoup_share : float = total_before_layer * recipient.shares[rev_source.id].percentage
				dict[recipient.id][&"post_recoup"] = post_recoup_share
				
				post_recoup_leftover -= post_recoup_share
				
				dict[recipient.id][&"total"] = dict[recipient.id][&"pre_recoup"] + dict[recipient.id][&"post_recoup"]
	
	dict[-1][&"post_recoup"] = post_recoup_leftover
	
	dict[-1][&"total_after_layer"] = total_before_layer - dict[-1][&"pre_recoup"] - dict[-1][&"post_recoup"]
	
	print(dict)
	return dict

func get_unprocessed_revenue_dict(rev_source : RevenueSourceData) -> Dictionary:
	var dict : Dictionary[int,Dictionary] = { # layer, totals
		-1 : { # -1 is total for all layers
				&"pre_recoup_total" : 0,
				&"post_recoup_total" : 0,
				&"leftover" : 0,
		} # rest is layers
	}
	
	var layer_dict : Dictionary[int,bool] = {}
	var linked_recipients : Array[RecipientData] = get_recipients_linked_to_rev(rev_source)
	for recipient : RecipientData in linked_recipients :
		layer_dict[recipient.shares[rev_source.id].layer] = true
	
	var total_before_layer : float = get_unprocessed_total(rev_source)
	var total_unrecouped : float = get_total_recoup_spend(rev_source) - get_total_recovered_recoup(rev_source)
	
	for layer : int in layer_dict.keys():
		var layer_totals : Dictionary = get_layer_unprocessed_totals(rev_source,layer,total_before_layer,total_unrecouped)
		total_before_layer -= layer_totals[-1][&"total_after_layer"]
		
		dict[-1][&"pre_recoup_total"] += layer_totals[-1][&"pre_recoup"]
		dict[-1][&"post_recoup_total"] += layer_totals[-1][&"post_recoup"]
		
		dict[layer] = layer_totals
	
	dict[-1][&"leftover"] = get_unprocessed_total(rev_source) - dict[-1][&"pre_recoup_total"] + dict[-1][&"post_recoup_total"]
	
	print(dict)
	return dict

func get_share(rev_source : RevenueSourceData, recipient : RecipientData) -> RecipientRevShare:
	for share : RecipientRevShare in recipient.shares.values() :
		if share.revenue_source == rev_source:
			return share
	return null


func get_unpaid_payments(rev_source : RevenueSourceData,recipient : RecipientData) -> Array[PaymentData]:
	var unpaid_payments : Array[PaymentData]
	for payment : PaymentData in recipient.payments:
		if payment.rev_source == rev_source:
			if payment.is_paid == false and payment.archived == false:
				unpaid_payments.append(payment)
	return unpaid_payments

func get_total_amount_from_payments(payment_array : Array[PaymentData]) -> float:
	var total : float = 0
	for payment: PaymentData in payment_array:
		total += payment.transaction.amount
	return total

func get_available_revenue_sources() -> Array[RevenueSourceData]:
	var sources : Array[RevenueSourceData] = []
	
	# Ignore if archived.
	for source : RevenueSourceData in revenue_sources.values():
		if source.archived == true:
				continue
		sources.append(source)
	
	return sources
