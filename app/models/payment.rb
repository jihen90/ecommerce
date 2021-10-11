class Payment < ApplicationRecord
  belongs_to :order
  belongs_to :payment_method

  def self.paypal_token
    #price must be in cents
    price = @order.total * 100

    response = EXPRESS_GATEWAY.setup_purchase(price,
      ip: request.remote_ip,
      return_url: process_paypal_payment_cart_url,
      cancel_return_url: root_url,
      allow_guest_checkout: true,
      currency: "USD"
    )
  end

  def self.responseMethod
    express_purchase_options =
    {
      ip: request.remote_ip,
        token: @token,
        payer_id: details.payer_id,
        currency: "USD"
      }

    price = details.params["order_total"].to_d * 100

    response = EXPRESS_GATEWAY.purchase(price, express_purchase_options)
  end

  def self.statement(response)
    if response.success?
  
      payment = Payment.find_by(token: response.token)
      order = payment.order
  
      #update object states
      payment.state = "completed"
      order.state = "completed"
  
      ActiveRecord::Base.transaction do
        order.save!
        payment.save!
      end
    end

  end

end

end
