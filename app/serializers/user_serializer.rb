class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :email, :balance, :role,  :created_at, :updated_at
end
