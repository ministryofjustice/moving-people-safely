class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
    :trackable, :validatable, :timeoutable
end
