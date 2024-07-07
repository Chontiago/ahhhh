class Game
  def initialize(args)
    @args = args
  end

  def game_state
  
  end

  def tick
    game_state
  end
end

def tick(args)
  args.state.game ||= Game.new(args)
  args.state.game.tick
end
