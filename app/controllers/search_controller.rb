require 'rubygems'
require 'mechanize'
require 'date'
require 'json'

class SearchController < ApplicationController
  def find_all_products
    agent = Mechanize.new
    page = agent.get('http://belchip.by')
    chipdip_form = page.form_with(:id => 'search_form')
    chipdip_form.query = 'he'
    page = agent.submit(chipdip_form, chipdip_form.buttons.first).css('.cat-item')
  end

  def get_info
    products = find_all_products
    info = [self.get_price(products), self.get_title(products), self.get_link(products)]
  end

  def get_price products
    products.css("div[class='denoPrice']")[0].text
  end

  def get_title products
    products.css('h3')[0].text
  end

  def get_link products
    product = products.xpath('//h3/a/@href')
  end
end
