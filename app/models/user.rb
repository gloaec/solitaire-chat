class User < ActiveRecord::Base
  attr_accessible :name, :deck, :created_at, :updated_at
  has_many :messages
  
  class Marshalize
    def load(text)
      return unless text
      Marshal.load(Base64.decode64(text))
    end

    def dump(text)
      Base64.encode64(Marshal.dump(text))
    end
  end

  serialize :deck, Marshalize.new
  
end