require 'nokogiri'
require 'rest-client'

module GroundControl

  class Wemo
    
    def self.on(url)
      Wemo.change_state(url, 1)
    end
    
    def self.off(url)
      Wemo.change_state(url, 0)
    end
    
    def self.on?(url)
      Wemo.status(url) == 'on'
    end
    
    def self.off?(url)
      wemo.status(url) == 'off'
    end
    
    def self.change_state(address, state)
      response = RestClient.post address + '/upnp/control/basicevent1', %{<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:SetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"><BinaryState>#{state}</BinaryState></u:SetBinaryState></s:Body></s:Envelope>},"SOAPACTION"   => '"urn:Belkin:service:basicevent:1#SetBinaryState"', "Content-type" => 'text/xml; charset="utf-8"'
      Nokogiri.XML(response).xpath('//BinaryState').text == state.to_s
    end
    
    def self.status(address)
      response = RestClient.post address + '/upnp/control/basicevent1', %{<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:GetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"></u:GetBinaryState></s:Body></s:Envelope>}, "SOAPACTION"  => '"urn:Belkin:service:basicevent:1#GetBinaryState"', "Content-type" => 'text/xml; charset="utf-8"'
      
      case Nokogiri.XML(response).xpath('//BinaryState').text
      when "1"
        return 'on'
      when "0"
        return 'off'
      end
    end
    
  end
    
end
