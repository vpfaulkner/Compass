class API::V1::LegislatorsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include HTTParty

  def search
    @location = Location.get_coordinates(legislator_params[:address])
    if @location.nil?
      render :text => "not a valid address", :status => 404
    else
      @legislators = Sunshine.search(@location)
      render json: @legislators
    end
  end

  def profile
    @profile = Sunshine.profile(legislator_params[:lastname], legislator_params[:state],  legislator_params[:title])
    if @profile["legislators"].empty?
      render :text => "no legislators match this query", :status => 404
    else
      render json:  @profile
    end
  end

  def funding
    @legislator_entity_id = Sunshine.legislator_entity_id_lookup(legislator_params[:bioguide_id])
    @funding_industries = Sunshine.legislator_funding_industries(@legislator_entity_id)
  end

  private

  def legislator_params
    params.permit(:address, :lastname, :state, :title, :bioguide_id)
  end

end
