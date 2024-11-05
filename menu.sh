#!/bin/bash

# Funciones para cada opción del menú
opcion1() {
    echo "Has seleccionado la opción 1"
    # Añade aquí el código para la opción 1
}

opcion2() {
    echo "Has seleccionado la opción 2"
    # Añade aquí el código para la opción 2
}

opcion3() {
    echo "Has seleccionado la opción 3"
    # Añade aquí el código para la opción 3
}

opcion4() {
    echo "Has seleccionado la opción 4"
    # Añade aquí el código para la opción 4
}

opcion5() {
    echo "Has seleccionado la opción 5"
    # Añade aquí el código para la opción 5
clear
}

# Mostrar el menú
mostrar_menu() {
    echo "Por favor selecciona una opción:"
    echo "1) Opción 1"
    echo "2) Opción 2"
    echo "3) Opción 3"
    echo "4) Opción 4"
    echo "5) Opción 5: Limpiar pantalla"
    echo "6) Salir"
}

# Leer la elección del usuario
leer_opcion() {
    local opcion
    read -p "Introduce una opción [1-6]: " opcion
    case $opcion in
        1) opcion1 ;;
        2) opcion2 ;;
        3) opcion3 ;;
        4) opcion4 ;;
        5) opcion5 ;;
        6) echo "Saliendo..." ; exit 0 ;;
        *) echo "Opción inválida. Inténtalo de nuevo." ;;
    esac
}

# Bucle principal
while true; do
    mostrar_menu
    leer_opcion
done

