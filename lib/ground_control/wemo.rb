require 'nokogiri'
require 'playful/ssdp'
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
    
    def self.search
      devices = []
      Playful::SSDP.search("urn:Belkin:device:lightswitch:1").each do |device|
        xml = Nokogiri.XML(RestClient.get(device[:location]))
        devices << {name: xml.at('friendlyName').text, model: xml.at('modelName').text, location: device[:location].sub('/setup.xml',''), xml: xml}
      end
      
      Playful::SSDP.search("urn:Belkin:device:controllee:1").each do |device|
        xml = Nokogiri.XML(RestClient.get(device[:location]))
        devices << {name: xml.at('friendlyName').text, model: xml.at('modelName').text, location: device[:location].sub('/setup.xml',''), xml: xml}
      end
      
      Playful::SSDP.search("urn:Belkin:device:sensors:1").each do |device|
        xml = Nokogiri.XML(RestClient.get(device[:location]))
        devices << {name: xml.at('friendlyName').text, model: xml.at('modelName').text, location: device[:location].sub('/setup.xml',''), xml: xml}
      end
      
      devices
    end
    
    
    
  end
    
end
