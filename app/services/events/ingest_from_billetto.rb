class Events::IngestFromBilletto
  def initialize
    @client = BillettoClient.new
  end

  def call(limit: 10)
    response = client.fetch_public_events(limit: limit)

    response["data"].each do |event_data|
      create_or_update_event(event_data)
    end
  end

  private

  attr_reader :client

  def create_or_update_event(data)
    billetto_id = data["id"].to_i
    Event.find_or_initialize_by(billetto_id: billetto_id).tap do |event|
      event.title = data["title"]
      event.description = data["description"]
      event.image_link = data["image_link"]
      event.start_date = data["startdate"]
      event.end_date = data["enddate"]

      event.save!
    end
  end
end
