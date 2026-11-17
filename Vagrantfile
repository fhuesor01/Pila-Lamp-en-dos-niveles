# -*- mode: ruby -*-
# vi: set ft=ruby :


# --- variables
# ip servidor apache
IP_A = "192.168.10.11"
# ip servidor mysql
IP_M  = "192.168.10.12"
# nombre BD
DB_N = "lamp_db"
# nombre usuario para la BD
DB_U = "lamp_user"
# contraseña para el usuario (!modificar esta variable por la contraseña que se desee)
DB_P = "lamp_pass"

Vagrant.configure("2") do |config|

  # box oficial de Debian 12 (Bookworm) para las dos máquinas
  config.vm.box = "debian/bookworm64"

  #  maquina 1: MySQL (definimos esta primero para que este lista para apache)
  config.vm.define "mysql" do |db|
    db.vm.hostname = "feliMysql"

    # con esta linea estamos creando la segunda interfaz de red privada para que se comuniquen ambas maquinas
    db.vm.network "private_network", ip: IP_M, virtualbox__intnet: true

    # aqui estamos especificando a Vbox, las caracteristicas de la maquina--> 
    # nombre, RAM, CPUs 
    db.vm.provider "virtualbox" do |vb|
      vb.name   = "feliMysql"
      vb.memory = 1024
      vb.cpus   = 1
    end

    # aqui indicamos la ruta del script de provisionamiento de esta maquina,
    # junto a una serie de variables que vamos a necesitar para el funcionamiento de este
    db.vm.provision "shell", path: "scripts/p-scriptmysql.sh",
    env: {
        "IP_A" => IP_A,
        "IP_M" => IP_M,
        "DB_N" => DB_N,
        "DB_U" => DB_U,
        "DB_P" => DB_P
      }
  end

  # ---

  #  maquina 2: Apache
  config.vm.define "apache" do |web|
    web.vm.hostname = "feliApache"

    # red interna
    web.vm.network "private_network", ip: IP_A, virtualbox__intnet: true

    # reenvio de puertos del 8080 de nuestro host al 80 de la maquina con apache
    web.vm.network "forwarded_port", guest: 80, host: 8080

    #Vbox config
    web.vm.provider "virtualbox" do |vb|
      vb.name   = "feliApache"
      vb.memory = 1024
      vb.cpus   = 1
    end

    # script provisionamiento
    web.vm.provision "shell", path: "scripts/p-scriptapache.sh",
      env: {
        "IP_M" => IP_M,
        "DB_N" => DB_N,
        "DB_U" => DB_U,
        "DB_P" => DB_P
      }
  end

end
