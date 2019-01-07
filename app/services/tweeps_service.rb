class TweepsService
  include HTTParty
  base_uri ConfigApp.api["url"]

  def initialize
    @headers = { Username: ConfigApp.api["user"] }
    @params = { q: ConfigApp.api["locaweb_user"] }
    @tweets = self.tweets["statuses"]
  end

  def tweets
    self.class.get("/search/tweets.json",
                  :query => @params,
                  :headers => @headers)
  end

  def most_relevants
    remove_reply
    remove_not_mention
    order
    filter
  end

  def most_mentions
    most_relevants
    group_by_users(@tweets)
  end

  private

  def remove_reply
    @tweets.reject! { |v| v["in_reply_to_screen_name"] == "locaweb" }
  end

  def remove_not_mention
    @tweets.reject! { |v| !v["text"].include?("@locaweb") }
  end

  def order
    @tweets.sort_by{|v| [v["user"]["followers_count"], v["retweet_count"], v["favorite_count"]] }.reverse
  end

  def group_by_users(tweets)
    tweets.group_by{ |d| d[:screen_name] }
  end

  def filter
    tweets = []
    @tweets.each do |tweet|
      followers_count = tweet['user']['followers_count']
      screen_name = tweet['user']['screen_name']
      profile_url = "https://twitter.com/#{screen_name}"
      created_at = tweet['created_at']
      tweet_url = "https://twitter.com/#{screen_name}/status/#{tweet["id"]}"
      retweet_count =  tweet['retweet_count']
      text = tweet['text']
      favorite_count = tweet['favorite_count']
      reply = tweet['in_reply_to_screen_name']

      tweets << {
                 followers_count: followers_count,
                 screen_name: screen_name,
                 profile_url:profile_url,
                 created_at:created_at,
                 tweet_url: tweet_url,
                 retweet_count: retweet_count,
                 text: text,
                 favorite_count: favorite_count,
                 reply: reply
                }
    end
    @tweets = tweets
  end
end
