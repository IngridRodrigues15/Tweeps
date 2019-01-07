require 'rails_helper'

describe TweepsService do
  describe '#initialize', vcr: "TweepsService.new" do
    subject { TweepsService.new }
    let(:query_params) { {:q=>"@locaweb"} }
    let(:headers) { {:Username=>"ingrid.santos@locaweb.com"} }

    it 'defines headers' do
      expect(subject.instance_variable_get(:@headers)).to eq(headers)
    end

    it 'defines query params' do
      expect(subject.instance_variable_get(:@params)).to eq(query_params)
    end
  end

  describe '#tweets', vcr: "TweepsService.tweets" do
    subject do
      TweepsService.new.tweets
    end

    let(:request_url) { 'http://tweeps.locaweb.com.br/tweeps' }
    let(:query_params) { {:q=>"@locaweb"} }
    let(:headers) { {:Username=>"ingrid.santos@locaweb.com"} }

    it 'request to tweeps locaweb url' do
      expect(subject.request.base_uri).to eq request_url
    end

    it 'returns status ok' do
      expect(subject.ok?).to eq true
    end

    it 'return statuses key' do
      expect(subject.keys).to include 'statuses'
    end

    it 'request with correct headers' do
      expect(subject.request.options[:headers]).to eq headers
   end

    it 'request passing locaweb user on query' do
      expect(subject.request.options[:query]).to eq query_params
    end
  end

  describe '#most_relevants', vcr: "TweepsService.most_relevants" do
    subject do
      TweepsService.new.most_relevants
    end

    let(:expected_keys) do
      [:followers_count,
       :screen_name,
       :profile_url,
       :created_at,
       :tweet_url,
       :retweet_count,
       :text,
       :favorite_count,
       :reply]
    end

    it 'returns only twets mentioning locaweb user' do
      expect(subject.pluck(:text)).to all ( include '@locaweb' )
    end

    it 'do not returns tweets in reply to locaweb' do
      expect(subject.pluck(:reply)).to satisfy { |v| !v.include?('locaweb') }
    end

    it 'returns only followers, name, profile, date, tweet, retweet count and favorite count' do
      expect(subject[0].keys).to eq expected_keys
    end
  end

  describe '#most_mentions', vcr: "TweepsService.most_mentions" do
    subject do
      TweepsService.new.most_mentions
    end

    let(:users) do
     ['ledner_mallory_ms', 'hayley_jacobi', 'cordell_thiel', 'elbert_spinka']
    end

    it 'group tweets by user' do
      expect(subject.keys).to eq users
    end
  end
end
