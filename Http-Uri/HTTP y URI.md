# HTTP y URI


# **Comprendiendo Request y Response**

Primero se procedio a hechar un vistazo al contenido de la pagina web señalada en la actividad, la cual trabajaremos en funcion de ella.

![Alt text](<Imagenes HTTP y URI/Untitled.png>)

El objetivo de esta actividad es el uso de de las herramientas de lineas de comandos **curl** y **nc**.

Es por eso que empezaremos haciendo uso del comando curl en nuestro terminal.

![Alt text](<Imagenes HTTP y URI/Untitled 1.png>)

Como se puede observar el uso de este comando mismo nos permito obtener datos del servidor web, esta información es la respuesta HTML que recibe del servidor web.

Siguiendo con la actividad, el siguiente paso será guardar el contenido obtenido en un archivo llamado *pagina_random_words.html* como se observa a continuación:

![Alt text](<Imagenes HTTP y URI/Untitled 2.png>)

Una vez guardado nuestro archivo en nuestro ordenador, abriremos el archivo para obtener una vista previa 

![Alt text](<Imagenes HTTP y URI/Untitled 3.png>)

**Pregunta: ¿Cuáles son las dos diferencias principales que has visto anteriormente y lo que ves en un navegador web 'normal'? ¿Qué explica estas diferencias?**

Cuando accedemos al archivo a través de nuestro navegador podemos observar que no se observa la imagen que si aparece cuando acedemos en nuestro navegador web “normal”. La diferencia se debe a que **`curl`** solo muestra el contenido HTML de la página y no carga activamente recursos externos como imágenes.

Además que al solo guardar una respuesta del servidor tan solo muestra una palabra, en ese caso unusual, en cambio al momento de recargar la pagina en el navegador web “normal” esta si cumple la funcion de generar palabras aleatorias continuamente, cosa que el archivo que guardamos tan solo genera. Esta diferencia se debe a que el servidor web que responde a la solicitud de **`curl`** proporciona una sola palabra en la respuesta, mientras que el navegador web "normal" está diseñado para interactuar con la página y solicitar nuevas palabras aleatorias de forma periódica.

Siguiendo con la actividad, ahora se procedera a hacernos pasar por un servidor Web escuchando el puerto 8081: `nc -l 8081`.

![Alt text](<Imagenes HTTP y URI/Untitled 4.png>)

**Pregunta: Suponiendo que estás ejecutando curl desde otro shell ¿qué URL tendrás que pasarle a curl para intentar acceder a tu servidor falso y por qué?**

Para acceder a nuestro servidor falso tendremos que usar la siguiente URL: http://localhost:8081

Ahora accederemos a nuestro servidor “falso”, este recibira la solicitud de cliente HTTP.

![Alt text](<Imagenes HTTP y URI/Untitled 5.png>)

**Pregunta: La primera línea de la solicitud identifica qué URL desea recuperar el cliente. ¿Por qué no ves `http://localhost:8081` en ninguna parte de esa línea?**

Por que es redundante , ya que el cliente envía una solicitud en su propia maquina(localhost) en el puerto especifico, por eso no necesita especificar la URL completa en la solicitud. El servidor ya sabe que está en "localhost" y en el puerto "8081" debido a cómo se configuró previamente, por lo que no es necesario repetirlo en la solicitud.

Prueba `curl --help` para ver la ayuda y verificar que la línea de comando `curl -i 'http://randomword.saasbook.info'` mostrará ambos (BOTH) encabezados de respuesta del servidor y(AND) luego el cuerpo de la respuesta.

![Alt text](<Imagenes HTTP y URI/Untitled 6.png>)

**Pregunta: Según los encabezados del servidor, ¿cuál es el código de respuesta HTTP del servidor que indica el estado de la solicitud del cliente y qué versión del protocolo HTTP utilizó el servidor para responder al cliente?**

Según el encabezado el código de respuesta que indica el estado de solicitud del cliente es el siguiente HTTP/1.1 200 OK donde

