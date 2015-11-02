#program for getting HTML of a Twitter account, it extracts relevant information 
#and deploys on the console.

#it requires 'Net::HTTP' and 'Nokogiri::HTML'
require 'net/http'
require 'nokogiri'

#scrapper twitter class
class TwitterScrapper
  
  #method to initialize class
  def initialize(url)
    @uri = URI(url)
    res = Net::HTTP.get(@uri)
    @doc = Nokogiri::HTML(res)
  end
  
  #it displays data of twitter
  def fetch!
    puts "Username: #{extract_username}"
    puts "------------------------------------------------"
    puts "Stats: Tweets: #{extract_stats[0]}, Siguiendo: #{extract_stats[1]}, Seguidores: #{extract_stats[2]}, Favoritos: #{extract_stats[3]}"
    puts "------------------------------------------------"
    puts "Tweets:"
    puts "    #{extract_tweets}"
  end

  #username is gotten
  def extract_username
    user_name = @doc.search(".ProfileHeaderCard-name > a")
    user_name.first.inner_text
  end

  #tweets are gotten
  def extract_tweets
    user_tweets_content = @doc.search(".tweet")
    user_tweets_content.pop
    user_tweets_content.map do |tweet|

      time = tweet.css(".content .tweet-timestamp ._timestamp").inner_text
      text = tweet.css(".content .tweet-text").inner_text
      retweets = tweet.css(".content .ProfileTweet-action--retweet .ProfileTweet-actionCountForPresentation").inner_text
      favorites = tweet.css(".content .ProfileTweet-action--favorite .ProfileTweet-actionCountForPresentation").inner_text
      puts "#{time}: #{text}"
      puts "Retweets:#{retweets}, Favorites:#{favorites}"
      puts
    end
    puts " "
  end

  #stats from twitter are gotten
  def extract_stats
    user_stats = @doc.search(".ProfileNav-value")
    user_stats.map { |el| el.inner_text }
  end

end

#it creates an instance of 'TwitterScrapper'
twitter = TwitterScrapper.new('https://twitter.com/CH14_')
#twitter information is displayed
twitter.fetch!