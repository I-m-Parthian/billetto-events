require "rails_helper"

RSpec.describe Event, type: :model do
  subject do
    described_class.new(
      billetto_id: 100,
      title: "Sample Event",
      description: "Test",
      image_link: "https://example.com/image.jpg",
      start_date: Time.current,
      end_date: Time.current + 5.hours
    )
  end

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is invalid without title" do
    subject.title = nil
    expect(subject).not_to be_valid
  end

  it "is invalid without start_date" do
    subject.start_date = nil
    expect(subject).not_to be_valid
  end

  it "does not allow duplicate billetto_id" do
    subject.save!
    duplicate = subject.dup
    expect(duplicate).not_to be_valid
  end
end
