require 'rails_helper'
FAILED_PAYMENT_SESSION = 'cs_test_b1SwgeHJqV2GHHrPWu6A5lWcIdJKKA90MBVAsP0SuvQ6Sc755mKSIKBlEs'.freeze
SUCCESSFUL_PAYMENT_SESSION = 'cs_test_a1jtE3oyoCMsqWudZXViqTiPWaCtxPBnkMGrN1MAocmOvgMYB5FEWwNnDQ'.freeze

RSpec.describe "Orders", type: :request do
  include AuthHelper

  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:order) { create :order, user: user }
  let(:other_user_order) { create :order, user: other_user }

  describe 'GET /orders/:number' do
    it_behaves_like 'Order Authenticable', :get, :order_path

    context 'when user is logged in' do
      before { sign_in user }
      context 'order does not exist' do
        it 'should redirect' do
          get(order_path(number: 'fake number'))
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq('order not found')
        end
      end

      context 'when other users order is accessed' do
        it 'should redirect' do
          get(order_path(other_user_order))
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq('order not found')
        end
      end

      context 'when own order is accessed' do
        context 'on empty cart' do
          it 'should redirect' do
            get(order_path(order))
            expect(response).to have_http_status(302)
            expect(flash[:notice]).to eq('cart is empty')
          end
        end

        context 'when order is not empty' do
          it 'should render orders show' do
            create_list :line_item, 2, order: order
            get(order_path(order))
            expect(response).to have_http_status(200)
            expect(request).to have_rendered('orders/show')
          end
        end
      end
    end
  end

  describe 'POST /orders/create' do
    it_behaves_like 'Order Authenticable', :post, :orders_path

    context 'when user is logged in' do
      context 'no current order exists' do
        let(:new_user) { create(:user) }
        before { sign_in new_user }

        it 'should create order and populate it with line item' do
          post(orders_path(credit_pack_id: 1, credit_pack_quantity: 2))
          expect(new_user.orders.in_cart.size).to be(1)
        end
      end

      context 'current order exists' do
        before do
          sign_in user
          create :line_item, order: order, credit_pack_id: 1, quantity: 1
        end

        context 'when line item for credit pack does not exist' do
          it 'should create line item' do
            post(orders_path(credit_pack_id: 2, credit_pack_quantity: 2))
            expect(order.line_items.count).to be(2)
          end
        end

        context 'when line item for credit pack exists' do
          it 'should update line item quantity' do
            post(orders_path(credit_pack_id: 1, credit_pack_quantity: 1))
            expect(order.line_items.count).to be(1)
            expect(order.line_items[0].quantity).to be(2)
          end
        end
      end
    end
  end

  describe 'POST /orders/:number/checkout' do
    let(:stripe_session) do
      OpenStruct.new({
        id: '123',
        url: '/stripeUrl'
      })
    end

    before { allow(Stripe::Checkout::Session).to receive(:create).and_return(stripe_session) }

    it_behaves_like 'Order Authenticable', :post, :checkout_order_path

    context 'user logged in' do
      before do
        sign_in user
        create_list(:line_item, 2, quantity: 2, order: order)
      end

      it 'should redirect to sripe url' do
        post(checkout_order_path(order))
        expect(response).to have_http_status(302)
        expect(response.location).to eq 'http://www.example.com/stripeUrl'
      end
    end
  end

  describe 'POST /orders/:number/clear_cart' do
    it_behaves_like 'Order Authenticable', :post, :clear_cart_order_path

    context 'user logged in' do
      before do
        sign_in user
        create_list(:line_item, 2, quantity: 2, order: order)
      end

      it 'should clear cart' do
        post(clear_cart_order_path(order))
        expect(response).to have_http_status(302)
        expect(flash[:notice]).to eq('Cart cleared')
      end
    end
  end

  describe 'DELETE /orders/:number?line_item_id=id' do
    it_behaves_like 'Order Authenticable', :delete, :remove_line_item_order_path

    context 'user logged in' do
      let(:line_item) { create :line_item, order: order }
      before { sign_in user }

      context 'line item does not exist' do
        it 'should redirect' do
          delete(remove_line_item_order_path(order, line_item_id: 3432))
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq('line item not found')
        end
      end

      context 'line item exists' do
        it 'should remove said line item' do
          delete(remove_line_item_order_path(order, line_item_id: line_item.id))
          expect(response).to have_http_status(302)
          expect(LineItem.find_by_id(line_item.id)).to be_nil
        end
      end
    end
  end

  describe 'POST /orders/:number/update_cart?line_item_id=id' do
    it_behaves_like 'Order Authenticable', :post, :update_cart_order_path

    context 'user logged in' do
      let(:line_item) { create :line_item, order: order }
      before { sign_in user }

      it 'should update line item' do
        post(update_cart_order_path(order, line_item_id: line_item.id, update_by: 10))
        expect(response).to have_http_status(302)
        expect(line_item.reload.quantity).to be(11)
      end
    end
  end

  describe 'GET /orders/:number/success?transaction_id=1' do
    it_behaves_like 'Order Authenticable', :get, :success_order_path

    context 'user logged in' do
      before { sign_in user }

      it_behaves_like 'Reject Empty Cart', :success

      context 'on unpaid transaction' do
        let(:stripe_response) { { payment_status: 'unpaid' } }
        before { allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(stripe_response) }
        before { create(:line_item, order: order) }

        it 'should redirect' do
          credit_transaction = create :credit_transaction, order: order, user: user, stripe_session_id: FAILED_PAYMENT_SESSION
          get(success_order_path(order, transaction_id: credit_transaction.id))
          expect(response).to have_http_status(302)
          expect(flash[:alert]).to eq('transaction is not complete')
        end
      end

      context 'on paid transaction' do
        let(:stripe_response) { { payment_status: 'paid' } }
        before { allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(stripe_response) }

        before { create(:line_item, order: order) }

        it 'should render success page' do
          credit_transaction = create :credit_transaction, order: order, user: user, stripe_session_id: SUCCESSFUL_PAYMENT_SESSION
          get(success_order_path(order, transaction_id: credit_transaction.id))
          expect(response).to have_http_status(200)
          expect(flash[:alert]).to have_rendered('orders/success')
        end
      end
    end
  end

  describe 'GET /orders/:number/cancel?transaction_id=1' do
    it_behaves_like 'Order Authenticable', :get, :cancel_order_path

    context 'user logged in' do
      before { sign_in user }

      it_behaves_like 'Reject Empty Cart', :cancel

      context 'on paid transaction' do
        let(:stripe_response) { { payment_status: 'paid' } }
        before { allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(stripe_response) }

        before { create(:line_item, order: order) }

        it 'should redirect' do
          credit_transaction = create :credit_transaction, order: order, user: user, stripe_session_id: SUCCESSFUL_PAYMENT_SESSION
          get(cancel_order_path(order, transaction_id: credit_transaction.id))
          expect(response).to have_http_status(302)
        end
      end

      context 'on unpaid transaction' do
        let(:stripe_response) { { payment_status: 'unpaid' } }
        before { allow(Stripe::Checkout::Session).to receive(:retrieve).and_return(stripe_response) }

        before { create(:line_item, order: order) }

        it 'should render cancel page' do
          credit_transaction = create :credit_transaction, order: order, user: user, stripe_session_id: FAILED_PAYMENT_SESSION
          get(cancel_order_path(order, transaction_id: credit_transaction.id))
          expect(response).to have_http_status(200)
          expect(flash[:alert]).to have_rendered('orders/cancel')
        end
      end
    end
  end
end
