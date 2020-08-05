require_relative '../app/coffee_machine'
require 'test/unit'
 
class TestCoffeeMachineIntegration < Test::Unit::TestCase
  def test_machine
    machine = CoffeeMachine.instance
    
    assert_equal(500, machine.inventory['hot_water'])
    assert_equal(500, machine.inventory['hot_milk'])
    assert_equal(100, machine.inventory['ginger_syrup'])
    assert_equal(100, machine.inventory['sugar_syrup'])
    assert_equal(100, machine.inventory['tea_leaves_syrup'])

    machine.serve(['hot_tea', 'hot_coffee', 'green_tea'])

    assert_equal(200, machine.inventory['hot_water'])
    assert_equal(0, machine.inventory['hot_milk'])
    assert_equal(60, machine.inventory['ginger_syrup'])
    assert_equal(40, machine.inventory['sugar_syrup'])
    assert_equal(40, machine.inventory['tea_leaves_syrup'])

    machine.serve(['hot_tea', 'hot_coffee', 'green_tea'])

    assert_equal(200, machine.inventory['hot_water'])
    assert_equal(0, machine.inventory['hot_milk'])
    assert_equal(60, machine.inventory['ginger_syrup'])
    assert_equal(40, machine.inventory['sugar_syrup'])
    assert_equal(40, machine.inventory['tea_leaves_syrup'])

    add_items = { 
      'hot_water': 500,
      'hot_milk': 500,
      'ginger_syrup': 500,
      'sugar_syrup': 500, 
      'tea_leaves_syrup': 500 
    }
    machine.refill(add_items)

    assert_equal(700, machine.inventory['hot_water'])
    assert_equal(500, machine.inventory['hot_milk'])
    assert_equal(560, machine.inventory['ginger_syrup'])
    assert_equal(540, machine.inventory['sugar_syrup'])
    assert_equal(540, machine.inventory['tea_leaves_syrup'])

    machine.serve(['green_tea'])

    assert_equal(700, machine.inventory['hot_water'])
    assert_equal(500, machine.inventory['hot_milk'])
    assert_equal(560, machine.inventory['ginger_syrup'])
    assert_equal(540, machine.inventory['sugar_syrup'])
    assert_equal(540, machine.inventory['tea_leaves_syrup'])

    machine.serve(['hot_tea', 'hot_coffee', 'black_tea'])

    assert_equal(100, machine.inventory['hot_water'])
    assert_equal(0, machine.inventory['hot_milk'])
    assert_equal(490, machine.inventory['ginger_syrup'])
    assert_equal(430, machine.inventory['sugar_syrup'])
    assert_equal(450, machine.inventory['tea_leaves_syrup'])
  end
end
