extends HBoxContainer
class_name UnpaidPaymentLine

@export var linked_payments : Array[PaymentData]

func _ready() -> void:
	while linked_payments.is_empty() :
		await get_tree().process_frame
	
	$Total.text = Utils.get_money_string(Global.get_total_amount_from_payments(linked_payments))

func _on_mark_paid_pressed() -> void:
	for payment : PaymentData in linked_payments:
		payment.is_paid = true
		payment.transaction.name = tr("PAYMENT_TITLE") % [ payment.rev_source.name ]
		payment.transaction.day = Time.get_date_dict_from_system().day
		payment.transaction.month = Time.get_date_dict_from_system().month
		payment.transaction.year = Time.get_date_dict_from_system().year
	Sig.pay_payment()
