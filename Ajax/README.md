## AJAX: Asynchronous JavaScript y XML

Indicamos los pasos necesarios para la programación `AJAX on Rails`: 

1. Crear una acción del controlador o modificar una existente para gestionar las peticiones AJAX hechas por el código JavaScript.
   En lugar de procesar una vista completa, la acción procesará una parcial para generar un fragmento HTML que se insertará en la página. 

2. Construir un URI REST en JavaScript y utilizar XHR (XmlHttpRequest) para enviar la petición HTTP al servidor.
   Como habrás supuesto, jQuery dispone de atajos útiles para muchos casos habituales, por lo que utilizaremos las funciones de más alto nivel y más potentes que ofrece jQuery en      lugar de llamar a XHR directamente. 

3. Dado que JavaScript, por definición, se ejecuta en un hilo único (single-threaded ), sólo puede trabajar en una tarea cada vez hasta que dicha tarea se completa, la interfaz de
   usuario del navegador se quedaría `congelada` mientras JavaScript esperara la respuesta del servidor. Por ello, XHR en cambio vuelve inmediatamente de la llamada a la función y
   permite proporcionar una función callback para manejar el evento que se activará cuando responda el servidor o si se produce un error. 

4. Cuando la respuesta llega al navegador, el contenido de la respuesta se pasa a la función callback. Puede utilizar la función `replaceWith()` de jQuery para reemplazar un       
   elemento existente por completo, `text()` o `html()` para actualizar el contenido de un elemento in situ o una animación como `hide()` para ocultar o mostrar elementos.
   Puesto que las funciones JavaScript son clausuras (como los bloques de Ruby), la función `callback` tiene acceso a todas las variables visibles en el momento en el que se
   realizó la llamada XHR, aun cuando se ejecuta más tarde y en un entorno distinto.


### Parte 0

Antes de comenzar con las modificaciones correspondientes para poder realizar la actividad, nos encontramos con unos pequeños errores, el primero en los controladores ya que la variable Moviegoers no esta inicializada en ese caso debemos cambiar esa linea de codigo por la variable Movie, luego nos muestra un error sobre sintaxis en el archivo de `movie.rb` ya que habia un segmento de codigo comentado, una vez resuelto estos errores ejecutamos nuestro servidor en rails, el cual tiene la siguiente vista:

![Alt text](image-1.png)

Pero al tratar de editar una película, nos dice que estamos intentando acceder a la acción de edición (edit) en el controlador MoviesController, pero Rails no puede encontrar la plantilla adecuada para mostrar en el formato text/html. Por eso, agregamos la vista llamada edit.html.erb, pero al actualizar la información de la película, nos aparece un error.

![Alt text](image-2.png)


### Parte 1

El paso 1 necesita que identifiquemos o creemos una nueva acción de controlador que será la encargada de gestionar la petición. Usaremos la acción ya existente `MoviesController#show`, por lo que no necesitaremos definir una nueva ruta. \

Primero identificaremos el elemento que se va a renderizar, como nos menciona la actividad modificaremos el metodo `show`, para que de este modo si se recibe una petición AJAX, entonces procesará la sencilla vista parcial en lugar de la vista completa.

![Alt text](image.png)


Para ello, agregaremos la siguiente linea, la cual es la encargada como ya mencionamos de renderizar una vista parcial de la vista `movie`, de este modo podra recibir peticiones normales como peticiones AJAX.

```
render(:partial => 'movie', :object => @movie) if request.xhr?
```

![Alt text](image-4.png)


Además, debemos crear un archivo de vista parcial llamado _movie.html.erb para definir la presentación específica de una película cuando se realiza una solicitud AJAX en la acción `show` del controlador `MoviesController`. Este archivo estará ubicado en el directorio app/views/movies de nuestro proyecto y contendrá lo siguiente:

```html
<p> <%= movie.description %> </p>
<%= link_to 'Edit Movie', edit_movie_path(movie), :class => 'btn btn-primary' %>
<%= link_to 'Close', '', :id => 'closeLink', :class => 'btn btn-secondary' %>
```
![Alt text](image-6.png)

Reiterando, este archivo define cómo se mostrará la información de la película en el contexto de una solicitud AJAX.

**¿Cómo sabe la acción de controlador si show fue llamada desde código JavaScript o mediante una petición HTTP normal iniciada por el usuario?**

La acción del controlador `show` determina si fue llamada desde código JavaScript o mediante una petición HTTP normal iniciada por el usuario a través de la verificación de `request.xhr?`. La condición `if request.xhr?` verifica si la solicitud se realizó a través de XMLHttpRequest, comúnmente asociado con peticiones AJAX. 

### Parte 2

 **¿Cómo debería construir y lanzar la petición XHR el código JavaScript?**     
 
  Queremos que la ventana flotante aparezca cuando pinchamos en el enlace que tiene el nombre de la película.

Explica el siguiente código

```
var MoviePopup = {
  setup: function() {
    // add hidden 'div' to end of page to display popup:
    let popupDiv = $('<div id="movieInfo"></div>');
    popupDiv.hide().appendTo($('body'));
    $(document).on('click', '#movies a', MoviePopup.getMovieInfo);
  }
  ,getMovieInfo: function() {
    $.ajax({type: 'GET',
            url: $(this).attr('href'),
            timeout: 5000,
            success: MoviePopup.showMovieInfo,
            error: function(xhrObj, textStatus, exception) { alert('Error!'); }
            // 'success' and 'error' functions will be passed 3 args
           });
    return(false);
  }
  ,showMovieInfo: function(data, requestStatus, xhrObject) {
    // center a floater 1/2 as wide and 1/4 as tall as screen
    let oneFourth = Math.ceil($(window).width() / 4);
    $('#movieInfo').
      css({'left': oneFourth,  'width': 2*oneFourth, 'top': 250}).
      html(data).
      show();
    // make the Close link in the hidden element work
    $('#closeLink').click(MoviePopup.hideMovieInfo);
    return(false);  // prevent default link action
  }
  ,hideMovieInfo: function() {
    $('#movieInfo').hide();
    return(false);
  }
};
$(MoviePopup.setup);
```

