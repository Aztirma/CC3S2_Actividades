# Código limpio y el arte del manejo de excepciones

En el link proporcionado, el  artículo en cuestión aborda el tema de manejo de excepciones en programación, centrándose en prácticas recomendadas para mejorar la legibilidad, mantenibilidad y calidad del código. 

A continuación se detallara un ejemplo siguiendo las pautas dadas en este tutorial.

## Paso 1: Creamos un Proyecto

Creamos un nuevo directorio para nuestro proyecto en un lugar conveniente del sistema de archivos. Por ejemplo:


```
mkdir gestion_excepciones
cd gestion_excepciones
``` 

## Paso 2: Creamos Excepciones Personalizadas
2.1. Dentro del directorio del proyecto, creamos un subdirectorio llamado lib para almacenar nuestros archivos de código fuente:

```
mkdir lib
```
2.2. Creamos un archivo llamado application_error.rb dentro del directorio lib:

touch lib/application_error.rb

2.3. Abrimos application_error.rb en nuestro editor de texto y definimos las excepciones personalizadas:

```ruby
# lib/application_error.rb
class ApplicationError < StandardError; end

class ValidationError < ApplicationError; end
class RequiredFieldError < ValidationError; end
class UniqueFieldError < ValidationError; end

class ResponseError < ApplicationError; end
class BadRequestError < ResponseError; end
class UnauthorizedError < ResponseError; end
```

## Paso 3: Creamos el Manejo de Excepciones

3.1. En el directorio lib, creamos un archivo llamado exception_handler.rb:

```
touch lib/exception_handler.rb
```
3.2. Abrimos exception_handler.rb en nuestro editor de texto y definimos el manejo de excepciones:
```ruby
# lib/exception_handler.rb
module ExceptionHandler
  def self.handle(exception)
    case exception
    when ValidationError
      handle_validation_error(exception)
    when ResponseError
      handle_response_error(exception)
    else
      log_unhandled_exception(exception)
    end
  end

  def self.handle_validation_error(exception)
    puts "Handling Validation Error: #{exception.message}"
    # Lógica adicional para manejar errores de validación
  end

  def self.handle_response_error(exception)
    puts "Handling Response Error: #{exception.message}"
    # Lógica adicional para manejar errores de respuesta
  end

  def self.log_unhandled_exception(exception)
    puts "Logging Unhandled Exception: #{exception.message}"
    # Lógica para registrar excepciones no manejadas
  end
end
```
## Paso 4: Creamos el Registro de Errores

4.1. En el directorio lib, creamos un archivo llamado logger.rb:

```
touch lib/logger.rb
```

## Paso 5: Usamos en la Aplicación

5.1. En el directorio principal del proyecto, creamos un archivo llamado main.rb:
```
touch main.rb
```

5.2. Abrimos main.rb en nuestro editor de texto y utilizamos las clases y módulos definidos:

```ruby
# main.rb
$LOAD_PATH << File.expand_path('lib', __dir__)

require 'application_error'
require 'exception_handler'
require 'logger'

include ExceptionHandler

begin
  # Código que puede generar excepciones
  raise ValidationError, 'Campo requerido no presente'
rescue ApplicationError => e
  ExceptionHandler.handle(e)
end
```
## Paso 6: Ejecutamos el Programa

6.1. Ejecutamos el programa main.rb:

```
ruby main.rb
```

6.3. Observamos la salida en la consola y verificamos que el manejo de excepciones se realiza correctamente.



¡Listo! Hemos replicado el tutorial y creado un simple sistema de gestión de excepciones en Ruby. Podemos expandir y personalizar este proyecto según nuestras necesidades.

**¿Que diferencias encuentras con lo indicado aquí https://codedamn.com/news/javascript/error-handling-debugging para Java Script?**

Este artículo proporciona una guía detallada sobre las técnicas de manejo de errores y depuración en JavaScript, con un enfoque en las mejores prácticas, llamaremos a este Articulo 1 y Articulo 2 al manejo de excepciones en Ruby, por tanto a continuación detallaremos las diferencias que hemos podido encontrar:

Ambos artículos abordan aspectos relacionados con el manejo de errores, pero se centran en lenguajes de programación diferentes (JavaScript en el primer artículo y Ruby en el segundo). Aquí hay algunas diferencias y similitudes notables entre los dos:

**Lenguaje de Programación:**

El artículo 1 se centra en JavaScript, mientras que el artículo 2 se centra en Ruby. Cada lenguaje tiene sus propias particularidades en cuanto a cómo se manejan las excepciones y errores, y los enfoques específicos pueden variar.

**Enfoque en Jerarquía de Excepciones:**

El artículo 2 destaca la importancia de crear una jerarquía de excepciones personalizada, una práctica específica de la programación orientada a objetos. El artículo 1 no profundiza específicamente en este aspecto.

**Convenciones de Nomenclatura:**

El artículo 2 menciona la importancia de seguir convenciones de nomenclatura, como el uso del signo de exclamación (!). Esto es específico de las convenciones de Ruby. El artículo 1 no se centra en convenciones de nomenclatura específicas.

**Manejo de Excepciones en JavaScript:**

El artículo 1 se centra en el manejo de errores en JavaScript, utilizando construcciones de try-catch y discutiendo diversas estrategias para identificar y gestionar errores.

**Enfoque en el Registro de Excepciones:**

El artículo 2 resalta la importancia de registrar excepciones para facilitar la depuración. Aunque el artículo 1 también destaca la importancia de la depuración, no se centra específicamente en el registro de excepciones.
