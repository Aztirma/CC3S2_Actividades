# Factory Method Pattern

class Restaurant
    def create_menu
      Menu.new
    end
end
  
  class ItalianRestaurant < Restaurant
    def create_menu
      ItalianMenu.new
    end
  end
  
  class MexicanRestaurant < Restaurant
    def create_menu
      MexicanMenu.new
    end
  end
  
# Bridge Pattern

class Delivery
    def deliver
        "Entrega no especificada"
    end
end
  
  class HomeDelivery < Delivery
    def deliver
      "Entrega a domicilio"
    end
  end
  
  class PickupDelivery < Delivery
    def deliver
      "Recoger en el restaurante"
    end
  end
  
  class Menu
    attr_reader :delivery
  
    def initialize(delivery = nil)
      @delivery = delivery
    end
  
    def display_menu
      "Menú genérico"
    end
  end
  
  class ItalianMenu < Menu
    def display_menu
      "Pizza Margherita, Pasta Carbonara, Tiramisu"
    end
  end
  
  class MexicanMenu < Menu
    def display_menu
      "Tacos, Quesadillas, Guacamole"
    end
  end
  
  
  # Command Pattern
  
  class Order
    def initialize(command)
      @command = command
    end
  
    def execute_order
      @command.execute
    end
  end
  
  class PlaceOrderCommand
    def initialize(menu)
      @menu = menu
    end
  
    def execute
      "Pedido realizado para:\n" + @menu.display_menu
    end
  end
  
  # Clase principal Main
  
  class Main
    def self.run
      # Lista de diferentes tipos de restaurantes
      restaurant_types = [ItalianRestaurant, MexicanRestaurant]
  
      # Selecciona aleatoriamente un tipo de restaurante
      selected_restaurant = restaurant_types.sample
  
      # Crea una instancia del restaurante seleccionado
      restaurant = selected_restaurant.new
  
      # Crea el menú del restaurante
      menu = restaurant.create_menu
  
      # Crear una instancia de entrega a domicilio (o cualquier otra subclase de Delivery)
      delivery = HomeDelivery.new
  
      # Crear un comando para realizar un pedido con el menú
      order_command = PlaceOrderCommand.new(menu)
  
      # Crear una orden utilizando el comando de pedido
      order = Order.new(order_command)
  
      # Imprimir mensajes informativos
      puts "Bienvenido al restaurante: #{selected_restaurant}"
      puts "Menú disponible:"
      puts menu.display_menu
      puts "Realizando pedido..."
      puts order.execute_order
      puts "Entrega seleccionada: #{delivery.deliver}"
    end
  end
  
  # Ejecutar la aplicación
  Main.run
  