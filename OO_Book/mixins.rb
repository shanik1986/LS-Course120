module Device
  def switch_on; puts "On" end
  def switch_off; puts "Off" end
end

module Volume
  def volume_up; puts "Volume up" end
  def voume_down; puts "Volume down" end
end
module Pluggable
  def plug_in; puts "Plug in" end
  def plug_out; puts "Plug out" end
end

class CellPhone
  include Device, Volume, Pluggable
  def ring
    puts "Ringing"
  end
end

cph = CellPhone.new
cph.switch_on
cph.volume_up
cph.ring
