class GamePresenter < SimpleDelegator
  EVENT_LOG_ENTRIES = 4

  def event_log
    operations.last(EVENT_LOG_ENTRIES).map {|op| description(op)}.join("\n")
  end

  def description(operation)
    case operation.type
    when :deal_card     then "#{operation.player.user.name} was dealt a card"
    when :pass_trump    then "#{operation.player.user.name} passed on the trump, #{operation.suit}"
    when :accept_trump  then "#{operation.player.user.name} accepted the trump"
    when :play_card     then "#{operation.player.user.name} played #{operation.card}"
    when :discard_card  then "#{operation.player.user.name} discard a card"
    when :draw_trump    then "Drew a new trump card"
    else "Undescribeable action"
    end
  end

  def operation_url(operation_type, suit=nil, rank=nil)
    args = "?operation_type=#{operation_type}"

    args += "&suit=#{suit}" if suit
    args += "&rank=#{rank}" if rank

    "/games/#{id}/players/#{players.first.id}/operations/new" + args
  end

  def card_link_url(card, operation, read_only: false)
    if read_only
      "javascript:void(0);"
    else
      operation_url(operation, card.suit, card.rank)
    end
  end

  def pass_trump_operation_url
    operation_url("pass_trump")
  end

  def accept_trump_operation_url
    operation_url("accept_trump")
  end

  def h
    @view
  end
end
