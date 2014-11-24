class Legislator

  attr_reader :new_legislator_object

  def initialize(old_legislator_object, required_fields)
    @new_legislator_object = Hash.new
    required_fields.each do |field|
      if old_legislator_object["legislator"][field]
        @new_legislator_object[field] = old_legislator_object["legislator"][field]
      else
        add_missing_fields(field, old_legislator_object)
      end
    end
  end

  def add_missing_fields(field, old_legislator_object)
    if field == "picture_url"
      @new_legislator_object["picture_url"] = "http://theunitedstates.io/images/congress/225x275/" + old_legislator_object["legislator"]["bioguide_id"] + ".jpg"
    elsif field == "ideology_rank"
      name = old_legislator_object["legislator"]["lastname"]
      legislator = JSON.parse(File.read("#{Rails.root}/app/assets/ideology_ratings.json"))["legislators"].select do |legislator|
        legislator["Last_name"] == name
      end
      @new_legislator_object["ideology_rank"] = legislator[0]["ideology_rank"]
    end
  end

end
