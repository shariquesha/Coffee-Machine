require_relative '../app/coffee_machine'
require 'test/unit'
 
class RefillTest < Test::Unit::TestCase
  def test_refill
    machine_config = {
      'machine'=> {
        'outlets'=> {
          'count_n'=> 3
        },
        'total_items_quantity'=> {
          'hot_water'=> 500,
          'hot_milk'=> 500,
          'ginger_syrup'=> 100,
          'sugar_syrup'=> 100,
          'tea_leaves_syrup'=> 100
        },
        'beverages'=> {
          'hot_tea'=> {
            'hot_water'=> 200,
            'hot_milk'=> 100,
            'ginger_syrup'=> 10,
            'sugar_syrup'=> 10,
            'tea_leaves_syrup'=> 30
          },
          'hot_coffee'=> {
            'hot_water'=> 100,
            'ginger_syrup'=> 30,
            'hot_milk'=> 400,
            'sugar_syrup'=> 50,
            'tea_leaves_syrup'=> 30
          },
          'black_tea'=> {
            'hot_water'=> 300,
            'ginger_syrup'=> 30,
            'sugar_syrup'=> 50,
            'tea_leaves_syrup'=> 30
          },
          'green_tea'=> {
            'hot_water'=> 100,
            'ginger_syrup'=> 30,
            'sugar_syrup'=> 50,
            'green_mixture'=> 30
          }
        }
      }
    }

    machine = App::CoffeeMachine.new(machine_config)
    machine.serve(['hot_tea', 'hot_coffee', 'green_tea'])
    
    assert_equal(0, machine.inventory['hot_milk'])
    
    machine.refill({ 'hot_milk': 500 })
    
    assert_equal(500, machine.inventory['hot_milk'])

    assert_raise(App::InvalidParameter) { machine.refill({ 'hot_milk': 500 }) }

    assert_raise(App::InvalidParameter) { machine.refill({ 'abcd': 121 }) }

    assert_raise(App::InvalidParameter) { machine.refill('INVALID INPUT') }

    assert_raise(App::InvalidParameter) { machine.refill({ 'hot_milk': - 10 }) }

    assert_equal(500, machine.inventory['hot_milk'])

  end
end