## Explicacion del codigo: 

De forma general, se podria decir que el codigo permite mostrar detalles de películas en ventanas emergentes al hacer clic en enlaces dentro del elemento con el id `movies`, utilizando solicitudes AJAX para obtener la información de manera interactiva. A continuacion se dara una informacion detallada por fragmento para un mejor entendimiento del código.


El **método `setup`** de MoviePopup se encarga de preparar la ventana emergente.Se crea un elemento `div` oculto llamado 'movieInfo' al final de la página. Además, se establece un evento de clic para los enlaces dentro del elemento con el id 'movies', de modo que al hacer clic, se activa la función `MoviePopup.getMovieInfo`.

```javascript
setup: function() {
  let popupDiv = $('<div id="movieInfo"></div>');
  popupDiv.hide().appendTo($('body'));
  $(document).on('click', '#movies a', MoviePopup.getMovieInfo);
},
```

El **método `getMovieInfo`** maneja la obtención de detalles de la película al hacer clic en un enlace dentro del elemento 'movies'. Hace una solicitud AJAX de tipo GET al URL del enlace clicado y espera la respuesta. Si la solicitud es exitosa, invoca `MoviePopup.showMovieInfo` para mostrar la información en la ventana emergente. En caso de error, muestra una alerta.

```javascript
getMovieInfo: function() {
  $.ajax({
    type: 'GET',
    url: $(this).attr('href'),
    timeout: 5000,
    success: MoviePopup.showMovieInfo,
    error: function(xhrObj, textStatus, exception) { alert('Error!'); }
  });
  return false;
},
```

**La función `showMovieInfo`** se encarga de presentar la información de la película en la ventana emergente. Calcula la posición y el tamaño de la ventana basándose en el tamaño de la pantalla. Rellena el contenido del elemento '#movieInfo' con los datos recibidos y hace visible la ventana emergente. Además, agrega un evento de clic al enlace de cierre ('#closeLink') para cerrar la ventana emergente.

```javascript
showMovieInfo: function(data, requestStatus, xhrObject) {
  let oneFourth = Math.ceil($(window).width() / 4);
  $('#movieInfo').
    css({'left': oneFourth,  'width': 2*oneFourth, 'top': 250}).
    html(data).
    show();
  $('#closeLink').click(MoviePopup.hideMovieInfo);
  return false;
},
```

**El método `hideMovieInfo`** simplemente oculta la ventana emergente al hacer clic en el enlace de cierre ('#closeLink'). Proporciona una manera sencilla de cerrar la presentación de la película.

```javascript
hideMovieInfo: function() {
  $('#movieInfo').hide();
  return false;
},
```
Este fragmento final $(MoviePopup.setup); se encarga de ejecutar la configuración inicial del objeto `MoviePopup` cuando el documento está completamente cargado.

```javascript
$(MoviePopup.setup);
```
Después de comprender la lógica y funcionamiento del código, procederemos a su implementación en nuestro proyecto. Creamos un archivo llamado  `movie_popup.js` ubicado en el directorio app/javascript/ 

![Alt text](image-7.png)

Adicionalmente, se ajustó el método `show` en el controlador `movies_controller.rb` para que, al recibir una solicitud XMLHttpRequest (`request.xhr?`), renderice el parcial '_partial_show' ubicado en el directorio 'movies'. 

![Alt text](image-9.png)

Este parcial, denominado `_partial_show.html.erb`, ha sido creado para contener la presentación específica de la película, incorporando elementos como el título y enlaces para editar y cerrar la ventana emergente.

![Alt text](image-10.png)


Para lograr que la ventana emergente tenga un comportamiento visual más atractivo, utilizaremos CSS para definir su posición. Añadiremos el siguiente código en el archivo app/assets/stylesheets/application.css:

```css
#movieInfo {
  padding: 2ex;
  position: absolute;
  border: 2px double grey;
  background: wheat;
}

```
![Alt text](image-8.png)


Estos cambios preparan la visualización exitosa de la ventana emergente al hacer clic en un enlace relacionado con una película específica.

![Alt text](image-11.png)



 

### Parte 3

Conviene mencionar una advertencia a considerar cuando se usa JavaScript para crear nuevos elementos dinámicamente en tiempo de ejecución, aunque no surgió en este ejemplo en concreto. Sabemos que `$(’.myClass’).on(’click’,func)` registra `func` como el manejador de eventos de clic para todos los elementos actuales que coincidan con la clase CSS myClass. Pero si se utiliza JavaScript para crear nuevos elementos que coincidan con `myClass` después de la carga inicial de la página y de la llamada inicial a `on`, dichos elementos no tendrán el manejador asociado, ya que `on` sólo puede asociar manejadores a elementos existentes. 

¿Cuál es solución que brinda jQuery  a este problema? 

jQuery aborda una posible soluacion a este problema mediante la "delegación de eventos". En lugar de asignar directamente el manejador a los elementos específicos, se asigna a un elemento contenedor existente que envuelve a los elementos dinámicos. Por ejemplo:

```javascript
$('#container').on('click', '.myClass', function() {
  
});
```
En este enfoque, `#container` es un elemento que ya existe en el DOM y actúa como el contenedor para los elementos dinámicos con la clase `.myClass`. Esto permite que los eventos sean gestionados incluso por elementos generados dinámicamente después de la carga inicial de la página.