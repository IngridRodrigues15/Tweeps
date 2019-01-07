class TweepsController < ApplicationController

  def most_relevants
    tweeps = TweepsService.new.most_relevants
    render :json => tweeps.as_json
  end

  def most_mentions
    tweeps = TweepsService.new.most_mentions
    render :json => tweeps.as_json
  end

end
