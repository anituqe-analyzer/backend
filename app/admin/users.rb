ActiveAdmin.register User do
  permit_params :username, :email, :password, :password_confirmation, :role

  # Remove password_digest from filters (security)
  remove_filter :password_digest

  # Customize index page
  index do
    selectable_column
    id_column
    column :username
    column :email
    column :role
    column :created_at
    actions
  end

  # Customize form
  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :role, as: :select, collection: User.roles.keys
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
