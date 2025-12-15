## 1. ¿Qué es el Shell Scripting? ¿A qué tipos de tareas está orientado? ¿Los scripts deben compilarse? ¿Por qué?

El shell scripting es la práctica de escribir scripts o programas en un lenguaje de shell, como Bash, para automatizar tareas en un sistema operativo basado en Unix/Linux. Está orientado a tareas como la automatización de procesos repetitivos, la administración del sistema (procesos), la manipulación de archivos, la gestión de usuarios y la ejecución de comandos del sistema.

Los scripts de shell no necesitan compilarse, la shell lee linea por linea y ejecuta los comandos directamente. Son interpretados.

## 2. Investigar echo y read

- `echo`: Es un comando utilizado para imprimir texto o variables, generalemente en la salida estándar (stdout).

```bash
echo "Hola"
echo $USER
```

Opciones comunes:

- `-n`: No agrega una nueva línea al final.
- `-e`: Habilita la interpretación de secuencias de escape. como `\n` para nueva línea o `\t` para tabulación.

- `read`: Es un comando utilizado para leer la entrada del usuario desde la entrada estándar (stdin) y asignarla a una o más variables.

```bash
read nombre
read nombre apellido
```

Si se ingresa una linea con dos palabras, la primera se asigna a `nombre` y la segunda a `apellido`.
Opciones comunes:

- `-p`: Muestra un mensaje antes de leer la entrada.
- `-s`: No muestra la entrada en la pantalla (útil para contraseñas).

## 2.a ¿Cómo se indican comentarios en un script?

Llos comentarios se indican utilizando el símbolo `#`. Todo lo que sigue a este símbolo en una línea se considera un comentario y no se ejecuta.

```bash
# Esto es un comentario
echo "Hola"  # Esto también es un comentario
```

## 2.b ¿Cómo se declaran y referencian variables?

Las variables se declaran simplemente asignándoles un valor sin espacios alrededor del signo `=`. Para referenciar una variable, se utiliza el símbolo `$` antes del nombre de la variable.

```bash
nombre="Juan"
echo $nombre
```

## 3a. Asignar los permisos de ejecución al script mostrar.sh

```bash
chmod +x mostrar.sh
```

## 3d. Sustitucion de comandos con backticks

Los backticks (`` ` ``) se utilizan para ejecutar un comando y capturar su salida para usarla en otro comando o asignarla a una variable.

```bash
fecha=`date`
echo "La fecha actual es: $fecha"
# o
echo "La fecha actual es: `date`"
```

Hoy en dia, es más común usar la sintaxis `$(comando)` en lugar de backticks, ya que es más legible y permite anidar comandos más fácilmente.

```bash
fecha=$(date)
echo "La fecha actual es: $fecha"
# o
echo "La fecha actual es: $(date)"
```

## 3e. Modificaciones del script mostrar.sh

```bash
#!/bin/bash
echo "Menú de opciones:"
echo "1) Mostrar fecha y hora actuales"
echo "2) Mostrat directorio personal"
echo "3) Mostrar usuario actual"
echo "4) Mostrar el contenido de un directorio"
echo "5) Mostrar el espacio libre en disco"
echo "6) Salir"

read -p "Seleccione una opción (1-6): " opcion

case $opcion in
  1)
    echo "Fecha y hora actuales: $(date)"
    ;;
  2)
    echo "Directorio personal: $HOME"
    ;;
  3)
    echo "Usuario actual: $USER"
    ;;
  4)
    read -p "Ingrese el nombre del directorio: " dir
    if [ -d "$dir" ]; then # -d verifica si es un directorio
      echo "Contenido de $dir:"
      ls "$dir"
    else
      echo "El directorio $dir no existe."
    fi
    ;;
  5)
    echo "Espacio libre en disco:"
    df -h
    ;;
  6)
    echo "Saliendo..."
    exit 0
    ;;
  *)
    echo "Opción inválida. "
    ;;
esac
```

## 4. Parametrización de scripts

Para acceder a los parámetros pasados a un script, se utilizan variables especiales:

- `$0`: Nombre del script.
- `$1`, `$2`, ...: Primer, segundo, etc. parámetro pasado al script.
- `$#`: Número total de parámetros pasados al script.
- `$*`: Todos los parámetros pasados al script como una sola cadena.
- `$?`: Código de salida del último comando ejecutado. 0 indica éxito, cualquier otro valor entre 1 y 255 indica un error.
- `$HOME`: Variable de entorno que contiene el directorio home del usuario actual.

## 5. Comando exit

