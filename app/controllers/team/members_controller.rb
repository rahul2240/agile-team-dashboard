module Team
  class MembersController < ApplicationController
    before_action :set_member, only: %i(show edit update destroy)

    def index
      @members = User.all
    end

    def new
      @member = User.new
    end

    def create
      @member = User.new(permitted_params)
      if @member.save
        flash[:success] = 'User was successfully created'
        redirect_to team_members_path
      else
        flash.now[:error] = @member.errors.full_messages.to_sentence
        render :new
      end
    end

    def show
      @absences = @member.absences
    end

    def edit; end

    def update
      if permitted_params[:password].blank? && permitted_params[:password_confirmation].blank?
        if @member.update_without_password(permitted_params)
          flash[:success] = 'User was successfully updated'
          redirect_to team_members_path
        else
          flash.now[:error] = @member.errors.full_messages.to_sentence
          render :new
        end
      elsif @member.update_attributes(permitted_params)
        sign_in @member, bypass: true
        flash[:success] = 'Account was successfully updated'
        redirect_to team_members_path
      else
        flash.now[:error] = @member.errors.full_messages.to_sentence
        render :new
      end
    end

    def destroy
      if @member.destroy
        flash[:success] = 'User was successfully Destroyed'
      else
        flash[:error] = @member.errors.full_messages.to_sentence
      end
      redirect_to team_members_path
    end

    private

    def set_member
      @member = User.find(params[:id])
    end

    def permitted_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :name,
        :surname,
        :birthday,
        :github_login,
        :location
      )
    end
  end
end
