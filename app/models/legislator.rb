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

  def add_campaign_finance_hash
    # Deprecated
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

end
