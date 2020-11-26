ActiveAdmin.register PurchaseOrder do
  filter :provider, as: :select
  filter :user, as: :select
  filter :voucher_type
  filter :voucher_series
  filter :voucher_number
  filter :products

  scope :all, default: true
  scope 'Nuevos' do |collection|
    collection.new_one
  end
  scope 'Solicitados' do |collection|
    collection.requested
  end
  scope 'Aprobados' do |collection|
    collection.approved
  end
  scope 'Rechazados' do |collection|
    collection.rejected
  end
  scope 'Pagados' do |collection|
    collection.paid
  end

  permit_params :provider_id, :voucher_type, :voucher_series, :voucher_number, :total,
                purchase_order_products_attributes: [:product_id, :quantity, :purchase_price, :total_purchase_price, :_destroy]

  before_create do |product|
    @purchase_order.status = :new_one
    @purchase_order.user = current_user
  end

  form do |f|
    f.semantic_errors
    f.inputs 'Información' do
      f.input :provider, as: :select
      f.input :voucher_type
      f.input :voucher_series
      f.input :voucher_number
      f.input :tax
      f.input :total
      f.input :voucher, as: :file
    end
    f.inputs 'Detalle del pedido' do
      f.has_many :purchase_order_products, allow_destroy: true do |a|
        a.input :product
        a.input :purchase_price
        a.input :quantity
        a.input :total_purchase_price
      end
    end
    f.actions
  end

  index do
    id_column
    column :status do|purchase_order|
      status_tag purchase_order.status, label: PurchaseOrder.human_enum_name(:status, purchase_order.status)
    end
    column :user
    column :provider
    column :tax
    column :total
    column :created_at
    column :requested_at
    column :paid_at
    actions
  end

  show do
    attributes_table do
      row :status do |purchase_order|
        status_tag purchase_order.status, label: PurchaseOrder.human_enum_name(:status, purchase_order.status)
      end
      row :user
      row :provider
      row :voucher_type
      row :voucher_series
      row :voucher_number
      row :tax
      row :total
      row :voucher do |purchase_order|
        if purchase_order.voucher.present?
          image_tag url_for(purchase_order.voucher), width: 300
        end
      end
    end

    panel 'Pedidos de compra' do
      table_for purchase_order.purchase_order_products do
        column :product
        column :purchase_price
        column :quantity
        column :total_purchase_price
      end
    end

    active_admin_comments
  end
end
