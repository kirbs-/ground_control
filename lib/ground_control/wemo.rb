require 'nokogiri'
require 'rest-client'

module GroundControl

  class Wemo
    
    def Wemo.on(url)
      Wemo.change_state(url, 1)
    end
    
    def Wemo.off(url)
      Wemo.change_state(url, 0)
    end
    
    def self.change_state(address, state)
      response = RestClient.post address + '/upnp/control/basicevent1', %{<?xml version="1.0" encoding="utf-8"?><s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/" s:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"><s:Body><u:SetBinaryState xmlns:u="urn:Belkin:service:basicevent:1"><BinaryState>#{state}</BinaryState></u:SetBinaryState></s:Body></s:Envelope>},"SOAPACTION"   => '"urn:Belkin:service:basicevent:1#SetBinaryState"', "Content-type" => 'text/xml; charset="utf-8"'
      Nokogiri.XML(response).xpath('//BinaryState').text == state.to_s
    end
    
  end
    
end