- "HTTP/1.1" indica la versión del protocolo HTTP que se está utilizando
- "200" es el código de estado HTTP, que en este caso es "OK." El código "200 OK" indica que la solicitud del cliente se ha procesado correctamente, y el servidor está devolviendo una respuesta exitosa.

**Pregunta: Cualquier solicitud web determinada puede devolver una página HTML, una imagen u otros tipos de entidades. ¿Hay algo en los encabezados que crea que le dice al cliente cómo interpretar el resultado?.**

![Alt text](<Imagenes HTTP y URI/Untitled 7.png>)

Si hay algo en los encabezados que contiene información que el cliente necesita para interpretar el contenido. Por ejemplo, en el caso de encabezado "Content-Type" especifica el tipo de entidad devuelta, como HTML, imágenes o archivos de texto. Esta información permite al cliente, como un navegador web, procesar y mostrar adecuadamente el contenido. 

# **¿Qué sucede cuando falla un HTTP request?**

**Pregunta: ¿Cuál sería el código de respuesta del servidor si intentaras buscar una URL inexistente en el sitio generador de palabras aleatorias? Prueba esto utilizando el procedimiento anterior.**

![Alt text](<Imagenes HTTP y URI/Untitled 8.png>)

Como se puede observar en la imagen, si escribimos una URL inválida con nuestro comando curl nos da como respuesta "HTTP/1.1 404 Not Found”, lo que indica que no encontró la pagina en el servidor. El código de estado "404" significa "No encontrado," lo que puede significar que la URL específica no existe en el servidor lo cual es correcto pues buscamos una URL inexistente.

**¿Qué otros códigos de error HTTP existen? Utiliza Wikipedia u otro recurso para conocer los significados de algunos de los más comunes: `200`, `301`, `302`, `400`, `404`, `500`. Ten en cuenta que estas son `familias` de estados: todos los estados 2xx significan `funcionó`, todos los 3xx son `redireccionar` etc.**

| Código de Estado | Familia | Significado |
| --- | --- | --- |
| 200 OK | 2xx | La solicitud se realizó con éxito. |
| 301 Moved Permanently | 3xx | La página o recurso se ha movido permanentemente a una nueva ubicación. |
| 302 Found (o 307 Temporary Redirect) | 3xx | La página o recurso se ha movido temporalmente a una nueva ubicación. |
| 400 Bad Request | 4xx | La solicitud del cliente es incorrecta o está mal formada. |
| 404 Not Found | 4xx | El servidor no pudo encontrar la página o recurso solicitado. |
| 500 Internal Server Error | 5xx | El servidor encontró un error interno al procesar la solicitud. |

Tanto el encabezado `4xx` como el `5xx` indican condiciones de error. **¿Cuál es la principal diferencia entre `4xx` y `5xx`?.**

Los códigos de estado HTTP 4xx y 5xx indican dos tipos de errores diferentes. Los 4xx son errores del cliente, es decir, que el cliente hizo algo mal, como escribir una URL incorrecta o no tener permiso para acceder a un recurso. A comparación de los 5xx que son errores del servidor, es decir, que el servidor no pudo procesar la solicitud correctamente, como por ejemplo porque la aplicación se cayó o no tenía recursos suficientes.

# **¿Qué es un cuerpo de Request?**

A continuación, crearemos un formulario HTML para que se pueda ver cómo se ve un formulario publicado en un servidor web.

Siguiendo la guía, iniciamos nuevamente ncat -l 8081, para escuchar en el puerto 8081

![Alt text](<Imagenes HTTP y URI/Untitled 9.png>)

Ahora guardaremos el siguiente archivo, el cual nombraremos *login.html*

```
 <!DOCTYPE html>
  <html>
  <head>
    </head>
    <body> <form method="post" action="Url-servidor-falso">
      <label>Email:</label>
       <input type="text" name="email">
        <label>Password:</label>
        <input type="password" name="password">
        <input type="hidden" name="secret_info" value="secret_value">
        <input type="submit" name="login" value="Log In!">
      </form>
    </body>
  </html>
```

