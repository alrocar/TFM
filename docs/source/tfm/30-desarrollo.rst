.. _desarrollo:

Desarrollo del trabajo y resultados obtenidos
=============================================

6. Desarrollo del trabajo y resultados obtenidos.

- CARTO: Arquitectura
      - PostGIS
        - FDW: pg_fdw or custom
        - ODBC drivers


De acuerdo a la metodología definida en el apartado a interior, en este apartado se incluye el desarrollo de la misma para cada uno de los sistemas de almacenamiento big data objetivo de ser integrados con CARTO.

El objetivo es contar con un procedimiento sistemático que incluya al menos las siguientes fases, para cada sistema de almacenamiento:

1. Despliegue de un entorno de prueba del sistema de almacenamiento big data
2. Búsqueda, instalación y prueba de un driver ODBC compatible
3. Búsqueda, instalación y prueba de un Foreign Data Wrapper (opcionalmente se puede utilizar la implementación base de PostgreSQL o implementar una propia)
4. Desarrollo de un conector para CARTO
5. Ingestión de datos hacia CARTO

Conceptos previos
-----------------

- Cómo probar un FDW / compatibilidad con postgres_fdw
- Cómo funciona unixODBC

Integración de CARTO con Apache Hive
------------------------------------

Apache Hive es una infraestructura de almacenamiento y procesamiento de datos almacenados sobre HDFS de Hadoop y otros sistemas compatibles como Amazon S3, originalmente desarrollado por Facebook.

Hive es fundamentalmente una capa de abstracción que convierte consultas SQL (escritas en un lenguaje compatible con SQL llamado HiveQL) en trabajos MapReduce, Tez o Spark.

La integración de CARTO con Apache Hive se va a realizar de acuerdo a los siguientes parámetros:

- Soporta SQL: Sí
- Driver ODBC: Sí
- Compatible con `postgres_fdw`: Sí
- Versión actual: 2.3.0
- Autenticación: Usuario y contraseña
- Distribución: Cloudera Quickstart
- Despliegue: Docker sobre AWS

Despliegue de un entorno de prueba de Apache Hive
-------------------------------------------------

Para desplegar una instancia de Apache Hive, utilizamos la imagen de Cloudera Quickstart disponible en Docker Hub, ejecutando el siguiente comando:

::

    docker pull cloudera/quickstart:latest
    docker run --name=cloudera -p 8888:8888 -p 10000:10000 -p 21050:21050 -v /tmp:/tmp --hostname=quickstart.cloudera --privileged=true -t -i -d cloudera/quickstart /usr/bin/docker-quickstart
    docker exec -it cloudera /bin/bash

Para este caso, hay que tener en cuenta que la imagen de Cloudera Quickstart cuenta con una distribución completa de Hadoop, por tanto con la imagen se arrancan multitud de servicios y es necesaria una cantidad considerable de memoria RAM.

Para el caso en el que sea desea correr esta imagen en una máquina local o con recursos limitados, es posible que algunos de los procesos no arranquen. En estos casos, es recomendable parar el resto de procesos que no son imprescindibles para contar con una instancia de Apache Hive.

Deteniendo los siguientes servicios es posible arrancar una imagen de Cloudera Quickstart con Docker, únicamente con 2GB de memoria:

::

    /etc/init.d/flume-ng-agent stop
    /etc/init.d/oozie stop
    /etc/init.d/spark-history-server stop
    /etc/init.d/solr-server stop
    /etc/init.d/flume-ng-agent stop
    /etc/init.d/hive-metastore restart
    /etc/init.d/hive-server2 restart
    /etc/init.d/flume-ng-agent stop
    /etc/init.d/hbase-master stop
    /etc/init.d/hbase-regionserver stop
    /etc/init.d/hbase-rest stop
    /etc/init.d/hbase-solr-indexer stop
    /etc/init.d/hbase-thrift stop
    /etc/init.d/oozie stop
    /etc/init.d/sentry-store stop

Después de detener los servicios es importante reiniciar la interfaz de HUE que nos permitirá realizar consultas interactivas sobre Hive con el siguiente comando: `/etc/init.d/hue restart`

Ingestión de datos en Apache Hive
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una vez hemos desplegado Apache Hive utilizando la imagen de Cloudera Quickstart con Docker, podemos hacer una ingestión inicial de datos para posteriormente realizar las pruebas necesarias de integración con CARTO.

Accediendo al servidor EC2 de Amazon:

::

    ssh {path_to_pem_file} {user}@{server}

Y a continuación abriendo una sesión de bash en el contenedor de Cloudera Quickstart:

::

	docker exec -it cloudera /bin/bash

Podemos utilizar `sqoop` para hacer una ingestión inicial de datos en Hive desde una base de datos MySQL incluida en la imagen de Cloudera con el siguiente comando:

::

    sqoop import-all-tables \
        --connect jdbc:mysql://localhost:3306/retail_db \
        --username=retail_dba \
        --password=cloudera \
        --compression-codec=snappy \
        --as-parquetfile \
        --warehouse-dir=/user/hive/warehouse \
        --hive-import

Por último, podemos acceder a la interfaz de HUE y comprobar que efectivamente las tablas se han cargado correctamente en Hive

TODO: añadir capturas de pantalla

::

    http://localhost:8888/
    usr/pwd: cloudera/cloudera

Instalación y prueba de un driver ODBC para Hive
------------------------------------------------

En este caso, Cloudera proporciona un driver ODBC para Hive con licencia libre que podemos instalar en distribuciones Redhat/CentOS con los siguientes comandos:

