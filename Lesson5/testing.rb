class Array
  def joinor(delimeter = ', ', last_item_connection = 'or')
    return self[0].to_s if size == 1 || size.zero?

    "#{self[0..-2].join(delimeter)} #{last_item_connection} #{self[-1]}"
  end
end

puts ['this', 'that'].joinor(', ', 'and')
