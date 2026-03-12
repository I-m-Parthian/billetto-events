require "rails_helper"

RSpec.describe VoteProjection do
  let(:event_record) do
    Event.create!(
      billetto_id: 1,
      title: "Test Event",
      description: "Test",
      image_link: "https://example.com/image.jpg",
      start_date: Time.current,
      end_date: Time.current + 2.hours
    )
  end

  let(:projection) { described_class.new }

  it "increments upvotes when EventUpvoted occurs" do
    event = EventUpvoted.new(
      data: {
        event_id: event_record.id,
        user_id: "user_1"
      }
    )

    projection.call(event)

    expect(event_record.reload.upvotes).to eq(1)
  end

  it "increments downvotes when EventDownvoted occurs" do
    event = EventDownvoted.new(
      data: {
        event_id: event_record.id,
        user_id: "user_1"
      }
    )

    projection.call(event)

    expect(event_record.reload.downvotes).to eq(1)
  end
end
