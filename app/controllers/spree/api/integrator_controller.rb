module Spree
  module Api
    class IntegratorController < Spree::Api::BaseController
      prepend_view_path File.expand_path("../../../../app/views", File.dirname(__FILE__))

      helper_method :variant_attributes,
        :order_attributes,
        :stock_transfer_attributes,
        :collection_attributes,
        :stock_transfer_attributes,
        :product_attributes

      respond_to :json

      before_filter :set_default_filter,
        only: [:show_orders,
               :show_users,
               :show_products,
               :show_return_authorizations,
               :show_stock_transfers]

        def index
          @collections = [
            OpenStruct.new({ name: 'orders',                 token: 'number',  frequency: '5.minutes' }),
            OpenStruct.new({ name: 'users',                  token: 'email',   frequency: '5.minutes' }),
            OpenStruct.new({ name: 'products',               token: 'sku',     frequency: '1.hour' }),
            OpenStruct.new({ name: 'return_authorizations',  token: 'number',  frequency: '1.hour' }),
            OpenStruct.new({ name: 'stock_transfers',        token: 'number',  frequency: '1.hour' })
          ]
        end

        def show_orders
          @orders = filter_resource(Spree::Order.complete)
        end

        def show_users
          @users = filter_resource(Spree.user_class)
        end

        def show_products
          @products = filter_resource(Spree::Product)
        end

        def show_return_authorizations
          @return_authorizations = filter_resource(Spree::ReturnAuthorization)
        end

        def show_stock_transfers
          @stock_transfers = filter_resource(Spree::StockTransfer)
        end

        private
        def set_default_filter
          @since    = params[:since] || 1.day.ago
          @page     = params[:page]  || 1
          @per_page = params[:per_page]
        end

        def filter_resource(relation)
          relation.ransack(updated_at_gteq: @since).result
          .page(@page)
          .per(@per_page)
          .order('updated_at ASC')
        end

        def collection_attributes
          [:name, :token, :frequency]
        end

        def stock_transfer_attributes
          [:id, :reference_number, :created_at, :updated_at]
        end

        def product_attributes
          [:id, :sku, :name, :description, :price, :available_on, :permalink, :meta_description, :meta_keywords, :shipping_category_id, :taxon_ids, :updated_at]
        end
    end
  end
end

