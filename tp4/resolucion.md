# Resolución del trabajo practico n4 de Introduccion a los Sistemas Operativos

## 1a. Beneficios de la memoria virtual

> Describa qué beneficios introduce este esquema de administración de la memoria.

La memoria virtual es una tecnica que permite a un proceso darle la ilusion de tener un espacio de direcciones contiguo y grande, aunque la memoria fisica (RAM) sea limitada.

Beneficios:

- Cada proceso tiene su propio espacio de direcciones, lo que mejora la seguridad y estabilidad del sistema.
- Permite la ejecucion de programas mas grandes que la memoria fisica disponible, cargando solo las paginas necesarias en memoria.
- Facilita la gestion de memoria, convirtiendo direcciones logicas en direcciones fisicas mediante tablas de paginas.
- Permite compartir paginas entre procesos (codigo compartido), reduciendo el uso de memoria.

## 1b. Implementacion

> ¿En que se debe apoyar el Kernel para su implementación?

Para implementar memoria virtual, el kernel se ayuda de ciertos componentes y estructuras como:

- Tablas de paginas (estructuras que mapean direcciones logicas a direcciones fisicas) y rutinas de kernel para manejar fallos de pagina.
- Hardware de MMU (Memory Management Unit) que traduce direcciones logicas a fisicas y maneja protecciones de memoria, y TLB (Translation Lookaside Buffer) para acelerar la traduccion de direcciones.
- Politicas de reemplazo de paginas y datos por entrada de pagina (como LRU, FIFO) para decidir que paginas sacar de memoria cuando es necesario.
  - Bits de validez: indican si una pagina esta en memoria fisica o no.
  - Referencia: indica si una pagina ha sido accedida recientemente.
  - Modificacion: indica si una pagina ha sido modificada (escribible) y necesita ser escrita de vuelta a disco.
  - Marco fisico: la direccion fisica donde se encuentra la pagina en memoria.

## 1c. Información adicional en la tabla de páginas

> Al implementar está técnica utilizando paginación por demanda, las tablas de páginas de un proceso deben contar con información adicional además del marco donde se encuentra la página. ¿Cuál es está información? ¿Por qué es necesaria?

La paginacion por demanda implica que las paginas no se cargan en memoria hasta que son accedidas por primera vez. Por lo tanto, la tabla de paginas debe incluir informacion adicional para manejar este esquema:

- Bit V (Validez): Indica si la pagina esta actualmente en memoria fisica. Si no está (bit en 0) hay que cargarla desde disco, lo que genera un fallo de pagina.
- Bit R (Referencia o Acceso/Uso): se setea cuando la CPU accede a la pagina (lectura o escritura). Indica si la pagina ha sido accedida recientemente. Esto ayuda a las politicas de reemplazo de paginas a decidir cuales paginas mantener en memoria, como LRU (Least Recently Used) o Second Chance.
- Bit M/D (Modificado/Sucio): Indica si la pagina ha sido modificada (escribible) desde que fue cargada en memoria. Si está en 1, significa que la pagina debe ser escrita de vuelta a disco antes de ser reemplazada, ya que contiene datos actualizados.
- Marco Fisico: numero de frame en memoria fisica donde se encuentra la pagina, solo si el bit V es 1.

Esta es la informacion necesaria para gestionar eficientemente la memoria virtual, se pueden agregar otros bits adicionales (opcionales) como:

- Bit de Proteccion: Indica los permisos de acceso (lectura, escritura, ejecucion) para la pagina. Esto ayuda a prevenir accesos no autorizados y proteger la memoria.
- Contador de Accesos: Lleva un registro del numero de veces que una pagina ha sido accedida. Esto puede ser util para politicas de reemplazo mas sofisticadas.
- Tiempo de Ultimo Acceso: Marca temporal del ultimo acceso a la pagina (timestamp). Esto puede ayudar a implementar politicas de reemplazo basadas en el tiempo.

## 2a. Cuando se produce un fallo de página