El comando `exit` se utiliza para finalizar la ejecución de un script o de una sesión de shell. Al usar `exit`, se puede especificar un código de salida que indica el estado de finalización del script. Un código de salida de `0` generalmente indica que el script se ejecutó correctamente, mientras que cualquier otro valor (entre 1 y 255) indica que ocurrió un error.

## 6. Comando expr

El comando `expr` se utiliza para evaluar expresiones y realizar operaciones aritméticas en la línea de comandos o en scripts de shell. Permite realizar operaciones como suma, resta, multiplicación, división y comparación de números enteros.

Operaciones aritméticas:

- Suma: `expr 5 + 3` (resultado: 8)
- Resta: `expr 5 - 3` (resultado: 2)
- Multiplicación: `expr 5 * 3` (resultado: 15) - el asterisco debe escaparse con una barra invertida.
- División: `expr 6 / 3` (resultado: 2)
- Módulo: `expr 5 % 3` (resultado: 2)

Comparaciones:

- Igualdad: `expr 5 = 5` (resultado: 1 si es verdadero, 0 si es falso)
- Desigualdad: `expr 5 != 3`
- Mayor que: `expr 5 \> 3`
- Menor que: `expr 3 \< 5`
- Mayor o igual que: `expr 5 \>= 3`
- Menor o igual que: `expr 3 \<= 5`

operaciones sobre cadenas:

- Longitud de una cadena: `expr length "Hola"` (resultado: 4)
- Subcadena: `expr substr "Hola Mundo" 1 4` (resultado: "Hola") Obtiene una subcadena desde la posición 1 con longitud 4. En este caso, la H es la posición 1.

Es importante tener en cuenta que `expr` evalúa las expresiones de izquierda a derecha y que los operadores deben estar separados por espacios.

Hoy en día, para operaciones aritméticas en scripts de shell, es más común utilizar la sintaxis `$(( expresión ))`, que es más legible y fácil de usar. Por ejemplo:

```bash
resultado=$((5 + 3))
echo $resultado  # Imprime 8
```

## 7. Comando test o [ ]

El comando `test` o los corchetes `[ ]` se utilizan en scripts de shell para evaluar expresiones condicionales. Permiten realizar comparaciones entre números, cadenas y archivos, y se usan comúnmente en estructuras de control como `if`, `while` y `until`.

Tiene dos valores de retorno:

- Retorna `0` (verdadero) si la expresión es cierta.
- Retorna `1` (falso) si la expresión es falsa.

Evaluación de archivos:

- `-f archivo`: Verdadero si el archivo existe y es un archivo regular.
- `-d archivo`: Verdadero si el archivo existe y es un directorio.
- `-e archivo`: Verdadero si el archivo existe (ya sea archivo regular, directorio, enlace simbólico, etc.).
- `-r archivo`: Verdadero si el archivo tiene permisos de lectura.
- `-w archivo`: Verdadero si el archivo tiene permisos de escritura.
- `-x archivo`: Verdadero si el archivo tiene permisos de ejecución.

Evaluación de cadenas:

- `-z cadena`: Verdadero si la cadena tiene longitud cero.
- `-n cadena`: Verdadero si la cadena tiene una longitud mayor que cero.
- `"a" = "b"`: Verdadero si las cadenas son iguales.
- `"a" != "b"`: Verdadero si las cadenas son diferentes.

Evaluación numérica:

- `a -eq b`: Verdadero si a es igual a b.
- `a -ne b`: Verdadero si a es diferente de b.
- `a -gt b`: Verdadero si a es mayor que b.
- `a -lt b`: Verdadero si a es menor que b.
- `a -ge b`: Verdadero si a es mayor o igual que b.
- `a -le b`: Verdadero si a es menor o igual que b.

Ejemplo de uso en un script:

```bash
if [ -f "archivo.txt" ]; then
  echo "El archivo existe."
else
  echo "El archivo no existe."
fi
# o
if test -f "archivo.txt"; then
  echo "El archivo existe."
else
  echo "El archivo no existe."
fi
```

## 8. Estructuras de control

Las estructuras de control en shell scripting permiten controlar el flujo de ejecución de un script basándose en condiciones o repeticiones. Las principales estructuras de control son:

- Estructura condicional `if`:

```bash
if [ condición ]; then
  # comandos si la condición es verdadera
elif [ otra_condición ]; then
  # comandos si la otra condición es verdadera
else
  # comandos si ninguna condición es verdadera
fi
```

- Estructura condicional `case`:

```bash
case $variable in
  valor1)
    # comandos para valor1
    ;;
  valor2)
    # comandos para valor2
    ;;
  *)
    # comandos para cualquier otro valor
    ;;
esac
```

