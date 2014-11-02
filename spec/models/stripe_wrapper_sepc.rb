require 'spec_helper'
require "stripe"

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create" do
      it "makes a successful charge", :vcr do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']

        token = Stripe::Token.create(
          :card => {
            :number    => "4242424242424242",
            :exp_month => 9,
            :exp_year  => Time.now.year+1,
            :cvc       => "314"
          },
        ).id

        response = StripeWrapper::Charge.create(
          :amount      => 999,
          :card        => token,
          :description => "test"
        )

        expect(response).to be_successful
      end

      it "makes a card declined charge", :vcr do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']

        token = Stripe::Token.create(
          :card => {
            :number    => "4000000000000002",
            :exp_month => 9,
            :exp_year  => Time.now.year+1,
            :cvc       => "314"
          },
        ).id

        response = StripeWrapper::Charge.create(
          :amount      => 999,
          :card        => token,
          :description => "test"
        )

        expect(response).not_to be_successful
      end

      it "returns the error message for declined charge", :vcr do
        Stripe.api_key = ENV['STRIPE_SECRET_KEY']

        token = Stripe::Token.create(
          :card => {
            :number    => "4000000000000002",
            :exp_month => 9,
            :exp_year  => Time.now.year+1,
            :cvc       => "314"
          },
        ).id

        response = StripeWrapper::Charge.create(
          :amount      => 999,
          :card        => token,
          :description => "test"
        )

        expect(response.error_message).to eq "Your card was declined."
      end
    end
  end
end
