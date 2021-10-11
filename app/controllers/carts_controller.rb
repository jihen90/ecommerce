class CartsController < ApplicationController
  before_action :authenticate_user!

  def update
    product = params[:cart][:product_id]
    quantity = params[:cart][:quantity]

    current_order.add_product(product, quantity)

    redirect_to root_url, notice: "Product added successfuly"
  end

  def show
    @order = current_order
  end

  def pay_with_paypal
    @order = Order.find(params[:cart][:order_id])

    PaymentMethod.create_payment_method #crea el metodo de pago

    redirect_to EXPRESS_GATEWAY.redirect_url_for(PaymentMethod.paypal_token.token) #entrega variable response
  end

  
  def process_paypal_payment
    @token = params[:token]
    details = EXPRESS_GATEWAY.details_for(@token)
    
    def express_purchase_options
        response = Payment.responseMethod
        Payment.statement(response)
    end

end