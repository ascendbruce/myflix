class Admin::PaymentsController < Admin::ApplicationController
  def index
    @payments = Payment.all
  end
end
