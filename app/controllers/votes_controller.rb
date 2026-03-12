class VotesController < ApplicationController
  def upvote
    event = Event.find(params[:event_id])

    Rails.configuration.command_bus.call(
      UpvoteEvent.new(
        event_id: event.id,
        user_id: current_user
      )
    )

    redirect_to events_path
  end
end
