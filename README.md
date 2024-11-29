A collection of shellscripts made mostly in perl, for use in korn Bash and zsh.

Colección de scripts para utilizar en entornos de Korn Shell, Bash o Zsh , hechos principalmente en perl.

He hecho la mayoría de herramientas en perl porque permite una portabilidad casi total entre entornos. Todos los scripts se han realizado sin módulos externos, para intentar garantizar su funcionamiento en cualquier situación.

Aunque los nombres de las herramientas intentan ser autoexplicativos, iré incorporando en este documento una breve descripción de las utilidades.

<image src="https://github.com/ethnaut/shellTools/blob/main/3-wise-men.jpg" alt="The Three wisemen of Code">

___ 
#awk-fa.pl

Uso: awk-fa.pl <cadena> [fichero] [separador]

awk field analizer analiza un fichero o entrada estándar y busca por una cadena dada, mostrando todos los campos de las líneas que hacen match.
Esta herramienta está pensada para analizar un fichero tabulado, identificando sus campos para poder tratarlos después con awk.

Argumentos:

  <cadena>     La cadena a buscar en el texto.
  
  [fichero]    (opcional) El fichero a analizar. Si no se proporciona, se espera entrada estándar (tubería).
  
  [separador]  (opcional) El separador a usar. Por defecto es tabulador.

Opciones:

  Puede recibir datos a través de una tubería, por ejemplo:
  
    cat datos.txt | ./awk-fa.pl 'cadena1' '-' '[\^~|]'

Ejemplos:

  ./awk-fa.pl 'cadena1' datos.txt                  # Busca 'cadena1' usando el separador por defecto.
  
  ./awk-fa.pl 'cadena2' datos.txt '|'               # Busca 'cadena2' usando '|' como separador.
  
  ./awk-fa.pl 'cadena1|cadena2' datos.txt           # Busca 'cadena1' o 'cadena2'.
  
  ./awk-fa.pl 'cadena3' '-' '[\^~|]'               # Usa tubería y busca 'cadena3' con múltiples separadores.

  ___

  \#edstr.sh
  
  Herramienta pensada para ser un sustituto de sed , utilizando un oneliner perl.
  
  Uso:
  
  1. Sustituir directamente en un archivo (con backup):
     ./edstream patrón reemplazo archivo
     - Sustituye todas las ocurrencias de 'patrón' por 'reemplazo' en 'archivo'.
     - Genera un archivo de respaldo con el sufijo ~ (archivo.txt -> archivo.txt~).

  3. Usar con redirección o pipe (sin backup):
     cat archivo.txt | ./edstream patrón reemplazo
     - Reemplaza todas las ocurrencias de 'patrón' por 'reemplazo' en el flujo de entrada.
     - No modifica ningún archivo, la salida es enviada a stdout.

Ejemplos:

  ./edstream foo bar archivo.txt     
  
  \# Sustituye 'foo' por 'bar' en archivo.txt con backup
  cat archivo.txt | ./edstream foo bar
  
  \# Sustituye 'foo' por 'bar' en la salida del pipe
  
./edstream '^\Q127.0.0.1\E' '# 127.0.0.1' hosts_file  

\# Añade comentario en la línea que comienza por localhost

---

\#grep-date.pl

Utiliza un oneliner perl para grepear líneas (nombres de fichero de un ls, por ejemplo) que contengan ocho dígitos. 

perl -ne 'print if /[0-9]{8}/'

---

\#grep-email.pl

Uso: grep-email.pl [archivo | -] o mediante una tubería

Este script extrae direcciones de correo electrónico de un archivo o de la entrada estándar.

Opciones:

  - Si se proporciona un archivo como argumento, el script extraerá direcciones de correo electrónico de ese archivo.
  - Si se usa '-' como argumento, el script leerá de la entrada estándar (stdin). Esto es útil para pegar contenido directamente en la terminal.
  - Si no se proporcionan argumentos y no hay entrada estándar, se mostrará este mensaje de ayuda.

Ejemplos:

  1. Usar con entrada estándar (ej. pegar contenido en la terminal):
     echo 'test@example.com' | perl grep-email.pl -

  2. Usar con un archivo:
     perl grep-email.pl archivo.txt
     
___

\#grep function.pl

Lanza un oneliner perl que permite capturar nombres de funciones en un código determinado.
Ejemplo:

#cat *.pl | ./grep-funcion.pl

___

\#grep-ip.pl

Extrae ips de archivos.

Uso: ./grep-ip.pl [archivo] o mediante una tubería

Ejemplo 1: cat ips.txt | ./grep-ip.pl

Ejemplo 2: ./grep-ip.pl ips.txt

___

\#jumpscp.pl

Uso: ./jumpscp.pl <proxy_user> <target_user> <target_host> <jump_server_index> <remote_file_path> <local_file_path>

Descripción:

Este script copia un archivo desde un servidor objetivo a tu máquina local a través de un servidor de salto seleccionado de una lista.

Parámetros:

  <proxy_user>      Usuario para el servidor de salto.
  
  <target_user>     Usuario para el servidor objetivo.
  
  <target_host>     Dirección del servidor objetivo.
  
  <jump_server_index>  Índice del servidor de salto en la lista (1 a 5).
  <remote_file_path>  Ruta del archivo en el servidor objetivo que deseas copiar.
  
  <local_file_path>   Ruta local donde deseas guardar el archivo.

Lista de servidores de salto disponibles:

  1: jump1.example.com
  
  2: jump2.example.com
  
  3: jump3.example.com
  
  4: jump4.example.com
  
  5: jump5.example.com

Ejemplo:

  $0 usuario_proxy usuario_objetivo servidor_objetivo.com 1 /ruta/remota/al/archivo /ruta/local/donde/guardar

___

\#lscount.pl

Uso: ./lscount.sh [DIRECTORIO]

Muestra una lista de extensiones de archivos y el número de archivos por cada extensión en el directorio especificado.

Parámetros:

  DIRECTORIO  El directorio a examinar.

Ejemplo:

  ./lscount.sh /ruta/al/directorio


___
