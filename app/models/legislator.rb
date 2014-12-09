class Legislator

  def self.ideology_json
    @ideology_json ||= File.read("#{Rails.root}/app/assets/ideology_ratings.json")
  end

  def self.catcodes
    @catcodes_json ||= File.read("#{Rails.root}/app/assets/catcodes.json")
  end

  def self.bill_positions
    @bill_positions ||= File.read("#{Rails.root}/app/assets/bill_positions113through111.json")
  end

  def self.bill_positions_index
    @bill_positions_index ||= File.read("#{Rails.root}/app/assets/index_for_bill_positions113through111.json")
  end

  def self.get_influence_and_ideology_json
    @get_influence_and_ideology_json ||= File.read("#{Rails.root}/app/assets/influence_and_ideology_scores_aggregated.json")
  end

  attr_reader :new_legislator_object

  def initialize(legislator_record, required_fields)
    @legislator_record = legislator_record
    @new_legislator_object = Hash.new
    required_fields.each do |field|
      add_field(field) unless @new_legislator_object[field]
    end
  end

  def add_field(field)
    if field == "firstname"
      @new_legislator_object[field] = @legislator_record["name"]["first"]
    elsif field == "lastname"
      @new_legislator_object[field] = @legislator_record["name"]["last"]
    elsif field == "state"
      @new_legislator_object[field] = @legislator_record["terms"].last["state"]
    elsif field == "party"
      @new_legislator_object[field] = @legislator_record["terms"].last["party"]
    elsif field == "title"
      @new_legislator_object[field] = @legislator_record["terms"].last["type"]
    elsif field == "bioguide_id"
      @new_legislator_object[field] = @legislator_record["id"]["bioguide"]
    elsif field == "website"
      add_sunshine_profile_fields unless @legislator_record["website"]
      @new_legislator_object[field] = @legislator_record["website"]
    elsif field == "phone"
      add_sunshine_profile_fields unless @legislator_record["phone"]
      @new_legislator_object[field] = @legislator_record["phone"]
    elsif field == "district"
      add_sunshine_profile_fields unless @legislator_record["district"]
      @new_legislator_object[field] = @legislator_record["district"]
    elsif field == "twitter_id"
      add_sunshine_profile_fields unless @legislator_record["twitter_id"]
      @new_legislator_object[field] = @legislator_record["twitter_id"]
    elsif field == "picture_url"
      @new_legislator_object["picture_url"] = add_picture_field
    elsif field == "elections_timeline_array"
      @new_legislator_object["elections_timeline_array"] = add_elections_timeline_array
    elsif field == "contributors_by_type"
      @new_legislator_object["contributors_by_type"] = add_contributors_by_type
    elsif field == "top_contributors"
      @new_legislator_object["top_contributors"] = add_top_contributors
    elsif field == "most_recent_votes"
      @new_legislator_object["most_recent_votes"] = add_most_recent_votes
    elsif field == "agreement_score_by_industry"
      @new_legislator_object["agreement_score_by_industry"] = add_agreement_score_by_industry
    elsif field == "contributions_by_industry"
      @new_legislator_object["contributions_by_industry"] = add_contributions_by_industry
    elsif field == "ideology_rank"
      @new_legislator_object["ideology_rank"] = add_ideology_field
    elsif field == "influence_rank"
      @new_legislator_object["influence_rank"] = add_influence_rank
    elsif field == "industry_scores"
      add_industry_scores
    elsif field == "aggregate_influence_and_ideology_scores"
      add_aggregate_influence_and_ideology_scores
    end
  end

  def add_sunshine_profile_fields
    sunshine_profile = HTTParty.get('http://services.sunlightlabs.com/api/legislators.getList.json',
    query: {apikey: ENV['SUNLIGHT_KEY'],bioguide_id: @legislator_record["id"]["bioguide"]})
    @legislator_record.merge!(sunshine_profile["response"]["legislators"][0]["legislator"])
    district_number = Integer(@legislator_record["district"]) rescue nil
    if district_number
      district = @legislator_record["district"]
      @legislator_record["district"] = "District #{district}"
    end
  end

  def add_picture_field
    picture_url = "http://theunitedstates.io/images/congress/225x275/" + @legislator_record["id"]["bioguide"] + ".jpg"
  end

  def add_ideology_field
    lastname = @legislator_record["name"]["last"]
    state = @legislator_record["terms"].last["state"]
    legislator = JSON.parse(Legislator.ideology_json)["legislators"].select do |legislator|
      legislator["last"] == lastname && legislator["State"] == state
    end
    return nil unless legislator && legislator[0] && legislator[0]["ideology_rank"]
    ideology_rank = legislator[0]["ideology_rank"]
  end

  def add_elections_timeline_array
    elections_timeline_array = Array.new
    @legislator_record["terms"].each do |term|
      elections_timeline_array.push(term)
    end
    elections_timeline_array
  end

  def add_contributors_by_type
    # Make iterative over multiple cycles
    # Add legislator id to JSON
    legislator_id = HTTParty.get('http://transparencydata.org/api/1.0/entities/id_lookup.json',
                    query: {apikey: ENV['SUNLIGHT_KEY'],bioguide_id: @legislator_record["id"]["bioguide"]})
    type_breakdown = HTTParty.get('http://transparencydata.com/api/1.0/aggregates/pol/' + legislator_id.first["id"] + '/contributors/type_breakdown.json',
                    query: {apikey: ENV['SUNLIGHT_KEY'],cycle: '2014'})
    total_amount = type_breakdown["Individuals"][1].to_i + type_breakdown["PACs"][1].to_i
    type_breakdown["Individuals"] = type_breakdown["Individuals"][1].to_f / total_amount.to_f
    type_breakdown["PACs"] = type_breakdown["PACs"][1].to_f / total_amount.to_f
    type_breakdown
  end

  def add_top_contributors
    legislator_id = HTTParty.get('http://transparencydata.org/api/1.0/entities/id_lookup.json',
                    query: {apikey: ENV['SUNLIGHT_KEY'],bioguide_id: @legislator_record["id"]["bioguide"]})
    top_contributors = HTTParty.get('http://transparencydata.com/api/1.0/aggregates/pol/' + legislator_id.first["id"] + '/contributors.json',
                              query: {apikey: ENV['SUNLIGHT_KEY'],cycle: '2014', limit: 100})
  end

  def find_next_passage_vote(individual_legislator_vote)
    bill_type = individual_legislator_vote["vote"]["question"].split(" ")[0]
    bill_number = individual_legislator_vote["vote"]["question"].split(" ")[1].split(":")[0]
    bill_identifier = bill_type + bill_number
    vote_description = individual_legislator_vote["vote"]["question"]
    date = Date.parse(individual_legislator_vote["created"]).strftime('%Y-%m-%d')
    vote_raw_value = individual_legislator_vote["option"]["value"]
    case vote_raw_value
    when "Yea"
      vote_value = "Yes"
    when "Aye"
      vote_value = "Yes"
    when "Nay"
      vote_value = "No"
    when "No"
      vote_value = "No"
    when "Not Voting"
      vote_value = "Not Voting"
    end
    vote_hash = {date: date, vote_value: vote_value, vote_description: vote_description}
    vote_hash
  end

  def add_most_recent_votes
    most_recent_votes = Array.new
    all_legislator_votes = HTTParty.get('https://www.govtrack.us/api/v2/vote_voter',
                                    query: {person: @legislator_record["id"]["govtrack"],
                                            limit: 1000, order_by: "-created",
                                            format: "json",
                                            fields: "vote__id,created,option__value,vote__category,vote__question"})
    all_legislator_votes["objects"].each do |individual_legislator_vote|
      break if most_recent_votes.count > 100
      next unless individual_legislator_vote["vote"]["category"] == "passage"
      vote_hash = find_next_passage_vote(individual_legislator_vote)
      most_recent_votes.push(vote_hash)
    end
    most_recent_votes
  end
