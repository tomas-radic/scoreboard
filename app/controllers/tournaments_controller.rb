class TournamentsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :refresh_score]
  before_action :load_tournament, only: [:show, :edit, :update, :destroy, :refresh_score]

  def index
    redirect_to new_user_session_path and return unless user_signed_in?
    redirect_to current_user.tournament and return if current_user.tournament.present?
  end

  def show
    redirect_to root_url if @tournament.nil? && user_signed_in?
  end

  def new
    authorize Tournament
    @tournament = Tournament.new(
      courts: [
        Court.new(label: '1'),
        Court.new(label: '2'),
        Court.new(label: '3')
      ]
    )
  end

  def create
    authorize Tournament
    @tournament = Tournament.new whitelisted_params
    @tournament.user = current_user
    @tournament.save
    redirect_to @tournament
  end

  def edit
    authorize @tournament
  end

  def update
    authorize @tournament
    @tournament.assign_attributes whitelisted_params
    @tournament.save
    redirect_to @tournament
  end

  def destroy
    authorize @tournament
    @tournament.destroy
    redirect_to tournaments_path
  end

  def refresh_score
    respond_to do |format|
      format.js
    end
  end


  private

  def load_tournament
    @tournament = Tournament.find_by(id: params[:id])
  end

  def whitelisted_params
    params.require(:tournament).permit(
      :label, :public_score_update, courts_attributes: [:label, :id, :_destroy]
    )
  end
end
