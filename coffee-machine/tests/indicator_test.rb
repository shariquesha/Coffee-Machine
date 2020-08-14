require_relative '../app/coffee_machine'
require 'test/unit'

class IndicatorTest < Test::Unit::TestCase
  def test_indicator
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
    values = machine.indicator
    assert_equal('100.0%', values['hot_water'])
    assert_equal('100.0%', values['hot_milk'])
    assert_equal('100.0%', values['ginger_syrup'])
    assert_equal('100.0%', values['sugar_syrup'])
    assert_equal('100.0%', values['tea_leaves_syrup'])

    machine.serve(%w[hot_tea hot_coffee green_tea])

    values = machine.indicator

    assert_equal('40.0%', values['hot_water'])
    assert_equal('0.0%', values['hot_milk'])
    assert_equal('60.0%', values['ginger_syrup'])
    assert_equal('40.0%', values['sugar_syrup'])
    assert_equal('40.0%', values['tea_leaves_syrup'])
  end
end
