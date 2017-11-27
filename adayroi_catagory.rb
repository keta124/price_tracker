require_relative 'fetch_uri'

class Catagory
  class << self
    def excute
      @url="https://www.adayroi.com"
      @uri =@url+'/'
      cat_item = FetchUri.new(@uri,{}).doc.at('.menu__cat-wrap').css('li.menu__cat-item')
      item_ =[]
      cat_item.each do |i|
        if (i.at('a.menu__cat-link')['href'].to_s.gsub(@url, ''))
          item_ << @url+i.at('a.menu__cat-link')['href'].to_s.gsub(@url, '')
        end
      end
      begin
        return item_.drop(1)
      rescue
        return []
      end
    end
  end
end
puts Catagory.excute