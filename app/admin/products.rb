ActiveAdmin.register Product do
  filter :category_id, as: :select, collection: proc { Category.all }
  filter :code
  filter :name
  filter :status, as: :select, collection: proc { Product.statuses }

  permit_params :category_id, :code, :name, :measure_unit_id, :sale_price, :custom_stock, :description, :status, :image

  form do |f|
    f.semantic_errors
    f.inputs 'Información' do
      f.input :category, as: :select
      f.input :code
      f.input :name
      f.input :description
      f.input :status, as: :select
      f.input :image, as: :file
    end
    f.inputs 'Detalle en la venta' do
      f.input :measure_unit, as: :select
      f.input :sale_price
      f.input :stock, input_html: { disabled: true }
      f.input :custom_stock
    end
    f.actions
  end

  index do
    id_column
    column :status do |product|
      status_tag product.status, label: Product.human_enum_name(:status, product.status)
    end
    column :code
    column :name
    column :category
    column :measure_unit
    column :sale_price
    column :stock
    column :custom_stock
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :category
      row :code
      row :name
      row :description
      row :status do |product|
        status_tag product.status, label: Product.human_enum_name(:status, product.status)
      end
      row :image do |product|
        if product.image.present?
          image_tag url_for(product.image), width: 300
        end
      end
      row :measure_unit
      row :sale_price
      row :stock
      row :custom_stock
    end

    panel 'Pedidos de compra del producto' do
      table_for product.purchase_order_products do
        column :purchase_order
        column :purchase_price
        column :quantity
        column :total_purchase_price
        column :status do |purchase_order_product|
          status_tag purchase_order_product.status, label: PurchaseOrder.human_enum_name(:status, purchase_order_product.status)
        end
      end
    end

    active_admin_comments
  end
end
