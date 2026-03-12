require "rails_helper"

RSpec.describe "Voting Authentication", type: :request do
  let(:event) do
    Event.create!(
      billetto_id: 1,
      title: "Test Event",
      description: "Test",
      image_link: "https://example.com/image.jpg",
      start_date: Time.current,
      end_date: Time.current + 2.hours
    )
  end

  it "redirects unauthenticated users to sign in" do
    post event_upvote_path(event)

    expect(response).to redirect_to(
      "https://next-snake-88.accounts.dev/sign-in"
    )
  end
end