**Pregunta:** Cuando se envía un formulario HTML, se genera una solicitud HTTP `POST` desde el navegador. Para llegar a tu servidor falso, ¿con qué URL deberías reemplazar `Url-servidor-falso` en el archivo anterior?

En el archivo anterior se debe reemplazar `Url-servidor-falso`  por  `http://localhost:8081` en el formmulario, ya que se esta utilizando ncat en nuestra maquina para crear un servidor en dicho puerto.

Una vez reemplazado, abrimos nuestro archivo html para poder visualizar su contenido:

![Alt text](<Imagenes HTTP y URI/Untitled 10.png>)

Al cambiar de servidor y autenticarnos, veremos que se ha creado un nuevo post, como respuesta, en el estado del servidor.

![Alt text](<Imagenes HTTP y URI/Untitled 11.png>)

Esto quiere decir que se ha enviado la información del servidor y este esta recibiendo los datos para procesarlos.

**Pregunta:¿Cómo se presenta al servidor la información que ingresó en el formulario?** 

La información se presenta al servidor en forma de datos en el cuerpo de la solicitud HTTP POST. Estos datos se envían al servidor en el cuerpo de la solicitud después de que el cliente haya completado el formulario y lo haya enviado.

 **¿Qué tareas necesitaría realizar un framework SaaS como Sinatra o Rails para presentar esta información en un formato conveniente a una aplicación SaaS escrita, por ejemplo, en Ruby?**

Un framework SaaS como Sinatra o Ruby on Rails se encargaría de recibir los datos enviados desde un formulario HTML, procesarlos según las necesidades  como autenticar usuarios o almacenar información en una base de datos, y luego generar una respuesta, como una página web o datos en formato JSON, que se presenta al usuario.

Repetimos el experimento varias veces y respondamos las siguientes preguntas:

- ¿Cuál es el efecto de agregar parámetros `URI` adicionales como parte de la ruta `POST`?
    
    Los parámetros URI adicionales en una ruta POST no tienen ningún efecto en los datos que se envían en la solicitud. Sin embargo, pueden ser útiles para proporcionar información adicional sobre la solicitud.
    
- ¿Cuál es el efecto de cambiar las propiedades de nombre de los campos del formulario?
    
    Para este caso, se hizo un cambio en el atributo **name** de un campo del formulario
    
    Sin cambios:
    
    ![Alt text](<Imagenes HTTP y URI/Untitled 12.png>)
    
    Con cambios:
    
    ![Alt text](<Imagenes HTTP y URI/Untitled 13.png>)
    
    Cambiar las propiedades de nombre de los campos en un formulario HTML afecta cómo se identifican y procesan los datos enviados por el formulario en el servidor.
    
- ¿Puedes tener más de un botón `Submit`? Si es así, ¿cómo sabe el servidor en cuál se hizo clic? (Sugerencia: experimenta con los atributos de la etiqueta `<submit>`).
    
    Para este caso, se agrego una nueva linea  que incluye `<input type="submit" name="register" value="Register">`, lo cual nos proporciona un botón adicional.
    
    ![Alt text](<Imagenes HTTP y URI/Untitled 14.png>)
    
    Cuando un usuario hace clic en uno de estos botones y envía el formulario, el servidor puede verificar el nombre del botón en la solicitud para saber qué acción se desea realizar. Esto permite al servidor responder de manera adecuada según la elección del usuario.
    
- ¿Se puede enviar el formulario mediante `GET` en lugar de `POST`? En caso afirmativo, ¿cuál es la diferencia en cómo el servidor ve esas solicitudes?
    
    Para este caso, realizaremos una modificación en la línea **`<body> <form method="get">`**.
    
    GET:
    
    ![Alt text](<Imagenes HTTP y URI/Untitled 15.png>)
    
    POST:
    
    ![Alt text](<Imagenes HTTP y URI/Untitled 16.png>)
    
    Respondiendo a las preguntas, es posible enviar el formulario utilizando el método **`GET`** en lugar de **`POST`.** Sin embargo, como se puede observar en ambas imágenes, hay una diferencia significativa en cómo se transmiten los datos del formulario. En el caso de la solicitud **`GET`**, los datos del formulario se muestran en la URL, mientras que en la solicitud **`POST`**, los datos se envían en el cuerpo de la solicitud.
    