- Estructura de repetición `for`:

```bash
for var in lista; do
  # comandos a repetir
  # Lista es un arreglo de valores, donde var toma cada valor en cada iteración
done
```

- Estructura de repetición `while`:

```bash
while [ condición ]; do
  # comandos a repetir mientras la condición sea verdadera
done
```

- Estructura de repetición `select`:

```bash
select var in lista; do
  # comandos a ejecutar para la opción seleccionada
done
```

La estructura `select` es útil para crear menús interactivos en scripts de shell, permitiendo al usuario elegir una opción de una lista presentada.

Ejemplo de uso de `select`:

```bash
select opcion in "Opción 1" "Opción 2" "Salir"; do
  case $opcion in
    "Opción 1")
      echo "Has seleccionado Opción 1"
      ;;
    "Opción 2")
      echo "Has seleccionado Opción 2"
      ;;
    "Salir")
      echo "Saliendo..."
      break
      ;;
    *)
      echo "Opción inválida"
      ;;
  esac
done
```

## 9. Break y continue

- `break`: Se utiliza para salir inmediatamente de un bucle (`for`, `while`, `until` o `select`). Cuando se encuentra un `break`, la ejecución del bucle termina y el control pasa a la siguiente línea después del bucle.

```bash
for i in 1 2 3 4 5; do
  if [ $i -eq 5 ]; then
    break  # Sale del bucle cuando i es igual a 5
  fi
  echo $i
done
```

- `continue`: Se utiliza para saltar a la siguiente iteración de un bucle. Cuando se encuentra un `continue`, el resto del código dentro del bucle para esa iteración se omite y el control vuelve al inicio del bucle para la siguiente iteración.

```bash
for i in 1 2 3 4 5; do
  if [ $i -eq 5 ]; then
    continue  # Salta a la siguiente iteración cuando i es igual a 5
  fi
  echo $i
done
```

Ambos comandos pueden recibir un argumento numérico opcional que indica cuántos niveles de bucles anidados se deben salir o saltar. Por defecto, afectan al bucle más interno.

```bash
while true; do
  while true; do
    break 2  # Sale de ambos bucles
  done
done

for i in 1 2 3 4 5; do
  for j in 1 2 3 4 5; do
    continue 2  # Salta a la siguiente iteración del bucle externo
  done
done
```

## 10. Variables

En shell los tipos de variables son:

- Variables simples: Almacenan cadenas de texto o números. No requieren declaración previa.

```bash
nombre="Juan"
edad=30
```

- Arreglos (Arrays indexados): Almacenan múltiples valores en una sola variable, accesibles mediante índices numéricos.

```bash
frutas=("manzana" "banana" "cereza")
echo ${frutas[0]}  # Imprime "manzana"
```

- Variables de entorno: Son variables globales que afectan el comportamiento del sistema y de los programas. Se definen en mayúsculas por convención.

```bash
export PATH=$PATH:/nuevo/directorio # Agrega un nuevo directorio al PATH
```

Bash no es un lenguaje fuertemente tipado, por lo que no es necesario declarar el tipo de variable antes de usarla. Las variables pueden cambiar de tipo dinámicamente según el contexto en el que se utilicen.

## 11. Funciones

Para definir una función en un script de shell, se utiliza la siguiente sintaxis:

```bash
nombre_funcion() {
  # comandos de la función
}
# o alternativamente
function nombre_funcion {
  # comandos de la función
}
```

Reciben los parametros igual que los scripts, a través de `$1`, `$2`, etc.
Puede retornar un valor utilizando el comando `return`, que establece el código de salida de la función (0 para éxito, cualquier otro valor para error). Para consultar el valor retornado se utiliza `$?`.

```bash
mi_funcion() {
  echo "Hola, $1"
  return 0
}
mi_funcion "Mundo"
echo "Código de salida: $?"
```

## 12a. Script expresiones.sh

```bash
#!/bin/bash
read -p "Ingrese dos numeros separados por espacio: " num1 num2
suma=$(($num1 + $num2))
resta=$(($num1 - $num2))
multiplicacion=$(($num1 * $num2))
if [ $num1 -gt $num2 ]; then
  mayor=$num1
elif [ $num2 -gt $num1 ]; then
  mayor=$num2
else
  mayor="ambos son iguales"
fi
echo "Suma: $suma"
echo "Resta: $resta"
echo "Multiplicación: $multiplicacion"
echo "Mayor: $mayor"
```

## 12b. Modificacion con parametros

```bash
#!/bin/bash
if [ $# -ne 2 ]; then
  echo "Uso del script: $0 numero1 numero2"
  exit 1
fi

num1=$1
num2=$2
# mismo codigo que antes
```

