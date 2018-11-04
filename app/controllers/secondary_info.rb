class SecondaryInfo
  def initialize product_link
      @product_link = product_link
  end

  def get_secondary_info
    @product_link.include?('belchip') ? get_belchip_secondary_info : get_chipdip_secondary_info
  end

  def get_belchip_secondary_info
    page = Mechanize.new.get(@product_link)
    return ["http://belchip.by/#{page.xpath('//td[contains(@class, "left-full")]/a/img/@src').text}", page.xpath('//div[contains(@class, "tech")]/table').text.strip]
  end

  def get_chipdip_secondary_info
    page = Mechanize.new.get(@product_link)
    return [page.xpath('//div[contains(@class, "item__image_medium_wrapper")]/span/img/@src').text, page.xpath('//div[contains(@class, "product_params")]').text]
  end
end