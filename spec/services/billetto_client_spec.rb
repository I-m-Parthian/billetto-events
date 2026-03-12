require "rails_helper"

RSpec.describe BillettoClient do
  it "fetches public events successfully" do
    stub_request(:get, /billetto.dk/)
      .to_return(
        status: 200,
        body: { data: [] }.to_json,
        headers: { "Content-Type" => "application/json" }
      )

    client = described_class.new
    response = client.fetch_public_events

    expect(response).to have_key("data")
  end
end
