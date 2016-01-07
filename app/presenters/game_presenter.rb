class GamePresenter < SimpleDelegator
  EVENT_LOG_ENTRIES = 4

  UNICODE_SUITS = {
    spades: "♠",
    hearts: "♥",
    diamonds: "♦",
    clubs: "♣",
  }

  UNICODE_CARDS = {
    spades: [
      "🂡",
      "🂢",
      "🂣",
      "🂤",
      "🂥",
      "🂦",
      "🂧",
      "🂨",
      "🂩",
      "🂪",
      "🂫",
      "🂭",
      "🂮"
    ],
    hearts: [
      "🂱",
      "🂲",
      "🂳",
      "🂴",
      "🂵",
      "🂶",
      "🂷",
      "🂸",
      "🂹",
      "🂺",
      "🂻",
      "🂽",
      "🂾"
    ],
    diamonds: [
      "🃁",
      "🃂",
      "🃃",
      "🃄",
      "🃅",
      "🃆",
      "🃇",
      "🃈",
      "🃉",
      "🃊",
      "🃋",
      "🃍",
      "🃎",
    ],
    clubs: [
      "🃑",
      "🃒",
      "🃓",
      "🃔",
      "🃕",
      "🃖",
      "🃗",
      "🃘",
      "🃙",
      "🃚",
      "🃛",
      "🃝",
      "🃞",
    ],
  }

  def event_log
    operations.last(EVENT_LOG_ENTRIES).map {|op| description(op)}.join("\n")
  end

  def hand_card_css_class(dynamic:)
    dynamic ? "dynamic_hand_card" : "hand_card"
  end

  def unicode_card(card)
    UNICODE_CARDS[card.suit][card.rank-1]
  end

  def unicode_suit(suit)
    UNICODE_SUITS[suit]
  end

  def unicode_card_back
    "🂠"
  end

  def phase_partial_name(game_state)
    case game_state.current_phase
    when :trump_selection then 'trump_selection'
    when :discard then 'discard'
    else 'table'
    end
  end

private

  def description(operation)
    player_name = operation.player.user.name
    case operation.symbol
    when :deal_card     then "#{player_name} was dealt a card"
    when :pass_trump    then "#{player_name} passed on the trump"
    when :accept_trump  then "#{player_name} accepted the trump"
    when :play_card     then "#{player_name} played #{operation.card}"
    when :discard_card  then "#{player_name} discard a card"
    when :draw_trump    then "Drew a new trump card"
    end
  end
end
