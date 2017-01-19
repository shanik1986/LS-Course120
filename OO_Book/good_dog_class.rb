# good_dog_class.rb

class Animal
  attr_accessor :name
  def initialize(name)
    self.name = name
  end

  def speak
    "Hello!"
  end
end

class GoodDog < Animal
  attr_accessor :color

  def initialize(color)
    super
    self.color = color
  end
end

class BadDog < Animal
  attr_accessor :age

  def initialize(name, age)
    super(name)
    self.age = age
  end
end
#
# class Cat < Animal
# end
#
# paws = Cat.new
# puts paws.speak

sparky = BadDog.new("Sparky", 20)

p sparky
