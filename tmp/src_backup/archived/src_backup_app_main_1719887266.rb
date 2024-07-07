class Game
  def initialize(args)
    @args = args
    @game_over || = false
  end

  def game_state
    if @game_over
      game_over_state
    end
    return gameplay_state
  end

  def gameplay_state
    render_gameplay
  end

  def game_over_state
    render_game_over
    game_reset
  end

  def render_gameplay
  end

  def render_game_over
  end

  def game_reset
  end

  def key_pressed
  end





  def tick
    game_state
  end
end

def tick(args)
  args.state.game ||= Game.new(args)
  args.state.game.tick
end
