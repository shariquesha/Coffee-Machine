# Coffee-Machine
A multithreaded coffee machine application in Ruby
* ruby 2.5 is required

* Directory structure
```
├── README.md
├── app
│   ├── coffee_machine.rb
│   ├── exception.rb
│   ├── initializer.rb
│   └── validator.rb
├── config
│   └── machine.json
├── run_all_tests.sh
├── start_machine.rb
└── tests
    ├── coffee_machine_test.rb
    ├── indicator_test.rb
    ├── initialize_test.rb
    ├── list_beverages.rb
    ├── refill_test.rb
    └── serve_test.rb
 ```
* To start the machine run:
` ruby start_machine.rb `
It will load machine configuration file from `config` and boot the machine.

* Machine can take different configuration file during the start by passing path of it:
` ruby start_machine.rb ~/machine.json `

* Actions
  * serve
    
    input: (comma separated values - without space)
        
        hot_tea,hot_coffee,green_tea 
    
    output: (order of output will not same for same input because of thread scheduling)

         
         green_tea cannot be prepared because green_mixture is not available

         hot_tea is prepared

         hot_coffee is prepared

  * list_beverages 

     `{"hot_tea"=>{"hot_water"=>200, "hot_milk"=>100, "ginger_syrup"=>10, "sugar_syrup"=>10, "tea_leaves_syrup"=>30}, "hot_coffee"=>{"hot_water"=>100, "ginger_syrup"=>30, "hot_milk"=>400, "sugar_syrup"=>50, "tea_leaves_syrup"=>30}, "black_tea"=>{"hot_water"=>300, "ginger_syrup"=>30, "sugar_syrup"=>50, "tea_leaves_syrup"=>30}, "green_tea"=>{"hot_water"=>100, "ginger_syrup"=>30, "sugar_syrup"=>50, "green_mixture"=>30}}`

  * total_items_quantity

     `{"hot_water"=>200, "hot_milk"=>0, "ginger_syrup"=>60, "sugar_syrup"=>40, "tea_leaves_syrup"=>40}`

  * refill
 
    input: (comma separated values - without space)

        hot_milk=10,hot_water=100

  * indicator

    `{"hot_water"=>"60.0%", "hot_milk"=>"6.0%", "ginger_syrup"=>"60.0%", "sugar_syrup"=>"40.0%", "tea_leaves_syrup"=>"40.0%"}`

  * capacity

    `{"hot_water"=>500, "hot_milk"=>500, "ginger_syrup"=>100, "sugar_syrup"=>100, "tea_leaves_syrup"=>100}`

  * exit

* run all test cases using shell:
`  sh run_all_tests.sh `


* run any individual test case file:
`  ruby tests/coffee_machine_test.rb `