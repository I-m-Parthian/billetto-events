require "rails_helper"

RSpec.describe Events::IngestFromBilletto do
  let(:event_data) do
    {
      "id" => "123",
      "title" => "Test Event",
      "description" => "Test description",
      "image_link" => "https://example.com/image.jpg",
      "startdate" => Time.current,
      "enddate" => Time.current + 2.hours
    }
  end

  let(:client) { instance_double(BillettoClient) }

  before do
    allow(BillettoClient).to receive(:new).and_return(client)
    allow(client).to receive(:fetch_public_events)
      .and_return({ "data" => [event_data] })
  end

  it "creates events from the Billetto API response" do
    expect {
      described_class.new.call
    }.to change(Event, :count).by(1)
  end

  it "does not create duplicate events" do
    described_class.new.call

    expect {
      described_class.new.call
    }.not_to change(Event, :count)
  end

  it "updates existing events when data changes" do
    described_class.new.call

    updated_data = event_data.merge("title" => "Updated Event")

    allow(client).to receive(:fetch_public_events)
      .and_return({ "data" => [updated_data] })

    described_class.new.call

    expect(Event.first.title).to eq("Updated Event")
  end
end
