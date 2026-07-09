extends BaseData
class_name PaymentData ## Payment class for transactions to recipients as payouts.

@export var transaction : TransactionData ## Transaction linked to this payment
@export var date : Dictionary ## Transaction Date
@export var recipient : RecipientData ## Recipient linked to payment.
