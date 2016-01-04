class GamePresenter < SimpleDelegator
  attr_reader :game, :view
  EVENT_LOG_ENTRIES = 4
  def initialize(game, view)
    @game, @view = game, view
    super(@game)
  end

  def event_log
    @game.operations.last(EVENT_LOG_ENTRIES).map {|op| op.description}.join("\n").tap do |s|
      puts "LOG : #{s}"
    end
  end

  def h
    @view
  end
end
