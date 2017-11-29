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
    def extract_url doc
      @url="https://www.adayroi.com"
      item_in_page = doc.css('.product-item__container')
      url_array =[]
      item_in_page.each do |i|
        url_array << @url+ URI(i.at('a.product-item__info-title')['href']).path
      end
      return url_array
    end
    def get_catagory_num_page catagory_url
      doc = FetchUri.new(catagory_url,{}).doc
      begin
        doc.css('.dropdown.adr-dropdown ul.dropdown-menu li').last.text.gsub(/\D/, '').to_i
      rescue => e
        return 0
      end
    end
    def crawler_catagory catagory_url
      num_page = get_catagory_num_page catagory_url
      item_in_catagory = [] 
      (0..num_page).each do |i|
        doc = FetchUri.new(catagory_url+'?q=%3Arelevance&page='+i.to_s,{}).doc
        item_in_catagory=item_in_catagory|extract_url(doc)
      end
      puts item_in_catagory.length
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
puts Catagory.execute
#Item.crawler_catagory(u)
#puts Catagory.excute
u ='https://www.adayroi.com/dien-may-cong-nghe-c321'
#doc = FetchUri.new(u,{}).doc
#puts Item.extract_url(doc)
Item.crawler_catagory(u)
#https://www.adayroi.com/du-lich-c332550
#https://www.adayroi.com/benh-vien-da-khoa-quoc-te-vinmec-br33257743
#https://www.adayroi.com/dien-thoai-may-tinh-bang-c322
#https://www.adayroi.com/dien-may-cong-nghe-c321
#https://www.adayroi.com/dien-may-dien-lanh-dien-gia-dung-c1773
#https://www.adayroi.com/thuc-pham-c591
#https://www.adayroi.com/nha-cua-doi-song-c861
#https://www.adayroi.com/thoi-trang-c1
#https://www.adayroi.com/suc-khoe-sac-dep-c139
#https://www.adayroi.com/me-be-c714
#https://www.adayroi.com/nha-cua-doi-song-c861
#https://www.adayroi.com/o-to-xe-may-c1077
#https://www.adayroi.com/voucher-dich-vu-c332500