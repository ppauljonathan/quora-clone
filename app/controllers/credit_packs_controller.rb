class CreditPacksController < ApplicationController
  def index
    @credit_packs = CreditPack.all
  end
end
