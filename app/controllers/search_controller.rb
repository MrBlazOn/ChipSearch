require 'mechanize'

class SearchController < ApplicationController
  def index
    @products = Product.paginate(:page => params[:page], :per_page => 10)
  end

  def get_all_products search_text
    if search_text.class != "NilClass"
      chipdip_products = find_chipdip_products(search_text).xpath("//tr[contains(@class, 'with-hover')]")
      belchip_products = find_belchip_products(search_text).css('.cat-item')
      info = [self.get_titles(belchip_products, chipdip_products), self.get_prices(belchip_products, chipdip_products), self.get_links(belchip_products, chipdip_products)]
    end
  end

  def add_to_database search_text
    Product.destroy_all
    products_info = get_all_products(search_text)
    (0...products_info[0].length).each do |i|
      Product.create(title: products_info[0][i], price: products_info[1][i], link: products_info[2][i])
    end
  end

  def find_chipdip_products search_text
    agent = Mechanize.new
    start_page = agent.get('https://www.ru-chipdip.by')
    search_form = start_page.form_with(:id => 'search__form')
    search_form.searchtext = search_text
    search_page = agent.submit(search_form, search_form.buttons.first).parser
  end

  def find_belchip_products search_text
    agent = Mechanize.new
    start_page = agent.get('http://belchip.by')
    search_form = start_page.form_with(:id => 'search_form')
    search_form.query = search_text
    search_page = agent.submit(search_form, search_form.buttons.first).parser
  end

  def get_titles belchip_products, chipdip_products
    titles = []
    belchip_products.css('h3').each { |product_title| titles.append(product_title.text)}
    chipdip_products.xpath("//td/div/a").each { |product_title| !(product_title.text.include? 'еще') ? titles.append(product_title.text) : nil }
    titles
  end

  def get_prices belchip_products, chipdip_products
    prices = []
    belchip_products.xpath("//div/span/div/div").each { |product_price| prices.append(product_price.text) }
    belchip_products.xpath("//div[contains(@style, 'color: #CC0000; font-size: 14px;')]").each { |out_of_order_message| prices.append('Нет в наличии') }
    chipdip_products.xpath("//td[contains(@class, 'h_pr nw')]/span[contains(@class, 'price')]").each { |product_price| prices.append(product_price.text) }
    prices
  end

  def get_links belchip_products, chipdip_products
    links = []
    belchip_products.xpath('//h3/a/@href').each { |product_link| product_link.to_s != 'catalog/' ? links.append("http://belchip.by/#{product_link}") : nil }
    chipdip_products.xpath('//td/div/a/@href').each { |product_link| !(product_link.to_s.include? 'catalog-show') ? links.append("http://www.ru-chipdip.by#{product_link}") : nil }
    links
  end
end