require "spec_helper"

describe "Deactive user on fail charge", :vcr do
  let(:event_data) do
    {
      "id" => "evt_1522N8DnMTO7dRB3lQBPRU4Z",
      "created" => 1416756838,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_1522N8DnMTO7dRB3ok741xjQ",
          "object" => "charge",
          "created" => 1416756838,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "captured" => false,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_1522N8DnMTO7dRB3ok741xjQ/refunds",
            "data" => []
          },
          "card" => {
            "id" => "card_1522MTDnMTO7dRB36ofyr4tS",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 11,
            "exp_year" => 2016,
            "fingerprint" => "pp0yCSRmin5Lqzku",
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
            "customer" => "cus_5CIhsvXe7IUfcM"
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_5CIhsvXe7IUfcM",
          "invoice" => nil,
          "description" => "payment to fail",
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
      "request" => "iar_5CRFC1n8wn3UDl",
      "api_version" => "2014-08-20"
    }
  end

  it "deactivates a user with the web hook data from stripefor charge failed" do
    alice = Fabricate(:user, customer_token: "cus_5CIhsvXe7IUfcM")
    post "/stripe_events", event_data
    alice.reload
    expect(alice).not_to be_active
  end
end
