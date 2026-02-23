## A collection of shellscripts made mostly in perl, for use in korn Bash and zsh.

## Colección de scripts para utilizar en entornos de Korn Shell, Bash o Zsh , hechos principalmente en perl.

He hecho la mayoría de herramientas en perl porque permite una portabilidad casi total entre entornos. Todos los scripts se han realizado sin módulos externos, para intentar garantizar su funcionamiento en cualquier situación.

Aunque los nombres de las herramientas intentan ser autoexplicativos, iré incorporando en este documento una breve descripción de las utilidades.

<image src="https://github.com/ethnaut/shellTools/blob/main/3-wise-men.jpg" alt="The Three wisemen of Code">

___ 
[#awk-fa.pl](https://github.com/ethnaut/shellTools/blob/main/awk-fa.pl)

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

  [#edstr.sh](https://github.com/ethnaut/shellTools/blob/main/edstr.sh)
  
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
[#mmv.pl](https://github.com/ethnaut/shellTools/blob/main/mmv.pl)

Uso:
  mmv.pl '<patrón_origen>' '<patrón_destino>'

Descripción:

Recreación del comando mmv (multi-move) en Perl. Uso extensivo de expresiones regulares.

Ejemplos:
  Renombrar file{a..z}.txt a data{a..z}.txt:
    ./mmv.pl 'file*.txt' 'data#1.txt'

Ejemplos adicionales:

1. Mover una selección de archivos a otro directorio:
   Mueve todos los archivos .txt al subdirectorio 'backup':
   ./mmv.pl '*.txt' 'backup/#1.txt'

2. Cambiar el formato de fechas en los nombres de archivo:
   Transforma archivos con fechas en formato mmddaaaa a aaaammdd.
   Ejemplo: file_12042023.log -> file_20231204.log
   ./mmv.pl '*_([0-9]{2})([0-9]{2})([0-9]{4}).log' '#1_#3#1#2.log'

3. Añadir un prefijo a varios archivos:
   Agrega el prefijo 'archived_' a todos los archivos .csv:
   ./mmv.pl '*.csv' 'archived_#1.csv'

4. Cambiar extensiones de archivo:
   Convierte todos los archivos .jpeg a .jpg:
   ./mmv.pl '*.jpeg' '#1.jpg'

5. Reemplazar un segmento en los nombres de archivo:
   Cambia 'January' por 'Jan' en los archivos como report_January.docx:
   ./mmv.pl '*_January.docx' '#1_Jan.docx'

6. Enumerar archivos:
   Agrega un número consecutivo al final de los nombres de archivos .png:
   Ejemplo: image.png -> image_1.png, image_2.png, etc.
   ./mmv.pl '*.png' '#1_#2.png'

Notas:
- Recuerda crear los directorios de destino, como 'backup', antes de mover archivos.
- Usa comillas simples para proteger los patrones de la shell.
- Los patrones utilizan expresiones regulares de Perl.

Notas sobre capturas y marcadores:

1. Capturas en expresiones regulares:
   En el patrón de origen, las capturas se definen con paréntesis `()`.
   Ejemplo: En '*_([0-9]{2})([0-9]{2})([0-9]{4}).log':
     - $1 captura el mes (dos primeros dígitos).
     - $2 captura el día (siguientes dos dígitos).
     - $3 captura el año (cuatro últimos dígitos).

2. Uso de marcadores `#1`, `#2`, etc.:
   En el patrón de destino, los marcadores `#1`, `#2`, etc., se reemplazan por los valores capturados en el patrón de origen.
   Ejemplo:
     ./mmv.pl '*_([0-9]{2})([0-9]{2})([0-9]{4}).log' '#1_#3#1#2.log'
     Para el archivo `file_12042023.log`, el nuevo nombre será `file_20231204.log`.

3. Relación entre `*` y capturas:
   Cada `*` en el patrón de origen se convierte en una captura `(.*)`, accesible como $1, $2, etc.
   Ejemplo:
     ./mmv.pl 'file*.txt' 'data#1.txt'
     Para `file123.txt`, el `*` captura `123` y `#1` lo inserta en el nuevo nombre: `data123.txt`.

4. Consideraciones:
   - Hasta 9 capturas disponibles ($1 a $9).
   - Si un marcador como `#3` no tiene una captura correspondiente, será reemplazado por una cadena vacía.
   - Diseña los patrones cuidadosamente para evitar errores.

___

## Perl Games

Todo el mundo conoce el poder místico de las perlas, símbolos de sabiduría y transformación en las tradiciones esotéricas. En este apartado, exploraremos su simbolismo a través de **juegos basados en scripting perl inspirados en grandes maestros del Ocultismo y la Magia Ceremonial** ; Si quieres pasar un rato con [Agripa](https://es.wikipedia.org/wiki/Enrique_Cornelio_Agripa_de_Nettesheim), [Giordano Bruno](https://es.wikipedia.org/wiki/Giordano_Bruno) o [Eliphas levi](https://es.wikipedia.org/wiki/Eliphas_L%C3%A9vi), éste es tu sitio.

___
[tarot.pl](https://github.com/ethnaut/shellTools/blob/main/tarot.pl)

Échate unas tiradas al [Tarot](https://www.youtube.com/watch?v=Oj8B6mKFST0). Varios tipos de tirada.

Vaticinios, Introspección, Un salto al interior de tu psique.

<img src="https://github.com/ethnaut/shellTools/blob/main/RWS_Tarot_01_Magician.jpg" 
     alt="Vaticinios, Introspección, Un salto al interior de tu psique" 
     style="width: 20%; height: auto;"><img src="https://github.com/ethnaut/shellTools/blob/main/tarot-imagen.png" 
     alt="Vaticinios, Introspección, Un salto al interior de tu psique" 
     style="width: 50%; height: auto;">
___
[tiradas_bruno.pl](https://github.com/ethnaut/shellTools/blob/main/tiradas_bruno.pl)

Usa las [ruedas combinatorias](https://www.youtube.com/watch?v=P1o93J9fBrs) de Giordano

Gira las ruedas, y crea tu evocación, para usarla en tus Aedes Memoriae

<img src="https://github.com/ethnaut/shellTools/blob/main/ruedas-giordano.png" 
     alt="Gira las ruedas, y crea tu evocación, para usarla en tus Aedes Memoriae" 
     style="width: 50%; height: auto;"><img src="https://github.com/ethnaut/shellTools/blob/main/ruedas-giordano2.png" 
     alt="Gira las ruedas, y crea tu evocación, para usarla en tus Aedes Memoriae" 
     style="width: 35%; height: auto;">
___
[oraculo-runico.pl](https://github.com/ethnaut/shellTools/blob/main/oraculo-runico.pl)

Pregunta a las Runas . Varios tipos de tirada.

> *"Lanza las runas, y escucha lo que te dicen."*

<img src="https://github.com/ethnaut/shellTools/blob/main/runes-image.png" 
     alt="Lanza las runas, y escucha lo que te dicen" 
     style="width: 20%; height: auto;"><img src="https://github.com/ethnaut/shellTools/blob/main/oraculo-runico.png" 
     alt="Lanza las runas, y escucha lo que te dicen" 
     style="width: 50%; height: auto;">
___
[mansion-lunar.pl](https://github.com/ethnaut/shellTools/blob/main/mansion-lunar.pl)

Calcula la mansión lunar actual (de 28 Siguiendo la tradición del [Picatrix](https://es.wikipedia.org/wiki/Libro_de_Picatrix) ) para hoy o fecha + n días usando solo módulos internos. Muestra fecha UTC, posición lunar y solar, fase lunar, conjunciones simples y ficha con nombre, magia y talismán en UTF-8.

Funciona con cálculos astronómicos básicos, asigna mansión según posición sideral lunar y ofrece salida clara para uso mágico y talismánico. Se ejecuta sin argumentos o con número de días para avanzar.

<img src="https://github.com/ethnaut/shellTools/blob/main/mansion-lunar-imagen2.jpg" 
     alt="El propósito del Sabio" 
     style="width: 15%; height: auto;"><img src="https://github.com/ethnaut/shellTools/blob/main/mansion-lunar-imagen1.png" 
     alt="Escucha lo que te dicen las mansiones de la Luna" 
     style="width: 40%; height: auto;">

___

[inferno-run.pl](https://github.com/ethnaut/shellTools/blob/main/inferno-run.pl)

🔥 Inferno Run 

Un viaje dantesco a través de los 9 círculos del Infierno. 

No hay combates. Solo dilemas.
En cada círculo, una pregunta moral:
¿Salvarías a un sabio pagano? ¿Perdonarías una mentira piadosa? ¿La ira puede ser justicia? 

Responde: sí, no, no sé.
Al final, tu patrón revelará tu destino:
del limbo por tibio… al infierno por intransigente. 

Hecho en Perl.
Inspirado en Dante.
Diseñado para hacerte pensar. 

> *"El que juzga, también es juzgado."* 
     

<img src="https://github.com/ethnaut/shellTools/blob/main/inferno-run.png" 
     alt="Lanza las runas, y escucha lo que te dicen" 
     style="width: 55%; height: auto;"><img src="https://github.com/ethnaut/shellTools/blob/main/inferno-run1.png" 
     alt="Desciende al Infierno para encontrarte a tí mismo" 
     style="width: 15%; height: auto;">
___

🔮 [alchemist.pl](https://github.com/ethnaut/shellTools/blob/main/alchemist.pl) – El [Ouroboros](https://es.wikipedia.org/wiki/Ur%C3%B3boro#En_la_alquimia) de [Paracelso](https://es.wikipedia.org/wiki/Paracelso)

> *"Visita interiora terrae, rectificando invenies occultum lapidem."*  
> — *El Libro de la Piedra Oculta*

**alchemist.pl** es un juego de texto escrito en Perl que simula la [Magnum Opus alquímica](https://es.wikipedia.org/wiki/Opus_magnum_(alquimia)): la transformación de la materia corrompida en la **Piedra Filosofal**. Inspirado en [Paracelso](https://es.wikipedia.org/wiki/Paracelso), [John Dee](https://es.wikipedia.org/wiki/John_Dee), Giordano Bruno y la [tradición hermética renacentista](https://es.wikipedia.org/wiki/Magia_renacentista), este juego te sumerge en un laboratorio de sombras, fuego y secretos olvidados.

Corre en tu terminal. No hay gráficos. Solo palabras, decisiones… y consecuencias.

Puedes correrlo también como **alchemist.pl -oraculo**

<img src="https://github.com/ethnaut/shellTools/blob/main/alchemist-imagen.jpg" 
     alt="Lanza las runas, y escucha lo que te dicen" 
     style="width: 20%; height: auto;"><img src="https://github.com/ethnaut/shellTools/blob/main/alchemist-imagen2.jpg" 
     alt="El Libro de la Piedra Oculta" 
     style="width: 60%; height: auto;">

___

[iching.pl](https://github.com/ethnaut/shellTools/blob/main/iching.pl) El [libro de los cambios](https://es.wikipedia.org/wiki/I_Ching)

☯️ I Ching Run

Una consulta directa al I Ching no predice, responde.

Lanzas monedas (o tallos).
Emergen hexagramas.
Cada línea habla de tu momento, no de tu futuro.

No hay victoria ni derrota, sólo situación, cambio y actitud correcta.

Lee el dictamen.
Observa las líneas mutantes.
Decide tú.

Hecho en Perl.

“El sabio no fuerza el curso: lo reconoce.”

<img src="https://github.com/ethnaut/shellTools/blob/main/iching.png" 
     alt="Lanza las runas, y escucha lo que te dicen" 
     style="width: 45%; height: auto;"><img src="https://github.com/ethnaut/shellTools/blob/main/iching2.png" 
     alt="Consulta el oráculo de la milenrama y escucha el cambio" 
     style="width: 40%; height: auto;">

