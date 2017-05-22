class Dungeon
  load 'player.rb'
  load 'room.rb'
  attr_accessor :player
  attr_reader :budget, :purchased

  def initialize(player_name)
    @player = Player.new(player_name)
    @rooms = []
    @budget = 300
    @purchased = []
  end

  def add_room(reference, name, description, connections)
    @rooms << Room.new(reference, name, description, connections)
  end

  def start
    @player.location = :center
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
    if @player.location == :center || @player.location == :exit
      puts "=> Your current balance: $#{@budget}"
      puts "=> Purchased items: #{@purchased.join(", ")}\n\n"
    else
      shop
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

  def shop
    items = [
    { "cotton t-shirt" => 40 },
    { "polo shirt" => 50 },
    { "denim shirt" => 70 },
    { "oxford shirt" => 70 },
    { "linen shirt" => 60 },
    { "chino shorts" => 50 },
    { "selvedge jeans" => 100 },
    { "down jacket" => 150 },
    { "sweat hoodie" => 70 },
    { "heavy gauge cardigan" => 90 },
    { "cashmere sweater" => 160 },
    { "low-cut socks" => 20 },
    { "leather belt" => 50 }
    ]
    selected_item = items[rand(12)]
    item = selected_item.keys.first
    price = selected_item.values.first
    puts "You purchased #{item} at $#{price}"
    @budget = (@budget - price)
    if @budget < 0
      puts "=> Your current balance: -$#{@budget.abs}"
    else
      puts "=> Your current balance: $#{@budget}"
    end
    @purchased << item
    puts "=> Purchased items: #{@purchased.join(", ")}\n\n"
  end

  def exit?
    @player.location == :exit
  end

  def over_budget?
    @budget < 0
  end

end

if __FILE__ == $PROGRAM_NAME
  print "What's your name? : "
  user_name = gets.chomp
  puts "Welcome to the shopping mall dungeon, #{user_name.capitalize}!"
  puts "Your goal is to find an exit without spending too much on shopping."
  puts "Your budget is $300. Please don't go over the budget."
  mall_dungeon = Dungeon.new(user_name)
  # loading the shopping mall dungeon.
  mall_dungeon.add_room(:center, "Center", "the center of shopping mall dungeon",
   { :north => :coach, :east => :zara, :south => :nike, :west => :jcrew })
  mall_dungeon.add_room(:uniqlo, "Uniqlo", "the basic, low price, casual wear shop",
   { :west => :coach, :south => :zara, :east => :exit })
  mall_dungeon.add_room(:zara, "Zara", "the trend, mid price, fashion wear shop",
   { :north => :uniqlo, :west => :center, :south => :theory })
  mall_dungeon.add_room(:theory, "Theory", "the basic, high price, minimal wear shop",
   {:north => :zara, :west => :nike })
  mall_dungeon.add_room(:nike, "NIKE", "the active, mid price, sports wear shop",
   { :north => :center, :east => :theory, :west => :gap })
  mall_dungeon.add_room(:gap, "GAP", "the basic, mid price, family wear shop",
   { :north => :jcrew, :east => :nike })
  mall_dungeon.add_room(:jcrew, "J.crew", "the butique, mid price, casual wear shop",
   { :north => :forever21, :east => :center, :south => :gap })
  mall_dungeon.add_room(:forever21, "Forever 21", "the young, low price, fashion wear shop",
   { :east => :coach, :south => :jcrew })
  mall_dungeon.add_room(:coach, "Coach", "the luxuary, high price, leather wear shop",
   { :east => :uniqlo, :south => :center, :west => :forever21 })
  mall_dungeon.add_room(:exit, "EXIT", "a way out", {} )

  mall_dungeon.start
  condition = false
  while condition == false
    mall_dungeon.play
    if mall_dungeon.over_budget?
      puts "Game over! You went over budget..."
      condition = true
    elsif mall_dungeon.exit?
      puts "Congrats! You managed to exit!"
      puts "You shopped #{mall_dungeon.purchased.join(", ")} and $#{mall_dungeon.budget} left."
      condition = true
    end
  end
end
