extends PanelContainer
class_name RecipientPaymentPanelContainer

@export var recipient : RecipientData

const UNPAID_PAYMENT_LINE : Resource = preload("uid://0maq18acxs5x")

func init() -> void:
	%Name.target_resource = recipient
	
	if not recipient.payments.is_empty():
		for rev_source : RevenueSourceData in Global.get_awaiting_payment_rev_sources(recipient) :
			var new_panel : UnpaidPaymentLine = UNPAID_PAYMENT_LINE.instantiate()
			new_panel.linked_payments.append(Global.get_unpaid_payments(rev_source,recipient))
			%AwaitingPayoutContainer.add_child(new_panel)
	
	%TotalPaid.set_text(Utils.get_money_string((Global.get_total_paid(recipient))))
	
	if recipient.payments.is_empty() or Global.get_awaiting_payment_rev_sources(recipient).is_empty() :
		%NoPaymentLabel.show()
		%TotalLine.hide()
	else:
		%NoPaymentLabel.hide()
		%TotalLine.show()
	
	%Total.text = (Utils.get_money_string((Global.get_total_unpaid(recipient))))
	
	if recipient.minimum_payout > Global.get_total_unpaid(recipient):
		%Note.text = tr("DOESNT_MEETS_MIN").format({"pending": Utils.get_money_string(Global.get_total_unpaid(recipient)),"minimum":Utils.get_money_string(recipient.minimum_payout)})
		%Note.color = HighlightContainer.ColorStyle.Red
	elif recipient.minimum_payout <= Global.get_total_unpaid(recipient):
		%Note.text = tr("MEETS_MIN").format({"pending": Utils.get_money_string(Global.get_total_unpaid(recipient)),"minimum":Utils.get_money_string(recipient.minimum_payout)})
		%Note.color = HighlightContainer.ColorStyle.Green
	%Note.update()

func _on_mark_total_paid_pressed() -> void:
	for rev_source : RevenueSourceData in Global.get_awaiting_payment_rev_sources(recipient) :
		for unpaid_payment : PaymentData in Global.get_unpaid_payments(rev_source,recipient):
			unpaid_payment.is_paid = true
			unpaid_payment.transaction.name = tr("PAYMENT_TITLE_ALL")
			unpaid_payment.transaction.day = Time.get_date_dict_from_system().day
			unpaid_payment.transaction.month = Time.get_date_dict_from_system().month
			unpaid_payment.transaction.year = Time.get_date_dict_from_system().year
	Sig.payment_paid()
