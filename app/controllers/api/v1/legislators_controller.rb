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
    required_fields = ["firstname", "lastname", "state", "party", "title", "picture_url", "bioguide_id", "website", "phone", "district", "twitter_id"]
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

  def most_recent_votes
    required_fields = ["firstname", "lastname", "state", "party", "title", "most_recent_votes"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def contributions_by_industry
    required_fields = ["firstname", "lastname", "state", "party", "title", "contributions_by_industry"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def cached_contributions_by_industry
    required_fields = ["firstname", "lastname", "state", "party", "title", "cached_contributions_by_industry"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end


  def agreement_score_by_industry
    required_fields = ["firstname", "lastname", "state", "party", "title", "agreement_score_by_industry"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def cached_agreement_score_by_industry
    required_fields = ["firstname", "lastname", "state", "party", "title", "cached_agreement_score_by_industry"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def industry_scores
    required_fields = ["industry_scores"]
    identifier = { all: [], industry: legislator_params[:industry] }
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def influence_and_ideology_score
    required_fields = ["firstname", "lastname", "state", "party", "title", "ideology_rank", "influence_rank"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def aggregate_influence_and_ideology_scores
    required_fields = ["aggregate_influence_and_ideology_scores"]
    identifier = { all: [] }
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  # Depricated

  def internal_get_norms
    all_legislators_array = Array.new
    @legislator_db ||= YAML.load_file("#{Rails.root}/app/assets/legislators-current.yaml")
    @legislator_db.each do |leg|
      legislator_hash = Hash.new
      legislator_hash[:last] = leg["name"]["last"]
      legislator_hash[:state] = leg["terms"].last["state"]
      legislator_hash[:title] = leg["terms"].last["type"]
      all_legislators_array.push(legislator_hash)
    end
    old_json = JSON.parse(File.read("/Users/vancefaulkner/Desktop/old_influence_scores.json"))
    new_legislators_array = old_json["legislators"]
    counter = 0
    file_counter = 1
    all_legislators_array.shift(250)
    all_legislators_array.each do |legislator|
      counter += 1
      required_fields = ["firstname", "lastname", "state", "party", "title", "ideology_rank", "influence_rank"]
      identifier = { lastname: legislator[:last], state: legislator[:state], title: legislator[:title]}
      api_response = APIResponse.new(identifier, required_fields).api_response
      legislator_hash = {}
      legislator_hash["firstname"] = api_response["legislators"][0]["firstname"]
      legislator_hash["lastname"] = api_response["legislators"][0]["lastname"]
      legislator_hash["state"] = api_response["legislators"][0]["state"]
      legislator_hash["party"] = api_response["legislators"][0]["party"]
      legislator_hash["title"] = api_response["legislators"][0]["title"]
      legislator_hash["ideology_rank"] = api_response["legislators"][0]["ideology_rank"]
      legislator_hash["influence_rank"] = api_response["legislators"][0]["influence_rank"]
      new_legislators_array.push(legislator_hash)
      if counter % 50 == 0
        mini_wrapper = {"legislators" => new_legislators_array }
        mini_json = mini_wrapper.to_json
        mini_new_file = File.open("/Users/vancefaulkner/Desktop/influence_and_ideology_scores#{file_counter}.json", "w+") { |file| file.write(mini_json) }
        file_counter += 1
      end
    end
    legislator_wrapper = {"legislators" => new_legislators_array }
    json = legislator_wrapper.to_json
    new_file = File.open("/Users/vancefaulkner/Desktop/influence_and_ideology_scores.json", "w+") { |file| file.write(json) }
  end

  private

  def legislator_params
    params.permit(:address, :lastname, :state, :title, :bioguide_id, :industry)
  end

end