#
  def add_contributions_by_industry
    contributions_by_industry = Hash.new(0)
    total_funding = 0
    funding_transactions = get_funding_transactions
    catcodes_directory = get_code_to_industry_hash
    funding_transactions.each do |transaction|
      next if !transaction || transaction["amount"].empty?
      contribution_amount = transaction["amount"].to_i
      total_funding += contribution_amount.to_i
      catcode = transaction["contributor_category"]
      industry = catcodes_directory[catcode]
      contributions_by_industry[industry] += contribution_amount
    end
    contributions_by_industry
  end

  def get_funding_transactions
    funding_contributions2014 = HTTParty.get('http://transparencydata.org/api/1.0/contributions.json',
        query: {apikey: ENV['SUNLIGHT_KEY'],amount: "%3E%7C1000", cycle: 2014, for_against: "for", recipient_ft: "#{@legislator_record["name"]["first"]} #{@legislator_record["name"]["last"]}"})
    funding_contributions2012 = HTTParty.get('http://transparencydata.org/api/1.0/contributions.json',
        query: {apikey: ENV['SUNLIGHT_KEY'],amount: "%3E%7C1000", cycle: 2012, for_against: "for", recipient_ft: "#{@legislator_record["name"]["first"]} #{@legislator_record["name"]["last"]}"})
    funding_contributions2010 = HTTParty.get('http://transparencydata.org/api/1.0/contributions.json',
        query: {apikey: ENV['SUNLIGHT_KEY'],amount: "%3E%7C1000", cycle: 2010, for_against: "for", recipient_ft: "#{@legislator_record["name"]["first"]} #{@legislator_record["name"]["last"]}"})
    funding_contributions2008 = HTTParty.get('http://transparencydata.org/api/1.0/contributions.json',
        query: {apikey: ENV['SUNLIGHT_KEY'],amount: "%3E%7C1000", cycle: 2008, for_against: "for", recipient_ft: "#{@legislator_record["name"]["first"]} #{@legislator_record["name"]["last"]}"})
    funding_contributions2014.zip(funding_contributions2012, funding_contributions2010, funding_contributions2008).flatten
  end
