#!/bin/bash

# actualizamos la lista de paquetes e instalamos los paquetes necesarios-->
# apache2 (servidor web), php y libapache2-mod-php (para que apache ejecute php),
# php-mysql (para que php se conecte a la bd) y git (para clonar la aplicacion)
apt-get update
apt-get install -y apache2 php libapache2-mod-php php-mysql git


# clonamos el repositorio de la aplicacion dentro de la carpeta tmp
git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /tmp/pila-lamp

# eliminamos la pagina por defecto de apache y copiamos la aplicacion
# (carpeta src del repo) a la raiz del servidor web
rm -f /var/www/html/index.html
cp -r /tmp/pila-lamp/src/* /var/www/html/

# eliminamos el clon del repo en tmp
rm -rf /tmp/pila-lamp


# ajustamos el config.php de la aplicacion con las variables de vagrantfile
# para que se conecte a la bd de la otra maquina
sed -i \
  -e "s/define('DB_HOST', '.*')/define('DB_HOST', '$IP_M')/" \
  -e "s/define('DB_NAME', '.*')/define('DB_NAME', '$DB_N')/" \
  -e "s/define('DB_USER', '.*')/define('DB_USER', '$DB_U')/" \
  -e "s/define('DB_PASSWORD', '.*')/define('DB_PASSWORD', '$DB_P')/" \
  /var/www/html/config.php


# hacemos al usuario de apache propietario de los archivos de la web 
chown -R www-data:www-data /var/www/html

# reiniciamos apache para aplicar los cambios
systemctl restart apache2
