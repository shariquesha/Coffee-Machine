require_relative '../app/coffee_machine'
require 'test/unit'

class CoffeeMachineTest < Test::Unit::TestCase
  def test_machine
    machine_config = {
      'machine' => {
        'outlets' => {
          'count_n' => 100
        },
        'total_items_quantity' => {
          'hot_water' => 1000,
          'hot_milk' => 1200,
          'ginger_syrup' => 200,
          'sugar_syrup' => 300,
          'tea_leaves_syrup' => 200
        },
        'beverages' => {
          'hot_tea' => {
            'hot_water' => 20,
            'hot_milk' => 10,
            'ginger_syrup' => 1,
            'sugar_syrup' => 1,
            'tea_leaves_syrup' => 3
          },
          'hot_coffee' => {
            'hot_water' => 10,
            'ginger_syrup' => 3,
            'hot_milk' => 40,
            'sugar_syrup' => 5,
            'tea_leaves_syrup' => 3
          },
          'black_tea' => {
            'hot_water' => 30,
            'ginger_syrup' => 3,
            'sugar_syrup' => 5,
            'tea_leaves_syrup' => 3
          },
          'green_tea' => {
            'hot_water' => 10,
            'ginger_syrup' => 3,
            'sugar_syrup' => 5,
            'green_mixture' => 3
          }
        }
      }
    }

    machine = App::CoffeeMachine.new(machine_config)

    assert_equal(1000, machine.inventory['hot_water'])
    assert_equal(1200, machine.inventory['hot_milk'])
    assert_equal(200, machine.inventory['ginger_syrup'])
    assert_equal(300, machine.inventory['sugar_syrup'])
    assert_equal(200, machine.inventory['tea_leaves_syrup'])

    # hot_tea = 17 hot_coffee = 23 black_tea = 14
    machine.serve(%w[hot_tea hot_coffee green_tea hot_tea hot_coffee green_tea
                     hot_coffee green_tea black_tea hot_tea hot_coffee hot_tea hot_coffee green_tea hot_tea hot_coffee green_tea
                     hot_coffee green_tea hot_tea black_tea hot_coffee hot_tea hot_coffee green_tea black_tea hot_tea hot_coffee green_tea
                     hot_coffee green_tea hot_tea hot_coffee black_tea black_tea hot_tea hot_coffee green_tea black_tea black_tea black_tea
                     hot_coffee black_tea green_tea black_tea hot_tea hot_coffee hot_tea black_tea hot_coffee green_tea hot_tea hot_coffee green_tea
                     hot_coffee black_tea green_tea hot_tea hot_coffee hot_tea hot_coffee black_tea green_tea hot_tea hot_coffee green_tea
                     hot_coffee green_tea black_tea hot_tea hot_coffee])
    
    assert_equal(10, machine.inventory['hot_water'])
    assert_equal(110, machine.inventory['hot_milk'])
    assert_equal(72, machine.inventory['ginger_syrup'])
    assert_equal(98, machine.inventory['sugar_syrup'])
    assert_equal(38, machine.inventory['tea_leaves_syrup'])

    machine.serve(['hot_tea', 'hot_coffee', 'green_tea'])

    assert_equal(0, machine.inventory['hot_water'])
    assert_equal(70, machine.inventory['hot_milk'])
    assert_equal(69, machine.inventory['ginger_syrup'])
    assert_equal(93, machine.inventory['sugar_syrup'])
    assert_equal(35, machine.inventory['tea_leaves_syrup'])

    add_items = { 
      'hot_water': 100,
      'hot_milk': 100,
      'ginger_syrup': 50,
      'sugar_syrup': 50, 
      'tea_leaves_syrup': 50
    }
    machine.refill(add_items)
    
    assert_equal(100, machine.inventory['hot_water'])
    assert_equal(170, machine.inventory['hot_milk'])
    assert_equal(119, machine.inventory['ginger_syrup'])
    assert_equal(143, machine.inventory['sugar_syrup'])
    assert_equal(85, machine.inventory['tea_leaves_syrup'])

    machine.serve(['green_tea'])

    assert_equal(100, machine.inventory['hot_water'])
    assert_equal(170, machine.inventory['hot_milk'])
    assert_equal(119, machine.inventory['ginger_syrup'])
    assert_equal(143, machine.inventory['sugar_syrup'])
    assert_equal(85, machine.inventory['tea_leaves_syrup'])
  end
end
