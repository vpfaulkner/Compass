class Legislator

  attr_reader :new_legislator_object

  def initialize(legislator_record, required_fields)
    @legislator_record = legislator_record
    @new_legislator_object = Hash.new
    required_fields.each do |field|
      add_field(field) unless @new_legislator_object[field]
    end
  end

  required_fields = ["firstname", "lastname", "state", "party", "title", "picture_url", "bioguide_id", "ideology_rank", "influence_rank", "website", "phone", "district", "twitter_id"]


  def add_field(field)
    if field == "firstname"
      @new_legislator_object[field] = @legislator_record["name"]["first"]
    elsif field == "lastname"
      @new_legislator_object[field] = @legislator_record["name"]["last"]
    elsif field == "state"
      @new_legislator_object[field] = @legislator_record["terms"][0]["state"]
    elsif field == "party"
      @new_legislator_object[field] = @legislator_record["terms"][0]["party"]
    elsif field == "title"
      @new_legislator_object[field] = @legislator_record["terms"][0]["type"]
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
      @new_legislator_object["influence_rank"] = 65
    end
  end

  def add_picture_field
    @new_legislator_object["picture_url"] = "http://theunitedstates.io/images/congress/225x275/" + @legislator_record["id"]["bioguide"] + ".jpg"
  end

  def add_ideology_field
    name = @legislator_record["name"]["last"]
    legislator = JSON.parse(File.read("#{Rails.root}/app/assets/ideology_ratings.json"))["legislators"].select do |legislator|
      legislator["Last_name"] == name
    end
    @new_legislator_object["ideology_rank"] = legislator[0]["ideology_rank"]
  end

  def add_sunshine_profile_fields
    sunshine_profile = HTTParty.get('http://services.sunlightlabs.com/api/legislators.getList.json',
                query: {apikey: ENV['SUNLIGHT_KEY'],bioguide_id: @legislator_record["id"]["bioguide"]})
    @legislator_record.merge!(sunshine_profile["response"]["legislators"][0]["legislator"])
  end

end
