require "rails_helper"

RSpec.describe UpvoteEventHandler do
  let(:event_store) { Rails.configuration.event_store }

  let!(:event_record) do
    Event.create!(
      billetto_id: 1,
      title: "Test Event",
      description: "Test",
      image_link: "https://example.com/image.jpg",
      start_date: Time.current,
      end_date: Time.current + 2.hours
    )
  end

  let(:command) do
    UpvoteEvent.new(
      event_id: event_record.id,
      user_id: "user_123"
    )
  end

  it "publishes an EventUpvoted event" do
    handler = described_class.new

    expect {
      handler.call(command)
    }.to change {
      event_store.read.stream("Event$#{event_record.id}").to_a.count
    }.by(1)
  end
end
