class UpvoteEventHandler
  def call(command)
    return if already_voted?(command)

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

  def already_voted?(command)
    event_store
      .read
      .stream(stream_name(command.event_id))
      .to_a
      .any? { |event| event.data[:user_id] == command.user_id }
  end
end
