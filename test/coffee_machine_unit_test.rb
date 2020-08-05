require_relative '../app/coffee_machine'
require 'test/unit'
 
class TestCoffeeMachineUnit < Test::Unit::TestCase
 
  def test_initialize
    machine = CoffeeMachine.instance

    assert_equal(500, machine.inventory['hot_water'])
    assert_equal(500, machine.inventory['hot_milk'])
    assert_equal(100, machine.inventory['ginger_syrup'])
    assert_equal(100, machine.inventory['sugar_syrup'])
    assert_equal(100, machine.inventory['tea_leaves_syrup'])

    assert_equal(200, machine.beverages['hot_tea']['hot_water'])
    assert_equal(100, machine.beverages['hot_tea']['hot_milk'])
    assert_equal(10, machine.beverages['hot_tea']['ginger_syrup'])
    assert_equal(10, machine.beverages['hot_tea']['sugar_syrup'])
    assert_equal(30, machine.beverages['hot_tea']['tea_leaves_syrup'])

    assert_equal(100, machine.beverages['hot_coffee']['hot_water'])
    assert_equal(400, machine.beverages['hot_coffee']['hot_milk'])
    assert_equal(30, machine.beverages['hot_coffee']['ginger_syrup'])
    assert_equal(50, machine.beverages['hot_coffee']['sugar_syrup'])
    assert_equal(30, machine.beverages['hot_coffee']['tea_leaves_syrup'])

    assert_equal(300, machine.beverages['black_tea']['hot_water'])
    assert_equal(30, machine.beverages['black_tea']['ginger_syrup'])
    assert_equal(50, machine.beverages['black_tea']['sugar_syrup'])
    assert_equal(30, machine.beverages['black_tea']['tea_leaves_syrup'])

    assert_equal(100, machine.beverages['green_tea']['hot_water'])
    assert_equal(30, machine.beverages['green_tea']['ginger_syrup'])
    assert_equal(50, machine.beverages['green_tea']['sugar_syrup'])
    assert_equal(30, machine.beverages['green_tea']['green_mixture'])

    assert_equal(3, machine.outlets)
  end

  def test_list_beverages
    machine = CoffeeMachine.instance

    assert_equal('hot_tea hot_coffee black_tea green_tea', machine.list_beverages)
  end

  def test_refill
    machine = CoffeeMachine.instance
    add_items = { 
      'hot_water': 500,
      'hot_milk': 500,
      'ginger_syrup': 100,
      'sugar_syrup': 100, 
      'tea_leaves_syrup': 100 
    }
    machine.refill(add_items)
    assert_equal(1000, machine.inventory['hot_water'])
    assert_equal(1000, machine.inventory['hot_milk'])
    assert_equal(200, machine.inventory['ginger_syrup'])
    assert_equal(200, machine.inventory['sugar_syrup'])
    assert_equal(200, machine.inventory['tea_leaves_syrup'])

    new_items = { 'abcd': 121 }
    assert_nothing_raised { machine.refill(new_items) }

    assert_raise(InvalidParameter) { machine.refill('INVALID INPUT') }

    assert_equal(1000, machine.inventory['hot_water'])
    assert_equal(1000, machine.inventory['hot_milk'])
    assert_equal(200, machine.inventory['ginger_syrup'])
    assert_equal(200, machine.inventory['sugar_syrup'])
    assert_equal(200, machine.inventory['tea_leaves_syrup'])

    negative_valued_items = { 
      'hot_water': -500,
      'hot_milk': 500,
      'ginger_syrup': 100,
      'sugar_syrup': 100, 
      'tea_leaves_syrup': 100 
    }
    assert_raise(InvalidParameter) { machine.refill(negative_valued_items) }

    assert_equal(1000, machine.inventory['hot_water'])
    assert_equal(1000, machine.inventory['hot_milk'])
    assert_equal(200, machine.inventory['ginger_syrup'])
    assert_equal(200, machine.inventory['sugar_syrup'])
    assert_equal(200, machine.inventory['tea_leaves_syrup'])
  end

  def test_serve
    machine = CoffeeMachine.instance
    assert_nothing_raised { machine.serve(['hot_tea', 'hot_coffee', 'green_tea']) }
    assert_raise(InvalidParameter) { machine.serve(['INVALID']) }
    assert_raise(InvalidParameter) { machine.serve(['hot_tea', 'hot_coffee', 'green_tea', 'black_tea']) }
    assert_raise(InvalidParameter) { machine.serve(['hot_tea', 'hot_coffee', 'abcd']) }
  end
end
