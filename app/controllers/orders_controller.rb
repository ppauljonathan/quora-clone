class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update checkout cancel success]
  before_action :set_transaction, only: %i[cancel success]

  def cancel
    redirect_to @credit_transaction if @credit_transaction.successful?
    return if @credit_transaction.cancelled!

    redirect_to checkout_order_path(@order), notice: 'error in transaction cancellation'
  end

  def create
    @order = find_existing_order || current_user.orders.build
    @order.assign_attributes order_params

    if @order.save
      redirect_to checkout_order_path(@order)
    else
      redirect_to credit_packs_path, alert: 'something went wrong'
    end
  end

  def checkout
    stripe_url = @order.checkout(success_order_url(@order), cancel_order_url(@order))
    if stripe_url
      redirect_to stripe_url, allow_other_host: true
    else
      redirect_back_or_to @order, alert: 'Transaction could not be made'
    end
  end

  def success
    return redirect_to checkout_order_path(@order), alert: 'transaction is not complete' if @credit_transaction.unpaid?
    return if @credit_transaction.mark_success

    redirect_to checkout_order_path(@order), alert: 'error in transaction'
  end

  def update
    @order.update(order_params)

    if @order.save
      redirect_to current_user, notice: 'order saved successfully'
    else
      render :show
    end
  end

  private def find_existing_order
    current_user.orders.in_cart.last
  end

  private def order_params
    params.require(:order).permit(:credit_pack_id, :amount)
  end

  private def set_order
    @order = Order.find_by_number(params[:number])

    redirect_back_or_to current_user unless @order
  end

  private def set_transaction
    @credit_transaction = CreditTransaction.find_by_id(params[:transaction_id])
    redirect_to @order, alert: 'transaction not found' unless @credit_transaction
  end
end
