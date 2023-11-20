## Java Script
La comunidad de JavaScript ha florecido en los últimos años y frameworks como [React](https://react.dev/) y [Node.js](https://nodejs.org/en) hacen posible escribir aplicaciones completas en JavaScript. Nos centraremos principalmente en el lenguaje JavaScript, AJAX, DOM y Eventos/Callback. 

### Preguntas conceptuales

**En JavaScript, todas las operaciones de red son asíncronas. ¿Porque es esto importante?** 

La asincronicidad significa que si JavaScript tiene que esperar a que se complete una operación, ejecutará el resto del código mientras espera. Esto es crucial para que se garantice que las operaciones de red no bloqueen mantenido asi la capacidad de respuesta.
Ya que si llega a bloquearse dichas operaciones la interfaz de usuario se volvería no receptiva y parecería congelada hasta que la operación de red termine.  

**En Javascript, queremos realizar acciones tras una operación/solicitud de red completa. ¿Qué paradigma de programación hace esto posible?**

El paradigma que permite realizar acciones tras una operacion de red completa es el paradigma de programacioon orientada a eventos, esto permite manejar acciones después de completarse operaciones asíncronas.

**¿Javascript proporciona soporte limitado para la herencia a través de qué mecanismo?**
Mecanismo de 

....


**¿Qué es el DOM? ¿Qué librería nos ayuda a usar Javascript para manipular el DOM?**

Document Objet Model, es una representacion estructurada de documentos HTML/XML,nos proporciona una interfaz que JavaScript utiliza para trabajar dinamicamente su estructura, contenido y estilo de documento.


### ¿Qué puede hacer Javascript ?

Al igual que Ruby, Javascript sigue de cerca el paradigma de "todo es un objeto" con un par de excepciones. La breve lista de primitivas incluye `String`, `Númber`, `undefined` (sin valor), `null` (diferente de `undefined`), Booleano y `BigInt`. Además, al igual que Ruby, los valores de JavaScript se escriben dinámicamente, por lo que las declaraciones de variables están precedidas por `var` o `let`, en lugar de tipos.

Dicho esto, Javascript tiene muchas idiosincrasias interesantes que vale la pena considerar. Para codificar eficazmente en Javascript, vale la pena familiarizarse con estas peculiaridades. En esta sección, repasaremos varios de ellos con un conjunto más que familiar de preguntas sobre "¿Qué haría Javascript?".

#### Booleano

Debido a cómo se escriben las variables de forma dinámica y flexible, hay valores que evalúan `True/False` cuando se convierten en Booleanos, pero cuando se comparan entre sí, pueden evaluarse o no como verdaderos.

Hay siete valores "Falsy" en Javascript. "Falsy" significa que se evalúan como falso en condicionales: `0` (`Number`), `0n` (`BigInt`), `null` (palabra clave), `undefined` (palabra clave), `false` (Booleano), `NaN` (`Number`), "" (`String`). Sin embargo, estos valores no son necesariamente iguales entre sí.

Para verificar tu comprensión, completa estas preguntas:

* `undefined == null`
* `NaN == NaN`
* `null == false`
* `0 == false`
* `"" == false`

¡Las comparaciones booleanas son complicadas! 1, Recomendamos usar métodos de comparación integrados en lugar de `==` o `===` 2. Evita comparar diferentes tipos. 3. Convierte explícitamente los tipos a Booleanos cuando sea necesario.

Para realizar esta actividad de aqui, abriremos una consola en Node en VisualStudioCode y comprarobaremos las lineas de código, asi como se observa a continuacion y veremos que es lo que nos devuelve cada sentenia

![Alt text](image.png)

Tambien creamos un archivo llamado Ejercicio1, donde se encuentran las mismas sentencias y corroboramos que nos devuelve los mismos resultados

![Alt text](image-1.png)

![Alt text](image-2.png)

Ahora explicaremos cada salida


#### Arrays

Los arrays son una de las estructuras de datos centrales en Javascript, pero se comportan de maneras interesantes. En este ejercicio, veremos algunos de los comportamientos relativamente extraños de las operaciones tradicionales con arrays. ¡Trata de justificar también por qué ese comportamiento es así!.

* `[1, 2, 3] + [4, 5, 6]`
* `!![]`
* `[] == true`
* `[10, 1, 3].sort()`
* `[] == 0​`

#### Clausuras

Un paradigma popular en Javascript es el uso de clausuras. Al igual que las funciones de orden superior en Python, las clausuras son combinaciones de una función agrupada con referencias a su estado circundante. Las clausuras le dan acceso al alcance de una función externa desde una función interna. Determina la salida del siguiente código.

```
function f1(x) {
  var baz = 3;
  return function (y) {
    console.log(x + y + (baz++));
    }
}
var bar = f1(5);
bar(11);
```
#### Algoritmos

La siguiente función encuentra el mayor número dentro de un array, pero tiene una eficiencia de `O(N2)`. Reescribe la función para que se convierta en una `O(N)``más rápida:

```
def greatestNumber(array):
   for i in array:
     isIValTheGreatest = True
     for j in array:
      if j > i:
         isIValTheGreatest = False
    if isIValTheGreatest:
      return i
```

La siguiente función devuelve si hay o no una “X” mayúscula dentro de una cadena.

```
function containsX(string) {
  foundX = false;
  for(let i = 0; i < string.length; i++) {
   if (string[i] === "X") {
     foundX = true;
     }
   }
   return foundX;
  }
```

¿Cuál es la complejidad temporal de esta función en términos de notación O grande? Luego, modifica el código para mejorar la eficiencia del algoritmo en los mejores y promedios escenarios.

Escribe una función que devuelva el primer carácter no duplicado de una cadena. Por ejemplo, la cadena "mínimum" tiene dos caracteres que solo existen una vez: la "n" y la "u", por lo que su función debería devolver la "n", ya que aparece primero. La función debe tener una eficiencia de `O(N)`.

#### Clases

Practiquemos la herencia y la programación orientada a objetos en Javascript. Diseñe 2 clases, una llamada "Pokemon" y otra llamada "Charizard". Las clases deben hacer lo siguiente:

Clase Pokémon:

- El constructor toma 3 parámetros (HP, ataque, defensa)
- El constructor debe crear 6 campos (HP, ataque, defensa, movimiento, nivel, tipo). Los valores de (mover, nivelar,
tipo) debe inicializarse en ("", 1, "").
– Implementa un método `flight` que arroje un error que indique que no se especifica ningún movimiento.
– Implementa un método `canFly` que verifica si se especifica un tipo. Si no, arroja un error. Si es así, verifica si el tipo incluye "volar". En caso afirmativo, devuelve verdadero; si no, devuelve falso.

Clase Charizard:

– El constructor toma 4 parámetros (HP, ataque, defensa, movimiento)
– El constructor configura el movimiento y el tipo (para "disparar/volar") además de establecer HP, ataque y defensa como el
constructor de superclase.
– Sobreescribe el método `fight`. Si se especifica un movimiento, imprime una declaración que indique que se está utilizando el movimiento y devuelve el campo de ataque. Si no, arroja un error.
