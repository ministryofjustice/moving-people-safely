class User < ApplicationRecord
  devise :invitable, :database_authenticatable, :recoverable,
    :trackable, :validatable, :timeoutable
end
