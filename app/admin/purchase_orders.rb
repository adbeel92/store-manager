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

  permit_params :provider_id, :voucher_type, :voucher_series, :voucher_number, :tax, :total, :voucher,
                purchase_order_products_attributes: [:id, :product_id, :quantity, :purchase_price, :total_purchase_price, :_destroy]

  before_create do |product|
    @purchase_order.status = :new_one
    @purchase_order.user = current_user
  end

  form do |f|
    f.semantic_errors *f.object.errors.keys
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
        a.input :product, as: :string, input_html: {
          autocomplete: 'off',
          value: a.object.product.try(:name),
          data: {
            url: autocomplete_admin_products_path,
            behavior: 'autocomplete'
          }
        }
        a.input :product_id, as: :hidden
        a.input :purchase_price
        a.input :quantity
        a.input :total_purchase_price
        a.input :id, as: :hidden
      end
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :status do |purchase_order|
      status_tag purchase_order.status, label: PurchaseOrder.human_enum_name(:status, purchase_order.status)
    end
    column :user
    column :provider
    column :tax
    column :total
    column :created_at
    column :requested_at
    column :paid_at
    actions(dropdown: true) do |purchase_order|
      if purchase_order.new_one?
        item 'Solicitar aprobación', make_request_admin_purchase_order_path(purchase_order), method: :put
      end
      if purchase_order.requested? && current_user.admin?
        item 'Aprobar solicitud', approve_admin_purchase_order_path(purchase_order), method: :put
        item 'Rechazar solicitud', reject_admin_purchase_order_path(purchase_order), method: :put
      end
      if purchase_order.approved?
        item 'Pagado', paid_admin_purchase_order_path(purchase_order), method: :put
      end
    end
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

  batch_action :make_request, confirm: "Va a SOLICITAR los pedidos ¿desea continuar?", if: proc { can? :make_request, PurchaseOrder } do |ids|
    purchase_orders = batch_action_collection.new_one.where(id: ids)
    if purchase_orders.empty?
      redirect_to collection_path, alert: 'No hay pedidos para Solicitar!'
    else
      purchase_orders.each do |purchase_order|
        purchase_order.requested!
      end
      redirect_to collection_path, notice: 'Solicitados!'
    end
  end

  batch_action :approve, confirm: "Va a APROBAR los pedidos ¿desea continuar?", if: proc { can? :approve, PurchaseOrder } do |ids|
    purchase_orders = batch_action_collection.requested.where(id: ids)
    if purchase_orders.empty?
      redirect_to collection_path, alert: 'No hay pedidos para Aprobar!'
    else
      purchase_orders.each do |purchase_order|
        purchase_order.approved!
      end
      redirect_to collection_path, notice: 'Aprobados!'
    end
  end

  batch_action :reject, confirm: "Va a RECHAZAR los pedidos ¿desea continuar?", if: proc { can? :reject, PurchaseOrder } do |ids|
    purchase_orders = batch_action_collection.requested.where(id: ids)
    if purchase_orders.empty?
      redirect_to collection_path, alert: 'No hay pedidos para Rechazar!'
    else
      purchase_orders.each do |purchase_order|
        purchase_order.rejected!
      end
      redirect_to collection_path, notice: 'Rechazados!'
    end
  end

  batch_action :paid, confirm: "Va a MARCAR COMO PAGADOS los pedidos ¿desea continuar?", if: proc { can? :paid, PurchaseOrder } do |ids|
    purchase_orders = batch_action_collection.approved.where(id: ids)
    if purchase_orders.empty?
      redirect_to collection_path, alert: 'No hay pedidos para Pagar!'
    else
      purchase_orders.each do |purchase_order|
        purchase_order.paid!
      end
      redirect_to collection_path, notice: 'Pagados!'
    end
  end

  member_action :make_request, method: :put do
    resource.requested!
    redirect_to resource_path, notice: 'Solicitado!'
  end

  member_action :approve, method: :put do
    resource.approved!
    redirect_to resource_path, notice: 'Aprobado!'
  end

  member_action :reject, method: :put do
    resource.rejected!
    redirect_to resource_path, notice: 'Rechazado!'
  end

  member_action :paid, method: :put do
    resource.paid!
    redirect_to resource_path, notice: 'Pagado!'
  end

  action_item :make_request, only: :show, if: proc{ can? :make_request, PurchaseOrder } do
    if purchase_order.new_one?
      link_to 'Solicitar aprobación', make_request_admin_purchase_order_path(purchase_order), method: :put, class: 'new_one'
    end
  end

  action_item :approve, only: :show, if: proc{ can? :approve, PurchaseOrder }  do
    if purchase_order.requested?
      link_to 'Aprobar solicitud', approve_admin_purchase_order_path(purchase_order), method: :put, class: 'approved'
    end
  end

  action_item :reject, only: :show, if: proc{ can? :reject, PurchaseOrder }  do
    if purchase_order.requested?
      link_to 'Rechazar solicitud', reject_admin_purchase_order_path(purchase_order), method: :put, class: 'rejected'
    end
  end

  action_item :paid, only: :show, if: proc{ can? :paid, PurchaseOrder } do
    if purchase_order.approved?
      link_to 'Pagado', paid_admin_purchase_order_path(purchase_order), method: :put, class: 'paid'
    end
  end
end
