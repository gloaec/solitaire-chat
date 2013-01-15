class Message < ActiveRecord::Base
  attr_accessible :content, :user_id
  belongs_to :user
  
  def letter2value(letter)
    return letter.ord-97 if letter >= 'a' and letter <= 'z' 
    return letter.ord-65 if letter >= 'A' and letter <= 'Z' 
    23
  end

  def value2letter(value)
    return (value+97).chr if value >= 0 and value < 27
    33.chr
  end

  def encrypt!
    solitaire = Sol.new(self.user.deck.clone)
    self.content = self.content.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').downcase.to_s
    self.content.delete!("^a-zA-Z")
    p "MESSAGE => #{self.content}"
    self.content = self.content.chars.to_a.map do |letter|
      value = (letter2value(letter)+solitaire.get_key_char)%26
      value2letter(value)
    end.join
    p "ENCRYPTED => #{self.content}"
    #self.save!
    self
    #p encrypted.join
  end

  def decrypt!(deck)
    solitaire = Sol.new(deck.clone)
    p "MESSAGE => #{self.content}"
    self.content = self.content.chars.to_a.map do |letter|
      value = (letter2value(letter)-solitaire.get_key_char)%26
      value2letter(value)
    end.join
    p "DECRYPTED => #{self.content}"
    #self.save!
    self
   # p encrypted.join
  end
end
  

