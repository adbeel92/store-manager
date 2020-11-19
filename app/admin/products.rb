ActiveAdmin.register Product do
  permit_params :category_id, :code, :name, :measure_unit, :sale_price, :stock, :description, :status, :image

  form do |f|
    f.inputs 'Información' do
      f.input :category, label: 'Categoría'
      f.input :code, label: 'Código'
      f.input :name, label: 'Nombre'
      f.input :description, label: 'Descripción'
      f.input :status, label: 'Estado'
      f.input :image, label: 'Imagen', as: :file
    end
    f.inputs 'Detalle en la venta' do
      f.input :measure_unit, label: 'Unidad de medida'
      f.input :sale_price, label: 'Precio de Venta'
      f.input :stock, label: 'Cantidad en stock'
    end
    f.actions
  end

  show do
    attributes_table do
      row :category
      row :code
      row :name
      row :description
      row :status
      row :image do |image|
        image_tag url_for(image.image), width: 300
      end
      row :measure_unit
      row :sale_price
      row :stock
    end
  end
end
