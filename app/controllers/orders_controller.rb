class OrdersController < ApplicationController
  before_action :set_order, only: %i[show update_cart checkout cancel success remove_line_item clear_cart]
  before_action :check_cart_not_empty, only: %i[show checkout cancel success]
  before_action :set_line_item, only: %i[update_cart remove_line_item]
  before_action :set_transaction, :check_pending_transaction, only: %i[cancel success]

  def cancel
    redirect_to @credit_transaction, notice: 'cannot access this path' unless @credit_transaction.unpaid?
    return if @credit_transaction.cancelled!

    redirect_to checkout_order_path(@order), notice: 'error in transaction cancellation'
  end

  def create
    @order = find_existing_order || current_user.orders.build
    @line_item = @order.line_items.find_or_initialize_by(credit_pack_id: params[:credit_pack_id])

    if @line_item.update_quantity_by(params[:credit_pack_quantity]) && @order.save
      redirect_to @order
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

  def clear_cart
    if @order.clear_cart
      redirect_to credit_packs_path, notice: 'Cart cleared'
    else
      flash.now[:alert] = 'Cart could not be cleared'
      render @order
    end
  end

  def remove_line_item
    flash[:alert] = 'Error in destroying line item' unless @line_item.destroy

    redirect_to @order
  end

  def success
    return redirect_to checkout_order_path(@order), alert: 'transaction is not complete' if @credit_transaction.unpaid?
    return if @credit_transaction.mark_success

    redirect_to checkout_order_path(@order), alert: 'error in transaction'
  end

  def update_cart
    flash[:alert] = 'Error in updating line item' unless @line_item.update_quantity_by params[:update_by]

    redirect_to @order
  end

  private def check_cart_not_empty
    redirect_to credit_packs_path, notice: 'cart is empty' if @order.line_items.empty?
  end

  private def check_pending_transaction
    redirect_to user_path(current_user), alert: 'cannot access this page' unless @credit_transaction.pending?
  end

  private def find_existing_order
    current_user.orders.in_cart.last
  end

  private def set_line_item
    @line_item = @order.line_items.find_by_id(params[:line_item_id])

    redirect_to @order, alert: 'line item not found' unless @line_item
  end

  private def set_order
    @order = current_user.orders
                         .includes(line_items: :credit_pack)
                         .find_by_number(params[:number])

    redirect_to current_user, alert: 'order not found' unless @order
  end

  private def set_transaction
    @credit_transaction = @order.credit_transactions.find_by_id(params[:transaction_id])
    redirect_to @order, alert: 'transaction not found' unless @credit_transaction
  end
end