> ¿Cuándo se producen?

Un fallo de pagina ocurre cuando un proceso intenta acceder a una pagina que no esta actualmente cargada en memoria fisica. Bit V = 0. Esto puede suceder en las siguientes situaciones:

- La pagina nunca ha sido cargada en memoria (primera vez que se accede a ella).
- La pagina fue cargada anteriormente pero fue reemplazada (sacada de memoria) para hacer espacio para otras paginas.
- El proceso intenta acceder a una direccion logica que no esta mapeada en su tabla de paginas (acceso invalido).

## 2b. Responsable de detectar un fallo de página

> ¿Quién es responsable de detectar un fallo de página?

El hardware de la MMU (Memory Management Unit) es responsable de detectar un fallo de pagina. Cuando la CPU genera una direccion logica para acceder a memoria, la MMU traduce esa direccion logica a una direccion fisica utilizando la tabla de paginas del proceso. Si el bit V (validez) de la entrada correspondiente en la tabla de paginas es 0 (o no encuentra una entrada válida), la MMU detecta que la pagina no esta en memoria fisica y genera una interrupcion de fallo de pagina. Esta interrupcion es manejada por el kernel del sistema operativo, que se encarga de cargar la pagina faltante desde el almacenamiento secundario (disco) a la memoria fisica y actualizar la tabla de paginas en consecuencia.

## 2c. Acciones del Kernel ante un fallo de página

> Describa las acciones que emprende el Kernel cuando se produce un fallo de página.

Cuando se produce un fallo de pagina, es decir, el kernel recibe una interrupcion de fallo de pagina, realiza las siguientes acciones:

1. Guardar el estado del proceso actual (contexto) para poder reanudarlo despues.
2. Verificar si la referencia a la pagina es valida (si la direccion logica esta dentro del espacio de direcciones del proceso). Si no es valida, se genera una excepcion de acceso invalido (SIGSEGV / abort). SIGSEGV es una señal en sistemas Unix/Linux que indica una violación de segmento, es decir, un intento de acceder a una direccion de memoria que no esta permitida para el proceso.
3. Si la referencia es valida, el kernel debe determinar la pagina que se necesita cargar, basandose en la direccion logica que causo el fallo, y localizar su copia en el backing store (swap o archivo de paginacion en disco). El backing store es un espacio en disco utilizado para almacenar paginas que no caben en la memoria fisica.
4. Encontrar un marco libre en memoria fisica para cargar la pagina. Si no hay marcos libres, se debe seleccionar una pagina existente para reemplazarla (página victima) utilizando una politica de reemplazo de paginas (como LRU, FIFO, etc.).
5. Si la pagina victima ha sido modificada (bit M = 1), se debe escribir al dispositivo de paginacion (swap) antes de reemplazarla. Este proceso puede ser sincrono (el proceso espera a que se complete la escritura) o asincrono (el proceso continua y la escritura se realiza en segundo plano).
6. Leer la pagina requerida desde el backing store y cargarla en el marco fisico seleccionado.
7. Actualizar la tabla de paginas del proceso para reflejar que la pagina ahora esta en memoria fisica (bit V = 1), establecer el marco fisico correspondiente, y resetear los bits R y M segun corresponda.
8. Restaurar el estado del proceso y reiniciar la instruccion que causo el fallo de pagina, permitiendo que el proceso continue su ejecucion normalmente.

## 3 Conversion de direcciones logicas a fisicas sin procesar page faults

Datos:

- Tamaño de pagina: 512 bytes
- Cada direccion refrencia 1 byte
- Los marcos se encuentran contiguos en memoria fisica desde la direccion 0

### a. 1052

nro pagina: 1052 / 512 = 2
La entrada de la pagina 2 tiene bit V = 0, por lo tanto no existe una direccion fisica valida para esta direccion logica. Se produce un page fault.

### b. 2221

nro pagina: 2221 / 512 = 4
La entrada de la pagina 4 tiene bit V = 0, por lo tanto no existe una direccion fisica valida para esta direccion logica. Se produce un page fault.

