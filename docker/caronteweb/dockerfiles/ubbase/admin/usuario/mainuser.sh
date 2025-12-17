#!/bin/bash

comprobar_usuario(){
    if grep -q "^$USUARIO:" /etc/passwd 
    then
        echo "El usuario $USUARIO ya existe." >> /root/logs/informe.log
        return 1
    else
        echo "El usuario $USUARIO no existe. Creando usuario..." >> /root/logs/informe.log
        return 0
    fi
}

comprobar_directorio(){
    if [ ! -d "/home/$USUARIO" ]
    then
        echo "El directorio /home/$USUARIO no existe." >> /root/logs/informe.log
        return 0
    else
        echo "El directorio /home/$USUARIO ya existe." >> /root/logs/informe.log
        return 1
    fi
}

crear_usuario(){
    comprobar_usuario
    if [ $? -eq 0 ]
    then
        comprobar_directorio
        if [ $? -eq 0 ]
        then
            useradd -rm -d /home/$USUARIO -s /bin/bash $USUARIO
            echo "$USUARIO:$PASSWORD" | chpasswd
            echo "Bienvenido $USUARIO" > /home/$USUARIO/welcome.txt
            echo "Usuario $USUARIO creado con éxito." >> /root/logs/informe.log
            return 0
        else
            echo "No se puede crear el usuario $USUARIO porque el directorio ya existe." >> /root/logs/informe.log
            return 1
        fi
    else
        echo "No se puede crear el usuario $USUARIO porque ya existe." >> /root/logs/informe.log
        return 1
    fi
}