# Sprints controller

require 'English'

class SprintsController < ApplicationController
  before_action :set_sprint, only: %i(show edit update destroy start)

  def index
    @sprints = Sprint.all
    @sprint = Sprint.new
  end

  def create
    @sprint = Sprint.new(permitted_params)
    if @sprint.save
      flash[:success] = 'Sprint was successfully created'
      redirect_to sprints_path
    else
      flash.now[:error] = ['Something happens:', @sprint.errors.full_messages]
      render :new
    end
  end

  def edit; end

  def update
    if @sprint.update_attributes(permitted_params)
      flash[:success] = 'Sprint was successfully updated'
      redirect_to sprints_path
    else
      flash.now[:error] = 'ohhhhhhhh'
      render :edit
    end
  end

  def destroy
    if @sprint.destroy
      flash[:success] = 'Sprint was successfully deleted'
    else
      flash[:error] = 'ohhhhhhhh'
    end
    redirect_to sprints_path
  end

  def start
    # Generate new sprint, paint burndown char and upload it to Trello
    system 'trollolo burndown --new_sprint --plot-to-board --output=trollolo '\
            "--total_days=#{@sprint.days} --weekend_lines=#{@sprint.weekend_lines} --sprint-number=#{@sprint.number}"
    image_name = "trollolo/burndown-#{@sprint.number}.png"
    if $CHILD_STATUS.success? && File.exist?(image_name)
      # TODO: implement this in Trollolo so we don't need to move the file afterwards
      system "mv #{image_name} public/burndown.png"
    else
      file_name = "trollolo/burndown-data-#{@sprint.number}.yaml"
      File.delete(file_name) if File.exist?(file_name)
      flash[:error] = 'Something went wrong, the new sprint was not generated'
      redirect_to action: 'index'
      return
    end

    redirect_to action: 'index'
  end

  private

  def set_sprint
    @sprint = Sprint.find(params[:id] || params[:sprint_id])
  end

  def permitted_params
    params.require(:sprint).permit(:number, :start_date, :end_date)
  end
end
