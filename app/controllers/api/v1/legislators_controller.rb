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
    required_fields = ["firstname", "lastname", "state", "party", "title", "picture_url", "bioguide_id", "ideology_rank", "influence_rank", "website", "phone", "district", "twitter_id"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title] }
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def funding_timeline
    required_fields = ["firstname", "lastname", "state", "party", "title", "campaign_finance_hash"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title] }
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def elections_timeline
    required_fields = ["firstname", "lastname", "state", "party", "title", "elections_timeline_array"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title] }
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def contributors_by_sector
    required_fields = ["firstname", "lastname", "state", "party", "title", "contributors_by_sector"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def contributors_by_type
    required_fields = ["firstname", "lastname", "state", "party", "title", "contributors_by_type"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def top_contributors
    required_fields = ["firstname", "lastname", "state", "party", "title", "top_contributors"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def funding_score_by_category
    required_fields = ["firstname", "lastname", "state", "party", "title", "funding_score_by_category"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def voting_score_by_category
    required_fields = ["firstname", "lastname", "state", "party", "title", "voting_score_by_category"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  private

  def legislator_params
    params.permit(:address, :lastname, :state, :title, :bioguide_id)
  end

end
