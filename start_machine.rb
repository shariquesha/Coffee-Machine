require_relative 'app/coffee_machine'
require_relative 'app/initializer'

machine = App::CoffeeMachine.new(App::Initializer.load_config(ARGV[0]))
puts 'Coffee Machine Started'
puts 'inputs:- 1:serve 2:list_beverages 3:total_items_quantity 4:refill 5:indicator 6:capacity 7:exit'
ARGV.clear
loop do
  begin
    action = gets.chomp
    case action.to_i
    when 1
      orders = gets.chomp
      puts machine.serve(orders.split(','))
    when 2
      puts machine.beverages
    when 3
      puts machine.inventory
    when 4
      items = gets.chomp
      enhancements = {}
      items.split(',').each do |x|
        enhancements[x.split('=')[0]] = x.split('=')[1]
      end
      machine.refill(enhancements)
    when 5
      puts machine.indicator
    when 6
      puts machine.capacity
    when 7
      break
    end
  rescue StandardError => e
    puts e.message
  end
end
