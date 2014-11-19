class Sunshine < ActiveRecord::Base

  def self.search(location)
    @sunshine_response = Sunshine.get_legislators(location)
    Sunshine.format_json(@sunshine_response, "search")
  end

  def self.profile(sunshine_response)
    Sunshine.format_json(sunshine_response, "profile")
  end

  def self.get_legislators(location)
    latitude = location[0]
    longitude = location[1]
    HTTParty.get('http://services.sunlightlabs.com/api/legislators.allForLatLong.json',
                query: {apikey: ENV['SUNLIGHT_KEY'],latitude: latitude, longitude: longitude},)
  end

  def self.format_json(sunshine_response, request_type)
    legislators = Array.new
    sunshine_response["response"]["legislators"].each do |legislator|
      legislator_hash = Hash.new
      legislator_hash["firstname"] = legislator["legislator"]["firstname"]
      legislator_hash["lastname"] = legislator["legislator"]["lastname"]
      legislator_hash["state"] = legislator["legislator"]["state"]
      legislator_hash["party"] = legislator["legislator"]["party"]
      legislator_hash["role"] = legislator["legislator"]["title"]
      if request_type == "profile"
        legislator_hash["website"] = legislator["legislator"]["website"]
        legislator_hash["middlename"] = legislator["legislator"]["middlename"]
        legislator_hash["phone"] = legislator["legislator"]["phone"]
        legislator_hash["district"] = legislator["legislator"]["district"]
        legislator_hash["twitter_id"] = legislator["legislator"]["twitter_id"]
      end
      legislators.push(legislator_hash)
    end
    json = Hash.new
    json["legislators"] = legislators
    json
  end

end
