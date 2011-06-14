class SmsdeliveryController < ApplicationController
  def create_ticket
    Freshdesk.create_tkt(params[:content])
    render :json => {"msisdn" => params[:msisdn], "content" => "Hi We recieved your ticket we will get back to you soon!"}
  end
end
