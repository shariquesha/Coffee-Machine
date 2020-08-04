require_relative 'app/coffee_machine'
puts 'inputs', '1:serve 2:total_items_quantity 3:refill 4:exit'
loop do
  begin
    action = gets.chomp
    case action.to_i
    when 1
      orders = gets.chomp
      orders_a = orders.split(',')
      outlets = CoffeeMachine.instance.outlets
      machine_overloaded = orders_a.length > outlets
      raise "machine can only serve #{outlets} at a time" if machine_overloaded
      CoffeeMachine.instance.serve(orders_a)
    when 2
      puts CoffeeMachine.instance.inventory
    when 3
      items = gets.chomp
      enhancements = {}
      items.split(',').each do |x|
        enhancements[x.split('=')[0]] = x.split('=')[1]
      end
      CoffeeMachine.instance.refil(enhancements)
    when 4
      break
    end
  rescue StandardError => e
    puts e.message
  end
end
