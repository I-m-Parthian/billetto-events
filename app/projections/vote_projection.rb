class VoteProjection
  def call(event)
    case event
    when EventUpvoted
      apply_event_upvoted(event)
    when EventDownvoted
      apply_event_downvoted(event)
    end
  end

  private

  def apply_event_upvoted(event)
    event_record = Event.find(event.data[:event_id])
    event_record.increment!(:upvotes)
  end

  def apply_event_downvoted(event)
    event_record = Event.find(event.data[:event_id])
    event_record.increment!(:downvotes)
  end
end