::

    wget "https://downloads.cloudera.com/connectors/hive_odbc_2.5.22.1014/Linux/EL6/ClouderaHiveODBC-2.5.22.1014-1.el6.x86_64.rpm"
    yum install cyrus-sasl-gssapi.x86_64 cyrus-sasl-plain.x86_64
    yum --nogpgcheck localinstall ClouderaHiveODBC-2.5.22.1014-1.el6.x86_64.rpm

Configuración del driver ODBC para Hive
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una vez descargado el driver ODBC para Hive es necesario editar los archivos que PostgreSQL utiliza para conocer los drivers disponibles en el sistema.

La ubicación de los archivos de configuración se puede obtener ejecutando la siguiente instrucción:

::

	[root@localhost vagrant]# odbcinst -j
        unixODBC 2.3.4
        DRIVERS............: /opt/carto/postgresql/embedded/etc/odbcinst.ini
        SYSTEM DATA SOURCES: /opt/carto/postgresql/embedded/etc/odbc.ini
        FILE DATA SOURCES..: /opt/carto/postgresql/embedded/etc/ODBCDataSources
        USER DATA SOURCES..: /root/.odbc.ini
        SQLULEN Size.......: 8
        SQLLEN Size........: 8
        SQLSETPOSIROW Size.: 8

El comando `odbcinst` lo provee el paquete `unixODBC` que viene instalado por defecto en la distribución on-premise de CARTO.

Una vez conocemos la ubicación de los archivos de configuración, añadimos el driver de Hive a la lista de drivers disponibles:

::

    printf "\n[Hive]
    Description=Cloudera ODBC Driver for Apache Hive (64-bit)
    Driver=/opt/cloudera/hiveodbc/lib/64/libclouderahiveodbc64.so" >> /data/production/config/postgresql/odbcinst.ini

Instalación y prueba de un Foreign Data Wrapper para Hive
---------------------------------------------------------

Una primera aproximación a la hora de probar un Foreign Data Wrapper para Hive, consiste en probar la implementación base disponible en PostgreSQL `postgres_fdw`.

En este caso, el driver ODBC de Cloudera para Apache Hive es compatible con `postgres_fdw` del que CARTO cuenta con una implementación base.

Desarrollo de un conector de Hive para CARTO
--------------------------------------------

Puesto que el driver ODBC para Hive es compatible con `postgres_fdw` la implementación de un conector de Hive para CARTO se reduce a añadir una nueva clase al `backend` indicando cuáles son los parámetros necesarios para realizar una consulta SQL sobre Hive y configurar este conector para que sea accesible desde la API de importación de CARTO.

El código del conector `hive.rb` se adjunta en el anexo xxx -> TODO incluir enlace

Una vez disponemos del código del conector, hay que configurarlo en CARTO de la siguiente manera:

::

    cp /opt/carto/builder/embedded/cartodb/lib/carto/connector/providers/hive.rb /opt/carto/builder/embedded/cartodb/lib/carto/connector/providers/hive.rb.bk
    sed 's/Hortonworks Hive ODBC Driver 64-bit/Hive/g' /opt/carto/builder/embedded/cartodb/lib/carto/connector/providers/hive.rb.bk > /opt/carto/builder/embedded/cartodb/lib/carto/connector/providers/hive.rb

A continuación, reiniciar los procesos de CARTO que hacen uso de los conectores:

::

    /etc/init.d/builder restart
    /etc/init.d/resque restart

Finalmente, habilitar el conector para una organización:

Enabling the Hive ODBC connector for the organization `organization`

::

    cd /opt/carto/builder/embedded/cartodb
    RAILS_ENV=production RAILS_CONFIG_BASE_PATH=/data/production/config/builder bundle exec rake cartodb:connectors:create_providers
    RAILS_ENV=production RAILS_CONFIG_BASE_PATH=/data/production/config/builder bundle exec rake cartodb:connectors:set_org_config[hive,organization,true,1000000]
    RAILS_ENV=production RAILS_CONFIG_BASE_PATH=/data/production/config/builder bundle exec rake cartodb:connectors:set_org_config[odbc,organization,true,1000000]

Ingestion de datos desde Hive a CARTO
-------------------------------------

Una vez disponemos de una instalación on-premise de CARTO, con el driver ODBC de Hive correctamente instalado y configurado tanto en el sistema como en CARTO y un conector correctamente implementado, podemos realizar una ingestión de datos desde Hive a CARTO utilizando la API de importación de la siguiente manera:

::

    curl -v -k -H "Content-Type: application/json"   -d '{
      "connector": {
        "provider": "hive",
        "connection": {
          "server":"{hive_server_ip}",
          "database":"default",
          "port":10000,
          "username":"{hive_user}",
          "password":"{hive_password}"
        },
        "schema": "default",
        "table": "top_order_items",
        "sql_query": "select * from order_items where price > 1000"
      }
    }'   "https://carto.com/user/carto/api/v1/imports/?api_key={YOUR_API_KEY}"

La anterior llamada a la API de importación, crea una conexión mediante Foreign Data Wrapper desde el servidor de CARTO (en concreto desde el servidor de PostgreSQL) hacia el servidor de Hive a través del puerto 10000 (el puerto por defecto de Hive).

Una vez realizada la conexión, se crea una tabla en PostgreSQL de nombre `top_order_items` y se ejecuta la siguiente consulta en Hive para obtener los pedidos con un precio superior a mil dólares:

::

    select * from order_items where price > 1000

Hive transformará está consulta SQL en un trabajo MapReduce y devolverá el resultado al Foreign Data Wrapper, convirtiéndose en filas de la tabla en PostgreSQL.

Esta table de PostgreSQL está asociada a un dataset del usuario de CARTO que lanzó la petición y por tanto puede trabajar con él, de la misma manera que con cualquier otro dataset.
