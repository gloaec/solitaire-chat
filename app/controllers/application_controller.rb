# Couleurs de carte
INVALID_SUIT = -1
CLUB = 0
DIAMOND = 1
HEART = 2
SPADE = 3
FIRST = 4
SECOND = 5

# Figures de carte
INVALID_FACE = -1
AS = 1
JACK = 11
QUEEN = 12
KING = 13
JOKER = 14

# Définition de la classe Carte

# Suits
INVALID_SUIT = -1
CLUB = 0
DIAMOND = 1
HEART = 2
SPADE = 3
FIRST = 4
SECOND = 5

# Faces
INVALID_FACE = -1
AS = 1
JACK = 11
QUEEN = 12
KING = 13
JOKER = 14

class Card
  
  attr_accessor :suit, :face 
  
  def initialize(suit, face)
    @suit, @face = suit, face
  end
  
  def value
    return -1 unless self.is_valid?
    return 0 if self.face == JOKER
    return self.face + 13 if (self.suit == HEART) || (self.suit == SPADE)
    self.face
  end
  
  def is_valid?
    true
  end
  
  def cut_value
    return 53 if self.face == JOKER 
    self.face + 13*self.suit
  end
end

class Deck < Array
  
  def initialize
    cards = [SPADE, HEART, DIAMOND, CLUB].flat_map do |suit|
      (1..13).map do |face|
        Card.new(suit, face)
      end
    end
    self.replace(cards)
    self << Card.new(SECOND, JOKER)
    self << Card.new(FIRST, JOKER)
  end
  
  def loadJSON(deck)
    #deck = JSON.parse(deck)
    deck.map! {|card| Card.new(card["suit"].to_i, card["face"].to_i)}
    self.replace(deck)
  end
  
  def cut!(pos)
    return self if pos == self.size-1
    positions = (pos..self.size-1).to_a + (0..pos-1).to_a
    self.replace(self.map.with_index {|card, index| self[positions[index]]})
  end
  
  def double_cut!(posa, posb)
    #return self.cut!(posa) if posb == self.size-1
    positions = (posb+1..self.size-1).to_a + (posa..posb).to_a + (0..posa-1).to_a
    self.replace(self.map.with_index {|card, index| self[positions[index]]})
    #self.replace(self[posb+1..-1]+self[posa..posb]+self[0..posa-1])
  end
  
  def swap!(a,b) 
    self[b], self[a] = self[a], self[b]
    self.flatten!
  end
  
  def shift_down!(position, shift_by)
    new_pos = ((position+shift_by)%(self.size-1))
    self.insert(new_pos==0 ? -1 : new_pos, self.delete_at(position))
    self
  end
end

class Sol
  
  def initialize(deck)
    @deck = deck
  end

  def round1
    position = @deck.index{|card| card.face == JOKER && card.suit == FIRST}
    #p @deck.each {|card| p 'TROUVE ----------> '+card.inspect if card.face == JOKER && card.suit == FIRST}
    @deck.shift_down!(position, 1) # if position = deck.size - 1 then shift_by 2
    #p "------------- ROUND1 size = #{@deck.count} ---------------"
    #@deck.each{|card| p card.inspect}
  end

  def round2
    position = @deck.index{|card| card.face == JOKER && card.suit == SECOND}
    @deck.shift_down!(position, 2)
    #p "------------- ROUND2 size = #{@deck.count} ---------------"
    #@deck.each{|card| p card.inspect}
  end

  def round3 
    jokerApos = @deck.index{|card| card.face == JOKER && card.suit == FIRST}
    jokerBpos = @deck.index{|card| card.face == JOKER && card.suit == SECOND}
  
    if jokerApos > jokerBpos
      jokerA, jokerB = jokerB, jokerA
      jokerApos, jokerBpos = jokerBpos, jokerApos
    end
    @deck.double_cut!(jokerApos, jokerBpos)
    #@deck.swap!(0..jokerApos-1, jokerBpos+1..@deck.size)
    #p "------------- ROUND3 size = #{@deck.count} ---------------"
    #@deck.each{|card| p card.inspect}
  end

  def round4
    cut_value = @deck.last.cut_value
    @deck.cut!(@deck.last.cut_value)
    #@deck.swap!(0..cut_value-1, cut_value..@deck.size)
    #p "------------- ROUND4 size = #{@deck.count} ---------------"
    #@deck.each{|card| p card.inspect}
  end

  def round5
    card_value = @deck.first.cut_value
    #p "CARD VALUE = #{card_value}"
    card = @deck[card_value]
    #p "------------- ROUND5 size = #{@deck.count} ---------------"
    #@deck.each{|card| p card.inspect}
    card
  end

  def get_key_char
    #p "------------- START size = #{@deck.count} ---------------"
    #@deck.each{|card| p card.inspect}
    round1
    round2
    round3
    round4
    round5.value
  end
end


class ApplicationController < ActionController::API
	include AbstractController::Layouts	
end
