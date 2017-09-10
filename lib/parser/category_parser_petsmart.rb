module Parser
  class CategoryParser
    def initialize
      @found_links =                []
      @collection_quantity_pages =  []
      @config = YAML::load(open('../config.yml'))
    end

    def print
      get_quantity_pages
      get_all_links_to_products
      create_collection_products

      print_result
    end

    private

    attr_reader :page, :found_links, :number_pages, :collection_quantity_pages, :all_products, :config

    def get_page(link)
      @page = Nokogiri::HTML(open("#{link}"))
    end

    def get_quantity_pages
      get_page(ARGV[0])

      page.xpath(config['petsmart']['quantity_pages_search']).each do |link|
        collection_quantity_pages << link.content
      end

      @number_pages = collection_quantity_pages[0].to_i
    end

    def get_all_links_to_products
       if number_pages == 0
        get_links_to_products
      else
        index = 0
        while index < number_pages
          get_page("#{ARGV[0]}?srule=best-sellers&pmin=0&sz=24&start=#{index}")
          get_links_to_products

          index += 24
        end
      end

      found_links
    end

    def get_links_to_products
      page.xpath(config['petsonic']['link_product_search']).each do |link|
        @found_links << link.content
      end

      @found_links << ARGV[0] if found_links.size == 0
    end

    def create_collection_products
      @all_products ||= found_links.map do |link|
        PageParser.new(link).result
      end
    end

    def print_result
      printer = Printer.new

      printer.print_in_file(all_products)
    end
  end
end