#
  def add_agreement_score_by_industry
    legislator_votes = get_legislator_votes
    agreement_score_by_industry = get_agreement_score_by_industry(legislator_votes)
  end

  def get_legislator_votes
    legislator_votes = []
    unformatted_legislator_votes = HTTParty.get('https://www.govtrack.us/api/v2/vote_voter',
                                  query: {person: @legislator_record["id"]["govtrack"], limit: 4000, order_by: "-created", format: "json", fields: "vote__id,created,option__value,vote__category,vote__question"})
    unformatted_legislator_votes["objects"].each do |unformatted_legislator_vote|
      next unless unformatted_legislator_vote["vote"]["category"] == "passage"
      bill_type = unformatted_legislator_vote["vote"]["question"].split(" ")[0]
      bill_number = unformatted_legislator_vote["vote"]["question"].split(" ")[1].split(":")[0]
      bill_identifier = bill_type + bill_number
      bill = {identifier: bill_identifier, vote: unformatted_legislator_vote["option"]["value"]}
      legislator_votes.push(bill)
    end
    legislator_votes
  end

  def get_code_to_industry_hash
    json = JSON.parse(Legislator.catcodes)["catcodes"]
    code_to_industry_hash = Hash.new
    json.each do |c|
      code_to_industry_hash[c["Catcode"]] = c["Industry"]
    end
    code_to_industry_hash
  end

  def get_agreement_score_by_industry(legislator_votes)
    voting_agreements_with_industry = Hash.new
    raw_agreements_per_industry = Hash.new(0)
    agreement_opportunities_per_industry = Hash.new(0)
    catcodes_directory = get_code_to_industry_hash
    bills_and_org_positions = JSON.parse(Legislator.bill_positions)["bills"]
    bill_positions_index = JSON.parse(Legislator.bill_positions_index)
    legislator_votes.each do |bill|
      if bill[:vote] == "Yea" || bill[:vote] == "Aye" || bill[:vote] == "Yes"
        legislator_vote = "Yes"
      else
        legislator_vote = "No"
      end
      index = bill_positions_index[bill[:identifier]]
      next unless index
      org_positions_on_bill = bills_and_org_positions[index]
      next unless org_positions_on_bill
      org_positions_on_bill = org_positions_on_bill["organizations"]
      org_positions_on_bill.each do |org_position|
        catcode = org_position["catcode"]
        next if catcode.empty?
        industry = catcodes_directory[catcode]
        if org_position["disposition"] == "support"
          org_vote = "Yes"
        else
          org_vote = "No"
        end
        raw_agreements_per_industry[industry] += 1 if org_vote == legislator_vote
        raw_agreements_per_industry[industry] -= 1 if org_vote != legislator_vote
        agreement_opportunities_per_industry[industry] += 1
      end
    end
    raw_agreements_per_industry.each do |industry_name, industry_raw_agreements|
      if agreement_opportunities_per_industry[industry_name] > 5
        proportion = industry_raw_agreements.to_f / agreement_opportunities_per_industry[industry_name].to_f
        voting_agreements_with_industry[industry_name] = proportion
      end
    end
    voting_agreements_with_industry
  end
#
  def add_influence_rank
    agreement_score_by_industry = add_agreement_score_by_industry
    contributions_by_industry = add_contributions_by_industry
    influence_score = 0
    total_funding = contributions_by_industry.inject(0) { |t, (i, c)| t += c if c.is_a? Numeric }
    agreement_score_by_industry.each do |industry, agreement_score|
      next if agreement_score < 0
      next unless contributions_by_industry[industry]
      influence_score += (contributions_by_industry[industry] * agreement_score) / total_funding
    end
    influence_score
  end
#
  def add_industry_scores
    json = JSON.parse(File.read("#{Rails.root}/app/assets/industry_scores_aggregated.json"))
    industry = @legislator_record[:industry]
    @new_legislator_object["industry_scores"] = json["industries"][industry]
  end

  def add_aggregate_influence_and_ideology_scores
    json = JSON.parse(Legislator.get_influence_and_ideology_json)
    @new_legislator_object["aggregate_influence_and_ideology_scores"] = json["legislators"]
  end

end
