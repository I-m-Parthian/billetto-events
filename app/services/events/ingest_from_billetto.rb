class Events::IngestFromBilletto
  def initialize(client: BillettoClient.new)
    @client = client
  end

  def call(limit: 10)
    response = client.fetch_public_events(limit: limit)

    events = response["data"]

    unless events.is_a?(Array)
      Rails.logger.error("Billetto API returned unexpected response: #{response.inspect}")
      return
    end

    events.each do |event_data|
      process_event(event_data)
    end
  rescue StandardError => e
    Rails.logger.error("Billetto ingestion failed: #{e.message}")
    Rails.logger.error(e.backtrace.join("\n"))
  end

  private

  attr_reader :client

  def process_event(event_data)
    create_or_update_event(event_data)
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.warn("Skipping invalid event #{event_data["id"]}: #{e.message}")
  rescue StandardError => e
    Rails.logger.error("Error processing event #{event_data["id"]}: #{e.message}")
  end

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
