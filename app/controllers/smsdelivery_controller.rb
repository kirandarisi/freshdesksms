class SmsdeliveryController < ApplicationController
  def create_ticket
    Freshdesk.create_tkt(params[:content])
    redirect_to "/"
  end
end
