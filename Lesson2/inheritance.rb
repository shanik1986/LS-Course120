class Pet
  def run
    "Running!"
  end

  def jump
    "Jumping!"
  end
end

class Dog < Pet
  def speak
    "Bark!"
  end

  def fetch
    "Fetching!"
  end

  def swim
    "Swimming!"
  end
end

class Cat < Pet
  def speak
    "Meow"
  end
end

bob = Dog.new
mou = Cat.new

p bob.swim
p bob.run
p bob.fetch
p bob.jump

p mou.swim
p mou.run
p mou.jump
p mou.fetch
