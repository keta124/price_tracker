class CrawlerMapAdayroiWorker
  include Sidekiq::Worker

  def perform url
    AdayroiMap.update_list_url url
  end
end
