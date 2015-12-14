class GamePresenter < SimpleDelegator
  attr_reader :game, :view

  def initialize(game, view)
    @game, @view = game, view
    super(@game)
  end

  def h
    @view
  end
end
