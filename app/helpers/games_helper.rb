module GamesHelper
  def operation_url(operation_type, suit=nil, rank=nil)
    args = "?operation_type=#{operation_type}"

    args += "&suit=#{suit}" if suit
    args += "&rank=#{rank}" if rank

    "/games/#{@game.id}/players/#{@game.players.first.id}/operations/new" + args
  end

  def pass_trump_operation_url
    operation_url("pass_trump")
  end

  def accept_trump_operation_url
    operation_url("accept_trump")
  end

  def card_link_url(card, operation, read_only: false)
    if read_only
      "javascript:void(0);"
    else
      operation_url(operation, card.suit, card.rank)
    end
  end

  def points_string(point_count)
    if point_count == 1
      "#{point_count} Point"
    else
      "#{point_count} Points"
    end
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
end
