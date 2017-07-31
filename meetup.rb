require 'httparty'
require 'fileutils'
require 'colorize'
require 'dotenv'

# .env
Dotenv.load
meetup_api_key = ENV["MEETUP_API_KEY"]

meetup_group_url = "ny-tech"
# meetup_group_url = "RubyFTW-Fort-Worth-Ruby-User-Group"
base_uri = "https://api.meetup.com/2/events?key=#{meetup_api_key}&group_urlname=#{meetup_group_url}&sign=true"
response = HTTParty.get(base_uri)
body = JSON.parse(response.body)

mu = body["results"][0]

@file_name_date = Time.at(mu["time"]/1000).strftime("%Y-%m-%d")
@title = mu["name"]
@description = mu["description"]
@long_date = Time.at(mu["time"]/1000).strftime("%B %d, %Y")
@link = mu["event_url"]
@time = Time.at(mu["time"]/1000).strftime("%I:%M%P")
@location = mu["venue"]["name"]
@location_url = "https://www.google.com/maps/search/#{@location}"
@rsvp_url = mu["event_url"]

@directory = "_upcoming_events"
@archived_directory = "_archived_events"
@directory_file_count = Dir[File.join(@directory, '**', '*')].count { |file| File.file?(file) }
@yes_or_no = "[Y]".green + "Yes" + " [N]".red + "No"

def validate_to_archive
  answer_to_archive = gets.chomp
  if answer_to_archive === "Y" || answer_to_archive === "y"
    puts "Moving files...".light_blue
    FileUtils.mv Dir.glob("#{@directory}/*"), @archived_directory
    puts "File(s) moved".green + ". Do you want to create a new post?\n" + @yes_or_no
    validate_to_create_new_post
  elsif answer_to_archive === "N" || answer_to_archive === "n"
    puts "No files were archived.".light_blue + " Do you want to create a new post?\n" + @yes_or_no
    validate_to_create_new_post
  else
    puts "Wrong input... Make sure to type 'Y' or 'N'  😎".red
  end
end
def validate_to_create_new_post
  answer_to_new_post = gets.chomp
  if answer_to_new_post === "Y" || answer_to_new_post === "y"
    create_post
  elsif answer_to_new_post === "N" || answer_to_new_post === "n"
    puts "No files were created.".red
  else
    puts "Wrong input... Make sure to type 'Y' or 'N'  😎".red
  end
end

def create_post
  content = "---\nlayout: post\ntitle: #{@title}\nlong_date: #{@long_date}\nlink: #{@link}\ntime: #{@time}\nlocation: #{@location}\nlocation_url: #{@location_url}\nrsvp_url: #{@rsvp_url}\n---\n#{@description}"
  new_event = File.new("#{Dir.pwd}/#{@directory}/#{@file_name_date}-#{@title.downcase!.gsub! /\s+/, '-'}.md", "w")
  new_event.write(content)
  new_event.close
  puts "#{@file_name_date}-#{@title}.md created".green
end

if @directory_file_count >= 1
  puts "\n#{@directory_file_count} file(s)".yellow + " in " + "#{@directory}".yellow + " directory.\n" + "Do you want to move them to " + "/#{@archived_directory}".yellow + "?\n" + @yes_or_no
  validate_to_archive
else
  puts "You have no files to archive.".light_blue + " Do you want to create a new post?\n" + @yes_or_no
  validate_to_create_new_post
end
