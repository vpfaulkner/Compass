class Legislator

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
      add_picture_field
    elsif field == "ideology_rank"
      add_ideology_field
    elsif field == "influence_rank"
      # FIX LATER
      @new_legislator_object["influence_rank"] = 65
    elsif field == "campaign_finance_hash"
      add_campaign_finance_hash
    elsif field == "elections_timeline_array"
      add_elections_timeline_array
    elsif field == "contributors_by_sector"
      add_contributors_by_sector
    elsif field == "contributors_by_type"
      add_contributors_by_type
    elsif field == "top_contributors"
      add_top_contributors
    elsif field == "funding_score_by_category"
      add_funding_score_by_category
    elsif field == "voting_score_by_issue"
      add_voting_score_by_issue
    elsif field == "most_recent_votes"
      add_most_recent_votes
    elsif field == "issue_ratings_dummy"
      add_issue_ratings_dummy
    elsif field == "legislator_issue_scores"
      add_legislator_issue_scores
    end
  end


  def add_picture_field
    @new_legislator_object["picture_url"] = "http://theunitedstates.io/images/congress/225x275/" + @legislator_record["id"]["bioguide"] + ".jpg"
  end


  def add_ideology_field
    lastname = @legislator_record["name"]["last"]
    state = @legislator_record["terms"].last["state"]
    legislator = JSON.parse(File.read("#{Rails.root}/app/assets/new_ideology_ratings.json"))["legislators"].select do |legislator|
      legislator["last"] == lastname && legislator["State"] == state
    end
    @new_legislator_object["ideology_rank"] = legislator[0]["ideology_rank"]
  end


  def add_sunshine_profile_fields
    sunshine_profile = HTTParty.get('http://services.sunlightlabs.com/api/legislators.getList.json',
                query: {apikey: ENV['SUNLIGHT_KEY'],bioguide_id: @legislator_record["id"]["bioguide"]})
    @legislator_record.merge!(sunshine_profile["response"]["legislators"][0]["legislator"])
  end


  def add_elections_timeline_array
    elections_timeline_array = Array.new
    @legislator_record["terms"].each do |term|
      elections_timeline_array.push(term)
    end
    @new_legislator_object["elections_timeline_array"] = elections_timeline_array
  end


  def add_contributors_by_sector
    # Make iterative over multiple cycles
    # Add legislator id to JSON
    legislator_id = HTTParty.get('http://transparencydata.org/api/1.0/entities/id_lookup.json',
                    query: {apikey: ENV['SUNLIGHT_KEY'],bioguide_id: @legislator_record["id"]["bioguide"]})
    sunshine_sector_breakdown = HTTParty.get('http://transparencydata.com/api/1.0/aggregates/pol/' + legislator_id.first["id"] + '/contributors/sectors.json',
                    query: {apikey: ENV['SUNLIGHT_KEY'],cycle: '2012'})
    sector_key = {"A" => "Agribusiness",
                  "B" => "Communications/Electronics",
                  "C" => "Construction",
                  "D" => "Defense",
                  "E" => "Energy/Natural Resources",
                  "F" => "Finance/Insurance/Real Estate",
                  "H" => "Health",
                  "K" => "Lawyers and Lobbyists",
                  "M" => "Transportation",
                  "N" => "Misc. Business",
                  "Q" => "Ideology/Single Issue",
                  "P" => "Labor",
                  "W" => "Other",
                  "Y" => "Unknown",
                  "Z" => "Administrative Use" }
    sunshine_sector_breakdown.each { |hash|
      hash["sector"] = sector_key[hash["sector"]]
    }
    @new_legislator_object["contributors_by_sector"] = sunshine_sector_breakdown
  end


  def add_contributors_by_type
    # Make iterative over multiple cycles
    # Add legislator id to JSON
    legislator_id = HTTParty.get('http://transparencydata.org/api/1.0/entities/id_lookup.json',
                    query: {apikey: ENV['SUNLIGHT_KEY'],bioguide_id: @legislator_record["id"]["bioguide"]})
    sunshine_type_breakdown = HTTParty.get('http://transparencydata.com/api/1.0/aggregates/pol/' + legislator_id.first["id"] + '/contributors/type_breakdown.json',
                    query: {apikey: ENV['SUNLIGHT_KEY'],cycle: '2014'})

    @new_legislator_object["contributors_by_type"] = sunshine_type_breakdown
  end


  def add_top_contributors
    legislator_id = HTTParty.get('http://transparencydata.org/api/1.0/entities/id_lookup.json',
                    query: {apikey: ENV['SUNLIGHT_KEY'],bioguide_id: @legislator_record["id"]["bioguide"]})
    sunshine_type_breakdown = HTTParty.get('http://transparencydata.com/api/1.0/aggregates/pol/' + legislator_id.first["id"] + '/contributors.json',
                              query: {apikey: ENV['SUNLIGHT_KEY'],cycle: '2014', limit: 100})
    @new_legislator_object["top_contributors"] = sunshine_type_breakdown
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
    @new_legislator_object["most_recent_votes"] = most_recent_votes
  end

  def add_issue_ratings_dummy
    issue_ratings = Array.new
    voting_json = JSON.parse(File.read("#{Rails.root}/app/assets/aggregated_legislator_voting_scores.json"))
    aggregated_voting_scores_by_legislator = voting_json["legislators"]
    aggregated_voting_scores_by_issue = get_aggregated_voting_scores_by_issue(aggregated_voting_scores_by_legislator)
    legislator_voting_record = get_individual_voting_record(aggregated_voting_scores_by_legislator)
    return unless legislator_voting_record
    issue_ratings = get_agreement_score_for_issue_ratings(legislator_voting_record, aggregated_voting_scores_by_issue, issue_ratings)
    individual_funding_contributions = get_individual_funding_contributions
    total_funding = 0
    individual_funding_contributions.each do |funding_hash|
      contributor_code = funding_hash["contributor_category"]
      amount = funding_hash["amount"]
      next if amount.empty?
      total_funding += amount.to_i
      issue_index = get_issue_index(contributor_code, issue_ratings)
      next unless issue_index
      issue_ratings[issue_index]["funding_score"] += amount.to_i
    end
    issue_ratings = convert_issue_funding_scores_to_percentages(issue_ratings, total_funding)
    @new_legislator_object["issue_ratings_dummy"] = issue_ratings
  end

  def find_next_passage_vote(individual_legislator_vote)
    bill_type = individual_legislator_vote["vote"]["question"].split(" ")[0]
    bill_number = individual_legislator_vote["vote"]["question"].split(" ")[1].split(":")[0]
    bill_identifier = bill_type + bill_number
    vote_description = individual_legislator_vote["vote"]["question"]
    date = Date.parse(individual_legislator_vote["created"]).strftime('%Y-%m-%d')
    vote_value = individual_legislator_vote["option"]["value"]
    vote_hash = {date: date, vote_value: vote_value, vote_description: vote_description}
    vote_hash
  end

  def get_aggregated_voting_scores_by_issue(aggregated_voting_scores_by_legislator)
    aggregated_voting_scores_by_issue = { "Pro-Life" => {aggregate_score: 0, total_legislators: 0, scores_array: []},
                                        "Pro-Choice" => {aggregate_score: 0, total_legislators: 0, scores_array: []},
                                        "Pro-Gun" => {aggregate_score: 0, total_legislators: 0, scores_array: []},
                                        "Anti-Gun" => {aggregate_score: 0, total_legislators: 0, scores_array: []},
                                        "Environment" => {aggregate_score: 0, total_legislators: 0, scores_array: []},
                                        "Oil and Energy" => {aggregate_score: 0, total_legislators: 0, scores_array: []},
                                        "Labor and Union" => {aggregate_score: 0, total_legislators: 0, scores_array: []},
                                        "Education" => {aggregate_score: 0, total_legislators: 0, scores_array: []},
                                        "Financial" => {aggregate_score: 0, total_legislators: 0, scores_array: []} }
      aggregated_voting_scores_by_legislator.each do |legislator_voting_score|
        legislator_voting_score["voting_score_by_issue"].each do |issue|
        issue_name = issue[0]
        issue_score = issue[1]
        aggregated_voting_scores_by_issue[issue_name][:aggregate_score] += issue_score
        aggregated_voting_scores_by_issue[issue_name][:total_legislators] += 1
        aggregated_voting_scores_by_issue[issue_name][:scores_array].push(issue_score)
        aggregated_voting_scores_by_issue[issue_name][:scores_array].sort!
      end
    end
    aggregated_voting_scores_by_issue
  end

  def get_individual_voting_record(aggregated_voting_scores_by_legislator)
    legislator = aggregated_voting_scores_by_legislator.select do |legislator_voting_scores|
      legislator_voting_scores["firstname"] == @legislator_record["name"]["first"] && legislator_voting_scores["lastname"] == @legislator_record["name"]["last"] && legislator_voting_scores["state"] == @legislator_record["terms"].last["state"]
    end
    return unless legislator
    return unless legislator[0]
    return unless legislator[0]["voting_score_by_issue"]
    legislator_voting_record = legislator[0]["voting_score_by_issue"]
  end

  def get_agreement_score_for_issue_ratings(legislator_voting_record, aggregated_voting_scores_by_issue, issue_ratings)
    legislator_voting_record.each do |issue|
      issue_score = issue[1]
      issue_name = issue[0]
      scores_below = 0
      aggregated_voting_scores_by_issue[issue_name][:scores_array].each {|score| scores_below += 1 if score < issue_score }
      scores_equal = 0
      aggregated_voting_scores_by_issue[issue_name][:scores_array].each {|score| scores_equal += 1 if score == issue_score }
      number_of_scores = aggregated_voting_scores_by_issue[issue_name][:scores_array].length
      normalized_score = ((scores_below.to_f + (0.5 * scores_equal.to_f)) / number_of_scores.to_f) * 100
      issue_object = {"issue_name" => issue_name, "funding_score" => 0 , "agreement_score" => normalized_score.round}
      issue_ratings.push(issue_object)
    end
    issue_ratings
  end

  def get_individual_funding_contributions
    individual_funding_contributions = HTTParty.get('http://transparencydata.org/api/1.0/contributions.json',
                    query: {apikey: ENV['SUNLIGHT_KEY'],recipient_ft: "#{@legislator_record["name"]["first"]} #{@legislator_record["name"]["last"]}"})
  end

  def get_issue_index(contributor_code, issue_ratings)
    case contributor_code
    when "J7120"
      issue_index = issue_ratings.index { |i| i["issue_name"] == "Pro-Life" }
    when "J7150"
      issue_index = issue_ratings.index { |i| i["issue_name"] == "Pro-Choice" }
    when "J6200"
      issue_index = issue_ratings.index { |i| i["issue_name"] == "Pro-Gun" }
    when "J6100"
      issue_index = issue_ratings.index { |i| i["issue_name"] == "Anti-Gun" }
    when "JE300"
      issue_index = issue_ratings.index { |i| i["issue_name"] == "Environment" }
    when /E11\d0/
      issue_index = issue_ratings.index { |i| i["issue_name"] == "Oil and Energy" }
    when /L..../
      issue_index = issue_ratings.index { |i| i["issue_name"] == "Labor and Union" }
    when /H5\d\d/
      issue_index = issue_ratings.index { |i| i["issue_name"] == "Education" }
    when /F1\d\d\d|F2\d\d\d/
      issue_index = issue_ratings.index { |i| i["issue_name"] == "Financial" }
    end
    issue_index
  end

  def convert_issue_funding_scores_to_percentages(issue_ratings, total_funding)
    issue_ratings.each do |issue|
      prevous_score = issue["funding_score"]
      decimal_percent = prevous_score.to_f / total_funding.to_f
      issue["funding_score"] = (decimal_percent * 100).round(2)
    end
    issue_ratings
  end



  def add_legislator_issue_scores
    json = JSON.parse(File.read("#{Rails.root}/app/assets/combined_funding_scores.json"))
    combined_scores_json = json["legislators"]
    chosen_issue = @legislator_record[:issue]
    legislator_issue_ratings = Array.new
    combined_scores_json.each do |record|
      issue_hash = Hash.new
      issue_hash["firstname"] = record["firstname"]
      issue_hash["lastname"] = record["lastname"]
      issue_hash["state"] = record["state"]
      issue_hash["party"] = record["party"]
      issue_hash["title"] = record["title"]
      next unless record["issue_ratings_dummy"]
      issue_match = record["issue_ratings_dummy"].select do |available_issues|
        available_issues["issue_name"] == chosen_issue
      end
      issue_hash["issue_ratings_dummy"] = issue_match
      legislator_issue_ratings.push(issue_hash)
    end
    @new_legislator_object["legislator_issue_scores"] = legislator_issue_ratings
  end







  def add_voting_score_by_issue
    voting_score_by_issue = Hash.new(0)
    legislator_votes = get_legislator_votes
    voting_agreements_with_catcodes = get_voting_agreements_with_catcodes(legislator_votes)
    catcodes_directory = JSON.parse(File.read("#{Rails.root}/app/assets/catcodes.json"))["catcodes"]
    voting_agreements_with_catcodes.each do |voting_agreements_with_catcode|
      code = voting_agreements_with_catcode[0]
      score = voting_agreements_with_catcode[1]
      voting_score_by_issue["Pro-Life"] += score if code == "J7120"
      voting_score_by_issue["Pro-Choice"] += score if code == "J7150"
      voting_score_by_issue["Pro-Gun"] += score if code == "J6200"
      voting_score_by_issue["Anti-Gun"] += score if code == "J6100"
      voting_score_by_issue["Environment"] += score if code == "JE300"
      voting_score_by_issue["Oil and Energy"] += score if /E11\d0/.match(code)
      voting_score_by_issue["Labor and Union"] += score if /L..../.match(code)
      voting_score_by_issue["Education"] += score if /H5\d\d/.match(code)
      voting_score_by_issue["Financial"] += score if /F1\d\d\d|F2\d\d\d/.match(code)
    end
    @new_legislator_object["voting_score_by_issue"] = voting_score_by_issue
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

  def get_voting_agreements_with_catcodes(legislator_votes)
    voting_agreements_with_catcodes = Hash.new
    bills_and_org_positions = JSON.parse(File.read("#{Rails.root}/app/assets/113_bills_compressed.json"))["bills"]
    legislator_votes.each do |bill|
      if bill[:vote] == "Yea" || bill[:vote] == "Aye" || bill[:vote] == "Yes"
        legislator_vote = "Yes"
      else
        legislator_vote = "No"
      end
      org_positions_on_bill = bills_and_org_positions.select do |bill_and_org_position|
        bill_and_org_position["identifier"] == bill[:identifier]
      end
      next unless org_positions_on_bill.first
      org_positions_on_bill = org_positions_on_bill.first["organizations"]
      org_positions_on_bill.each do |org_position|
        catcode = org_position["catcode"]
        next if catcode.empty?
        if org_position["disposition"] == "support"
          org_vote = "Yes"
        else
          org_vote = "No"
        end
        if voting_agreements_with_catcodes[catcode]
          voting_agreements_with_catcodes[catcode] += 1 if org_vote == legislator_vote
          voting_agreements_with_catcodes[catcode] -= 1 if org_vote != legislator_vote
        else
          voting_agreements_with_catcodes[catcode] = 1 if org_vote == legislator_vote
          voting_agreements_with_catcodes[catcode] = -1 if org_vote != legislator_vote
        end
      end
    end
    voting_agreements_with_catcodes
  end


  # DEPRECATED


  def get_bills
    bills = []
    bills_and_legislator_votes = HTTParty.get('https://www.govtrack.us/api/v2/vote_voter',
    query: {person: @legislator_record["id"]["govtrack"], limit: 4000, order_by: "-created", format: "json", fields: "vote__id,created,option__value,vote__category,vote__question"})
    bills_and_legislator_votes["objects"].each do |bill_and_legislator_vote|
      next unless bill_and_legislator_vote["vote"]["category"] == "passage"
      bill_type = bill_and_legislator_vote["vote"]["question"].split(" ")[0]
      bill_number = bill_and_legislator_vote["vote"]["question"].split(" ")[1].split(":")[0]
      bill_identifier = bill_type + bill_number
      bill = {identifier: bill_identifier, vote: bill_and_legislator_vote["option"]["value"]}
      bills.push(bill)
    end
    bills
  end

  def add_campaign_finance_hash

    campaign_finance_hash = Hash.new
    years_run_for_office = Array.new
    years_with_data = [2000, 2002, 2004, 2006, 2008, 2010, 2012, 2014]
    @legislator_record["terms"].each { |term| years_run_for_office.push(term["start"].to_date.year - 1) }
    @legislator_record["id"]["fec"].each do |fec|
      years_with_data.each do |year|
        # FIGURE OUT HOW TO REDUCE THESE CALLS
        ny_times_finance_record = Candidate.find(fec, year) rescue nil
        next unless ny_times_finance_record
        campaign_finance_hash[year] ? campaign_finance_hash[year] += \
        ny_times_finance_record.total_contributions : campaign_finance_hash[year] \
        = ny_times_finance_record.total_contributions
      end
    end
    @new_legislator_object["campaign_finance_hash"] = campaign_finance_hash
  end

end
