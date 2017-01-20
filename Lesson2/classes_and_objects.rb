class Person
  attr_accessor :first_name, :last_name
  attr_reader :full_name

  def initialize(full_name)
    @full_name = full_name
    split_name
  end

  def name
    "#{@first_name} #{@last_name}".strip
  end

  def name=(new_name)
    @full_name = new_name
    split_name
  end

  def ==(other_person)
    self.full_name == other_person.full_name
  end

  private

  def split_name
    @name_arr = @full_name.split
    @first_name = @name_arr.first
    @last_name = @name_arr.size > 1 ? @name_arr.last : ''
  end
end

bob = Person.new("Robert Smith")
rob = Person.new("Robert Smith")

p rob == bob
