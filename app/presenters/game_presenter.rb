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
    if dynamic
      "dynamic_hand_card"
    else
      "hand_card"
    end
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

  def event_log
    operations.last(EVENT_LOG_ENTRIES).map {|op| description(op)}.join("\n")
  end

  def points_string(point_count)
    if point_count == 1
      "#{point_count} Point"
    else
      "#{point_count} Points"
    end
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

private

  def description(operation)
    player_name = operation.player.user.name
    case operation.type
    when :deal_card     then "#{player_name} was dealt a card"
    when :pass_trump    then "#{player_name} passed on the trump"
    when :accept_trump  then "#{player_name} accepted the trump"
    when :play_card     then "#{player_name} played #{operation.card}"
    when :discard_card  then "#{player_name} discard a card"
    when :draw_trump    then "Drew a new trump card"
    end
  end
end
