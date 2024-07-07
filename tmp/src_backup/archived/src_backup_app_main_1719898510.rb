$gtk.reset 

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
CUBE_SIZE = 50
PLAYER_WIDTH = CUBE_SIZE * 2
PLAYER_Y_POS = 0
PLAYER_X_POS = HALF_SCREEN_WIDTH - CUBE_SIZE

class Game
  def initialize(args)
    @args = args
    @game_over ||= false
    @player ||= Player.new(PLAYER_X_POS, PLAYER_Y_POS, PLAYER_WIDTH, CUBE_SIZE).player_traits
    @enemy ||= Enemies.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, CUBE_SIZE, CUBE_SIZE).enemy_traits
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
    def initialize(x_pos, y_pos, w, h)
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
    def initialize(text, y_pos=HALF_SCREEN_HEIGHT, x_pos=HALF_SCREEN_WIDTH, anchors=0.5, line_skip=50)
      @x_pos = x_pos
      @y_pos = y_pos
      @anchors = anchors
      @text = text
      @line_skip = line_skip
    end
    
    def draw_text
      args.outputs.labels << {x: @x_pos, y: @y_pos, anchor_x: @anchors, anchor_y: @anchors, text: @text}
    end   
    
    def draw_multiple_text_lines
      @text.each_with_index do |text, index|
        @args.outputs.labels << {x: @x_pos, y:@y_pos - (index * line_skip), text: text }
      end
    end 
  end

  def game_state
    if @game_over
     game_over_state
    end
    return game_over_state
  end

  def gameplay_state
    render_gameplay
    player_controls
    game_over
    
  end
 
  def render_gameplay
    @args.outputs.solids << @player
    @args.outputs.solids << @enemy
  end

  def player_controls
  end

  def game_over
    if collision(@player, @enemy)
      @game_over
    end
  end
  
  def game_over_state
    render_game_over
    game_reset
  end

  def render_game_over
    GameText.new("Hola").draw_text 
  end

  def game_reset
    key_pressed(:key_down, :enter, $gtk.method(:reset))
  end

  def key_pressed(key_action, key, output)
    if @args.inputs.keyboard.send(key_action).send(key)
      output.call
    end
  end

  def collision(box1, box2) #box1 enemy, box2 player
    box1[:y] <= box2[:y] + box2[:h] &&
    box1[:x] <= box2[:x] + box2[:w] &&
    box1[:x] + box1[:w] >= box2[:x]
  end

  def tick
    game_state
  end
end

def tick(args)
  args.state.game ||= Game.new(args)
  args.state.game.tick
end
