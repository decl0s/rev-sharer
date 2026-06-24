extends Node
class_name GlobalData

@export var revenue_sources : Dictionary[int,RevenueSourceData]
@export var recipients : Dictionary[int,RecipientData]

@export var next_rev_source_id : int = 0
@export var next_recipient_id : int = 0
@export var next_rev_share_id : int = 0

func _ready() -> void:
	dev_populate_mock_revenue_sources(10)
	dev_populate_mock_recipients(10)

var mock_revenue_names : Array[String] = ["Goonipilant","Anthro Heat","Merch","Counter Strike Skins","The One","Bath Water Selling","Casino Winnings","Pyramid Scheme"]
func dev_populate_mock_revenue_sources(amount : int) -> void: ## Creates mock data for testing.
	for i : int in amount:
		var mock_revenue : RevenueSourceData = RevenueSourceData.new()
		mock_revenue.id = next_rev_source_id
		next_rev_source_id += 1
		mock_revenue.name = mock_revenue_names.pick_random() + str(i)
		mock_revenue.payout_schedule = [0,1,2].pick_random()
		mock_revenue.revenue = {100.0:{01:2025}}
		revenue_sources[mock_revenue.id] = mock_revenue

var mock_names : Array[String] = ["Alex","Marl","Ted","Alan","Ana","Julien","Martin","Nancy"]
func dev_populate_mock_recipients(amount : int) -> void: ## Creates mock data for testing.
	for i : int in amount:
		var mock_recipient : RecipientData = RecipientData.new()
		mock_recipient.id = next_recipient_id
		next_recipient_id += 1
		mock_recipient.name = mock_names.pick_random() + str(i)
		mock_recipient.minimum_payout = randi_range(10,300)
		#mock_recipient.revenue_sources.append(revenue_sources.pick_random())
		mock_recipient.payments = {100.0:{01:2025}}
		recipients[mock_recipient.id] = mock_recipient

func create_recipient(new_recipient : RecipientData) -> void:
	new_recipient.id = next_recipient_id
	next_recipient_id += 1
	recipients[new_recipient.id] = new_recipient
	Sig.create_recipient()

func create_revenue_source(new_revenue_source : RevenueSourceData) -> void:
	new_revenue_source.id = next_rev_source_id
	next_rev_source_id += 1
	revenue_sources[new_revenue_source.id] = new_revenue_source
	Sig.create_revenue_source()

func add_rev_share_to_recipient(desired_recipient : RecipientData, desired_rev_share : RecipientRevShare) -> void:
	recipients[desired_recipient.id].shares[desired_rev_share.id] = desired_rev_share
	#print("Added revenue source to ", desired_recipient.name)
	print(recipients[desired_recipient.id].shares)
	Sig.add_rev_share_to_recipient()

func delete_share_from_recipient(desired_recipient : RecipientData, desired_rev_share : RecipientRevShare) -> void:
	print("Removing Revenue Source from ", desired_recipient.name)
	Global.recipients[desired_recipient.id].shares.erase(desired_rev_share.id)
	Sig.delete_rev_share_from_recipient()

func delete_recipient(desired_recipient : RecipientData) -> void:
	print("Archiving Recipient:", desired_recipient.name)
	
	Global.recipients[desired_recipient.id].archived = true
	Sig.delete_recipient()

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

func delete_revenue_source(revenue : RevenueSourceData) -> void:
	print("Archiving Revenue Source:", revenue.name)
	
	Global.revenue_sources[revenue.id].archived = true
	Sig.delete_revenue_source()

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