## 12c. Script calculadora.sh

```bash
#!/bin/bash
if [ $# -ne 3 ]; then
  echo "Error. Uso del script: $0 numero1 operador numero2"
  exit 1
fi

num1=$1
operador=$2
num2=$3

case $operador in
  +)
    resultado=$(($num1 + $num2))
    ;;
  -)
    resultado=$(($num1 - $num2))
    ;;
  \*)
    resultado=$(($num1 * $num2))
    ;;
  /)
    if [ $num2 -eq 0 ]; then
      echo "Error: División por cero"
      exit 1
    fi
    resultado=$(($num1 / $num2))
    ;;
  *)
    echo "Error: Operador inválido. Use +, -, *, /"
    echo "Uso del script: $0 numero1 operador numero2"
    exit 1
    ;;
esac

echo "Resultado: $resultado"
exit 0
```

## 13a. Script cuadrados.sh

```bash
#!/bin/bash
for i in {1..100}; do
  cuadrado=$(($i * $i))
  echo "Número: $i, Cuadrado: $cuadrado"
done
```

## 13b. opciones.sh

```bash
#!/bin/bash
echo "Seleccione una opción:"
echo "1) Listar"
echo "2) DondeEstoy"
echo "3) QuienEsta"
read -p "Ingrese el número de la opción: " opcion

case $opcion in
  1)
    echo "Contenido del directorio actual:"
    ls
    ;;
  2)
    echo "Directorio actual:"
    pwd
    ;;
  3)
    echo "Usuarios conectados al sistema:"
    who
    ;;
  *)
    echo "Opción inválida."
    ;;
esac
```

## 13c. archivo.sh

```bash
#!/bin/bash

if [] [ $# -ne 1 ]; then
  echo "Uso del script: $0 nombre_archivo"
  exit 1
fi

archivo=$1

if [ -e $archivo ]; then
  echo "El archivo '$archivo' existe."
  if [ -f $archivo ]; then
    echo "Es un archivo regular."
  elif [ -d $archivo ]; then
    echo "Es un directorio."
  fi
else
  echo "El archivo '$archivo' no existe."
  mkdir $archivo
  echo "Directorio '$archivo' creado."
fi
```

## 14. renombra.sh

```bash
#!/bin/bash
if [ $# -ne 3 ]; then
  echo "Uso del script: $0 directorio -a|-b CADENA"
  exit 1
fi
directorio=$1
opcion=$2
cadena=$3
if [ ! -d "$directorio" ]; then
  echo "Error: $directorio no es un directorio válido."
  exit 1
fi

for archivo in "$directorio"/*; do
  if [ -f "$archivo" ]; then
    nombre_archivo=$(basename "$archivo")
    ruta_directorio=$(dirname "$archivo")
    case $opcion in
      -a)
        nuevo_nombre="${nombre_archivo}${cadena}"
        ;;
      -b)
        nuevo_nombre="${cadena}${nombre_archivo}"
        ;;
      *)
        echo "Opción inválida. Use -a o -b."
        exit 1
        ;;
    esac
    mv "$archivo" "$ruta_directorio/$nuevo_nombre"
    echo "Renombrado: $archivo -> $ruta_directorio/$nuevo_nombre"
  fi
done
```

## 15. Comando cut

El comando `cut` se utiliza para extraer secciones específicas de líneas de texto en archivos o entradas estándar. Es especialmente útil para procesar archivos de texto estructurados, como archivos CSV o TSV.

Sintaxis básica:

```bash
cut [opciones] [archivo]
```

Opciones comunes:

- `-f`: Especifica los campos a extraer, separados por comas. Por ejemplo, `-f 1,3` extrae el primer y tercer campo.
- `-d`: Define el delimitador que separa los campos. Por defecto, es una tabulación. Por ejemplo, `-d ','` para archivos CSV.
- `-c`: Extrae caracteres específicos de cada línea. Por ejemplo, `-c 1-5` extrae los primeros cinco caracteres.

Ejemplo de uso:

```bash
# Extraer el segundo campo de un archivo CSV
cut -d ',' -f 2 archivo.csv
# Extraer los primeros 10 caracteres de cada línea de un archivo de texto
cut -c 1-10 archivo.txt
# Extraer el primer y tercer campo de un archivo separado por tabulaciones
cut -f 1,3 archivo.txt
```

Ejemplo práctico:
Dado el archivo `datos.txt` con el siguiente contenido:

```nombre,edad,ciudad
Juan,30,Madrid
Ana,25,Barcelona
Luis,28,Valencia
```

