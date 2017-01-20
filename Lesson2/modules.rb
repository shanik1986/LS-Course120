class Person
  attr_accessor :name, :pets

  def initialize(name)
    @name = name
    @pets = []
  end
end

module Swim
  def swim
    "Swimming"
  end
end

class Pet
  def to_s
    "This is a #{self.class}"
  end
end

class Mammals < Pet
  def run
    "Running"
  end

  def jump
    "Jumping"
  end
end

class Dog < Mammals
  include Swim
  def speak
    "Whoof!"
  end
end

class Bulldog < Dog; end

class Cat < Mammals
  def speak
    "Meow!"
  end
end

class Fish < Pet
  include Swim
end


bob = Person.new("Robert")
bud = Dog.new
kitty = Cat.new

p bud.swim
