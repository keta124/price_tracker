require_relative 'fetch_uri'
require_relative 'influxdb_connection'

class Catagory
  class << self
    def execute
      @url="https://www.adayroi.com"
      @uri =@url+'/'
      cat_item = FetchUri.new(@uri,{}).doc.at('.menu__cat-wrap').css('li.menu__cat-item')
      cat_ =[]
      cat_item.each do |i|
        if (i.at('a.menu__cat-link')['href'].to_s.gsub(@url, ''))
          cat_ << @uri+i.at('a.menu__cat-link')['href'].to_s.gsub(@uri, '').gsub('#', '').gsub('&q=%3Arelevance', '')+'&q=%3Arelevance'
        end
      end
      return cat_.drop(1)
    end
  end
end
class Item
  class << self
    def get_page_data doc
      @url="https://www.adayroi.com"
      item_in_page = doc.css('.product-item__container')
      item_in_page.each do |i|
        price = i.css('span.product-item__info-price-sale').text.gsub(/\D/, '').to_i
        uri = @url+i.at('a.product-item__info-title')['href']
        url = URI(uri).scheme+'://'+ URI(uri).host+URI(uri).path
        point = {
                  values: {
                    price: price
                  },
                  tags: { source: 'adayroi' },
                  timestamp: (Time.now.to_f).to_i
                }
        influxdb = InfluxConnection.connection
        influxdb.write_point url, point
      end
    end

    def crawler_catagory catagory_url
      doc = FetchUri.new(catagory_url,{}).doc
      get_page_data doc
      begin
      next_page = doc.css('.input-group.product-list__filter a.btn').last['href']
      while next_page != "javascript:void(0);"
        doc = FetchUri.new('https://www.adayroi.com'+next_page,{}).doc
        get_page_data doc
        next_page = doc.css('.input-group.product-list__filter a.btn').last['href']
      end
      rescue => e
        puts e
      end
    end

    def execute
      #cat_item = Catagory.execute
      cat_item = [
        'https://www.adayroi.com/vinpearl-sieu-tiet-kiem-lp32524?q=%3Arelevance&page=0',
        'https://www.adayroi.com/benh-vien-da-khoa-quoc-te-vinmec-br33257743?q=%3Arelevance&page=0',
        'https://www.adayroi.com/dien-thoai-may-tinh-bang-c322?q=%3Arelevance&page=0',
        'https://www.adayroi.com/dien-may-cong-nghe-c321?q=%3Arelevance&page=0',
        'https://www.adayroi.com/dien-may-dien-lanh-dien-gia-dung-c1773?q=%3Arelevance&page=0',
        'https://www.adayroi.com/thuc-pham-c591?q=%3Arelevancepage=0',
        'https://www.adayroi.com/nha-cua-doi-song-c861?q=%3Arelevance&page=0',
        'https://www.adayroi.com/thoi-trang-c1?q=%3Arelevance&page=0',
        'https://www.adayroi.com/suc-khoe-sac-dep-c139?q=%3Arelevance&page=0',
        'https://www.adayroi.com/me-be-c714?q=%3Arelevance&page=0',
        'https://www.adayroi.com/nha-cua-doi-song-c861?q=%3Arelevance&page=0',
        'https://www.adayroi.com/o-to-xe-may-c1077?q=%3Arelevance&page=0',
        'https://www.adayroi.com/voucher-dich-vu-c332500?q=%3Arelevance&page=0',
      ]
      cat_item.each do |i|
        puts i
        crawler_catagory(i)
      end
    end
  end
end
#u = 'https://www.adayroi.com/dien-thoai-may-tinh-bang-c322?q=%3Arelevance&amp;page=68'.gsub(/&amp;/, "&")
#u = 'https://www.adayroi.com/vinpearl-sieu-tiet-kiem-lp32524?q=%3Arelevance'
#puts URI.parse(u)
#page ='5'
#puts Catagory.execute
#Item.crawler_catagory(u)
#puts Catagory.excute
#u ='https://www.adayroi.com/dien-thoai-may-tinh-bang-c322?q=%3Arelevance&page=0'
#doc = FetchUri.new(u,{}).doc
#Item.get_page_data(doc)
Item.execute
#puts Catagory.execute