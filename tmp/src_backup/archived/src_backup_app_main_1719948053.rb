$gtk.reset 

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
CUBE_SIZE = 50
PLAYER_WIDTH = CUBE_SIZE * 2
PLAYER_Y_POS = 0
PLAYER_X_POS = HALF_SCREEN_WIDTH - CUBE_SIZE
PLAYER_SPEED = 5

class Game
  def initialize(args)
    @args = args
    @game_over ||= false
    @player ||= Player.new(PLAYER_X_POS, PLAYER_Y_POS, PLAYER_WIDTH, CUBE_SIZE).player_traits
    @enemy ||= Enemies.new(HALF_SCREEN_WIDTH, HALF_SCREEN_HEIGHT, CUBE_SIZE, CUBE_SIZE).enemy_traits
  end

  class Player
    attr_reader :x_pos, :speed
    attr_writer :x_pos

    def initialize(x_pos, y_pos, w, h)
      @x_pos = x_pos
      @y_pos = y_pos
      @width = w
      @height = h 
      @speed = 5
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
    def initialize(args, text, y_pos=HALF_SCREEN_HEIGHT, x_pos=HALF_SCREEN_WIDTH, anchors=1.5, line_skip=50)
      @args = args
      @x_pos = x_pos
      @y_pos = y_pos
      @anchors = anchors
      @text = text
      @line_skip = line_skip
    end
    
    def draw_text
      @args.outputs.labels << {x: @x_pos, y: @y_pos, anchor_x: @anchors, anchor_y: @anchors, text: @text}
    end   
    
    def draw_multiple_text_lines
      @text.each_with_index do |text, index|
        @args.outputs.labels << {x: @x_pos, y:@y_pos - (index * @line_skip), text: text }
      end
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
    player_movement
    game_over
    
  end
 
  def render_gameplay
    @args.outputs.solids << @player
    @args.outputs.solids << @enemy
  end

  def player_movement
    move_left = lambda {@player.x -= @player.speed}
    move_right = lambda {@player.x_pos += @player.speed}

    key_pressed(:key_held, :left, move_left)
    key_pressed(:key_held, :right, move_right)
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
    game_over_message = ["GAME OVER", "SCORE: ", "PRESS ENTER TO RESTART"]
    GameText.new(@args, game_over_message).draw_multiple_text_lines
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