Para extraer solo los nombres y las ciudades, se puede usar:

```bash
cut -d ',' -f 1,3 datos.txt
```

## 16. generar-reporte.sh

Realizar un script que reciba como parámetro una extensión y haga un reporte
con 2 columnas, el nombre de usuario y la cantidad de archivos que posee con
esa extensión. Se debe guardar el resultado en un archivo llamado reporte.txt

```bash
#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Uso del script: $0 <extension>"
  echo "Ejemplo: $0 pdf"
  exit 1
fi
extension=$1
archivo="reporte.txt"
> "$archivo" # Limpiar el archivo si ya existe, o crearlo si no existe
echo "Usuario Cantidad_de_Archivos_$extension" > "$archivo"
for usuario in /home/*; do
  nombre_usuario=$(basename "$usuario")
  cantidad=$(find "$usuario" -type f -name "*.$extension" -print 2>/dev/null | wc -l)
  echo "$nombre_usuario $cantidad" >> "$archivo"
done
echo "Reporte generado en $archivo"
```

El comando `find` se utiliza para buscar archivos y directorios en una jerarquía de directorios basándose en criterios específicos. En este caso, se usa para contar la cantidad de archivos con una extensión determinada en el directorio home de cada usuario.

> find "$usuario": Inicia la búsqueda en el directorio del usuario actual.
> -type f: Especifica que se buscan solo archivos regulares.
> -name "\*.$extension": especifica el patrón de nombre de archivo a buscar.
> -print: Imprime la ruta completa de cada archivo que coincide con el patrón. 2>/dev/null redirige los mensajes de error (por ejemplo, permisos denegados) a /dev/null para que no aparezcan en la salida.

El comando `wc -l` cuenta el número de líneas en la salida del comando `find`, que corresponde a la cantidad de archivos encontrados con la extensión especificada.

## 17. Script print-ls.sh

```bash
#!/bin/bash
ls | tr 'A-Za-z' 'a-zA-Z' | tr -d 'aA'
```

El comando `tr` se utiliza para traducir o eliminar caracteres de la entrada estándar. En este caso, se utilizan dos comandos `tr` encadenados:

- `tr 'A-Za-z' 'a-zA-Z'`: Este comando traduce todas las letras mayúsculas a minúsculas y todas las letras minúsculas a mayúsculas.
- `tr -d 'aA'`: Este comando elimina todas las letras 'a' y 'A' de la entrada.

## 18. Script verificar-usuario.sh

Crear un script que verifique cada 10 segundos si un usuario se ha logueado en
el sistema (el nombre del usuario será pasado por parámetro). Cuando el usuario
finalmente se loguee, el programa deberá mostrar el mensaje ”Usuario XXX
logueado en el sistema” y salir.

```bash
#!/bin/bash
if [ $# -ne 1 ]; then
  echo "Uso del script: $0 nombre_usuario"
  exit 1
fi
usuario=$1
while true; do
  if who | grep -q "^$usuario\b"; then
    echo "Usuario $usuario logueado en el sistema"
    exit 0
  fi
  sleep 10
done
```

El comando `who` muestra una lista de usuarios actualmente conectados al sistema. Al usar `grep -q "^$usuario\b"`, se busca si el nombre del usuario especificado está presente en la salida de `who`. La opción `-q` hace que `grep` no produzca salida, sino que solo devuelva un código de estado (0 si encuentra una coincidencia, 1 si no). El patrón `^$usuario\b` asegura que se busque el nombre del usuario al inicio de una línea y que esté seguido por un límite de palabra, evitando coincidencias parciales.

El comando `sleep 10` pausa la ejecución del script durante 10 segundos antes de volver a verificar si el usuario se ha logueado.

## 19. Script menu.sh

```bash
#!/bin/bash
while true; do
  echo "MENU DE COMANDOS"
  echo "1) Ejercicio 3"
  echo "2) Evaluar Expresiones"
  echo "3) Probar estructuras de control"
  echo "4) Salir"
  read -p "Ingrese la opción a ejecutar: " opcion
  case $opcion in
    1)
      # path al script del ejercicio 3
      ;;
    2)
      # path al script de evaluar expresiones
      ;;
    3)
      # path al script de estructuras de control
      ;;
    4)
      echo "Saliendo..."
      exit 0
      ;;
    *)
      echo "Opción inválida. Intente nuevamente."
      ;;
  esac
done
```

## 20. Script pila.sh

