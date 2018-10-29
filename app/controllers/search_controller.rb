require 'rubygems'
require 'mechanize'
require 'date'
require 'json'

class SearchController < ApplicationController
  def find_all_reviews
    agent = Mechanize.new
    page = agent.get('http://belchip.by')
    chipdip_form = page.form_with(:id => 'search_form')
    chipdip_form.query = 'he'
    page = agent.submit(chipdip_form, chipdip_form.buttons.first)
    page.css('h3')
  end
end
