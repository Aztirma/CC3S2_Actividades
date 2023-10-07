# Parte 1

def sum(array)
  array.reduce(0, :+)
end

def max_2_sum(array)
  sorted_array = array.sort.reverse
  sum_of_max_2 = sorted_array.take(2).sum
end

def sum_to_n?(array, n)
  array.combination(2).any? { |a, b| a + b == n }
end



class BookInStock
  def initialize(isbn, price)
    validate_input(isbn, price)
    set_isbn(isbn)
    set_price(price)
  end

  def isbn
    @isbn
  end

  def isbn=(new_isbn)
    set_isbn(new_isbn)
  end

  def price
    @price
  end

  def price=(new_price)
    set_price(new_price)
  end

  def price_as_string
    "$%.2f" % @price
  end

  private

  def validate_input(isbn, price)
    if isbn.empty? || price <= 0
      raise ArgumentError, "ISBN no puede ser una cadena vacía y el precio debe ser mayor que cero"
    end
  end

  def set_isbn(new_isbn)
    @isbn = new_isbn
  end

  def set_price(new_price)
    @price = new_price
  end
end
