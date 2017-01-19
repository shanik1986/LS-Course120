x = 30
y = 0

begin
  z = x / y
  puts z
rescue => err
  puts err
  p err
end
