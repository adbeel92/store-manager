ActiveAdmin.register User do
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  permit_params :email, :password, :password_confirmation

  form do |f|
    f.inputs do
      f.input :email
      f.input :status, as: :select
      f.input :first_name
      f.input :last_name
      f.input :role, as: :select
      f.input :dni
      f.input :address
      f.input :phone
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end
end
