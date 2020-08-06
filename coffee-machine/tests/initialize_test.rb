require_relative '../app/coffee_machine'
require 'test/unit'

class InitializerTest < Test::Unit::TestCase
  def test_initialize
    machine_config = {
      'machine' => {
        'outlets' => {
          'count_n' => 3
        },
        'total_items_quantity' => {
          'hot_water' => 500,
          'hot_milk' => 500,
          'ginger_syrup' => 100,
          'sugar_syrup' => 100,
          'tea_leaves_syrup' => 100
        },
        'beverages' => {
          'hot_tea' => {
            'hot_water' => 200,
            'hot_milk' => 100,
            'ginger_syrup' => 10,
            'sugar_syrup' => 10,
            'tea_leaves_syrup' => 30
          },
          'hot_coffee' => {
            'hot_water' => 100,
            'ginger_syrup' => 30,
            'hot_milk' => 400,
            'sugar_syrup' => 50,
            'tea_leaves_syrup' => 30
          },
          'black_tea' => {
            'hot_water' => 300,
            'ginger_syrup' => 30,
            'sugar_syrup' => 50,
            'tea_leaves_syrup' => 30
          },
          'green_tea' => {
            'hot_water' => 100,
            'ginger_syrup' => 30,
            'sugar_syrup' => 50,
            'green_mixture' => 30
          }
        }
      }
    }

    machine = App::CoffeeMachine.new(machine_config)

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
end
