#!/bin/bash

# Verificar que se proporcionaron el directorio local como parámetro
if [ "$#" -ne 1 ]; then
    echo "Uso: $0 <directorio_local>"
    exit 1
fi

# Asignar el parámetro a una variable
LOCAL_DIR=$1
USER="jenbeita"
SERVER="eirenhost.com"
PORT=106
REMOTE_DIR="/home/jenbeita/tests/"  # Cambia esta ruta por la ruta deseada en el servidor
BUILD_DIR="/home/jenbeita/tests/testing/" #ruta del tester

# Verificar si la carpeta local existe
if [ ! -d "$LOCAL_DIR" ]; then
    echo "La carpeta local $LOCAL_DIR no existe."
    exit 1
fi

# Eliminar la subcarpeta .git si existe
if [ -d "$LOCAL_DIR/.git" ]; then
    echo "Eliminando la subcarpeta .git de $LOCAL_DIR"
    rm -rf "$LOCAL_DIR/.git"
fi

# Renombrar la carpeta local
RENAMED_DIR="$(dirname "$LOCAL_DIR")/testing"
cp "$LOCAL_DIR" "$RENAMED_DIR"

# Conectar a SFTP y realizar las operaciones
sftp -P $PORT $USER@$SERVER <<EOF
rm -rf $REMOTE_DIR/testing || true  # Eliminar la carpeta remota si existe, ignorar errores si no existe
mkdir $REMOTE_DIR  # Crear el directorio remoto si no existe
put -r $RENAMED_DIR $REMOTE_DIR  # Subir la carpeta
bye
EOF

echo "La carpeta ha sido subida correctamente al servidor."
