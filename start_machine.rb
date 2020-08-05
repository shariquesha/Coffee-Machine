require_relative 'app/coffee_machine'
puts 'inputs', '1:serve 2:list_beverages 3:total_items_quantity 4:refill 5:indicator 6:exit'
loop do
  begin
    action = gets.chomp
    case action.to_i
    when 1
      orders = gets.chomp
      puts CoffeeMachine.instance.serve(orders.split(','))
    when 2
      puts CoffeeMachine.instance.list_beverages
    when 3
      puts CoffeeMachine.instance.inventory
    when 4
      items = gets.chomp
      enhancements = {}
      items.split(',').each do |x|
        enhancements[x.split('=')[0]] = x.split('=')[1]
      end
      CoffeeMachine.instance.refill(enhancements)
    when 5
      puts CoffeeMachine.instance.indicator
    when 6
      break
    end
  rescue StandardError => e
    puts e.message
  end
end
