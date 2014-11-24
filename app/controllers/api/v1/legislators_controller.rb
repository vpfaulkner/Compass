class API::V1::LegislatorsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include HTTParty

  def search
    required_fields = ["firstname", "lastname", "state", "party", "title", "picture_url", "bioguide_id"]
    identifier = { address: legislator_params[:address] }
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def profile
    required_fields = ["firstname", "lastname", "state", "party", "title", "picture_url", "bioguide_id", "ideology_rank", "website", "phone", "district", "twitter_id"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title] }
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  # Refactor completely
  # def funding
  #   @legislator_entity_id = Sunshine.legislator_entity_id_lookup(legislator_params[:bioguide_id])
  #   @funding_industries = Sunshine.legislator_funding_industries(@legislator_entity_id)
  # end

  private

  def legislator_params
    params.permit(:address, :lastname, :state, :title, :bioguide_id)
  end

end
