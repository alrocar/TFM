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
- Versión probada: 2.3.0
- Autenticación: Usuario y contraseña
- Distribución: Cloudera Quickstart
- Despliegue: Docker sobre AWS

Despliegue de un entorno de prueba de Apache Hive
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una primera aproximación a la hora de probar un Foreign Data Wrapper para Hive, consiste en probar la implementación base disponible en PostgreSQL `postgres_fdw`.

En este caso, el driver ODBC de Cloudera para Apache Hive es compatible con `postgres_fdw` del que CARTO cuenta con una implementación base.

Desarrollo de un conector de Hive para CARTO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Puesto que el driver ODBC para Hive es compatible con `postgres_fdw` la implementación de un conector de Hive para CARTO se reduce a añadir una nueva clase al `backend` indicando cuáles son los parámetros necesarios para realizar una consulta SQL sobre Hive y configurar este conector para que sea accesible desde la API de importación de CARTO.

El código del conector `hive.rb` se adjunta en el anexo xxx -> TODO incluir enlace

Ingestion de datos desde Hive a CARTO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

Esta tabla de PostgreSQL está asociada a un dataset del usuario de CARTO que lanzó la petición y por tanto puede trabajar con él, de la misma manera que con cualquier otro dataset.

Integración de CARTO con Apache Impala
--------------------------------------

Apache Impala es una infraestructura de almacenamiento y procesamiento de datos almacenados sobre HDFS de Hadoop, originalmente desarrollado por Cloudera.

Apache Impala es compatible con HiveQL y utiliza la misma base de datos de metadatos para acceder a HDFS que Hive, pero a diferencia de este, cuenta con un modelo de procesamiento en memoria de baja latencia que permite realizar consultas interactivas orientadas a entornos *Business Intelligence*.

La integración de CARTO con Apache Impala se va a realizar de acuerdo a los siguientes parámetros:

- Soporta SQL: Sí
- Driver ODBC: Sí
- Compatible con `postgres_fdw`: Sí
- Versión probada: 2.10.0
- Autenticación: Usuario y contraseña
- Distribución: Cloudera Quickstart
- Despliegue: Docker sobre AWS

Despliegue de un entorno de prueba de Apache Impala
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Para desplegar una instancia de Apache Impala, utilizamos la imagen de Cloudera Quickstart disponible en Docker Hub, tal y como hicimos al desplegar Apache Hive.

TODO añadir link a la sección anterior

Ingestión de datos en Apache Impala
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Apache Impala es compatible con el modelo de metadatos de Apache Hive, por tanto, se pueden ingestar datos en Apache Impala tal y como se hizo para Apache Hive. [TODO] -> Añadir link a la sección correspondiente.

Una vez presentes los datos en el `metastore` de Hive, es necesario ejecutar la siguiente instrucción para actualizar la base de datos de metadatos de Impala:

::

    invalidate metadata;

Dicha instrucción se puede ejecutar directamente desde la consola de Impala disponible en HUE y accesible con las siguientes credenciales:

::

    http://localhost:8888/
    usr/pwd: cloudera/cloudera

Instalación y prueba de un driver ODBC para Impala
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El procedimiento para instalar el driver ODBC para Impala es similar al de Hive [TODO] -> link a la sección correspondiente.

::

    yum install -y cyrus-sasl.x86_64 cyrus-sasl-gssapi.x86_64 cyrus-sasl-plain.x86_64
    wget "https://downloads.cloudera.com/connectors/impala_odbc_2.5.37.1014/Linux/EL6/ClouderaImpalaODBC-2.5.37.1014-1.el6.x86_64.rpm"
    yum --nogpgcheck -y localinstall ClouderaImpalaODBC-2.5.37.1014-1.el6.x86_64.rpm

Configuración del driver ODBC para Impala
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una vez descargado el driver ODBC para Impala es necesario editar los archivos que PostgreSQL utiliza para conocer los drivers disponibles en el sistema.

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

Una vez conocemos la ubicación de los archivos de configuración, añadimos el driver de Impala a la lista de drivers disponibles:

::

    printf "\n[Impala]
    Description=Cloudera ODBC Driver for Impala (64-bit)
    Driver=/opt/cloudera/impalaodbc/lib/64/libclouderaimpalaodbc64.so" >> /data/production/config/postgresql/odbcinst.ini

Instalación y prueba de un Foreign Data Wrapper para Impala
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Análogamente a lo que ocurría con Hive, el driver ODBC de Cloudera para Apache Impala también es compatible con `postgres_fdw` del que CARTO cuenta con una implementación base. Por tanto, no es necesaria una implementación personalizada.

Desarrollo de un conector de Impala para CARTO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Puesto que el driver ODBC para Impala es compatible con `postgres_fdw` la implementación de un conector de Impala para CARTO se reduce a añadir una nueva clase al `backend` indicando cuáles son los parámetros necesarios para realizar una consulta SQL sobre Impala y configurar este conector para que sea accesible desde la API de importación de CARTO.

El código del conector `impala.rb` se adjunta en el anexo xxx -> TODO incluir enlace

Ingestion de datos desde Impala a CARTO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una vez más, la petición a la API de importación de CARTO es análoga a la del caso de Hive.

