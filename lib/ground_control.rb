require "ground_control/version"
require 'nokogiri'
require 'rest-client'

require 'ground_control/wemo'

module GroundControl
  # Your code goes here...

  def self.turn_on(device)
    Wemo.on(device)
  end
  
  def self.turn_off(device)
    Wemo.off(device)
  end
  
end
