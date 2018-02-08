# frozen_string_literal: true

# Meetings controller
class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[show edit update destroy]
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  def index
    @active_meetings = smart_listing_create :active_meetings, Meeting.active, partial: 'meetings/listing'
    @finished_meetings = smart_listing_create :finished_meetings, Meeting.finished, partial: 'meetings/listing'
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(permitted_params)
    if @meeting.save
      flash[:success] = 'Meeting was successfully created'
      redirect_to meetings_path
    else
      flash.now[:error] = 'ohhhhhhhh'
      render :new
    end
  end

  def edit; end

  def update
    if @meeting.update_attributes(permitted_params)
      flash[:success] = 'Meeting was successfully updated'
      redirect_to meetings_path
    else
      flash.now[:error] = 'ohhhhhhhh'
      render :new
    end
  end

  def destroy
    if @meeting.destroy
      flash[:success] = 'Meeting was successfully deleted'
    else
      flash[:error] = 'ohhhhhhhh'
    end
    redirect_to meetings_path
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def permitted_params
    params.require(:meeting).permit(
      :name,
      :event_type,
      :description,
      :location,
      :start_date,
      :end_date,
      :sprint_id
    )
  end
end
