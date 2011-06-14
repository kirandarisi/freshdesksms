require 'httparty'

module Freshdesk
  include HTTParty
  base_uri 'http://gavl.freshdesk.com'
  format :xml
  #headers 'Content-Type' => 'application/xml'
  
  
  def initialize
    @auth = {:username => "kiran.darisi@gmail.com", :password => "test"}
  end
  
 def self.create_tkt(content)
   options = {
      :body => {
         :helpdesk_ticket => { 
         :email => 'kiran.darisi@gmail.com', 
         :subject => content[0,50],
         :description => content
       }
       }
   }
   options.merge!({:basic_auth => @auth})
   post( '/widgets/feedback_widget.xml',options)
  
 end
 
end