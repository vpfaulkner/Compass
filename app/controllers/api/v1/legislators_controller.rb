class API::V1::LegislatorsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include HTTParty

  def search
    required_fields = ["firstname", "lastname", "state", "party", "role", "picture_url", "bioguide_id"]
    identifier = { address: legislator_params[:address] }
    render json: APIResponse.new(identifier, required_fields)
  end

  def profile
    required_fields = ["firstname", "lastname", "state", "party", "role", "picture_url", "role", "website", "middlename", "phone", "district", "twitter_id"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title] }
    @response = Response.new(identifier, required_fields)
    render @response

    # OLD
    # @profile = Sunshine.profile(legislator_params[:lastname], legislator_params[:state],  legislator_params[:title])
    # if @profile["legislators"].empty?
    #   render :text => "no legislators match this query", :status => 404
    # else
    #   render json:  @profile
    # end
  end

  # Refactor completely
  def funding
    @legislator_entity_id = Sunshine.legislator_entity_id_lookup(legislator_params[:bioguide_id])
    @funding_industries = Sunshine.legislator_funding_industries(@legislator_entity_id)
  end

  private

  def legislator_params
    params.permit(:address, :lastname, :state, :title, :bioguide_id)
  end

end
