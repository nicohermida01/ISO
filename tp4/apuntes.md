# Apuntes del trabajo practico n4 de Introduccion a los Sistemas Operativos

## Temas importantes

- Memoria virtual con paginacion por demanda
- Atributos en la tabla de paginas
- Fallos de pagina
- Paginas grandes vs paginas pequeñas
- Asignacion fija vs asignacion dinamica
- Algoritmos de reemplazo de paginas
- Reemplazo sincrono vs asincrono
- Reemplazo local vs global
- Calculo de fallos de pagina, y tiempo de atencion de fallos
- Calculo de capacidad de un disco
- Calculo de tiempos de acceso a disco
- Algoritmos de planificacion en HDD (con y sin page faults)

## E/S y Administracion de Discos

### Organizacion fisica del disco

Un disco esta compuesto por varios platos apilados uno sobre otro, cada plato tiene dos caras y cada cara tiene pistas concéntricas. Cada pista se divide en sectores que son las unidades mas pequeñas de almacenamiento en el disco.
Los platos giran a una velocidad constante y un brazo con cabezales de lectura/escritura se mueve radialmente para acceder a las diferentes pistas.

- Platos: cada plato tiene 2 superficies utiles. Cada superficie tiene pistas concéntricas, es decir, anillos donde se almacenan los datos.
- Pista: circunferencia en la superficie del plato. Se divide en sectores.
- Cilindro: conjunto de pistas alineadas verticalmente en todos los platos del disco. Todas tienen el mismo numero de pista (misma posicion radial).
- Sector: unidad minima de transferencia de datos en el disco. Generalmente tiene un tamaño de 512 bytes o 4096 bytes.

La capacidad de un disco esta dada por la formula:
**Capacidad = #caras \* #pistas_x_cara \* sectores_x_pista \* tamaño_sector**

### Acceso al disco

El acceso a un bloque de datos en el disco implica varios pasos:

1. Mover el brazo lector/escritor a la pista correcta (tiempo de seek).
2. Esperar a que el sector deseado gire bajo el cabezal (latencia rotacional).
3. Transferir los datos entre el disco y la memoria (tiempo de transferencia).

Tiempos que componen el acceso al disco:

- Seek time: es el tiempo que tarda el brazo en moverse a la pista correcta.
- Latency (latencia rotacional): es el tiempo de espera hasta que el sector deseado pase bajo el cabezal. Si no se conoce este tiempo, se asume la mitad del tiempo de rotacion completa, es decir, 1/(2\*RPM) en ms.
- Transfer time: es el tiempo que se tarda en transferir los datos. Depende del throughput del disco en bytes/s. Throughput es la cantidad de datos que se pueden transferir por unidad de tiempo.
- Acceso total secuencial: **seek + latency + transfer time \* #bloques**
- Acceso total aleatorio: **(seek + latency + transfer time) \* #bloques**

Los bloques son las unidades logicas de almacenamiento que el sistema operativo utiliza para gestionar los datos en el disco. Un bloque puede contener uno o mas sectores fisicos. Por lo tanto, el numero de bloques a transferir depende del tamaño del bloque y del tamaño del archivo o datos que se desean leer o escribir.

### Algoritmos de scheduling

El scheduling de E/S determina el orden en que se atienden las solicitudes de acceso al disco. Existen diferentes algoritmos que optimizan el tiempo de seek y la latencia rotacional. Algunos de los algoritmos mas comunes son:

- **FCFS (First-Come, First-Served)**: atiende las solicitudes en el orden en que llegan. Es simple pero puede causar tiempos de espera largos.
- **SSTF (Shortest Seek Time First)**: atiende la solicitud que requiere el menor tiempo de seek. Reduce el tiempo promedio de espera pero puede causar inanicion para solicitudes lejanas.
- **SCAN (Elevator Algorithm)**: el brazo se mueve en una direccion atendiendo todas las solicitudes hasta llegar al final, luego invierte la direccion. Equilibra el tiempo de espera.
- **LOOK**: similar a SCAN, pero el brazo solo se mueve hasta la ultima solicitud en lugar de ir hasta el final del disco.
- **C-SCAN (Circular SCAN)**: el brazo se mueve en una direccion atendiendo solicitudes, y al llegar al final vuelve rapidamente al inicio sin atender solicitudes en el camino de regreso. Da mejor tiempo de espera promedio.
- **C-LOOK**: similar a C-SCAN, pero el brazo solo se mueve hasta la ultima solicitud antes de volver al inicio.
