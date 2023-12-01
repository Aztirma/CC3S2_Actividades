
# Testing Java Script y Ajax


## Paso 1: Configuración inicial

Para empezar a utilizar [Jasmine](https://jasmine.github.io/), añadimos `gem jasmine` en nuestro  Gemfile y ejecutamos bundle install como siempre; después, ejecuta los comandos siguientes desde el directorio raíz de su aplicación.

![Alt text](image.png)
Una vez escrita la gema que nesecitamos en nuestro archivo gemfile, para que se instale escribimos el siguiente comando:

```
bundle install
```

Como se puede observar en la siguiente imagen, se instalo correctamente la gema Jasmine.

![Alt text](image-1.png)

A continuación, ejecutamos los siguientes comandos desde el directorio raíz de nuestra aplicación:

```
rails generate jasmine:install 
```

![Alt text](image-2.png)

Creamos el directorio para los fixtures de Jasmine con:


```
mkdir spec/javascripts/fixtures 
```

![Alt text](image-3.png)

## Paso 2: Creación de una prueba básica

Creamos el archivo `spec/javascripts/basic_check_spec.js` con el siguiente contenido:

   ```javascript
   describe('Jasmine basic check', function() {
     it('works', function() {
       expect(true).toBe(true);
     });
   });
   ```

Como se observa a continuación, el código 
![Alt text](image-4.png)

Una vez creado el conjunto de pruebas, agregamos `/= link boot0.js` en la ubicacion `app/assets/config/manifest.js`

![Alt text](image-7.png)

Además en la ubicacion `config/routes.` agregar la siguientes lineas de codigo para que coincida con la ruta `/spec` y que este configurada para manejar solicitudes GET.



Iniciamos nuestra aplicación con:

   ```bash
   rails server
   ```

![Alt text](image-5.png)
![Alt text](image-6.png)
Accedemos a las pruebas Jasmine en el navegador (por ejemplo, http://localhost:3000/specs) y verificamos que la prueba básica se ejecuta correctamente.

## Preguntas:

#### Pregunta 1: ¿Cuáles son los problemas que se tiene cuando se debe probar Ajax?. Explica tu respuesta.

Cuando probamos Ajax, nos enfrentamos a algunos problemas comunes, como la asincronía, el manejo de respuestas asíncronas y la dependencia de servicios externos.

#### Pregunta 2: ¿Qué son los stubs, espias y fixture en Jasmine para realizar pruebas de Ajax?

- **Stubs:** Son funciones que reemplazan las implementaciones originales de funciones para controlar su comportamiento durante las pruebas.
- **Espías:** Permiten rastrear llamadas a funciones y verificar su comportamiento.
- **Fixture:** Datos de prueba utilizados en las pruebas para simular el entorno de la aplicación.

#### Pregunta: Experimenta el siguiente código de especificaciones (specs) de Jasmine del camino feliz del código AJAX llamado `movie_popup_spec.js`.

Experimentamos con el código de especificaciones en `movie_popup_spec.js`.

 ```
describe('MoviePopup', function() {
  describe('setup', function() {
    it('adds popup Div to main page', function() {
      expect($('#movieInfo')).toExist();
    });
    it('hides the popup Div', function() {
      expect($('#movieInfo')).toBeHidden();
    });
  });
  describe('clicking on movie link', function() {
    beforeEach(function() { loadFixtures('movie_row.html'); });
    it('calls correct URL', function() {
      spyOn($, 'ajax');
      $('#movies a').trigger('click');
      expect($.ajax.calls.mostRecent().args[0]['url']).toEqual('/movies/1');
    });
    describe('when successful server call', function() {
      beforeEach(function() {
        let htmlResponse = readFixtures('movie_info.html');
        spyOn($, 'ajax').and.callFake(function(ajaxArgs) { 
          ajaxArgs.success(htmlResponse, '200');
        });
        $('#movies a').trigger('click');
      });
      it('makes #movieInfo visible', function() {
        expect($('#movieInfo')).toBeVisible();
      });
      it('places movie title in #movieInfo', function() {
        expect($('#movieInfo').text()).toContain('Casablanca');
      });
    });
  });
});
 ```
#### Pregunta: ¿Que hacen las siguientes líneas del código anterior?. ¿Cuál es el papel de spyOn de Jasmine y los stubs en el código dado.
 ```
it('calls correct URL', function() {
      spyOn($, 'ajax');
      $('#movies a').trigger('click');
      expect($.ajax.calls.mostRecent().args[0]['url']).toEqual('/movies/1');
    });
 ```
   - La primera línea utiliza `spyOn` para espiar la función `$.ajax` y luego verifica que la URL sea correcta después de hacer clic en un enlace.

   - Las siguientes líneas simulan una llamada exitosa al servidor y verifican la visibilidad del elemento `#movieInfo` y el contenido del mismo.


#### Pregunta 3:

Las líneas de código:

```javascript
spyOn($, 'ajax');
$('#movies a').trigger('click');
expect($.ajax.calls.mostRecent().args[0]['url']).toEqual('/movies/1');
```

Espían la llamada a `$.ajax`, simulan un clic en un enlace y verifican que la URL de la última llamada a `$.ajax` sea '/movies/1'.

#### Pregunta 4: ¿Que hacen las siguientes líneas del código anterior?.

Las líneas de código:

```javascript
 let htmlResponse = readFixtures('movie_info.html');
        spyOn($, 'ajax').and.callFake(function(ajaxArgs) { 
          ajaxArgs.success(htmlResponse, '200');
        });
        $('#movies a').trigger('click');
      });
      it('makes #movieInfo visible', function() {
        expect($('#movieInfo')).toBeVisible();
      });
      it('places movie title in #movieInfo', function() {
        expect($('#movieInfo').text()).toContain('Casablanca');

```

Simulan una llamada Ajax exitosa con datos simulados. Luego, las pruebas verifican la visibilidad de `#movieInfo` y si el título de la película está contenido en él. FALTA FALTA GALTA

### Verificación de la Función `setup`

Verificamos que la función `setup` en `movie_popup.js` se ejecute correctamente. Cargamos la página y confirmamos que el elemento `#movieInfo` se agregue y esté oculto.

#### Pregunta: Dado que Jasmine carga todos los ficheros JavaScript antes de ejecutar ningún ejemplo, la llamada a setup (línea 34 del codigo siguiente llamado `movie_popup.js`)ocurre antes de que se ejecuten nuestras pruebas, comprueba que dicha función hace su trabajo y muestra los resultados.

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

#### Pregunta 5: Indica cuales son los stubs y fixtures disponibles en Jasmine y Jasmine-jQuery.

- **Stubs en Jasmine:** Se utilizan con `spyOn` para controlar el comportamiento de funciones durante las pruebas.
- **Fixtures en Jasmine y Jasmine-jQuery:** Proporcionan datos de prueba y se cargan dentro de `div#jasmine-fixtures` para simular el entorno de la aplicación.

#### Pregunta 6:  Como en RSpec, Jasmine permite ejecutar código de inicialización y desmantelamiento de pruebas utilizando beforeEach y afterEach. El código de inicialización carga el fixture HTML mostrado en el código siguiente, para imitar el entorno que el manejador getMovieInfo vería si fuera llamado después de mostrar la lista de películas.

```
<div id="movies">
  <div class="row">
    <div class="col-8"><a href="/movies/1">Casablanca</a></div>
    <div class="col-2">PG</div>
    <div class="col-2">1943-01-23</div>
  </div>
</div>
```

En Jasmine, `beforeEach` y `afterEach` permiten ejecutar código de inicialización y desmantelamiento antes y después de cada prueba, respectivamente.

### Ejercicios

11. **Herencia de Prototipos y Métodos Privados en JavaScript:**

   Implementamos un constructor para objetos `User` que acepta un nombre de usuario y una contraseña. Proporcionamos un método `checkPassword` para verificar la contraseña sin revelarla.

12. **Identificación de Filas Ocultas:**

   Utilizando solo JavaScript del lado cliente, identificamos filas ocultas en una tabla sin modificar el código del servidor.

13. **Código AJAX para Menús en Cascada:**

   Escribimos código AJAX para crear menús en cascada basados en la asociación `has_many` en Rails.

14. **Extensión de Validación en ActiveModel:**

   Extendemos la función de validación en ActiveModel para generar automáticamente código JavaScript que valide las entradas del formulario antes de ser enviado.