- ¿Qué otros verbos `HTTP` son posibles en la ruta de envío del formulario? ¿Puedes hacer que el navegador web genere una ruta que utilice `PUT`, `PATCH` o `DELETE`?.
    
    Además de GET y POST, también se pueden usar PUT, PATCH y DELETE en las rutas de envío de formularios.
    
    Para usar estos verbos, se puede establecer la propiedad `method` del elemento `form` o el atributo `data-method`.
    

# **HTTP sin estados y cookies**

Nos piden probar las dos primeras operaciones `GET`. El cuerpo de la respuesta para la primera debe ser `"Logged in: false"` y para la segunda `"Login cookie set"`. 

Ejecutamos el comando curl con la URL proporcionada para realizar la primera operación GET, a cual verifica si el usuario ha iniciado sesión.

![Alt text](<Imagenes HTTP y URI/Untitled 17.png>)

En la salida de este comando se puede observar los encabezado de solicitud y respuesta.

Luego ejecutamos el siguiente comando para la segunda operación GET, la cual establece una cookie.

![Alt text](<Imagenes HTTP y URI/Untitled 18.png>)

**Pregunta: ¿Cuáles son las diferencias en los encabezados de respuesta que indican que la segunda operación está configurando una cookie?**

La diferencia en los encabezados es que en la segunda operación GET se encuentra un encabezado "Set-Cookie", lo cual indica la configuración de una cookie, mientras que en la primera operación GET no. Además, el cuerpo de la respuesta de la segunda operación incluye la frase "Login cookie set", lo cual significa que se estableció una cookie, a diferencia de la primera operación.

**Pregunta: Bien, ahora supuestamente `"logged in"` porque el servidor configuró una cookie que indica esto. Sin embargo, si intenta`GET /` nuevamente, seguirá diciendo `"Logged: false"`. ¿Qué está sucediendo? (Sugerencia: `usa curl -v` y observa los encabezados de solicitud del cliente).**

La respuesta de la aplicación continúa mostrando 'Logged in: false' después de haber ejecutado la segunda operación GET para configurar la cookie. A pesar de haber iniciado sesión, esto podría deberse a varias razones posibles, como problemas en la configuración de la cookie, restricciones de dominio y ruta, expiración de la cookie o problemas en el manejo de cookies en el servidor.

![Alt text](<Imagenes HTTP y URI/Untitled 19.png>)

Para solucionar este problema, tenemos que decirle a curl que almacene las cookies relevantes que envía el servidor, para que sepa incluirlas en futuras solicitudes a ese servidor.

Siguiendo con la actividad probamos `curl -i --cookie-jar cookies.txt http://esaas-cookie-demo.herokuapp.com/login` 

![Alt text](<Imagenes HTTP y URI/Untitled 20.png>)

Ahora verificamos que el archivo `cookies.txt` recién creado contenga información sobre la cookie que coincida con el encabezado `Set-Cookie` de el servidor.

![Alt text](<Imagenes HTTP y URI/Untitled 21.png>)

**Pregunta:** Al observar el encabezado `Set-Cookie` o el contenido del archivo `cookies.txt`, parece que podría haber creado fácilmente esta cookie y simplemente obligar al servidor a creer que ha iniciado sesión. En la práctica, ¿cómo evitan los servidores esta inseguridad?

Los servidores evitan la inseguridad en las cookies mediante firmas, tokens de sesión únicos, control de sesiones activas y políticas de expiración. Además, establecen restricciones de seguridad en el dominio y la ruta de las cookies. Estas medidas protegen contra ataques de suplantación de identidad y aseguran la seguridad de las sesiones de usuario.
