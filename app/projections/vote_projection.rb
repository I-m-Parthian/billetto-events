class VoteProjection
  def call(event)
    case event
    when EventUpvoted
      apply_event_upvoted(event)
    end
  end

  private

  def apply_event_upvoted(event)
    event_record = Event.find(event.data[:event_id])
    event_record.increment!(:upvotes)
  end
end
