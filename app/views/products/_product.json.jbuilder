json.extract! product, :id, :title, :description, :price, :link, :img_src, :created_at, :updated_at
json.url product_url(product, format: :json)
