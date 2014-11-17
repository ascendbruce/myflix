module StripeWrapper
  class Charge
    attr_reader :error_message, :response

    def initialize(options = {})
      @response      = options[:response]
      @error_message = options[:error_message]
    end

    def successful?
      response.present?
    end

    def self.create(options = {})
      charge = Stripe::Charge.create(
        :amount      => options[:amount],
        :currency    => "usd",
        :card        => options[:card],
        :description => options[:description]
      )
      new(response: charge)
    rescue Stripe::CardError => e
      new(error_message: e.message)
    end
  end

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