### c. 5499

nro pagina: 5499 / 512 = 10
La pagina 10 no esta definida en la tabla de paginas, por lo tanto no existe una direccion fisica valida para esta direccion logica. Se produce un page fault o excepcion de acceso invalido.

### d. 3101

nro pagina: 3101 / 512 = 6
La pagina 6 no esta definida en la tabla de paginas, por lo tanto no existe una direccion fisica valida para esta direccion logica. Se produce un page fault o excepcion de acceso invalido.

## 4. Impacto del tamaño de página en paginación por demanda

> Analice cómo impacta el tamaño de una página (pequeña o grande) en paginación por demanda.

La paginacion por demanda consiste en cargar paginas en memoria solo cuando son necesarias, por lo tanto, que una pagina tenga un tamaño pequeño o grande tiene varios impactos:

- Páginas pequeñas:

  - Ventajas:

    - Mejor aprovechamiento de la memoria, ya que se cargan solo las partes necesarias del proceso. Produce menos fragmentacion interna que las paginas grandes, ya que es menos probable que se desperdicie espacio dentro de una pagina.
    - Mas granularidad en la gestion de memoria, permitiendo cargar y descargar paginas con mayor precision, es decir, solo las paginas que realmente se necesitan. Lo que produce potencialmente menos I/O de disco innecesario.

  - Desventajas:
    - Mayor cantidad de entradas en la tabla de paginas, lo que aumenta el overhead (sobrecarga) de gestion de memoria y puede requerir mas memoria para almacenar la tabla de paginas.
    - TLB menos efectivo, ya que hay mas paginas para mapear, lo que puede aumentar la tasa de fallos de TLB (misses) y reducir el rendimiento.
    - Mayor overhead en la gestion de fallos de pagina, ya que pueden ocurrir mas fallos de pagina debido a la mayor cantidad de paginas.

- Páginas grandes:

  - Ventajas
    - Menos overhead en la gestion de la tabla de paginas, ya que hay menos entradas que manejar. Esto produce un mejor rendimiento de la TLB, ya que hay menos paginas para mapear, lo que puede reducir la tasa de fallos de TLB (misses).
  - Desventajas:
    - Produce mas fragmentacion interna que las paginas pequeñas, ya que es mas probable que se desperdicie espacio dentro de una pagina grande.
    - Produce mas I/O de disco innecesario, ya que se cargan paginas completas aunque solo se necesite una pequeña parte de ellas. Esto puede llevar a un mayor numero de fallos de pagina si el proceso accede a muchas paginas diferentes.

Por lo tanto, la eleccion del tamaño de pagina debe balancear estos factores para optimizar el rendimiento del sistema segun el workload (carga de trabajo), tamaño de TLB y coste de I/O.

La carga de trabajo (workload) se refiere al tipo y cantidad de operaciones que un sistema debe manejar. Diferentes cargas de trabajo pueden beneficiarse de diferentes tamaños de pagina. Por ejemplo, aplicaciones que acceden a grandes bloques de datos secuencialmente pueden beneficiarse de paginas grandes, mientras que aplicaciones con acceso aleatorio a pequeños bloques de datos pueden beneficiarse de paginas pequeñas.

## 5a. Asignacion fija vs asignacion dinamica

> Con la memoria paginada, no se requiere que todas las paginas de una proceso se encuentren en memoria. El kernel es el que debe controlar cuantas paginas de un proceso puede tener en memoria pricipal. Existen dos politicas que se pueden utilizar: asignacion fija y asignacion dinamica. Describa como trabajan ambas politicas.

- Asignación fija: esta politica asigna un numero fijo de frames a cada proceso. No cambia en tiempo de ejecucion. Existen 2 formas de repartir
  los frames inicialmente:

  - Reparto equitativo: cada proceso recibe la misma cantidad de frames. **M / N**, donde M es el numero total de frames y N es el numero de procesos.

  - Reparto proporcional: cada proceso recibe una cantidad de frames proporcional a su tamaño. **Frames asignados = total de frames \* (paquinas requeridas por el proceso / total de paginas de todos los procesos)**, ajustado al entero mas cercano.

