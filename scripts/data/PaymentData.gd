extends BaseData
class_name PaymentData ## Payment class for transactions to recipients as payouts.

@export var is_paid : bool = false ## Status of a payment. Wether it as been paid out or not.
@export var transaction : TransactionData ## Transaction linked to this payment
@export var recipient : RecipientData ## Recipient linked to payment.
@export var rev_source : RevenueSourceData ## Linked Revenue Source this payout is linked to.
