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
4. Ingestión de datos hacia CARTO

Integración de CARTO con Apache Hive
------------------------------------

Apache Hive es una infraestructura de almacenamiento y procesamiento de datos almacenados sobre HDFS de Hadoop y otros sistemas compatibles como Amazon S3, originalmente desarrollado por Facebook.

Hive es fundamentalmente una capa de abstracción que convierte consultas SQL (escritas en un lenguaje compatible con SQL llamado HiveQL) en trabajos MapReduce, Tez o Spark.

La integración de CARTO con Apache Hive se va a realizar de acuerdo a los siguientes parámetros:

- Soporta SQL: Sí
- Driver ODBC: Sí
- Compatible con `pg_fdw`: Sí
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


