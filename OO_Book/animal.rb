class Animal
  def a_public_method
    "Will this work? " + protected_method
  end

  protected

  def protected_method
    "Yep, it looks like it will :)"
  end
end

fins = Animal.new

p fins.a_public_method
p fins.protected_method
