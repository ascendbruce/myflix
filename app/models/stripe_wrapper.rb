module StripeWrapper
  class Customer
    attr_reader :error_message, :response

    def initialize(options = {})
      @response      = options[:response]
      @error_message = options[:error_message]
    end

    def successful?
      response.present?
    end

    def self.create(options = {})
      response = Stripe::Customer.create(
        card: options[:card],
        plan: "base",
        email: options[:user].email
      )
      new(response: response)
    rescue Stripe::CardError => e
      new(error_message: e.message)
    end
  end
end
