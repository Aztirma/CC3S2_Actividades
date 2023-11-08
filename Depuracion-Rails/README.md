### Depuración SaaS que usan Rails

En las aplicaciones SaaS que usan Rails, esta confusión se puede agravar si la operación que falló ocurre en una acción del controlador, pero el objeto inválido se pasó como una
variable de instancia y luego fue dereferenciada en la vista, como se muestra en los siguientes extractos de un controlador y una vista:

```
# in controller action:
def show
  @movie = Movie.find_by_id(params[:id]) # what if this movie not in DB?
  # BUG: we should check @movie for validity here!
end
-# ...later, in the Haml view:

%h1= @movie.title
-# will give "undefined method 'title' for nil:NilClass" if @movie is nil
```
- Pregunta (Ask) Si estamos en un entorno de trabajo de "puestos no asignados", o tiene activada la mensajería instantánea, distribuye el mensaje ahí fuera.

- Busca (Search): Buscamos el error presentado en diferentes motores de busqueda utilizando palabras clave o el mensaje de error.

- Postea (Post) una pregunta a uno de esos sitios si todo lo demás falla. Selo más específico posible acerca de lo que fue mal, cuál es tu entorno y cómo reproducir el problema
 
 Otras medidas que se puede optar realizar si la aplicación se detiene es mirar el `log file` por lo general `log/development.log`, para obtener una información más completa del error, incluyendo la traza.  

## Segundo tipo de problema 
En este caso la aplicación se ejecuta pero tiene un resultado o comportamiento incorrecto. Para depurar este tipo de problema se realizan diferentes enfoques, uno de ellos puede ser los siguientes:


- Mostrar la descripción detallada de un objeto en una vista. Por ejemplo, probaremos a insertar `= debug(@movie)` o `= @movie.inspect` en cualquier vista (donde el signo
`=` le dice a Haml que ejecute el código e inserta el resultado en la vista).


  ``` ruby
  -# in app/views/movies/show.html.haml

  %h2 Details about #{@movie.title}

  %ul#details
    %li
      Rating:
      = @movie.rating
    %li
      Released on:
      = @movie.release_date.strftime("%B %d, %Y")

  %h3 Description:
  = link_to 'Edit info', edit_movie_path(@movie)
  = link_to 'Back to movie list', movies_path


  = debug(@movie)
  = @movie.inspect
  ```
  Cuando se añaden las líneas = debug(@movie) y = @movie.inspect en la vista de la aplicación, se obtiene información detallada sobre el objeto @movie. La primera línea mostrará esta información en la consola del servidor de Rails, lo que les permitirá analizar los atributos y valores del objeto durante la interacción con la página. La segunda línea mostrará la representación del objeto directamente en la vista web, facilitando la visualización de los datos sin necesidad de acceder a la consola del servidor. 


- Detener la ejecución dentro de un método de un controlador lanzando una excepción cuyo mensaje sea una representación del valor que quieres inspeccionar, por ejemplo, `raise params.inspect`

  
  Dentro de MoviesController
  ``` ruby
  def show
      id = params[:id] 
      @movie = Movie.find(id) 
      raise @movie.inspect

  ```

  Al detener la ejecución dentro de un método de un controlador en Ruby on Rails mediante el lanzamiento de una excepción con un mensaje que es una representación del valor deseado, como en raise @movie.inspect, se interrumpe el flujo del programa y se muestra una página de error en el navegador. El mensaje de la excepción contiene una representación detallada del objeto que se quiere inspeccionar, en este caso, la variable @movie, lo que facilita la depuración al visualizar sus atributos y valores en la página de error para identificar problemas en el controlador


- Podemos usar `logger.debug( mensaje)` para imprimir el mensaje al fichero de logging. `logger` está disponible en los modelos y en los controladores y puede registrar mensajes con distintos niveles de importancia. 

  Dentro de MoviesController
  ```ruby
  def show
      id = params[:id] 
      @movie = Movie.find(id)
      logger.debug("Mostrando mensaje en el logger")
  ```
  Al agregar logger.debug("Mostrando mensaje en el logger") en el método show del controlador MoviesController, se registra un mensaje de depuración en el archivo de registro de la aplicación.  
  Nos pide comparar config/environments/production.rb con development.rb para ver cómo difieren los niveles logs por defecto entre los entornos de producción y desarrollo.

  Dentro del entorno de production tenemos el siguiente fragmento:
  ```ruby
    # Use default logging formatter so that PID and timestamp are not suppressed.
    config.log_formatter = ::Logger::Formatter.new

    # Use a different logger for distributed setups.
    # require "syslog/logger"
    # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new "app-name")

    if ENV["RAILS_LOG_TO_STDOUT"].present?
      logger           = ActiveSupport::Logger.new(STDOUT)
      logger.formatter = config.log_formatter
      config.logger    = ActiveSupport::TaggedLogging.new(logger)
    end
  ```

  Mientras que el entorno de desarrollo captura los deprecation messages:
  ```ruby
    # Print deprecation notices to the Rails logger.
    config.active_support.deprecation = :log
  ```

La segunda forma de depurar los problemas es con un depurador interactivo. Procedemos a instalarla la gema `debug` utilizando el comando `gem install debug`.

Editamos el siguiente fragmento de código en MoviesController:
```ruby
  def show    
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    debugger
    # will render render app/views/movies/show.html.haml by default
  end
```
Cuando iniciamos el servidor con rails server, esta línea detiene la ejecución en ese punto y abre un entorno de depuración interactivo. Desde aquí, podemos examinar variables y rastrear el flujo de la aplicación en tiempo real, lo que facilita la identificación y solución de problemas. 
 
 
 