module PaymentsHelper
  def formatted_amount(payment)
    number_to_currency(payment.amount, :unit => payment.currency.symbol)
  end
end