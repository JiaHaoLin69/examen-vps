#!/bin/bash
load_entrypoint_seguridad() {
    echo "Ejecutando entrypoint seguridad..." >> /root/logs/informe_nginx.log
    
    if [ -f /root/admin/ubseguridad/jhlwstart.sh ]; then
        bash /root/admin/ubseguridad/jhlwstart.sh
        echo "Entrypoint seguridad ejecutado" >> /root/logs/informe_nginx.log
    else
        echo "ERROR: No se encontró /root/admin/ubseguridad/jhlwstart.sh" >> /root/logs/informe_nginx.log
    fi
}

load_entrypoint_nginx(){
    echo "Cargando entrypoint Nginx..." >> /root/logs/informe_react.log
    
    if [ -f /root/admin/sweb/nginx/jhlwstart.sh ]; then
        bash /root/admin/sweb/nginx/jhlwstart.sh
        echo "Entrypoint Nginx ejecutado" >> /root/logs/informe_react.log
    else
        echo "ADVERTENCIA: start.sh de Nginx no encontrado" >> /root/logs/informe_react.log
    fi
}

workdir(){
    echo "Cambiando directorio..." >> /root/logs/informe_react.log
    
    if [ -d /root/admin/node/proyectos/autocaravaneando ]; then
        cd /root/admin/node/proyectos/autocaravaneando
        echo "Directorio cambiado a: $(pwd)" >> /root/logs/informe_react.log
    else
        echo "ERROR: Directorio /root/admin/node/proyectos/autocaravaneando no existe" >> /root/logs/informe_react.log
        exit 1
    fi
}

dependencias-y-servicio(){
    echo "Instalando dependencias..." >> /root/logs/informe_react.log
    
    # Verificar si package.json existe
    if [ -f package.json ]; then
        npm install && echo "Dependencias instaladas" >> /root/logs/informe_react.log
        npm audit fix && echo "Vulnerabilidades corregidas" >> /root/logs/informe_react.log
        npm audit fix --force && echo "Vulnerabilidades graves corregidas" >> /root/logs/informe_react.log
        # Inciar el servidor de desarrollo de React
        npm start -- --host 0.0.0.0 --port 3000 && echo "Servidor React iniciado" >> /root/logs/informe_react.log
    else
        echo "ERROR: package.json no encontrado" >> /root/logs/informe_react.log
    fi
}

contruir_y_copiar(){
    
    # Construir proyecto
    if npm run build; then
        echo "Proyecto construido" >> /root/logs/informe_react.log
    else
        echo "ERROR: Falló npm run build" >> /root/logs/informe_react.log
        exit 1
    fi

    # Copiar a /var/www/html
    if [ -d dist ]; then
        cp -r dist/* /var/www/html/
        echo "Archivos copiados a /var/www/html" >> /root/logs/informe_react.log
    else
        echo "ERROR: Directorio dist no encontrado" >> /root/logs/informe_react.log
        exit 1
    fi
}

cargar_nginx(){
    echo "Configurando Nginx..." >> /root/logs/informe_react.log
    # Verificar configuración de Nginx
    if nginx -t; then
        echo "Configuración Nginx OK" >> /root/logs/informe_react.log
    else
        echo "ERROR: Configuración Nginx inválida" >> /root/logs/informe_react.log
        exit 1
    fi
    
    # Iniciar Nginx
    nginx -g 'daemon off;'
    echo "Nginx iniciado" >> /root/logs/informe_react.log
}

main(){
    mkdir -p /root/logs
    touch /root/logs/informe_react.log
    load_entrypoint_seguridad
    load_entrypoint_nginx
    workdir
    dependencias-y-servicio
    construir_y_copiar
    cargar_nginx
}

main