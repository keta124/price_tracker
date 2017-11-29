require 'net/http'
require 'nokogiri'
class Item
  class << self
    def extract_url sitemap_url
      doc = FetchUri.new(sitemap_url,{}).doc
      puts doc
      category_urls = doc.css("loc").map &:text 
    end
  end
end
HEADER_OPTIONS = {"User-Agent" => "Mozilla/5.0 Firefox/3.0.6"}
#puts Item.extract_url('https://www.adayroi.com/sitemap/product-sitemap-48-2.xml')
u ='https://tiki.vn/sitemap_category.xml'
Nokogiri::XML open('https://tiki.vn/sitemap_category.xml')