- Asignación dinámica: esta politica permite que el numero de frames asignados a un proceso cambie en tiempo de ejecucion, segun sus demandas.
  Si un proceso necesita mas frames, sube su working set (conjunto de paginas activas) y el kernel puede asignarle mas frames si hay disponibles o tomar frames de otros procesos si se usa una reemplazo global.

  El working set es el conjunto de paginas que un proceso ha accedido recientemente y que probablemente necesitara en el futuro cercano. Mantener el working set en memoria ayuda a reducir los fallos de pagina y mejorar el rendimiento del proceso.

  Existen varias estrategias para la asignacion dinamica:

  - Reemplazo local: cada proceso solo puede usar los frames que le fueron asignados inicialmente. Si necesita mas, debe esperar a que libere alguno.
  - Reemplazo global: los procesos pueden competir por todos los frames disponibles en el sistema. Si un proceso necesita mas frames, puede tomar frames de otros procesos si es necesario.

## 5b. Ejercicio de asignacion de marcos a procesos

Datos:

- Total de marcos: 40

- P1: 15 paginas
- P2: 20 paginas
- P3: 20 paginas
- P4: 8 paginas

### a. Asignacion fija - reparto equitativo

- Total de procesos: 4
- Marcos por proceso: total de marcos / total de procesos = 40 / 4 = 10 marcos por proceso

### b. Asignacion fija - reparto proporcional

- Frames_i = total de frames \* (paginas requeridas por el proceso / total de paginas de todos los procesos)
- Total de paginas: 15 + 20 + 20 + 8 = 63 paginas

- P1: 40 \* (15 / 63) = 9.52 ≈ 9 marcos
- P2: 40 \* (20 / 63) = 12.69 ≈ 12 marcos
- P3: 40 \* (20 / 63) = 12.69 ≈ 12 marcos
- P4: 40 \* (8 / 63) = 5.08 ≈ 5 marcos

9 + 12 + 12 + 5 = 38 marcos asignados, quedan 2 marcos libres que se pueden distribuir segun la parte fraccinaria:

- Los procesos P2 y P3 son los que tienen la parte fraccionaria mas cercana al entero siguiente, por lo tanto distribuimos 1 marco extra a cada uno.
- P1: 9 marcos
- P2: 13 marcos
- P3: 13 marcos
- P4: 5 marcos

- Total: 40 marcos

## 5c. Eficiencia de los repartos

> ¿Cuál de los 2 repartos usados en b) resultó más eficiente? Justifique

El reparto proporcional resultó más eficiente que el reparto equitativo. Esto se debe a que en el reparto proporcional, cada proceso recibe una cantidad de marcos basada en su tamaño y necesidades reales. Procesos más grandes (con más páginas) reciben más marcos, lo que les permite mantener un conjunto de trabajo adecuado en memoria y reducir la cantidad de fallos de página.

## 6a. Clasificación de algoritmos de reemplazo de páginas

> Clasifique los siguientes algoritmos de malo a bueno de acuerdo a la tasa de fallos de pagina que se obtienen al utilizarlos: LRU, FIFO, Optimo y Segunda Chance.

- FIFO (First In First Out): Selecciona la pagina que ha estado en memoria por mas tiempo para ser reemplazada. No considera el uso reciente, lo que puede llevar a una alta tasa de fallos de pagina en ciertos patrones de acceso (**malo**). Puede sufrir del problema de Belady anomaly en algunos casos. Belady anomaly es un fenomeno donde aumentar el numero de marcos asignados a un proceso puede aumentar la tasa de fallos de pagina, lo cual es contraintuitivo.

- Segunda Chance: Una mejora de FIFO que da una "segunda oportunidad" a las paginas que han sido referenciadas recientemente. Si la pagina tiene el bit R en 1, se le da una segunda oportunidad y se mueve al final de la cola. Esto reduce la tasa de fallos de pagina en comparacion con FIFO (**regular**).

