class Sunshine < ActiveRecord::Base

  # def self.search(location)
  #   @sunshine_json = get_legislators(location)
  #   Sunshine.create_array(@sunshine_json, "search")
  # end
  #
  # def self.profile(lastname, state, title)
  #   @sunshine_json = Sunshine.get_legislator(lastname, state, title)
  #   # IDEOLOGY HERE
  #   ideology_rating = get_ideology_rating(lastname, state, title) unless @sunshine_json["response"]["legislators"].empty?
  #   Sunshine.create_array(@sunshine_json, "profile")
  # end
  #
  # def self.get_legislators(location)
  #   latitude = location[0]
  #   longitude = location[1]
  #   HTTParty.get('http://services.sunlightlabs.com/api/legislators.allForLatLong.json',
  #               query: {apikey: ENV['SUNLIGHT_KEY'],latitude: latitude, longitude: longitude})
  # end
  #
  # def self.get_legislator(lastname, state, title)
  #   HTTParty.get('http://services.sunlightlabs.com/api/legislators.getList.json',
  #               query: {apikey: ENV['SUNLIGHT_KEY'],lastname: lastname, state: state}, title: title)
  # end
  #
  #
  #
  #
  # def self.get_ideology_rating(lastname, state, title)
  #   json = JSON.parse(File.read("app/assets/ideology_ratings.json"))
  #   @legislature = json["legislatures"].select { |legislature| legislature["State"] == state && legislature["Title"] == title && legislature["Last_name"] == lastname }
  #   @legislature[0]["ideology_rank"]
  # end
  #
  # def self.legislator_entity_id_lookup(bioguide_id)
  #   response = HTTParty.get('http://transparencydata.com/api/1.0/entities/id_lookup.json',
  #                           query: {apikey: ENV['SUNLIGHT_KEY'],bioguide_id: bioguide_id},)
  #   response[0]["id"]
  # end
  #
  # def self.legislator_funding_industries(legislator_entity_id)
  #   HTTParty.get('http://transparencydata.com/api/1.0/aggregates/pol/' + legislator_entity_id + '/contributors/industries.json',
  #               query: {apikey: ENV['SUNLIGHT_KEY']})
  # end
  #
  #
  #
  # def self.create_array_of_objects(sunshine_json, request_type)
  #   legislators = Array.new
  #   # Take object
  #   sunshine_json["response"]["legislators"].each do |legislator|
  #     legislator_hash = Hash.new
  #     legislator_hash["firstname"] = legislator["legislator"]["firstname"]
  #     legislator_hash["lastname"] = legislator["legislator"]["lastname"]
  #     legislator_hash["state"] = legislator["legislator"]["state"]
  #     legislator_hash["party"] = legislator["legislator"]["party"]
  #     legislator_hash["role"] = legislator["legislator"]["title"]
  #     legislator_hash["picture_url"] = "http://theunitedstates.io/images/congress/225x275/" + legislator["legislator"]["bioguide_id"] + ".jpg"
  #     legislator_hash["bioguide_id"] = legislator["legislator"]["bioguide_id"]
  #     if request_type == "profile"
  #       legislator_hash["website"] = legislator["legislator"]["website"]
  #       legislator_hash["middlename"] = legislator["legislator"]["middlename"]
  #       legislator_hash["phone"] = legislator["legislator"]["phone"]
  #       legislator_hash["district"] = legislator["legislator"]["district"]
  #       legislator_hash["twitter_id"] = legislator["legislator"]["twitter_id"]
  #     end
  #     legislators.push(legislator_hash)
  #   end
  #   Sunshine.format_response(legislators)
  # end
  #
  # def self.format_response(create_array_of_objects)
  #   json = Hash.new
  #   json["legislators"] = create_array_of_objects
  #   json
  # end

end
