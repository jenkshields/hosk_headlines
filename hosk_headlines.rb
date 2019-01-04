require 'marky_markov'
require 'tempfile'

#take the CSV generated by the scraper and strip any comma not surrounded by whitespace
#also strip quotation marks

def file_edit(filename, regexp, replacement)
  Tempfile.open(".#{File.basename(filename)}", File.dirname(filename)) do |tempfile|
    File.open(filename).each do |line|
      tempfile.puts line.gsub(regexp, replacement)
    end
    tempfile.fdatasync
    tempfile.close
    stat = File.stat(filename)
    FileUtils.chown stat.uid, stat.gid, tempfile.path
    FileUtils.chmod stat.mode, tempfile.path
    FileUtils.mv tempfile.path, filename
  end
end

file_edit('headlines.txt', "\"", '')
file_edit('headlines.txt', /(,(?=\S)|:)/, ' ')
file_edit('headlines.txt', "Hosking", '')

file_edit('blurbs.txt', /(,(?=\S)|:)/, ' ')
file_edit('blurbs.txt', "\"", '')
file_edit('blurbs.txt', 'COMMENT:', '')


#markov logic
headline_markov = MarkyMarkov::TemporaryDictionary.new
headline_markov.parse_file "headlines.txt"
puts "Hosking: #{headline_markov.generate_n_words 10}"
headline_markov.clear!

blurb_markov = MarkyMarkov::TemporaryDictionary.new
blurb_markov.parse_file "blurbs.txt"
puts "COMMENT: #{blurb_markov.generate_n_sentences 2}"
blurb_markov.clear!