require_relative './concerns/slugifiable.rb'

class User < ActiveRecord::Base
  has_many :collections
  has_many :items, through: :collections
  has_secure_password
  validates_presence_of :username, :email, :password
  
  include Slugifiable::InstanceMethods
  extend Slugifiable::ClassMethods
end