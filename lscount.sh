#!/bin/bash

# Función para mostrar ayuda
mostrar_ayuda() {
    echo "Uso: $0 [DIRECTORIO]"
    echo "Muestra una lista de extensiones de archivos y el número de archivos por cada extensión en el directorio especificado."
    echo ""
    echo "Parámetros:"
    echo "  DIRECTORIO  El directorio a examinar."
    echo ""
    echo "Ejemplo:"
    echo "  $0 /ruta/al/directorio"
}

# Verificar si no se proporcionaron parámetros
if [ $# -eq 0 ]; then
    echo "Error: Debes proporcionar un directorio."
    mostrar_ayuda
    exit 1
fi

# Verificar si el parámetro es un directorio válido
DIRECTORIO=$1
if [ ! -d "$DIRECTORIO" ]; then
    echo "Error: $DIRECTORIO no es un directorio válido."
    exit 1
fi

# Contar las extensiones de archivo en el directorio dado
find "$DIRECTORIO" -type f | awk -F. '{if (NF>1) print $NF; else print "no_extension"}' | sort | uniq -c | sort -nr

