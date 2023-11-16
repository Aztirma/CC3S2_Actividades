# Rails-Avanzado

## Sección 0: Introducción y Errores Iniciales

### Descripción Inicial:

El código proporcionado inicialmente tiene algunos errores en la lógica del proceso del uso de frameworks y presenta casi todos los tópicos avanzados en clase.

### Errores Iniciales:

Los primeros errores se encuentran en el archivo `app/controllers/application_controller.rb`, donde llamamos a un método de la clase `Moviegoer`, la cual no existe.
Inicio del error:

!![Alt text](image-1.png)
Para corregir esto, cambiaremos la referencia a la clase `Movie`.
  ![Alt text](image-2.png)
Luego de cambiar por `Movie`:
![Alt text](image-3.png)
Vemos que el error ha cambiado, ahora enfrentamos un error de sintaxis. Este problema se encuentra en la carpeta `app/models`. 
![Alt text](image-4.png)

Aquí, debemos quitar los comentarios y ejecutar nuevamente el servidor.

![Alt text](image-5.png)

Ahora, el error ha sido corregido. Podemos visualizar las películas y alguna información adicional. Además, ahora podemos agregar nuevas películas.

## Sección 1: Vistas parciales, validaciones y filtros

### Vistas Parciales:

Una vista parcial es el nombre de Rails para una parte reutilizable de una vista. Cuando debe aparecer contenido similar en diferentes vistas.

Según la actividad, nos sugiere , colocar ese contenido en una parte e “incluirlo” en archivos separados ayuda a DRY la repetición.

Creamos el archivo `_movie.html.erb` en el directorio `app/views` e incluimos este fragmento de codigo, que actuara como una vsta parcial.

``` html
<div class="row">
    <div class="col-8"> <%= link_to movie.title, movie_path(movie) %> </div>
    <div class="col-2"> <%= movie.rating %> </div>
    <div class="col-2"> <%= movie.release_date.strftime('%F') %> </div>
</div>
``` 

Actualizamos la línea `<%= render partial: 'movie', collection: @movies %>` del archivo `index.html.haml ` para que coincida con la nueva ubicación.

``` html
<!--  ...other code from index.html.erb here... -->
<div class="row bg-dark text-white">
    <div class="col-6 text-center">Title and More Info</div>
    <div class="col-2 text-center">Rating</div>
    <div class="col-4 text-center">Release Date</div>
</div>
<%= render partial: 'movie', collection: @movies %>
``` 

También cambiaremos el formato de html.haml a html.erb del archivo anteriormente mencionado `index.html.haml `

![Alt text](image-7.png)

Ahora si observamos que al ejecutar nuestro servidor, no hay ningun error y se pueden observar las tablas.

![Alt text](image-8.png)


### Validaciones de Modelos:

Las validaciones de modelos, al igual que las migraciones, se expresan en un mini-DSL integrado en Ruby, como muestra en el siguiente código.Agregamos el código de validación al modelo `Movie` que se proporciona.
``` ruby
class Movie < ActiveRecord::Base
    def self.all_ratings ; %w[G PG PG-13 R NC-17] ; end #  shortcut: array of strings
    validates :title, :presence => true
    validates :release_date, :presence => true
    validate :released_1930_or_later # uses custom validator below
    validates :rating, :inclusion => {:in => Movie.all_ratings},
        :unless => :grandfathered?
    def released_1930_or_later
        errors.add(:release_date, 'must be 1930 or later') if
        release_date && release_date < Date.parse('1 Jan 1930')
    end
    @@grandfathered_date = Date.parse('1 Nov 1968')
    def grandfathered?
        release_date && release_date < @@grandfathered_date
    end
end
``` 

Verificamos los resultados en la consola utilizando el código de ejemplo proporcionado.

![Alt text](image-9.png)


Se creó una instancia llamada m de la clase Movie con un título vacío, un rating incorrecto y una fecha de lanzamiento anterior a 1930. Al ejecutar las validaciones, se obtuvo un resultado de false, indicando problemas de validación. Se generaron mensajes de error específicos para el título, señalando que no puede estar en blanco, y para la fecha de lanzamiento, indicando que debe ser en 1930 o posterior. 

### Controlador de Películas (`MoviesController`):

Analizamos y entiendemos el código del controlador proporcionado. Comprendemos cómo se manejan las acciones `new`, `create`, `edit`, `update`, y `destroy`.

