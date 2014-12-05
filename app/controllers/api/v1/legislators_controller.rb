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

  def most_recent_votes
    required_fields = ["firstname", "lastname", "state", "party", "title", "most_recent_votes"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def issue_ratings_dummy
    required_fields = ["firstname", "lastname", "state", "party", "title", "issue_ratings_dummy"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def legislator_issue_scores
    required_fields = ["legislator_issue_scores"]
    identifier = { all: [], issue: legislator_params[:issue] }
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end





  # Now part of issue_ratings above

  def funding_score_by_category
    required_fields = ["firstname", "lastname", "state", "party", "title", "funding_score_by_category"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

  def voting_score_by_issue
    required_fields = ["firstname", "lastname", "state", "party", "title", "voting_score_by_issue"]
    identifier = { lastname: legislator_params[:lastname], state: legislator_params[:state], title: legislator_params[:title]}
    @api_response = APIResponse.new(identifier, required_fields).api_response
    render json: @api_response
  end

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
    # issue_score_stats = { "Pro-Life" => {aggregate_score: 0, total_legislators: 0},
    #                       "Pro-Choice" => {aggregate_score: 0, total_legislators: 0},
    #                       "Pro-Gun" => {aggregate_score: 0, total_legislators: 0},
    #                       "Anti-Gun" => {aggregate_score: 0, total_legislators: 0},
    #                       "Environment" => {aggregate_score: 0, total_legislators: 0},
    #                       "Oil & Energy" => {aggregate_score: 0, total_legislators: 0},
    #                       "Labor & Union" => {aggregate_score: 0, total_legislators: 0},
    #                       "Education" => {aggregate_score: 0, total_legislators: 0},
    #                       "Financial" => {aggregate_score: 0, total_legislators: 0} }
    array_wrapper = []
    counter = 0
    file_counter = 1
    all_legislators_array.each do |legislator|
      counter += 1
      required_fields = ["firstname", "lastname", "state", "party", "title", "issue_ratings_dummy"]
      identifier = { lastname: legislator[:last], state: legislator[:state], title: legislator[:title]}
      api_response = APIResponse.new(identifier, required_fields).api_response
      array_wrapper.push(api_response["legislators"][0])
      if counter % 50 == 0
        json = array_wrapper.to_json
        new_file = File.open("/Users/vancefaulkner/Desktop/funding_score#{file_counter}.txt", "w+") { |file| file.write(json) }
        file_counter += 1
        array_wrapper = []
      end
      # @api_response["legislators"].first["voting_score_by_issue"].each do |issue|
      #   issue_name = issue[0]
      #   issue_score = issue[1]
      #   issue_score_stats[issue_name][:aggregate_score] += issue_score
      #   issue_score_stats[issue_name][:total_legislators] += 1
      # end
    end

  end

  private

  def legislator_params
    params.permit(:address, :lastname, :state, :title, :bioguide_id, :issue)
  end

end
