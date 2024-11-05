#!/bin/bash

# Funciones para cada opción del menú
mostrar_espacio_en_disco() {
    echo "Espacio en disco:"
    df -h
}

listar_archivos() {
    read -p "Introduce el directorio para listar los archivos: " directorio
    if [ -d "$directorio" ]; then
        echo "Archivos en $directorio:"
        ls -lah "$directorio"
    else
        echo "El directorio no existe."
    fi
}

mostrar_fecha_y_hora() {
    echo "Fecha y hora actuales:"
    date
}

buscar_archivo() {
    read -p "Introduce el nombre del archivo a buscar: " nombre_archivo
    read -p "Introduce el directorio donde buscar: " directorio
    if [ -d "$directorio" ]; then
        echo "Buscando '$nombre_archivo' en $directorio..."
        find "$directorio" -name "$nombre_archivo"
    else
        echo "El directorio no existe."
    fi
}

mostrar_top_procesos_memoria() {
    echo "Los 10 procesos que más memoria consumen:"
    ps aux --sort=-%mem | head -n 11
}

# Mostrar el menú
mostrar_menu() {
    echo "Por favor selecciona una opción:"
    echo "1) Mostrar espacio en disco"
    echo "2) Listar archivos en un directorio"
    echo "3) Mostrar fecha y hora actuales"
    echo "4) Buscar un archivo por nombre"
    echo "5) Mostrar los primeros 10 procesos por uso de memoria"
    echo "6) Salir"
}

# Leer la elección del usuario
leer_opcion() {
    local opcion
    read -p "Introduce una opción [1-6]: " opcion
    case $opcion in
        1) mostrar_espacio_en_disco ;;
        2) listar_archivos ;;
        3) mostrar_fecha_y_hora ;;
        4) buscar_archivo ;;
        5) mostrar_top_procesos_memoria ;;
        6) echo "Saliendo..." ; exit 0 ;;
        *) echo "Opción inválida. Inténtalo de nuevo." ;;
    esac
}

# Bucle principal
while true; do
    mostrar_menu
    leer_opcion
done

