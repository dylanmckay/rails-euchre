module GamesHelper
  def card_onclick_handler(card)
    "play_card(#{@game.id},
               #{@game_state.main_player.id},
               \"#{card.suit}\",
               #{card.rank})"
  end

  def card_html_id(card)
    "#{card.suit}_#{card.rank}"
  end

  def operation_url(operation_type, suit=nil, rank=nil)
    args = "?operation_type=#{operation_type}"

    args += "&suit=#{suit}" if suit
    args += "&rank=#{rank}" if rank

    "/games/#{@game.id}/players/#{@game.players.first.id}/operations/new" + args
  end

  def play_card_operation_url(suit, rank)
    operation_url("play_card", suit, rank)
  end

  def pass_trump_operation_url
    operation_url("pass_trump")
  end

  def accept_trump_operation_url
    operation_url("accept_trump")
  end

  def pick_trump_operation_url
    operation_url("pick_trump")
  end

  def card_link_url(card, read_only: false)
    if read_only
      "javascript:void(0);"
    else
      play_card_operation_url(card.suit, card.rank)
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
