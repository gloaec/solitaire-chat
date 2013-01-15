module MainHelper
  def card_image(card)
    image_tag("#{card.face}-#{card.suit}.png", :class => 'card')
  end
end
