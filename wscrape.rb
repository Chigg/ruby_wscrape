require 'nokogiri'
require 'rss/nokogiri'
require 'date'
require 'csv'

# require 'pry'


print "How many headlines do you want to view (up to 7)? "
response = gets.chomp
while response.to_i <= 0 || response.to_i > 7
  print "Please enter a number from 1 to 7: "
  response = gets.chomp
end

#loop until input is given

#audio cue
print "\a"
#bbc_news
rss = Nokogiri::XML(open('http://newsrss.bbc.co.uk/rss/newsonline_uk_edition/front_page/rss.xml'))
puts "Errors exist" if (rss.errors.any?)

bbc_news = rss.search('item').map { |i|
#use css's namespace wildcard
{
    'text' => i.search('title').text        
    }
}

#wall street journal
rss = Nokogiri::XML(open('http://www.wsj.com/xml/rss/3_7085.xml'))
puts "Errors exist" if (rss.errors.any?)

wsj_news = rss.search('item').map { |i|
    {
        'text' => i.search('title').text
    }
}

#NY Times
rss = Nokogiri::XML(open('http://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml'))
puts "Errors exist" if (rss.errors.any?)

nyt_news = rss.search('item').map {|i|
    {
        'text' => i.search('title').text
    }
}

#Reuters
rss = Nokogiri::XML(open('http://feeds.reuters.com/reuters/topNews'))
puts "Errors exist" if (rss.errors.any?)

reuters_news = rss.search('item').map {|i|
    {
        'text' => i.search('title').text
    }
}

# binding.pry

time = Time.now
puts "Today's date is: " + time.to_s
CSV.open('output.csv', 'a') do |csv|
    puts "\n"
    puts " - - - Source: BBC News - - -"
    x = 0
    while x < response.to_i
        puts (x+1).to_s + ". "+ bbc_news[x]['text']
        csv << bbc_news[x]['text'].split(' ')
        x += 1
    end
    puts "\n"
    puts " - - - Source: Wall Street Journal - - - "
    y = 0
    while y < response.to_i
        puts (y+1).to_s + ". "+ wsj_news[y]['text']
        csv << wsj_news[y]['text'].split(' ')
        y +=1
    end

    puts "\n"
    puts " - - - Source: NY Times - - -"
    z = 0
    while z < response.to_i
        puts (z + 1).to_s + ". " + nyt_news[z]['text']
        csv << nyt_news[z]['text'].split(' ')
        z += 1
    end

    puts "\n"
    puts" - - - Source: Reuters - - -"
    xx = 0
    while xx < response.to_i
        puts (xx + 1).to_s + ". " + reuters_news[xx]['text']
        csv << reuters_news[xx]['text'].split(' ')
        xx += 1
    end
end

