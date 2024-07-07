class Game
  def initialize(args)
    @args = args
    @game_over ||= false

  end

  class Player
    attr_reader :x_pos

    def initialize(x_pos, y_pos, w, h)
      @x_pos = x_pos
      @y_pos = y_pos
      @width = w
      @height = h 
    end

    def player_traits
      return {x: @x_pos, y: @y_pos, w: w, h: h}
    end
  end

  class Enemies
      attr_reader :x_pos, :y_pos
    def initialize(x, y, w, h)
      @x_pos = x_pos
      @y_pos = y_pos
      @width = w
      @height = h
    end

    def enemy_traits
      return {x: @x_pos, y: @y_pos, w: w, h: h}
    end

  end

  class GameText
    attr_reader :y_pos
    def initialize(x, y, text)
    end
    
    def draw_text
    end    
  end

  def game_state
    if @game_over
      game_over_state
    end
    return gameplay_state
  end

  def gameplay_state
    render_gameplay
    player_controls
  end

  def game_over_state
    render_game_over
    game_reset
  end

  def render_gameplay
    
  end

  def player_controls
  end

  def render_game_over
  end

  def game_reset
  end

  def key_pressed
  end

  def collision
    
  end

  def tick
    game_state
  end
end

def tick(args)
  args.state.game ||= Game.new(args)
  args.state.game.tick
end
