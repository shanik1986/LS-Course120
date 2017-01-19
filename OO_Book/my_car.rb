# my_car.rb

require 'pry'

class Vehicle
  attr_accessor :color
  attr_reader   :year, :model

  @@number_of_inheretors = 0

  def initialize(year, color, model)
    @@number_of_inheretors += 1 if self.class.superclass == Vehicle
    @year = year
    @color = color
    @model = model
    @speed = 0
  end

  def details
    vehicle_age
  end

  def self.inheretors
    @@number_of_inheretors
  end

  def speed_up(num)
    puts "Currently driving at #{@speed} Kph. Speeding up by #{num} Kph."
    @speed += num
    puts "Current speed is now #{@speed} Kph"
  end

  def brake
    if @speed == 0
      puts "We can't go any slower... We're standing!"
    else
      puts "Okay, slowing down from #{@speed} to #{@speed - 10} Kph"
      @speed -= 10
    end
  end

  def shut_off
    @speed = 0
    puts "Okay, shutting down. Fun's over."
  end
  def spray_paint(new_color)
    puts "Wow, look at all this #{new_color} spray paint!"
    self.color = new_color
    puts "The vehicle is now #{new_color}"
  end

  private

  def vehicle_age
    current_year = Time.new.year
    "The vehicle is #{current_year - self.year} old"
  end
end

module Unloadable
  def unload
    "Unloading cargo"
  end
end

class MyCar < Vehicle
  VEHICLE_TYPE = "car"

  def initialize(year, color, model)
    super(year, color, model)
  end
end

class MyTruck < Vehicle
  include Unloadable

  VEHICLE_TYPE = "truck"
  def initialize(year, color, model)
    super(year, color, model)
  end

end

jane = MyCar.new(2000, "Black", "Ford Fiesta")
joe = MyTruck.new(10, "Yellow", "Big")
jim = Vehicle.new(20, "Purple", "Small")

puts jane.details
puts jane.vehicle_age

#
# jane.speed_up(40)
# jane.brake
# jane.shut_off
#
# puts jane.spray_paint("Dark Red")

# puts "Jane's year of making is #{jane.year}"

# puts "#{jane.year} #{jane.color} #{jane.model}"
#
# jane.year = 3000
# jane.color = "Purple"
# jane.model = "Spaceship"
#
# puts "#{jane.year} #{jane.color} #{jane.model}"
