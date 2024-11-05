#!/bin/ksh


if [[ $# -eq 0 && -t 0 ]]; then
  echo "Uso:"
  echo "  1. Sustituir directamente en un archivo (con backup):"
  echo "     ./edstream patrón reemplazo archivo"
  echo "     - Sustituye todas las ocurrencias de 'patrón' por 'reemplazo' en 'archivo'."
  echo "     - Genera un archivo de respaldo con el sufijo ~ (archivo.txt -> archivo.txt~)."
  echo
  echo "  2. Usar con redirección o pipe (sin backup):"
  echo "     cat archivo.txt | ./edstream patrón reemplazo"
  echo "     - Reemplaza todas las ocurrencias de 'patrón' por 'reemplazo' en el flujo de entrada."
  echo "     - No modifica ningún archivo, la salida es enviada a stdout."
  echo
  echo "Ejemplos:"
  echo "  ./edstream foo bar archivo.txt     # Sustituye 'foo' por 'bar' en archivo.txt con backup"
  echo "  cat archivo.txt | ./edstream foo bar  # Sustituye 'foo' por 'bar' en la salida del pipe"
  echo "./edstream '^\Q127.0.0.1\E' '# 127.0.0.1' hosts_file  # Añade comentario en la línea que comienza por localhost"
  exit 1
fi

# Verifica si el script recibe un archivo o si los datos provienen de stdin (pipe o redirección)
if [[ -t 0 ]]; then
  # Si hay argumentos, espera un archivo como parámetro
  if [[ $# -ne 3 ]]; then
    echo "Uso: $0 patrón reemplazo archivo"

    exit 1
  fi

  # Usa Perl para hacer la sustitución en el archivo directamente, con backup
  perl -pi~ -e "s/$1/$2/g" "$3"

  # Mensaje de éxito
  echo "Sustitución realizada en $3. Se creó un archivo de respaldo $3~."

else
  # Si se reciben datos a través de un pipe o redirección, no hay respaldo y se usa stdin
  if [[ $# -ne 2 ]]; then
    echo "Uso: $0 patrón reemplazo < archivo" >&2
    exit 1
  fi

  # Lee desde stdin (canalización o redirección) y ejecuta la sustitución
  perl -pe "s/$1/$2/g"
fi

