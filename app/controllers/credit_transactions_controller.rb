class CreditTransactionsController < ApplicationController
  before_action :set_credit_transaction, only: :show

  def index
    @credit_transactions = current_user.credit_transactions
  end

  private def set_credit_transaction
    @credit_transaction = CreditTransaction.find_by_id(params[:id])
    @order = @credit_transaction.order
    redirect_back_or_to root_path unless @credit_transaction
  end
end
