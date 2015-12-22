
class Pile
  # Internal helper class to store card and player
  class CardInfo

    attr_reader :card, :player

    def initialize(card, player)
      @card = card
      @player = player
    end
  end

  def initialize
    @infos = []
  end

  def add(card, player)
    fail "card is nil" if card == nil
    @infos << CardInfo.new(card, player)
  end

  def clear
    infos = @infos
    @infos = []
    infos
  end

  def length
    @infos.length
  end

  def cards
    @infos.each.map { |info| info.card }
  end

  def leading_card
    if @infos.empty?
      nil
    else
      @infos.first.card
    end
  end

  def card_owner(card)
    raise Exception, 'the pile is empty' if empty?

    info = @infos.each.find { |i| i.card == card }

    info.player if info
  end

  def empty?
    @infos.empty?
  end
end
