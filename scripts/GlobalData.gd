extends Node
class_name GlobalData

@export var revenue_sources : Array[RevenueSourceData]
@export var recipients : Array[RecipientData]

func _ready() -> void:
	dev_populate_mock_revenue_sources(10)
	dev_populate_mock_recipients(10)

var mock_revenue_names : Array[String] = ["Goonipilant","Anthro Heat","Merch","Counter Strike Skins","The One","Bath Water Selling","Casino Winnings"," Pyramid Scheme"]
func dev_populate_mock_revenue_sources(amount : int) -> void: ## Creates mock data for testing.
	for i : int in amount:
		var mock_revenue : RevenueSourceData = RevenueSourceData.new()
		mock_revenue.name = mock_revenue_names.pick_random() + str(i)
		mock_revenue.payout_schedule = [0,1,2].pick_random()
		mock_revenue.revenue = {100.0:{01:2025}}
		revenue_sources.append(mock_revenue)

var mock_names : Array[String] = ["Alex","Marl","Ted","Alan","Ana","Julien","Martin","Nancy"]
func dev_populate_mock_recipients(amount : int) -> void: ## Creates mock data for testing.
	for i : int in amount:
		var mock_recipient : RecipientData = RecipientData.new()
		mock_recipient.name = mock_names.pick_random() + str(i)
		mock_recipient.minimum_payout = randi_range(10,300)
		#mock_recipient.revenue_sources.append(revenue_sources.pick_random())
		mock_recipient.payments = {100.0:{01:2025}}
		recipients.append(mock_recipient)

func get_recipient_index(desired_recipient : RecipientData) -> int:
	return recipients.find(desired_recipient)

func create_recipient(new_recipient : RecipientData) -> void:
	recipients.append(new_recipient)
	Sig.create_recipient()


func add_rev_share_to_recipient(desired_recipient : RecipientData, desired_rev_share : RecipientRevShare) -> void:
	recipients[get_recipient_index(desired_recipient)].shares.append(desired_rev_share)
	print("Added revenue source to ", desired_recipient.name)
	Sig.add_revenue_to_recipient()

func delete_share_from_recipient(desired_recipient : RecipientData, desired_rev_share : RecipientRevShare) -> void:
	print("Removing Revenue Source from ", desired_recipient.name)
	
	var desired_recipient_index : int = get_recipient_index(desired_recipient)
	var desired_rev_share_index: int = recipients[desired_recipient_index].shares.find(desired_rev_share)
	Global.recipients[desired_recipient_index].shares.remove_at(desired_rev_share_index)
	Sig.delete_revenue_from_recipient()

func delete_recipient(desired_recipient : RecipientData) -> void:
	print("Erasing Recipient:", desired_recipient.name)
	
	Global.recipients.erase(desired_recipient)
	Sig.delete_recipient()

func get_available_shares(desired_recipient : RecipientData) -> Array[RevenueSourceData]:
	var sources : Array[RevenueSourceData] = revenue_sources.duplicate()
	for linked_rev_share : RecipientRevShare in desired_recipient.shares :
		#print("Already owns ", linked_rev_share.revenue_source)
		sources.erase(linked_rev_share.revenue_source)
	#print("Available Revenue Sources: ", sources)
	return sources
