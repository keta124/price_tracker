require_relative 'fetch_uri'

class Catagory
  class << self
    def execute
      @url="https://www.adayroi.com"
      @uri =@url+'/'
      cat_item = FetchUri.new(@uri,{}).doc.at('.menu__cat-wrap').css('li.menu__cat-item')
      item_ =[]
      cat_item.each do |i|
        if (i.at('a.menu__cat-link')['href'].to_s.gsub(@url, ''))
          item_ << @url+i.at('a.menu__cat-link')['href'].to_s.gsub(@url, '').gsub('?q=%3Arelevance', '')+'?q=%3Arelevance'
        end
      end
      begin
        return item_
      rescue => e
        return []
      end
    end
  end
end
class Item
  class << self
    def cat_num_page catagory
      FetchUri.new(catagory,{}).doc.css('ul.dropdown-menu li a').each do |e|
        puts e['href']
      end
    end
    def get_page_data doc
      puts doc.css('.product-item__container').first.css('span.product-item__info-price-sale').text
    end

    def crawler_catagory catagory_url
      doc = FetchUri.new(catagory_url,{}).doc
      get_page_data doc
      begin
      next_page = doc.css('.input-group.product-list__filter').css('a.btn').last['href']
      while next_page != "javascript:void(0);"
        puts next_page
        doc = FetchUri.new('https://www.adayroi.com'+next_page,{}).doc
        next_page = doc.css('.input-group.product-list__filter').css('a.btn').last['href']
      end
      rescue =>e
        puts e
      end
    end

    def execute
      cat_item = Catagory.excute
      cat_item.each do |i|
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
u ='https://www.adayroi.com/dien-thoai-may-tinh-bang-c322?q=%3Arelevance&page=11'
doc = FetchUri.new(u,{}).doc
Item.get_page_data(doc)