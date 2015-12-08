module GamesHelper
  def card_onclick_handler(card)
    "play_card(#{@game.id},
               #{@game_state.players[0].id},
               \"#{card.suit}\",
               #{card.rank})"
  end

  def card_html_id(card)
    "#{card.suit}_#{card.rank}"
  end

  def operation_url(operation_type, suit, rank)
    args = "?operation_type=#{operation_type}&suit=#{suit}&rank=#{rank}"
    "/games/#{@game.id}/players/#{@game.players.first.id}/operations/new"+args
  end

  def play_card_operation_url(suit, rank)
    operation_url("play_card", suit, rank)
  end

  def unicode_card(card)
    UNICODE_CARDS[card.suit][card.rank-1]
  end

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
    back: [
      "🂠"
    ],
  }

end