```bash
#!/bin/bash
pila=()
push() {
  # Agrega un elemento en el tope de la pila (final del array)
  # Podriamos verificar que se esté pasando el parámetro, pero lo omitimos por simplicidad
  pila+=("$1")
}
pop() {
  # Elimina el elemento en el tope de la pila (final del array)
  if [ ${#pila[@]} -eq 0 ]; then
    echo "La pila está vacía."
  else
    unset pila[-1]
  fi
}
length() {
  # Imprime la longitud de la pila
  echo "${#pila[@]}"
}
print() {
  # Imprime todos los elementos de la pila
  for elemento in "${pila[@]}"; do
    echo "$elemento"
  done
}
while true; do
  echo "MENU PILA"
  echo "1) Agregar 10 elementos a la pila"
  echo "2) Sacar 3 elementos de la pila"
  echo "3) Imprimir longitud de la pila"
  echo "4) Imprimir todos los elementos de la pila"
  echo "5) Salir"
  read -p "Ingrese la opción a ejecutar: " opcion
  case $opcion in
    1)
      for i in {1..10}; do
        push "Elemento_$i"
      done
      echo "10 elementos agregados a la pila."
      ;;
    2)
      for i in {1..3}; do
        pop
      done
      echo "3 elementos sacados de la pila."
      ;;
    3)
      echo "Longitud de la pila: $(length)"
      ;;
    4)
      echo "Elementos en la pila:"
      print
      ;;
    5)
      echo "Saliendo..."
      exit 0
      ;;
    *)
      echo "Opción inválida. Intente nuevamente."
      ;;
  esac
done
```

> pila[@] se utiliza para referirse a todos los elementos del array `pila`.
> #pila[@] devuelve la cantidad de elementos en el array `pila`.
> unset pila[-1] elimina el último elemento del array `pila`, simulando la operación de "pop" en una pila.

> Tip importante: `${}` se utiliza para delimitar el nombre de una variable cuando se accede a sus elementos o propiedades, especialmente en el caso de arrays. `$()` se utiliza para ejecutar un comando y capturar su salida.

> Tip de for: `{1..10}` es una forma de generar una secuencia de números del 1 al 10 en Bash.

## 21. Script productoria.sh

```bash
#!/bin/bash
num=(10 3 5 7 9 3 5 4)
productoria() {
  # multiplica todos los elementos del arreglo num

  prod=1
  for elem in ${num[@]}; do
    prod=$(( prod * elem ))
  done
  echo "La productoria es: $prod"
}

productoria
```

## 22. Script numeros.sh

```bash
#!/bin/bash
numeros=(12 7 9 14 3 8 11 6 5 10)
impares=()
for num in ${numeros[@]}; do
  if [ $((num % 2)) -eq 0 ]; then
    echo "Número par: $num"
  else
    impares+=($num)
  fi
done
echo "Numeros impares: "
for impar in ${impares[@]}; do
  echo "$impar"
done
```

## 23. Script vectores.sh

```bash
#!/bin/bash
vector1=( 1 80 65 35 2 )
vector2=( 5 98 3 41 8 )
longitud=${#vector1[@]}
for (( i=0; i<$longitud; i++ )); do
  suma=$(( vector1[i] + $vector2[i] ))
  echo "La suma de los elementos de la posición $i de los vectores es $suma"
done
```

## 24. Script usuarios.sh

```bash
#!/bin/bash
grupo="users"
usuarios=($(getent group $grupo | awk -F: '{print $4}' | tr ',' ' '))

if [ $# -eq 0 ]; then
  echo "Erro: uso del script: $0 [-b n | -l | -i]"
  exit 1
fi

opcion=$1

case $opcion in
  -b)
    if [ $# -ne 2 ]; then
      echo "Error: uso del script: $0 -b n"
      exit 1
    fi
    pos=$2
    if [ ${#usuarios[@]} -ge $(( pos + 1 )) ]; then
      echo "Usuario en la posición $pos: ${usuarios[pos]}"
    else
      echo "Error: posición inválida."
      exit 1
    fi
    ;;
  -l)
    echo "Cantidad de usuarios: ${#usuarios[@]}"
    ;;
  -i)
    for user in ${usuarios[@]}; do
      echo "$user"
    done
    ;;
  *)
    echo "Error: uso del script: $0 [-b n | -l | -i]"
    exit 1
    ;;
esac
```

> getent group $grupo: Obtiene la entrada del grupo "users" desde la base de datos de grupos del sistema.
> awk -F: '{print $4}': Utiliza `awk` para extraer el cuarto campo de la salida, que contiene los nombres de los usuarios separados por comas.
> tr ',' ' ': Utiliza `tr` para reemplazar las comas por espacios, facilitando la conversión a un arreglo.

## 25. Script parametros.sh

