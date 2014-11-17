require 'spec_helper'
require "stripe"

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number    => "4242424242424242",
        :exp_month => 9,
        :exp_year  => Time.now.year+1,
        :cvc       => "314"
      },
    ).id
  end

  let(:declined_token) do
    Stripe::Token.create(
      :card => {
        :number    => "4000000000000002",
        :exp_month => 9,
        :exp_year  => Time.now.year+1,
        :cvc       => "314"
      },
    ).id
  end

  describe StripeWrapper::Charge do

    describe ".create", :vcr do
      it "makes a successful charge" do

        response = StripeWrapper::Charge.create(
          :amount      => 999,
          :card        => valid_token,
          :description => "test"
        )

        expect(response).to be_successful
      end

      it "makes a card declined charge" do

        response = StripeWrapper::Charge.create(
          :amount      => 999,
          :card        => declined_token,
          :description => "test"
        )

        expect(response).not_to be_successful
      end

      it "returns the error message for declined charge" do
        response = StripeWrapper::Charge.create(
          :amount      => 999,
          :card        => declined_token,
          :description => "test"
        )

        expect(response.error_message).to eq "Your card was declined."
      end
    end
  end
end