- LRU (Least Recently Used): Reemplaza la pagina que ha sido usada menos recientemente. Considera el uso reciente de las paginas, lo que generalmente resulta en una tasa de fallos de pagina mas baja que FIFO y Segunda Chance (**bueno**). Sin embargo, puede ser costoso de implementar debido al seguimiento del orden de uso. Recencia es una medida de cuan recientemente una pagina ha sido accedida. Se utiliza para determinar cuales paginas son mas probables de ser necesitadas en el futuro cercano.

- OPT (Optimo): Reemplaza la pagina que no sera usada por el periodo mas largo en el futuro. Es el algoritmo ideal con la tasa de fallos de pagina mas baja posible. Teoricamente es el mejor (**bueno**), pero es imposible de implementar en tiempo real sin conocimiento previo del futuro.

## 6b. Análisis de algoritmos de reemplazo de páginas

> Analice el funcionamiento de cada uno de los algoritmos mencionados en el punto anterior. ¿Cómo se podrían implementar?

- FIFO: Se puede implementar utilizando una cola de frames. Cuando se necesita reemplazar una pagina, se saca la pagina al frente de la cola (la que ha estado mas tiempo en memoria) y se inserta la nueva pagina al final de la cola.

- Segunda Chance: Se puede implementar utilizando la misma estrategia que FIFO, pero chequeando el bit R de la pagina al frente de la cola. Si el bit R es 1, se resetea a 0 y se mueve la pagina al final de la cola, dando una segunda oportunidad. Si el bit R es 0, se reemplaza esa pagina.

- LRU: Este algoritmo reemplaza la pagina que mas tiempo lleva sin usarse, por lo que se necesita llevar un registro de timestamps o utilizar una lista enlazada para mantener el orden de uso de las paginas (costoso). Otra forma es utilizar una pila (stack) donde cada vez que se accede a una pagina, se mueve al tope de la pila. Cuando se necesita reemplazar, se saca la pagina del fondo de la pila.

- OPT: Este algoritmo requiere conocimiento previo de las referencias futuras, por lo que no es implementable en tiempo real. Se usa como referencia teorica para comparar otros algoritmos.

## 6c. Manejo de páginas modificadas

> Sabemos que la página a ser reemplazada puede estar modificada. ¿Cómo detecta el Kernel esta situación? ¿Qué acciones adicionales deben realizarse cuando se encuentra ante esta situación?

Para detectar si una pagina ha sido modificada, el kernel utiliza el bit M (Modificado/Sucio) en la tabla de paginas. Si este bit esta en 1, significa que la pagina ha sido escrita (modificada) desde que fue cargada en memoria. Por lo tanto, antes de reemplazar esta pagina, el kernel debe escribir la pagina en el backing store (swap o archivo de paginacion en disco). Si M = 0, la pagina no ha sido modificada y puede ser reemplazada directamente sin necesidad de escribirla en disco, no hay I/O de escritura.

En los casos donde la escritura al backing store puede ser costosa en terminos de tiempo, el kernel puede optar por utilizar una descarga asincrona (reserva un frame para descarga y continua la ejecucion del proceso).

## 7a. Políticas de reemplazo de páginas: local vs global

> Describa como trabajan las siguientes politicas de reemplazo de páginas: reemplazo local y reemplazo global.

- Reemplazo local: En esta politica, cada proceso solo puede reemplazar paginas dentro de los marcos que le han sido asignados. Cuando un proceso tiene un page fault, solo puede reemplazar una de sus propias paginas.

- Reemplazo global: En esta politica, la pagina victima puede ser tomada de cualquier proceso en el sistema.

## 7b. Compatibilidad de políticas de asignación y reemplazo

> ¿Es posible utilizar la política de “Asignación Fija” de marcos junto con la política de “Reemplazo Global"? Justifique.

