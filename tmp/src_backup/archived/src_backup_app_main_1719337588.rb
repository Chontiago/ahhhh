$gtk.reset

SCREEN_WIDTH = 1280
SCREEN_HEIGHT = 720
HALF_SCREEN_WIDTH = SCREEN_WIDTH / 2
HALF_SCREEN_HEIGHT = SCREEN_HEIGHT / 2
BOX_SIZE = 50
PLAYER_WIDTH = BOX_SIZE * 2
PLAYER_X_POS = HALF_SCREEN_WIDTH - BOX_SIZE
ENEMY_SPAWN_POINT = SCREEN_HEIGHT - BOX_SIZE
LINE_SKIP = 50
PLAYER_BOUNDS = SCREEN_WIDTH + PLAYER_WIDTH
PLAYER_SPEED = 5
NEXT_FALL = 2
LEFT_BORDER = 0
RIGHT_BORDER = SCREEN_WIDTH 
BOTTOM_BORDER = 0 - BOX_SIZE


class Game
  def initialize(args)
    @args = args
    @game_over ||= false
    #@randomize_x_pos = random(0..SCREEN_WIDTH)
    @player = Box.new(PLAYER_X_POS, 0, PLAYER_WIDTH).draw_box
    @enemy = Box.new(HALF_SCREEN_WIDTH, ENEMY_SPAWN_POINT, BOX_SIZE ).draw_box
    @move ||= nil
    @score ||= 0
    @fall_speed  ||= 5
  end

  class Box
    def initialize(x, y, width)
      @x = x
      @y = y
      @width = width
      @height = BOX_SIZE
    end

    def draw_box
      return {x: @x, y: @y, w: @width , h: @height }
    end
  end

  class Text
    def initialize(x=HALF_SCREEN_WIDTH, y, text)
      @x = x
      @y = y
      @text = text
    end

    def draw_text
      return {x: @x, y: @y, anchor_x: 0.5, anchor_y: 0.5, text: @text}
    end
  end

  def game_state
   if @game_over == true
    return game_over_state
   end
   return gameplay_state

  end

  def gameplay_state
    render_gameplay
    player_movement
    enemy_movement
    score
    game_over

  end

  def game_over_state
    render_game_over
    reset_game
  end
  

  def render_gameplay
    @args.outputs.solids << @player
    @args.outputs.solids << @enemy
    @args.outputs.labels << Text.new(HALF_SCREEN_HEIGHT, @score.to_i).draw_text
  end

  def player_movement
    move_left = lambda {@player.x -= PLAYER_SPEED }
    move_right =lambda{@player.x += PLAYER_SPEED}

    key_pressed(:left, move_left)
    key_pressed(:right, move_right)
  end
  

  def score
    if @enemy.y <= BOTTOM_BORDER
      @enemy.y = ENEMY_SPAWN_POINT
      @score += 1
    end
  end

  def render_game_over
    game_over_screen = ["GAME OVER", @score.to_s, "PRESS ENTER TO RESTART"]
    
    game_over_screen.each_with_index do |text, index|
      @args.outputs.labels << Text.new(HALF_SCREEN_HEIGHT - (index * LINE_SKIP), text).draw_text
    end

  end

  def enemy_movement
    @enemy.y -= 5
  end

  def game_over
    if collision(@enemy, @player)
      @game_over = true
    end
  end

  def reset_game
    key_pressed(:enter, $gtk.method(:reset))
  end

  def key_pressed(key, action)
    if @args.inputs.keyboard.key_held.send(key) 
      action.call
    end
  end

  def collision(box1, box2) # box1 enemy, box2 player
    box1[:y] <= box2[:y] + box2[:h] &&  
    box1[:x] + box1[:w] >= box2[:x] &&
    box1[:x] <= box2[:x] + box2[:w]
  end
    
  def tick
    game_state
  end
end

def tick (args)
  args.state.game ||= Game.new(args)
  args.state.game.tick  
end
