require 'json'
old_json = JSON.parse(File.read('/Users/vancefaulkner/Desktop/Code/Compass/app/assets/old_catcodes.json'))
new_json = old_json["catcodes"]
new_json.each do |code_hash|
  old_name = code_hash["Industry"]
  new_name = old_name.gsub(/&/, ' and ').gsub(/,/, ', ').gsub(/\//, ' / ').gsub(/\(/, ' ( ').underscore.humanize.titleize
  position = new_json.index(code_hash)
  new_json[position]["Industry"] = new_name
end
json = {"catcodes" => new_json}.to_json
new_file = File.open("/Users/vancefaulkner/Desktop/out.json", "w+") { |file| file.write(json) }
