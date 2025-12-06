# Comandos utilizados en la practica 3

- `who`: Muestra los usuarios actualmente conectados al sistema. Parametros comunes incluyen:

  - `-H`: Muestra encabezados de columna.
  - `-q`: Muestra solo los nombres de usuario y el número total de usuarios.
  - `-b`: Muestra la última vez que se inició el sistema.
  - `-a`: Muestra toda la información disponible.

- `wc`: Cuenta líneas, palabras y bytes en archivos o entrada estándar. Parametros comunes incluyen:

  - `-l`: Cuenta solo las líneas.
  - `-w`: Cuenta solo las palabras.
  - `-c`: Cuenta solo los bytes.
  - `-m`: Cuenta solo los caracteres.

- `grep`: Busca patrones en archivos o entrada estándar y muestra las líneas que coinciden. Parametros comunes incluyen:

  - `-i`: Ignora mayúsculas y minúsculas en la búsqueda.
  - `-v`: Invierte la coincidencia, mostrando líneas que no coinciden con el patrón.
  - `-r` o `-R`: Busca recursivamente en directorios.
  - `-n`: Muestra el número de línea junto con las líneas coincidentes.

- `find`: Busca archivos y directorios en una jerarquía de directorios según criterios especificados. Parametros comunes incluyen:

  - `-name`: Busca por nombre de archivo.
  - `-type`: Busca por tipo de archivo (por ejemplo, `f` para archivos regulares, `d` para directorios).
  - `-size`: Busca por tamaño de archivo.
  - `-exec`: Ejecuta un comando sobre los archivos encontrados.

- `sleep`: Pausa la ejecución de un script o comando por un período de tiempo especificado. Parametros comunes incluyen:

  - Número de segundos a pausar (por ejemplo, `sleep 5` pausa por 5 segundos).
  - Soporta sufijos como `s` (segundos), `m` (minutos), `h` (horas), y `d` (días) para especificar la duración.

- `tr`: Transforma o elimina caracteres de la entrada estándar. Parametros comunes incluyen:

  - `-d`: Elimina caracteres especificados.
  - `-s`: Squeeze, reemplaza múltiples ocurrencias de un carácter con una sola.
  - `-c`: Complementa el conjunto de caracteres especificado.

- `basename`: Extrae el nombre del archivo de una ruta completa. Parametros comunes incluyen:

  - `-s`: Elimina una extensión específica del nombre del archivo.
  - `-a`: Procesa múltiples nombres de archivo.

- `dirname`: Extrae el directorio de una ruta completa. Parametros comunes incluyen:

  - `-z`: Maneja nombres de archivo terminados en null.
  - `-a`: Procesa múltiples nombres de archivo.

- `cut`: Extrae secciones de cada línea de entrada, como campos o caracteres específicos. Parametros comunes incluyen:

  - `-d`: Define el delimitador de campo.
  - `-f`: Especifica los campos a extraer.
  - `-c`: Especifica los caracteres a extraer.

- `unset`: Elimina variables o funciones del entorno del shell. Parametros comunes incluyen:

  - `-f`: Elimina funciones.
  - `-v`: Elimina variables.

- `getent`: Recupera entradas de bases de datos del sistema, como usuarios o grupos. Parametros comunes incluyen:

  - `passwd`: Recupera información de usuarios.
  - `group`: Recupera información de grupos.

- `awk`: Un lenguaje de programación para procesamiento de texto y generación de informes, útil para manipular y analizar datos en archivos de texto. Parametros comunes incluyen:

  - `-F`: Define el delimitador de campo.
  - `{print $n}`: Imprime el n-ésimo campo de cada línea.
  - `NR`: Número de registro (línea actual).
  - `NF`: Número de campos en la línea actual.
  - `BEGIN` y `END`: Bloques para ejecutar acciones antes y después del procesamiento de líneas.

- `mv`: Mueve o renombra archivos y directorios. Parametros comunes incluyen:

  - `-i`: Solicita confirmación antes de sobrescribir archivos existentes.
  - `-v`: Muestra los archivos a medida que se mueven.
  - `-n`: No sobrescribe archivos existentes.
