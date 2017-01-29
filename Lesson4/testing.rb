# module Moveable
#   attr_accessor :speed, :heading
#   attr_writer :fuel_capacity, :fuel_efficiency
#
#   def range
#     @fuel_capacity * @fuel_efficiency
#   end
# end
#
# class WheeledVehicle
#   include Moveable
#
#   def initialize(tire_array, km_traveled_per_liter, liters_of_fuel_capacity)
#     @tires = tire_array
#     self.fuel_efficiency = km_traveled_per_liter
#     self.fuel_capacity = liters_of_fuel_capacity
#   end
#
#   def tire_pressure(tire_index)
#     @tires[tire_index]
#   end
#
#   def inflate_tire(tire_index, pressure)
#     @tires[tire_index] = pressure
#   end
# end
#
# class Seacraft
#   # include Moveable
#
#   attr_accessor :propeller_count, :hull_count
#
#   def initialize
#     def initialize(num_propellers, num_hulls, km_traveled_per_liter, liters_of_fuel_capacity)
#       self.num_propellers = num_propellers
#       self.num_hulls = num_hulls
#       self.fuel_efficiency = km_traveled_per_liter
#       self.fuel_capacity = liters_of_fuel_capacity
#     end
#   end
#
#   def range
#     super.range + 10
#   end
#
# end
#
# class Catamaran < Seacraft; end
#
# class MotorBoat < Seacraft
#   NUM_PROPELLERS = 1
#   NUM_HULLS = 1
#
#   def initialize(km_traveled_per_liter, liters_of_fuel_capacity)
#     super(NUM_PROPELLERS, NUM_HULLS, km_traveled_per_liter, liters_of_fuel_capacity)
#   end
# end


module Swim
  def swim
    "I swim like a champ"
  end
end

class Human
  include Swim
  def swim
    super + " in bathing suit"
  end

end

shani = Human.new
puts shani.swim
