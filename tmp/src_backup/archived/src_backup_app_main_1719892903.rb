SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
PLAYER_Y_POS = 0
CUBE_SIZE = 50
PLAYER_WIDTH = CUBE_SIZE * 2

class Game
  def initialize(args)
    @args = args
    @game_over ||= false
    @player ||= Player.new(HALF_SCREEN_WIDTH, PLAYER_Y_POS, PLAYER_WIDTH, CUBE_SIZE).player_traits
    @enemy = Enemies.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, CUBE_SIZE, CUBE_SIZE).enemy_traits
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
      return {x: @x_pos, y: @y_pos, w: @width, h: @height}
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
      return {x: @x_pos, y: @y_pos, w: @width, h: @height}
    end

  end

  class GameText
    attr_reader :y_pos
    def initialize(x_pos, y_pos, anchor_x, anchor_y, text)
      @x_pos = x_pos
      @y_pos = y_pos
      @anchor_x = anchor_x
      @anchor_y = anchor_y
      @text = text

    end
    
    def draw_text
      return {x: @x_pos, y: @y_pos, anchor_x: @anchor_x, anchor_y: @anchor_y, text: @text}
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
    @args.outputs.solids << @enemy
    @args.outputs.solids << @player
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
