class GamePresenter < SimpleDelegator
  EVENT_LOG_ENTRIES = 4

  def event_log
    operations.last(EVENT_LOG_ENTRIES).map {|op| description(op)}.join("\n")
  end

private

  def description(operation)
    player_name = operation.player.user.name
    case operation.type
    when :deal_card     then "#{player_name} was dealt a card"
    when :pass_trump    then "#{player_name} passed on the trump, #{operation.suit}"
    when :accept_trump  then "#{player_name} accepted the trump"
    when :play_card     then "#{player_name} played #{operation.card}"
    when :discard_card  then "#{player_name} discard a card"
    when :draw_trump    then "Drew a new trump card"
    end
  end
end
