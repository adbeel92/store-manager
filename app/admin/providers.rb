ActiveAdmin.register Provider do
  filter :name
  filter :status, as: :select, collection: proc { Provider.statuses }

  permit_params :name, :description, :ruc, :status, :address, :phone_1, :phone_2

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'Información' do
      f.input :name
      f.input :description
      f.input :ruc
      f.input :status, as: :select
    end
    f.inputs 'Detalle de contacto' do
      f.input :address
      f.input :phone_1
      f.input :phone_2
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :status do |provider|
      status_tag provider.status, label: Provider.human_enum_name(:status, provider.status)
    end
    column :name
    column :ruc
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :name
      row :description
      row :ruc
      row :status do |provider|
        status_tag provider.status, label: Provider.human_enum_name(:status, provider.status)
      end
      row :address
      row :phone_1
      row :phone_2
    end

    panel 'Pedidos de compra' do
      table_for provider.purchase_orders do
        column :user
        column :provider_products_qty
        column :total
        column :status
      end
    end

    active_admin_comments
  end
end