::

    curl -v -k -H "Content-Type: application/json"   -d '{
      "connector": {
        "provider": "impala",
        "connection": {
          "server":"{impala_server_ip}",
          "database":"default",
          "port":21050,
          "username":"{impala_user}",
          "password":"{impala_password}"
        },
        "schema": "default",
        "table": "top_order_items",
        "sql_query": "select * from order_items where price > 1000"
      }
    }'   "https://carto.com/user/carto/api/v1/imports/?api_key={YOUR_API_KEY}"

La anterior llamada a la API de importación, crea una conexión mediante Foreign Data Wrapper desde el servidor de CARTO (en concreto desde el servidor de PostgreSQL) hacia el servidor de Impala a través del puerto 21050 (el puerto por defecto de Impala).

Una vez realizada la conexión, se crea una tabla en PostgreSQL de nombre `top_order_items` y se ejecuta la siguiente consulta en Impala para obtener los pedidos con un precio superior a mil dólares:

::

    select * from order_items where price > 1000

En este caso, Impala no implementa el paradigma MapReduce sino que utiliza un mecanismo de procesamiento en memoria que permite la realización de consultas interactivas, por lo que la respuesta tiene una latencia menor al caso de Hive.

La tabla generada en PostgreSQL está asociada a un dataset del usuario de CARTO que lanzó la petición y por tanto puede trabajar con él, de la misma manera que con cualquier otro dataset.

Integración de CARTO con Amazon Redshift
----------------------------------------

Amazon Redshift es un almacén de datos de la familia de servicios web de Amazon, completamente administrado que permite analizar datos con SQL estándar.

La integración de CARTO con Apache Redshift se va a realizar de acuerdo a los siguientes parámetros:

- Soporta SQL: Sí
- Driver ODBC: Sí
- Compatible con `postgres_fdw`: Sí
- Versión probada: Amazon no proporciona información acerca del versionado de Redshift, por tanto, las pruebas realizadas son con la versión actual a fecha Septiembre 2017
- Autenticación: Usuario y contraseña
- Distribución: AWS
- Despliegue: Auto-gestionado a través de la consola de administración de AWS

Despliegue de un entorno de prueba de Amazon Redshift
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TODO -> incluir capturas de pantalla

Ingestión de datos en Amazon Redshift
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

TODO

Instalación y prueba de un driver ODBC para Amazon Redshift
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El procedimiento para instalar el driver ODBC para Impala es similar a los de Hive e Impala [TODO] -> link a la sección correspondiente.

::

    wget "https://s3.amazonaws.com/redshift-downloads/drivers/AmazonRedshiftODBC-64bit-1.3.1.1000-1.x86_64.rpm"
    yum --nogpgcheck localinstall AmazonRedshiftODBC-64bit-1.3.1.1000-1.x86_64.rpm

Configuración del driver ODBC para Redshift
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una vez descargado el driver ODBC para Amazon Redshift es necesario editar los archivos que PostgreSQL utiliza para conocer los drivers disponibles en el sistema.

El procedimiento es análogo a los casos de Hive e Impala:

::

    printf "\n[Redshift]
    Description=Amazon Redshift ODBC Driver(64-bit)
    Driver=/opt/amazon/redshiftodbc/lib/64/libamazonredshiftodbc64.so" >> /data/production/config/postgresql/odbcinst.ini

Instalación y prueba de un Foreign Data Wrapper para Redshift
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Análogamente a lo que ocurría con Hive e Impala, el driver ODBC de Cloudera para Amazon Redshift también es compatible con `postgres_fdw` del que CARTO cuenta con una implementación base. Por tanto, no es necesaria una implementación personalizada.

Desarrollo de un conector de Redshift para CARTO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

El código del conector `redshift.rb` se adjunta en el anexo xxx -> TODO incluir enlace

Ingestion de datos desde Redshift a CARTO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una vez más, la petición a la API de importación de CARTO es análoga a la del caso de Hive e Impala.

::

    curl -v -k -H "Content-Type: application/json"   -d '{
      "connector": {
        "provider": "redshift",
        "connection": {
          "server":"{redshift_server_ip}",
          "database":"default",
          "port":5439,
          "username":"{redshift_user}",
          "password":"{redshift_password}"
        },
        "schema": "default",
        "table": "top_order_items",
        "sql_query": "select * from order_items where price > 1000"
      }
    }'   "https://carto.com/user/carto/api/v1/imports/?api_key={YOUR_API_KEY}"

Antes de continuar
------------------

Antes de continuar con el desarrollo de los siguientes conectores big data para CARTO, cabe destacar que hemos encontrado un procedimiento sistemática para desarrollar conectores desde sistemas de almacenamiento que cumplen las siguientes características:

- Tienen un Driver ODBC
- Soportan SQL como lenguaje de procesamiento
- Son compatibles con `postgres_fdw`

Tal y como hemos visto en las secciones anteriores, el desarrollo de conectores para Hive, Impala y Redshift es completamente análogo, por tanto, el mismo procedimiento sería válido para sistemas de almacenamiento que cumplan las 3 características mencionadas en esta sección.