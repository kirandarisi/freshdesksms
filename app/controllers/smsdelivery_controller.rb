class SmsdeliveryController < ApplicationController
  def create_ticket
    Freshdesk.create_tkt(params[:content],params[:msisdn])
    render :text => "We received the request and we will get back to you soon." 
  end
end
