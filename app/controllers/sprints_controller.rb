# Sprints controller
class SprintsController < ApplicationController
  before_action :set_sprint, only: %i(show edit update destroy)

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

  private

  def set_sprint
    @sprint = Sprint.find(params[:id])
  end

  def permitted_params
    params.require(:sprint).permit(:name, :start_date, :end_date)
  end
end