Escriba un script que reciba una cantidad desconocida de parámetros al
momento de su invocación (debe validar que al menos se reciba uno). Cada
parámetro representa la ruta absoluta de un archivo o directorio en el sistema. El
script deberá iterar por todos los parámetros recibidos, y solo para aquellos
parámetros que se encuentren en posiciones impares (el primero, el tercero, el
verificar si el archivo o directorio existen en el sistema, imprimiendo en pantalla
que tipo de objeto es (archivo o directorio). Además, deberá informar la cantidad
de archivos o directorios inexistentes en el sistema.

```bash
#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Error: uso del script: $0 dir1 [dir2 ... dirN]"
  exit 1
fi
inexistentes=0
for (( i=1; i<=$#; i+=2 )); do
  parametro=${!i}
  if [ -e "$parametro" ]; then
    if [ -f "$parametro" ]; then
      echo "$parametro es un archivo."
    elif [ -d "$parametro" ]; then
      echo "$parametro es un directorio."
    fi
  else
    echo "$parametro no existe."
    inexistentes=$((inexistentes + 1))
  fi
done
echo "Cantidad de archivos o directorios inexistentes: $inexistentes"
```

> Usamos `${!i}` para acceder al i-ésimo parámetro pasado al script.

## 26. Script arreglos.sh

```bash
#!/bin/bash
array=()
inicializar() {
  array=()
}
agregar_elem() {
  array+=($1)
}
eliminar_elem() {
  if [ $1 -ge 0 ] && [ $1 -lt ${#array[@]} ]; then
    unset array[$1]
    array=("${array[@]}") # Reindexar el arreglo
  else
    echo "Posición inválida."
  fi
}
longitud() {
  echo "${#array[@]}"
}
imprimir() {
  for elem in "${array[@]}"; do
    echo "$elem"
  done
}
inicializar_Con_Valores() {
  inicializar
  for (( i=0; i<$1; i++ )); do
    array+=($2)
  done
}
```

## 27. Script directorio.sh

```bash
#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Error: no se pasaron parametros"
  echo "Uso del script: $0 <directorio>"
  exit 1
fi

dir=$1
archivos_rw=0

if [ -d $dir ]; then
  for archivo in "$dir"/*; do
    if [ -f $archivo ]; then
      if [[ -r $archivo && -w $archivo ]]; then
        echo $archivo
        archivos_rw=$(( archivos_rw + 1 ))
      else
        echo "El archivo $archivo no tiene permisos de lectura y escritura"
      fi
    else
      echo "El archivo $archivo no es un archivo regular"
    fi
  done
else
  echo "El directorio no existe o el path no corresponde a un directorio"
  exit 4
fi

echo "Cantidad de archivos con permisos de lectura y escritura: $archivos_rw"
```

> -r y -w son opciones del comando test (o [ ]) que verifican si un archivo tiene permisos de lectura y escritura, respectivamente. Estos validan los permisos del usuario que ejecuta el script sobre el archivo especificado. Por lo tanto, no es necesario hacer una logica adicional para verificar si el usuario es el propietario del archivo.

> Al pasar un directorio como parametro, escribiendo "$dir"/\* podemos iterar sobre todos los archivos y subdirectorios dentro de ese directorio.

## 28. Script home.sh

```bash
#!/bin/bash
archivos_doc=()
for archivo in /home/*.doc; do
  if [ -f "$archivo" ]; then
    archivos_doc+=("$archivo")
  fi
done
verArchivo() {
  if [ $# -lt 1 ]; then
    echo "Error: no se paso el nombre del archivo"
    exit 1
  else
    flag=0
    for archivo in ${archivos_doc[@]}; do
      nombre_archivo=${basename $archivo}
      if [ $nombre_archivo -eq $archivo ]; then
        flag=1
      fi
    done

    if [ $flag -eq 1 ]; then
      cat $archivo
    else
      echo "Error: Archivo no encontrado"
      exit 5
    fi
  fi
}
cantidadArchivos() {
  echo "Cantidad de archivos .doc en /home: ${#archivos_doc[@]}"
}
borrarArchivo() {
  if [ $# -lt 1 ]; then
    echo "Error: no se paso el nombre del archivo"
    exit 1
  else
    flag=0
    for i in ${!archivos_doc[@]}; do
      nombre_archivo=${basename ${archivos_doc[i]}}
      if [ $nombre_archivo -eq $1 ]; then
        flag=1
        indice=$i
      fi
    done

    if [ $flag -eq 1 ]; then
      read -p "¿Desea eliminar el archivo lógicamente? (Si/No): " respuesta
      if [ "$respuesta" == "Si" ]; then
        unset archivos_doc[$indice]
        archivos_doc=("${archivos_doc[@]}") # Reindexar el arreglo
      elif [ "$respuesta" == "No" ]; then
        rm "${archivos_doc[$indice]}"
        unset archivos_doc[$indice]
        archivos_doc=("${archivos_doc[@]}") # Reindexar el arreglo
      else
        echo "Respuesta inválida. Use 'Si' o 'No'."
      fi
    else
      echo "Error: Archivo no encontrado"
      exit 10
    fi
  fi
}

```

## 29. Script programas.sh

```bash
#!/bin/bash
directorio_bin="$HOME/bin"
if [ ! -d "$directorio_bin" ]; then
  mkdir "$directorio_bin"
fi

contador=0
for archivo in *; do
  if [[ -f $archivo && -x $archivo ]]; then
    mv "$archivo" "$directorio_bin/"
    echo "Movido: $archivo"
    contador=$((contador + 1))
  fi
done
```

> Para saber si un archivo es ejecutable, se utiliza la opción `-x` del comando `test` (o `[ ]`). Esta opción verifica si el archivo tiene permisos de ejecución para el usuario que ejecuta el script.

> Para obtener el directorio actual utilizamos `*`, que representa todos los archivos y directorios en el directorio actual.

> Para obtener el subdirectorio "bin" dentro del directorio HOME del usuario actual, utilizamos la variable de entorno `$HOME`, que contiene la ruta al directorio home del usuario que está ejecutando el script. Concatenamos esta ruta con "/bin" para formar la ruta completa al subdirectorio "bin".

## Ejercicio extra: modelo parcial

Escriba un script en bash que reciba como argumento una lista de nombres de usuario (debe validar que se reciba al menos uno), y para cada uno
de los usuarios VALIDOS que se hayan recibido deberá imprimir un reporte con la siguiente información:

- Nombre de usuario
- Ruta al directorio personal, solo si el usuario tiene directorio personal configurado y éste existe.
- Cantidad de archivos (no directorios) en su directorio personal. Debera informar 0 si el usuario no posee directorio personal o no existe.

```bash
#!/bin/bash
if [ $# -lt 1 ]; then
  echo "Error: uso del script: $0 usuario1 [usuario2 ... usuarioN]"
  exit 1
fi
for usuario in "$@"; do
  if id "$usuario" &>/dev/null; then
    echo "Reporte para el usuario: $usuario"
    dir_home=$(getent passwd "$usuario" | cut -d: -f6)
    if [ -d "$dir_home" ]; then
      echo "Directorio personal: $dir_home"
      cantidad_archivos=$(find "$dir_home" -type f 2>/dev/null | wc -l)
      echo "Cantidad de archivos en el directorio personal: $cantidad_archivos"
    else
      echo "El usuario no tiene un directorio personal configurado o no existe."
      echo "Cantidad de archivos en el directorio personal: 0"
    fi
    echo "-----------------------------------"
  else
    echo "El usuario '$usuario' no es válido."
    echo "-----------------------------------"
  fi
done
```

> **"$@"**: Representa todos los argumentos pasados al script como una lista.
> **id "$usuario" &>/dev/null**: Verifica si el usuario existe en el sistema. Redirige toda la salida (tanto estándar como de error) a /dev/null para evitar mostrar mensajes en pantalla. if id "$usuario" &>/dev/null; then evalúa a verdadero si el usuario existe.
> **getent passwd "$usuario" | cut -d: -f6\*\*: Obtiene la ruta del directorio personal del usuario desde la base de datos de usuarios del sistema. El comando `getent passwd` devuelve la entrada completa del usuario en formato de archivo passwd, y `cut -d: -f6` extrae el sexto campo, que corresponde al directorio home del usuario.
> **find "$dir_home" -type f 2>/dev/null | wc -l**: Cuenta la cantidad de archivos regulares en el directorio personal del usuario. El comando `find` busca todos los archivos (`-type f`) en el directorio especificado, y `wc -l` cuenta las líneas de la salida, que corresponde al número de archivos encontrados. La redirección `2>/dev/null` se utiliza para ignorar cualquier mensaje de error que pueda surgir si el directorio no existe o no se puede acceder a él.

Indique como se deberia ejecutar su script (asuma que el archivo se llama reporte.sh) para que la salida del mismo se guarde en un archivo llamado
reporte.txt dentro del directorio personal del usuario que ejecuta el script, sobreescribiendo cualquier contenido que el mismo puediera tener.

```bash
./reporte.sh usuario1 usuario2 usuario3 > "$HOME/reporte.txt"
```
