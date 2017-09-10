  require 'nokogiri'
  require 'open-uri'
  require 'csv'
  require 'yaml'


  class PageParser
    attr_reader :input

    def initialize(input)
      @config = YAML::load(open('../../config.yml'))
      @input = input
      @found_values = []

      @all_products_from_page = []
    end

    def result
      get_file(input)

      found_product_name
      found_product_weight


      # get_the_required_values
      # get_collection_value
    end

    private

    attr_reader :found_values, :values, :quantity_positions, :all_products_from_page, :config

    def get_file(input_link)
      @values = Nokogiri::HTML(open("#{input_link}"))
    end

    def found_product_weight
      found_links = values.xpath(".//li[@class='attribute'][1]//div[@class='value']/ul/li/a/@data-product-body")
      found = []
      index = 1
      found_links.each do |link|
        get_file(link)
        found << values.xpath(".//li[@class='attribute'][1]//div[@class='value']/ul/li[#{index}]/a/@title", ".//div/div[@class='product-price']/span[1]/text()")
        @found_values << found[index - 1].first
        @found_values << found[index - 1].last

        index += 1
      end
      puts found_values
    end

    def found_product_name
      found = []
      found << values.xpath(config['petsmart']['product_name'])

      @found_values << found
    end

    def get_collection_value
      get_quantity_positions
      index = 1

      while index <= quantity_positions
        @all_products_from_page << ["#{found_values[0]} - #{found_values[index]}", "#{found_values[index + quantity_positions]}", "#{found_values.last}"]

        index += 1
      end

      all_products_from_page
    end

    def get_quantity_positions
      @quantity_positions = (found_values.size - 2)/2
    end
  end

page_parser = PageParser.new("http://www.petsmart.com/dog/food/canned-food/hills-science-diet-mature-adult-dog-food-2737.html?cgid=100245")

page_parser.result

