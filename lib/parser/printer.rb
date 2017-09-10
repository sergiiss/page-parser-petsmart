module Parser
  class Printer
    def print_in_file(all_products)
      CSV.open("#{ARGV[1]}.csv", 'wb') do |writer|
        all_products.each do |data|
          data.each do |data_inside|
            writer << ["#{data_inside[0]}", "#{data_inside[1]}", "#{data_inside[2]}"]
          end
        end
      end
    end
  end
end
