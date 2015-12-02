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
end
