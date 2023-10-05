require 'sqlite3'
require 'active_record'
require 'byebug'


ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => 'customers.sqlite3')
# Mostrar consultas en la consola.
# Comenta esta linea para desactivar la visualización de consultas SQL sin formato.
ActiveRecord::Base.logger = Logger.new(STDOUT)

class Customer < ActiveRecord::Base
  def to_s
    "  [#{id}] #{first} #{last}, <#{email}>, #{birthdate.strftime('%Y-%m-%d')}"
  end

  # Consulta para encontrar cualquier persona con el nombre Candice
  def self.any_candice
    where(first: 'Candice')
  end

  # Consulta para encontrar clientes con correo electrónico válido (contiene "@")
  def self.with_valid_email
    where("email LIKE '%@%'")
  end

  # Consulta para encontrar clientes con emails que contienen ".org"
  def self.with_dot_org_email
    where("email LIKE '%.org%'")
  end

  # Consulta para encontrar clientes con correo electrónico no válido pero no en blanco (no contiene "@")
  def self.with_invalid_email
    where("email NOT LIKE '%@%' AND email IS NOT NULL")
  end

  # Consulta para encontrar clientes con correo electrónico en blanco
  def self.with_blank_email
    where("email IS NULL OR email = ''")
  end

  # Consulta para encontrar clientes nacidos antes del 1 de enero de 1980
  def self.born_before_1980
    where('birthdate < ?', Time.parse('1980-01-01'))
  end

  # Consulta para encontrar clientes con correo electrónico válido y nacidos antes del 1/1/1980
  def self.with_valid_email_and_born_before_1980
    with_valid_email.born_before_1980
  end

  # Consulta para encontrar clientes con apellidos que comienzan con "B", ordenados por fecha de nacimiento
  def self.last_names_starting_with_b
    where("last LIKE 'B%'").order(:birthdate)
  end

  # Consulta para encontrar los 20 clientes más jóvenes, en cualquier orden
  def self.twenty_youngest
    order(birthdate: :desc).limit(20)
  end
  

  # Actualiza la fecha de nacimiento de Gussie Murray hasta el 8 de febrero de 2004
  def self.update_gussie_murray_birthdate
    customer = find_by(first: 'Gussie', last: 'Murray')
    customer.update(birthdate: Time.parse('2004-02-08'))
  end

  # Cambia todos los correos electrónicos no válidos a blanco
  def self.change_all_invalid_emails_to_blank
    where("email IS NOT NULL AND email NOT LIKE '%@%'").update_all(email: '')
  end

  # Elimina al cliente Meggie Herman de la base de datos
  def self.delete_meggie_herman
    where(first: 'Meggie', last: 'Herman').destroy_all
  end

  # Elimina todos los clientes nacidos el 31 de diciembre de 1977 de la base de datos
  def self.delete_everyone_born_before_1978
    where("birthdate < ?", "1978-01-01").destroy_all
  end  
end  
