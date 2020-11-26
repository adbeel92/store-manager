ActiveAdmin.register Category do
  filter :name
  filter :status, as: :select, collection: proc { Category.statuses }

  permit_params :status, :name, :description

  form do |f|
    f.semantic_errors
    f.inputs 'Información' do
      f.input :name
      f.input :description
      f.input :status, as: :select
    end
    f.actions
  end

  index do
    id_column
    column :status do |category|
      status_tag category.status, label: Category.human_enum_name(:status, category.status)
    end
    column :name
    column :created_at
    actions
  end
end
