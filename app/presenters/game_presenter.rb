class GamePresenter < Delegator
  include Rails.application.routes.url_helpers

  def initialize(game, state)
    super(game)
    @game = game
    @game_state = state
  end

  EVENT_LOG_ENTRIES = 5

  UNICODE_SUITS = {
    spades: '♠',
    hearts: '♥',
    diamonds: '♦',
    clubs: '♣'
  }

  UNICODE_CARDS = {
    spades: [
      '🂡',
      '🂢',
      '🂣',
      '🂤',
      '🂥',
      '🂦',
      '🂧',
      '🂨',
      '🂩',
      '🂪',
      '🂫',
      '🂭',
      '🂮'
    ],
    hearts: [
      '🂱',
      '🂲',
      '🂳',
      '🂴',
      '🂵',
      '🂶',
      '🂷',
      '🂸',
      '🂹',
      '🂺',
      '🂻',
      '🂽',
      '🂾'
    ],
    diamonds: [
      '🃁',
      '🃂',
      '🃃',
      '🃄',
      '🃅',
      '🃆',
      '🃇',
      '🃈',
      '🃉',
      '🃊',
      '🃋',
      '🃍',
      '🃎',
    ],
    clubs: [
      '🃑',
      '🃒',
      '🃓',
      '🃔',
      '🃕',
      '🃖',
      '🃗',
      '🃘',
      '🃙',
      '🃚',
      '🃛',
      '🃝',
      '🃞'
    ]
  }

  def event_log
    operations.last(EVENT_LOG_ENTRIES).map {|op| description(op)}.join("\n")
  end

  def card_css_class(interactive:)
    interactive ? 'interactive_hand_card' : 'hand_card'
  end

  def unicode_card(card)
    UNICODE_CARDS[card.suit][card.rank-1]
  end

  def unicode_suit(suit)
    UNICODE_SUITS[suit]
  end

  def unicode_card_back
    '🂠'
  end

  def phase_partial_name(game_state)
    game_state.current_phase.to_s
  end

  def link_to_card(card, player:, operation_type:)
    ActionController::Base.helpers.link_to(
      card_text(card, player),
      card_path(operation_type, card, player),
      class: card_css_class(interactive: interactive_card?(operation_type, card, player))
    )
  end

  def main_player?(player)
    @game_state.main_player == player
  end

  def __getobj__
    @game
  end

  def __setobj__(obj)
    @game = obj
  end

  private

  def interactive_card?(operation_type, card, player)
    ((operation_type == 'play_card'  && @game_state.human_can_play_card?(card)) ||
      operation_type == 'discard_card') &&
      main_player?(player)
  end

  def card_text(card, player)
    main_player?(player) ? unicode_card(card) : unicode_card_back
  end

  def card_path(operation_type, card, player)
    operation_values = {
      operation_type: operation_type,
      suit: card.suit,
      rank: card.rank,
    }

    if interactive_card?(operation_type, card, player)
      new_game_player_operation_path(@game, player.model, operation_values)
    else
      ''
    end
  end

  def description(operation)
    player_name = operation.player.user.name
    case operation.symbol
    when :deal_card     then " #{player_name} was dealt a card"
    when :pass_trump    then " #{player_name} passed on the trump"
    when :accept_trump  then " #{player_name} accepted the trump"
    when :play_card     then " #{player_name} played #{operation.card}"
    when :discard_card  then " #{player_name} discard a card"
    when :draw_trump    then ' Drew a new trump card'
    end
  end
end
