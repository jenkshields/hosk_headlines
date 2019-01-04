require 'HTTParty'
require 'Nokogiri'
require 'Pry'
require 'csv'

page = HTTParty.get('https://www.nzherald.co.nz/author/mike-hosking/')

parse_page = Nokogiri::HTML(page)

blurb_array = []
headline_array = []

parse_page.css('.blurb').map do |a|
  blurb_content = a.text
  blurb_array.push(blurb_content)
end

parse_page.css('h3').css('a').map do |a|
  headline_name = a.text
  headline_array.push(headline_name)
end

CSV.open('blurbs.txt', 'w') do |csv|
  csv << blurb_array
end

CSV.open('headlines.txt', 'w') do |csv|
  csv << headline_array
end