class GamePresenter < SimpleDelegator
  EVENT_LOG_ENTRIES = 4

  def event_log
    operations.last(EVENT_LOG_ENTRIES).map {|op| description(op)}.join("\n")
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
  
  private

  #TODO in the wrong place
  def operation_url(operation_type, suit=nil, rank=nil)
    args = {}
    args[:operation_type] = operation_type
    args[:suit] = suit if suit
    args[:rank] = rank if rank

    new_operation_url + args.to_query
  end

  def new_operation_url
    "/games/#{id}/players/#{players.first.id}/operations/new?"
  end


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