Si se utiliza una politica de asignacion fija, donde todos los procesos tienen un numero fijo de marcos asignados, no es compatible utilizar una politica de reemplazo global ya que esta politica de reemplazo puede romper la asignacion fija de un proceso al permitir que se tomen marcos de otros procesos como paginas victimas.

**Reemplazo global + Asignacion dinamica** si son compatibles, ya que los procesos pueden variar la cantidad de marcos asignados en tiempo de ejecucion.

**Asignacion fija + reemplazo local** son compatibles, ya que cada proceso solo puede reemplazar paginas dentro de sus propios marcos asignados.

## 8a. Ejercicio de fallos de página

> Considerando la siguiente secuencia de referencias a paginas: 1, 2, 15, 4, 6, 2, 1, 5, 6, 10, 4, 6, 7, 9, 1, 6, 12, 11, 12, 2, 3, 1, 8, 1, 13, 14, 15, 3, 8. Si se disponen 5 marcos. ¿Cuántos fallos de página se producirán si se utilizan las siguientes técnicas de selección de víctima? (Considere una política de Asignación Dinámica y Reemplazo Global): Segunda Chance, FIFO, LRU y OPT

- FIFO: se producen 21 fallos de pagina.

- Segunda Chance: este algoritmo es similar a FIFO, pero da una segunda oportunidad a las paginas referenciadas recientemente. Cuando se cargan las paginas por primera vez, todas tienen el bit R en 0, por lo que se comporta igual que FIFO. Si una pagina es referenciada nuevamente estando en memoria, su bit R se setea a 1. Al momento de reemplazar, si la pagina al frente de la cola tiene R = 1, se resetea a 0 y se mueve al final de la cola, dando una segunda oportunidad. En este caso, se producen 22 fallos de pagina.

- LRU: este algoritmo reemplaza la pagina que ha sido usada menos recientemente. Se producen 22 fallos de pagina.

- OPT: este algoritmo reemplaza la pagina que no sera usada por el periodo mas largo en el futuro. Para esto esnecesario conocer la secuencia completa de referencias. En este caso, se producen 16 fallos de pagina.

## 8b. Cálculo del tiempo consumido por atención a fallos de página

> Suponiendo que cada atención de un fallo se página requiere de 0,1 seg. Calcular el tiempo consumido por atención a los fallos de páginas para los algoritmos de a).

Datos:

- Si cada atencion de fallo = 0.1s, el tiempo consumido por atencion de fallos es: #fallos \* 0.1s. Entonces:

- FIFO: 21 fallos \* 0.1s = 2.1s
- Segunda Chance: 22 fallos \* 0.1s = 2.2s
- LRU: 22 fallos \* 0.1s = 2.2s
- OPT: 16 fallos \* 0.1s = 1.6s

## 15. Tiempo de Acceso Efectivo a Memoria (EAT)

El tiempo de acceso efectivo a memoria (EAT, por sus siglas en inglés) es una métrica que refleja el tiempo promedio que tarda un sistema en acceder a una ubicación de memoria, considerando tanto los accesos exitosos como los fallos de página.

La fórmula para calcular el EAT es la siguiente:

**EAT = At + [(1 - p) * Am] + [p * (Tf + Am)]**

Donde:

- p: tasa de fallos de página (probabilidad de que ocurra un fallo de página), debe ser un valor entre 0 y 1.
- Am: Tiempo de acceso a la memoria real.
- Tf: Tiempo de atencion de un fallo de pagina.
- At: Tiempo de acceso a la tabla de páginas. Este valor es igual a Am si la entrada de la tabla de paginas no se encuentra en la TLB (Translation Lookaside Buffer). La TLB es una cache que almacena las traducciones recientes de direcciones logicas a fisicas para acelerar el proceso de traduccion. Es decir, que si la entrada de la tabla de paginas se encuentra en la TLB, el tiempo de acceso a la tabla de paginas es mucho menor que Am, ya que acceder a la cache es mas rapido que acceder a la memoria principal.
