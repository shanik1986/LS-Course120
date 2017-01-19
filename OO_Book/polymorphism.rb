class Animal
  def make_noise
    "Some noise"
  end

  def sleep
    "#{self.class.name} is sleeping"
  end
end

class Dog < Animal
  def make_noise
    "Woof!"
  end
end

class Cat < Animal
  def make_noise
    "Meow!"
  end
end

[Animal.new, Dog.new, Cat.new].each do |object|
  p object.make_noise
  p object.sleep
end
