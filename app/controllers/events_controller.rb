class EventsController < ApplicationController
  before_action :set_event, only: [:show]

  def index
    @events = Event.order(start_date: :asc)
  end

  def show
  end

  def fetch
    Events::IngestFromBilletto.new.call
    redirect_to events_path, notice: "Events fetched successfully"
  end

  private

  def set_event
    @event = Event.find_by!(id: params[:id])
  end
end