``` ruby
class MoviesController < ApplicationController
  def new
    @movie = Movie.new
  end 
  def create
    if (@movie = Movie.create(movie_params))
      redirect_to movies_path, :notice => "#{@movie.title} created."
    else
      flash[:alert] = "Movie #{@movie.title} could not be created: " +
        @movie.errors.full_messages.join(",")
      render 'new'
    end
  end
  def edit
    @movie = Movie.find params[:id]
  end
  def update
    @movie = Movie.find params[:id]
    if (@movie.update_attributes(movie_params))
      redirect_to movie_path(@movie), :notice => "#{@movie.title} updated."
    else
      flash[:alert] = "#{@movie.title} could not be updated: " +
        @movie.errors.full_messages.join(",")
      render 'edit'
    end
  end
  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path, :notice => "#{@movie.title} deleted."
  end
  private
  def movie_params
    params.require(:movie)
    params[:movie].permit(:title,:rating,:release_date)
  end
end

 ``` 

* `new` : Esta acción, permite la creación de una nueva instancia de la clase Movie.  
* `create` :Nos permite manejar la creacion de una pelicula con los datos mandados desde un formulario, si esta es exitosa entonces da un mensaje de exito y redirige a la lista de peliculas, de lo contrario da un mensaje de error y vuelvo al formulario de creacion.  
* `edit` : Esta acción permite editar la informacion de una pelicula, buscandola a traves de un id.  
* `update` : Maneja la actualizacion de una pelicula que ya existe, si la actualiza exitosamente entonces redirige a la pagina de informacion de la pelicula, si falla nos redirige a la pagina de edicion.  
* `destroy` : Maneja la destruccion de una pelicula por medio de su id.  
* `movie_params` : Gestiona los parametros que podemos enviar a traves de nuestras peticiones.


### Canonicalización de Campos del Modelo:

Agregamos el método `capitalize_title` al modelo `Movie` para capitalizar el título antes de guardarlo. 

 ```ruby
class Movie < ActiveRecord::Base
    before_save :capitalize_title
    def capitalize_title
        self.title = self.title.split(/\s+/).map(&:downcase).
        map(&:capitalize).join(' ')
    end
end
 ``` 

Verificamos los resultados en la consola con el código de ejemplo proporcionado para comprobar si funciona la canonicalizacion :



### Filtro del Controlador:

Analiza el código del filtro en `ApplicationController`. Entiende cómo se utiliza el filtro `before_filter` para asegurar que un usuario esté autenticado. Comprueba el resultado ejecutando el código proporcionado en la consola.

## Sección 2: SSO y Autenticación a través de Terceros

### Configuración Inicial:

Ejecuta el comando para generar el modelo `Moviegoer` y la migración. Modifica el archivo `app/models/moviegoer.rb` con el código proporcionado.

### OmniAuth y Configuración:

Añade las rutas y controladores necesarios para OmniAuth en `config/routes.rb` y `app/controllers/sessions_controller.rb`. Reemplaza `API_KEY` y `API_SECRET` con las claves reales de Twitter en `config/initializers/omniauth.rb`.

### Seguridad y Preguntas:

Analiza la pregunta sobre la seguridad y comprende la posible vulnerabilidad. Proporciona una respuesta sobre cómo evitar la vulnerabilidad.

## Sección 3: Asociaciones y Claves Foráneas

### Migración y Modelo de Reviews:

Ejecuta el comando para generar la migración de la tabla `Reviews`. Completa la migración en `db/migrate/*_create_reviews.rb`. Crea el modelo `Review` en `app/models/review.rb`.

### Asociaciones Directas:

Agrega la línea `has_many :reviews` a las clases `Movie` y `Moviegoer`. Comprende cómo se utilizan las asociaciones directas en el código proporcionado.

## Sección 4: Asociaciones Indirectas

### Migración de Reviews (Repetida):

Ejecuta el comando para generar la migración de la tabla `Reviews`. Completa la migración de nuevo.

### Asociaciones Indirectas y Consultas SQL:

Comprende cómo se utiliza la opción `:through` en `has_many` para representar una asociación indirecta. Entiende la consulta SQL proporcionada.

### Validaciones y Save con Asociaciones:

Agrega las validaciones al modelo `Review` que se proporcionan. Comprueba el comportamiento de `save` y `save!` en objetos con asociaciones.

### Opciones Adicionales en Asociaciones:

Analiza la información sobre opciones adicionales en los métodos de asociaciones.

## Sección 5: Conclusión y Organización del Informe

### Conclusión:

Recapitula los puntos clave y aprendizajes de cada sección.

### Organización del Informe:

Escribe un informe en formato Ruby on Rails avanzado, organizando la información de manera clara y concisa. Incluye ejemplos y resultados relevantes de la consola donde sea necesario. Presenta el informe en un repositorio llamado `Rails-Avanzado`.

