class TournamentsController < ApplicationController
  def index
    redirect_to new_user_session_path and return unless user_signed_in?
    redirect_to current_user.tournament and return if current_user.tournament.present?
  end

  def show
    @tournament = Tournament.find(params[:id])
  end

  def new
    authorize Tournament
    @tournament = Tournament.new
  end

  def create
    authorize Tournament
    @tournament = Tournament.new whitelisted_params
    @tournament.user = current_user
    @tournament.save
    redirect_to @tournament
  end

  def edit
    @tournament = Tournament.find(params[:id])
    authorize @tournament
  end

  def update
    @tournament = Tournament.find(params[:id])
    authorize @tournament
    @tournament.assign_attributes whitelisted_params
    @tournament.save
    redirect_to @tournament
  end

  def destroy
    @tournament = Tournament.find(params[:id])
    authorize @tournament
    @tournament.destroy
    redirect_to tournaments_path
  end

  private

  def whitelisted_params
    params.require(:tournament).permit(:label, courts_attributes: [:label, :id, :_destroy])
  end

end
