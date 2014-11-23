require "spec_helper"

describe "Create payment on successful charge", :vcr do
  let(:event_data) do
    {
      "id" => "evt_150vS7DnMTO7dRB3DHf2k4N5",
      "created" => 1416491911,
      "livemode" => false,
      "type" => "charge.succeeded",
      "data" => {
        "object" => {
          "id" => "ch_150vS7DnMTO7dRB3AixiMGod",
          "object" => "charge",
          "created" => 1416491911,
          "livemode" => false,
          "paid" => true,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "card" => {
            "id" => "card_150vS5DnMTO7dRB3iKuD5nXu",
            "object" => "card",
            "last4" => "4242",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 11,
            "exp_year" => 2016,
            "fingerprint" => "ccU8j59zBXkSvpzk",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "customer" => "cus_5BI27Ip1kyWOJR"
          },
          "captured" => true,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_150vS7DnMTO7dRB3AixiMGod/refunds",
            "data" => []
          },
          "balance_transaction" => "txn_150vS7DnMTO7dRB3kNfO57Z8",
          "failure_message" => nil,
          "failure_code" => nil,
          "amount_refunded" => 0,
          "customer" => "cus_5BI27Ip1kyWOJR",
          "invoice" => "in_150vS7DnMTO7dRB3RdfPucN8",
          "description" => nil,
          "dispute" => nil,
          "metadata" => {},
          "statement_description" => nil,
          "fraud_details" => {
            "stripe_report" => "unavailable",
            "user_report" => nil
          },
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_5BI2a3GwIzp1IC",
      "api_version" => "2014-08-20"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded" do
    Fabricate.create(:user, customer_token: "cus_5BI27Ip1kyWOJR")
    post "/stripe_events", event_data
    expect(Payment.count).to eq 1
  end

  it "creates the payment associated with user" do
    alice = Fabricate.create(:user, customer_token: "cus_5BI27Ip1kyWOJR")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq alice
  end

  it "cretaes the payment with the amount" do
    Fabricate.create(:user, customer_token: "cus_5BI27Ip1kyWOJR")
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq 999
  end

  it "creates the payment with reference id" do
    Fabricate.create(:user, customer_token: "cus_5BI27Ip1kyWOJR")
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq "ch_150vS7DnMTO7dRB3AixiMGod"
  end
end
