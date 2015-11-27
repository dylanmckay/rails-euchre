
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

  def card_owner(card)
    raise Exception, 'the pile is empty' if @infos.empty?

    @infos.each.find { |info| info.card == card }.player
  end
end

