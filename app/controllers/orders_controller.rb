class OrdersController < ApplicationController
  before_action :check_previous_orders, only: :create
  before_action :set_order, only: %i[show checkout cancel success]
  before_action :set_transaction, only: %i[cancel success]

  def cancel
    redirect_to @credit_transaction if @credit_transaction.successful?
    return if @credit_transaction.cancelled!

    redirect_to checkout_order_path(@order), notice: 'error in transaction cancellation'
  end

  def create
    @order = current_user.orders.build order_params

    if @order.save
      redirect_to checkout_order_path(@order)
    else
      redirect_to credit_packs_path, alert: 'something went wrong'
    end
  end

  def checkout
    stripe_session = @order.generate_stripe_session(success_order_url(@order),
                                                    cancel_order_url(@order))
    credit_transaction = current_user.credit_transactions
                                     .create(order: @order,
                                             stripe_session_id: stripe_session.id)
    if credit_transaction
      redirect_to stripe_session.url, allow_other_host: true
    else
      redirect_back_or_to @order, alert: 'transaction failed'
    end
  end

  def success
    if @credit_transaction.incomplete?
      return redirect_to checkout_order_path(@order), alert: 'transaction is not complete'
    end

    unless @credit_transaction.successful! &&
           @order.successful! &&
           current_user.update_credits(@order.credit_pack.credit_amount, 'purchased credits from store')
      redirect_to checkout_order_path(@order), alert: 'error in transaction'
    end
  end

  private def order_params
    params.require(:order).permit(:credit_pack_id)
  end

  private def check_previous_orders
    @order = current_user.orders.in_cart.find_by_credit_pack_id(order_params[:credit_pack_id])

    return unless @order

    redirect_to checkout_order_path(@order)
  end

  private def set_order
    @order = Order.find_by_number(params[:number])

    redirect_back_or_to current_user unless @order
  end

  private def set_transaction
    @credit_transaction = @order.credit_transactions.last
    redirect_to @order, alert: 'transaction not fount' unless @credit_transaction
  end
end
