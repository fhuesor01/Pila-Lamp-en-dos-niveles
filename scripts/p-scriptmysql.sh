#!/bin/bash

# actualizar la lista de paquetes e instalamos los paquetes necesarios-->
# mariadb-server (servidor de bd que tambien incluye cliente mysql) y 
# git (para clonar la aplicacion)
apt-get update
apt-get install -y mariadb-server git


# permitimos la conexion cambiando el contenido del campo "bind-address"
# por la ip de la maquina (red interna) en el archivo de configuracion
# seguido de un reinicio de mariadb
sed -i "s/^bind-address.*/bind-address = $IP_M/" /etc/mysql/mariadb.conf.d/50-server.cnf
systemctl restart mariadb


# creamos una bd con la variable de vagrantfile
mysql -e "CREATE DATABASE IF NOT EXISTS $DB_N;"

# y ahora con la bd ya creada clonamos el repositorio dentro de la carpeta tmp
# para importar el esquema de tablas dentro de la bd creada
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/pila-lamp
mysql "$DB_N" < /tmp/pila-lamp/db/database.sql
# eliminamos el clon del repo en tmp
rm -rf /tmp/pila-lamp


# creamos el usuario de la bd con las variables de vagrantfile
# para poder conectarnos desde apache, dandole permisos totales
# a la bd de la aplicacion importada
mysql <<EOF
DROP USER IF EXISTS '$DB_U'@'$IP_A';
CREATE USER '$DB_U'@'$IP_A' IDENTIFIED BY '$DB_P';
GRANT ALL PRIVILEGES ON $DB_N.* TO '$DB_U'@'$IP_A';
FLUSH PRIVILEGES;
EOF


# prevenimos que haya salida a internet una vez se reinicie la maquina
# no dejando al DHCP que vuelva a poner la puerta de enlace
echo "unset new_routers" > /etc/dhcp/dhclient-enter-hooks.d/del-gateway
# borramos la ruta por defecto actual que es la que nos da salida a internet
ip route del default
