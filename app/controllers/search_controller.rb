require 'mechanize'

class SearchController < ApplicationController
  def find_all_products
    agent = Mechanize.new
    start_page = agent.get('http://belchip.by')
    search_form = start_page.form_with(:id => 'search_form')
    search_form.query = 'he'
    search_page = agent.submit(search_form, search_form.buttons.first).parser
  end

  def get_info
    products = find_all_products.css('.cat-item')
    info = [self.get_titles(products), self.get_prices(products), self.get_links(products)]
  end

  def get_titles products
    titles = []
    products.css('h3').each { |product_title| titles.append(product_title.text)}
    titles
  end

  def get_prices products
    prices = []
    products.xpath("//div/span/div/div").each { |product_price| prices.append(product_price.text)}
    prices
  end

  def get_links products
    links = []
    products.xpath('//h3/a/@href').each { |product_link| links.append(product_link)}
    links[1...links.length]
  end
end
