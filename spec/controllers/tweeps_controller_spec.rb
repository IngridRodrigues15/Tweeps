require 'rails_helper'

describe TweepsController, :type => :controller do
  describe '#most_relevants', vcr: "TweepsController.most_relevants" do
    subject(:request) do
      get :most_relevants, :format => :json
    end

    it 'returns success' do
      subject
      expect(response.status).to eq 200
    end
  end

  describe '#most_mentions', vcr: "TweepsController.most_mentions" do
    subject(:request) do
      get :most_mentions, :format => :json
    end

    it 'returns success' do
      subject
      expect(response.status).to eq 200
    end
  end
end
