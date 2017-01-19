# good_dog.rb

# class GoodDog
#
#   DOG_YEARS = 7
#
#   attr_accessor :name, :age
#
#   def initialize(n, a)
#     self.name = n
#     self.age = a * DOG_YEARS
#   end
#
#   def to_s
#     "This Dog's name is #{name} and its age in dog years is #{age}"
#   end
# end
#
# sparky = GoodDog.new("Sparky", 4)
# puts sparky

class GoodDog
  attr_accessor :name, :height, :weight

  def initialize(n, h, w)
    self.name   = n
    self.height = h
    self.weight = w
  end

  def change_info(n, h, w)
    self.name   = n
    self.height = h
    self.weight = w
  end

  def info
    "#{self.name} weighs #{self.weight} lbs and is #{self.height} high"
  end

  def to_s
    "#{self.name} weighs #{self.weight} lbs and is #{self.height} high"
  end
end

sparky = GoodDog.new("Sparky", '12 inches', '10 lbs')
puts sparky
