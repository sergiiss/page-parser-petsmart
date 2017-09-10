require 'test_helper'

class TestPageParser < Minitest::Test
  def test_single_product_page
    page_parser = Parser::PageParser.new(File.absolute_path("test/page/single_product_page.html"))
    result = page_parser.result

    assert_equal [[" Snacks de Ternera en Monodosis para Perro - 16 Unidades", " 13.95 € ", "https://www.petsonic.com/12023-large_default/snacks-de-ternera-en-monodosis-para-perro.jpg"]], result
  end

  def test_multi_product_page
    page_parser = Parser::PageParser.new(File.absolute_path("test/page/multi_product_page.html"))
    result = page_parser.result

    assert_equal [[" Galletas Granja para Perro - 200 Gr.", " 1.50 € ", "https://www.petsonic.com/5830-large_default/hobbit-alf-galletas-granja-para-perros.jpg"], [" Galletas Granja para Perro - 430 gr", " 2.60 € ", "https://www.petsonic.com/5830-large_default/hobbit-alf-galletas-granja-para-perros.jpg"], [" Galletas Granja para Perro - 4 Kg.", " 18.70 € ", "https://www.petsonic.com/5830-large_default/hobbit-alf-galletas-granja-para-perros.jpg"]], result
  end
end
