class Dungeon
  attr_accessor :player

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
  end

  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  def start(location)
    @player.location = location
    show_current_description
  end

  def show_current_description
    puts find_room_in_dungeon(@player.location).full_description
  end

  def find_room_in_dungeon(reference)
    @rooms.detect { |room| room.reference == reference }
  end

  def find_room_in_direction(direction)
    find_room_in_dungeon(@player.location).connections[direction]
  end

  def go(direction)
    puts "You go " + direction.to_s
    @player.location = find_room_in_direction(direction)
    show_current_description
  end

  class Player
    attr_accessor :name, :location

    def initialize(player_name)
      @name = player_name
    end
  end

  class Room
    attr_accessor :reference, :name, :description, :connections

    def initialize(reference, name, description, connections)
      @reference = reference
      @name = name
      @description = description
      @connections = connections
    end

    def full_description
      "\n#{@name}: You are in #{@description}.\n\n"
    end
  end

  def play
    puts "Which direction would you like to go?"
    puts "You have options below."
    puts "-----------------"
    room = @rooms.select { |el| el.reference == @player.location }
    move_options = room[0].connections
    counter = 1
    move_options.each do |k, v|
      puts "#{counter}: #{k.to_s} => #{v}"
      counter += 1
    end
    puts "-----------------"
    print "Type a number: "
    user_input = gets.chomp
    direction = move_options.to_a[user_input.to_i - 1]
    if !direction.nil?
      go(direction.first)
    else
      puts "\nInvalid - please choose a valid direction.\n"
      play
    end
  end

  def won?
    @player.location == :exit
  end

end

print "What's your name? : "
user_name = gets.chomp
puts "Welcome to the shopping mall dungeon, #{user_name}!"
puts "Your goal is to find an exit."
mall_dungeon = Dungeon.new(user_name)

mall_dungeon.add_room(:center, "Center", "the center of shopping mall dungeon", { :north => :coach, :east => :zara, :south => :nike, :west => :jcrew })
mall_dungeon.add_room(:uniqlo, "Uniqlo", "the basic, low price, casual wear shop", { :west => :coach, :south => :zara, :east => :exit })
mall_dungeon.add_room(:zara, "Zara", "the trend, mid price, fashion wear shop", { :north => :uniqlo, :west => :center, :south => :theory })
mall_dungeon.add_room(:theory, "Theory", "the basic, high price, minimal wear shop", {:north => :zara, :west => :nike })
mall_dungeon.add_room(:nike, "NIKE", "the active, mid price, sports wear shop", { :north => :center, :east => :theory, :west => :gap })
mall_dungeon.add_room(:gap, "GAP", "the basic, mid price, family wear shop", { :north => :jcrew, :east => :nike })
mall_dungeon.add_room(:jcrew, "J.crew", "the butique, mid price, casual wear shop", { :north => :forever21, :east => :center, :south => :gap })
mall_dungeon.add_room(:forever21, "Forever 21", "the young, low price, fashion wear shop", { :east => :coach, :south => :jcrew })
mall_dungeon.add_room(:coach, "Coach", "the luxuary, high price, leather wear shop", { :east => :uniqlo, :south => :center, :west => :forever21 })
mall_dungeon.add_room(:exit, "EXIT", "a way out. Congrats! You managed to exit", {} )

mall_dungeon.start(:center)
until mall_dungeon.won?
  mall_dungeon.play
end
