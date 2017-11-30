require_relative 'fetch_uri'
require_relative 'influxdb_connection'

class Catagory
  class << self
    def execute
      @url="https://www.adayroi.com"
      cat_item = FetchUri.new(@url,{}).doc.at('.menu__cat-wrap').css('li.menu__cat-item')
      cat_ =[]
      cat_item.each do |i|
        href = i.at('a.menu__cat-link')['href']
        if (href)
          href = '/'+href if href[0] !='/'
          cat_ << @url+URI(href).path.gsub(@url+'/', '')
        end
      end
      return cat_.drop(1)
    end
  end
end
class Item
  class << self
    def extract_url uri
      doc = FetchUri.new(uri,{}).doc
      @url="https://www.adayroi.com"
      url_array =[]
      if doc.css('a.product-item').empty?
        item_in_page = doc.css('.product-item__container')
        item_in_page.each do |i|
          url_array << @url+ URI(i.at('a.product-item__info-title')['href']).path
        end
      elsif !doc.css('a.product-item').empty?
        item_in_page = doc.css('a.product-item')
        item_in_page.each do |i|
          url_array << @url+ URI(i['href']).path
        end
      end
      return url_array
    end

    def update_list_item uri 
      extract_url uri
      # update to db
      # insert influxdc

    def get_catagory_num_page catagory_url
      doc = FetchUri.new(catagory_url,{}).doc
      begin
        doc.css('.dropdown.adr-dropdown ul.dropdown-menu li').last.text.gsub(/\D/, '').to_i
      rescue => e
        return 1
      end
    end
    def crawler_catagory catagory_url
      num_page = get_catagory_num_page(catagory_url)-1
      item_in_catagory = [] 
      (0..num_page).each do |i|
        update_list_item(catagory_url+'?q=%3Arelevance&page='+i.to_s)
        #doc = FetchUri.new(catagory_url+'?q=%3Arelevance&page='+i.to_s,{}).doc
        #item_in_catagory=item_in_catagory|extract_url(doc)
      end
      puts item_in_catagory
    end
  end
end
u ='https://www.adayroi.com/du-lich-c332550'
Item.crawler_catagory(u)