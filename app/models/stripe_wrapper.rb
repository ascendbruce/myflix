module StripeWrapper
  class Charge
    def self.create(options = {})
      begin
        charge = Stripe::Charge.create(
          :amount      => options[:amount],
          :currency    => "usd",
          :card        => options[:card],
          :description => options[:description]
        )
      rescue Stripe::CardError => e
        # The card has been declined
      end
    end
  end
end
