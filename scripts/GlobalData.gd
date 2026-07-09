extends Node
class_name GlobalData

@export var revenue_sources : Dictionary[int,RevenueSourceData]
@export var recipients : Dictionary[int,RecipientData]
@export var recoups : Dictionary[int,RecoupData]
@export var transactions : Dictionary[int,TransactionData]
@export var revenues : Dictionary[int, RevenueData]
@export var payments : Dictionary[int, PaymentData]
@export var rev_shares : Dictionary[int,RecipientRevShare]


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
		mock_revenue.revenue = {100.0:{01:2025}}
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
		mock_recipient.payments = {100.0:{01:2025}}
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

func create_data(new_resource : Resource) -> void:
		if new_resource is RecipientData:
			new_resource.id = get_next_id(recipients)
			recipients[new_resource.id] = new_resource
			Sig.create_recipient()
			
		elif new_resource is RevenueSourceData:
			new_resource.id = get_next_id(revenue_sources)
			revenue_sources[new_resource.id] = new_resource
			Sig.create_revenue_source()
			
		elif new_resource is RecoupData:
			new_resource.id = get_next_id(recoups)
			recoups[new_resource.id] = new_resource
			Sig.create_recoup()
			
		elif new_resource is TransactionData:
			new_resource.id = get_next_id(transactions)
			transactions[new_resource.id] = new_resource
			Sig.create_transaction()
			
		elif new_resource is RevenueData:
			new_resource.id = get_next_id(revenues)
			revenues[new_resource.id] = new_resource
			Sig.create_revenue()
			
		elif new_resource is PaymentData:
			new_resource.id = get_next_id(payments)
			payments[new_resource.id] = new_resource
			Sig.create_payment()

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

func get_available_recipients() -> Array[RecipientData]:
	var recipient_array : Array[RecipientData] = []
	
	# Ignore if archived.
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

func get_available_revenue_sources() -> Array[RevenueSourceData]:
	var sources : Array[RevenueSourceData] = []
	
	# Ignore if archived.
	for source : RevenueSourceData in revenue_sources.values():
		if source.archived == true:
				continue
		sources.append(source)
	
	return sources
