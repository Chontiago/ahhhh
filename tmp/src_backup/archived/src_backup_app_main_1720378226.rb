$gtk.reset 

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
CUBE_SIZE = 50
PLAYER_WIDTH = CUBE_SIZE * 2
PLAYER_Y_POS = 0
PLAYER_X_POS = HALF_SCREEN_WIDTH - CUBE_SIZE
LEFT_BORDER = 0
RIGHT_BORDER =  SCREEN_WIDTH - PLAYER_WIDTH
BOTTOM_BORDER = 0 - CUBE_SIZE


class Game
  def initialize(args)
    @args = args
    @game_over ||= false
    @player = Player.new(PLAYER_X_POS, PLAYER_Y_POS, PLAYER_WIDTH, CUBE_SIZE)
    @score ||= 0 
    @enemies = generate_enemies(10)
  end

  class Player
    attr_accessor :x_pos, :speed
   
    def initialize(x_pos, y_pos, w, h)
      @x_pos = x_pos
      @y_pos = y_pos
      @width = w
      @height = h 
      @speed = 5
    end

    def traits
      return {x: @x_pos, y: @y_pos, w: @width, h: @height}
    end
  end

  class Enemies
      attr_accessor :x_pos, :y_pos, :width, :height, :speed
    def initialize(x_pos, y_pos, w, h)
      @x_pos = x_pos
      @y_pos = y_pos
      @width = w
      @height = h
      @speed = rand(5) + 6
    end

    def traits
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
     return game_over_state
    end
    return gameplay_state
  end

  def gameplay_state
    render_gameplay
    player_bounds
    player_movement
    score 
    enemy_movement
    enemy_respawn
    game_over
  end
 
  def game_over_state
    render_game_over
    game_reset
  end
 
  def render_gameplay
    @args.outputs.solids << @player.traits
    GameText.new(@args, "SCORE: #{@score}", SCREEN_HEIGHT, RIGHT_BORDER).draw_text
    
    @enemies.each do |enemy|
      @args.outputs.solids << enemy.traits
    end
  end

  def render_game_over
    game_over_message = ["GAME OVER", "SCORE: #{@score}", "PRESS ENTER TO RESTART"]
    GameText.new(@args, game_over_message).draw_multiple_text_lines
  end

  def player_bounds
    @player.x_pos = [@player.x_pos, LEFT_BORDER].max
    @player.x_pos = [@player.x_pos, RIGHT_BORDER].min
  end

  def player_movement
    move_left = lambda {@player.x_pos -= @player.speed}
    move_right = lambda {@player.x_pos += @player.speed}

    key_pressed(:key_held, :left, move_left)
    key_pressed(:key_held, :right, move_right)
  end
  
  def enemy_movement
   @enemies.each{ |enemy| enemy.y_pos -= enemy.speed}
  end

  def score
    @enemies.each do |enemy|
      if enemy.y_pos <= BOTTOM_BORDER
        @score += 1
      end
    end
  end

  def enemy_respawn
    
      @enemies.each do |enemy|
        if enemy.y_pos <= BOTTOM_BORDER
        enemy.y_pos = SCREEN_HEIGHT
        enemy.x_pos = rand(SCREEN_WIDTH)
        enemy.speed = rand(6) + 5
      end
    end
  end
  
  def game_over
    @enemies.each do |enemy|
      if collision(enemy.traits, @player.traits)
        @game_over = true
      end
    end
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

  def generate_enemies(number_of_enemies)
    enemies = []
    number_of_enemies.times do
      enemies << Enemies.new(rand(SCREEN_WIDTH), SCREEN_HEIGHT, CUBE_SIZE, CUBE_SIZE)
    end
    return enemies
  end

  def enemy_reached_end_point
    end_point = false
    @enemies.each do |enemy|
      if  enemy.y_pos <= BOTTOM_BORDER
        end_point = true
        GameText.new(@args, "#{end_point}").draw_text
      end
      return end_point
    end
  end

  def tick
    game_state
  end
end

def tick(args)
  args.state.game ||= Game.new(args)
  args.state.game.tick
end
