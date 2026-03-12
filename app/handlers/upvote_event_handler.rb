class UpvoteEventHandler
  def call(command)
    event_store.publish(
      EventUpvoted.new(
        data: {
          event_id: command.event_id,
          user_id: command.user_id
        }
      ),
      stream_name: stream_name(command.event_id)
    )
  end

  private

  def event_store
    Rails.configuration.event_store
  end

  def stream_name(event_id)
    "Event$#{event_id}"
  end
end