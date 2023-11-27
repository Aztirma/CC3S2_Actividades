
# Testing Java Script y Ajax

Para empezar a utilizar [Jasmine](https://jasmine.github.io/), añadimos `gem jasmine` en nuestro  Gemfile y ejecutamos bundle install como siempre; después, ejecuta los comandos siguientes desde el directorio raíz de su aplicación.


```
rails generate jasmine_rails:install 
mkdir spec/javascripts/fixtures 
curl https://raw.githubusercontent.com/velesin/jasmine-jquery/master/lib/jasmine-jquery.js
    > spec/javascripts/helpers/jasmine-jquery.js 
git add spec/javascripts 
```

No podemos ejecutar un conjunto de pruebas Jasmine completamente vacío, así que crea el fichero `spec/javascripts/basic_check_spec.js` con el siguiente código: 

```
describe ('Jasmine basic check', function() { 
    it('works', function() { expect(true).toBe(true); }); 
}); 
```
Para ejecutar pruebas de Jasmine, simplemente inicia tu aplicación con el comando `rails server` y, una vez que se esté ejecutando, busca el subdirectorio `spec` de tu aplicación (por ejemplo, `http://localhost:3000/specs` si desarrollas la actividad en tu propia computadora) para ejecutar todas las especificaciones y ver los resultados. 
