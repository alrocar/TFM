.. _estado-del-arte:

Estado del arte
===============

En este capítulo se presenta un informe sobre los diferentes sistemas de almacenamiento y procesamiento big data para los que se van a realizar conectores para CARTO y una breve definición de los conceptos teóricos que sirven de fundamentación para el trabajo.

Conceptos previos
-----------------

- Procesamiento batch vs interactivo (Interactivo es batch pero con latencia del orden de segundos o minutos en caso de análisis de petabytes)
- Driver ODBC
- Foreign Data Wrapper

CARTO
-----

- Business Intelligence ~ Location Intelligence
- CARTO: Arquitectura
  - PostgreSQL/PostGIS como base de datos y framework de análisis 

Características:

- Datos estructurados


Sistemas de almacenamiento y procesamiento big data
---------------------------------------------------

En este trabajo se estudian los siguientes sistemas de almacenamiento y procesamiento big data:

- Apache Hive
- Impala
- Amazon Redshift
- MongoDB
- Google BigQuery

- Cassandra
- SparkSQL

- Amazon Aurora
- Oracle

- MemSQL
- Teradata
- SAP Hana

Como se puede observar de la lista, el ecosistema es muy amplio y como veremos a continuación, heterogéneo. Por lo que en esta sección se va a hacer una breve descripción de los mismos atendiendo a las siguientes características:

- Tipo de sistema: Si ofrece almacenamiento y procesamiento o sólo uno de ambos.
- Tipo de procesamiento: Batch, interactivo, tiempo real, etc.
- Tipo de despliegue/distribución: Nube pública, privada, SaaS, on-premises, etc.
- Interfaces de programación/consulta: SQL, SDKs en diferentes lenguajes, APIs REST, etc.
- Autenticación: Usuario y contraseña, HTTP/HTTPS, Kerberos/LDAP, OAuth, etc.
- Tipo de licencia/propietario: Software libre (Apache, GPL, etc.), propietaria (Google, Amazon, Oracle, etc.)
- Versión actual
- Driver ODBC

Para el motivo de este trabajo, no es necesario conocer otros detalles como mecanismos de replicación, particionamiento, tolerancia a fallos, etc. ya que el objetivo no consiste en administrar este tipo de sistemas.

Sin embargo, el objetivo es doble:

1. Por una parte, contar con una visión general de los sistemas con los que se va a trabajar.
2. Por otra parte, poder identificar similitudes y diferencias entre ellos.
3. Por último, dar soporte al mayor número posible de tecnologías de almacenamiento y procesamiento big data, especialmente aquellas de carácter libre.

Apache Hive
^^^^^^^^^^^

Apache Hive es una infraestructura de almacenamiento y procesamiento de datos almacenados sobre HDFS de Hadoop y otros sistemas compatibles como Amazon S3, originalmente desarrollado por Facebook.

Ofrece un lenguaje de consulta basado en SQL llamado HiveQL que convierte las consultas en trabajos MapReduce, Tez o Spark.

Actualmente, como gran parte de los sistemas batch es considerado un sistema *legacy*, aunque por otra parte es un sistema apliamente establecido en la industria que cuenta con gran cantidad de herramientas integradoras dentro del sistema Hadoop tales como: Pig, Sqoop, Flume, etc.

Se suele utilizar para procesamiento batch de ficheros almacenados en HDFS.

- Tipo de sistema: Almacenamiento y procesamiento.
- Tipo de procesamiento: Batch.
- Tipo de despliegue/distribución: Nube pública y privada (on-premises) con multitud de distribuciones (Amazon EMR, Cloudera, Hortonworks, MapR)
- Interfaces de programación/consulta: HiveQL compatible con SQL
- Autenticación: Usuario y contraseña, HTTP/HTTPS, Kerberos/LDAP
- Tipo de licencia/propietario: Apache 2.0
- Versión actual: 2.3.0
- Driver ODBC: sí

Impala
^^^^^^

Apache Hive es una infraestructura de almacenamiento y procesamiento de datos almacenados sobre HDFS de Hadoop, originalmente desarrollado por Cloudera.

Apache Impala es compatible con HiveQL y utiliza la misma base de datos de metadatos para acceder a HDFS que Hive, pero a diferencia de este, cuenta con un modelo de procesamiento en memoria de baja latencia que permite realizar consultas interactivas orientadas a entornos *Business Intelligence*.

Se suele utilizar para procesamiento de ficheros almacenados HDFS con menor latencia que Hive y por tanto orientada a aplicaciones finales.

- Tipo de sistema: Almacenamiento y procesamiento.
- Tipo de procesamiento: Interactivo.
- Tipo de despliegue/distribución: Nube pública y privada (on-premises) con multitud de distribuciones (Amazon EMR, Cloudera, Oracle, MapR)
- Interfaces de programación/consulta: HiveQL compatible con SQL
- Autenticación: Usuario contraseña, Kerberos, Sentry
- Tipo de licencia/propietario: Apache 2.0
- Versión actual: 2.10.0
- Driver ODBC: sí


Amazon Redshift
^^^^^^^^^^^^^^^

Amazon Redshift es un almacén de datos rápido y completamente administrado que permite analizar todos los datos empleando de forma sencilla y rentable SQL estándar y las herramientas de Business Intelligence existentes.

Forma parte de la familia de servicios web de Amazon, por tanto se integra con gran parte de sus servicios, como por ejemplo Amazon S3.

Se suele utilizar para almacenar y analizar datos en entornos donde es necesaria una alta integración con otros servicios de AWS.

- Tipo de sistema: Almacenamiento y procesamiento.
- Tipo de procesamiento: Interactivo.
- Tipo de despliegue/distribución: Nube pública (Amazon Web Services)
- Interfaces de programación/consulta: SQL
- Autenticación: Usuario y contraseña.
- Tipo de licencia/propietario: Propietario.
- Versión actual: Al ser un servicio auto-administrado por Amazon no se ofrece información de versiones
- Driver ODBC: Sí

MongoDB
^^^^^^^

MongoDB es una base de datos orientada a objetos que pertenece a la familia de bases de datos NoSQL. Está diseñada para soportar escalabilidad, particionamiento, replicación, alta disponibilidad siendo de las primeras bases de datos NoSQL en ofrecer estas características y una de las más populares en la actualidad.

Se suele utilizar como base de datos operacional y es muy popular en arquitecturas MEAN, en las que tanto el front como el backend están desarrollados sobre Javascript.

- Tipo de sistema: Almacenamiento y procesamiento.
- Tipo de procesamiento: Interactivo.
- Tipo de despliegue/distribución: on-premises
- Interfaces de programación/consulta: Javascript (nativo) y otros SDK con lenguajes varios.
- Autenticación: Usuario y contraseña, Kerberos/LDAP
- Tipo de licencia/propietario: AGPL v3.0
- Versión actual: 3.4
- Driver ODBC: Sí

Google BigQuery
^^^^^^^^^^^^^^^

Google BigQuery es el almacén de datos en la nube de Google, totalmente administrado y apto para analizar petabytes de datos.

Google BigQuery es un sistema de almacenamiento con una arquitectura serverless y ofrecido a modo de SaaS. Entre sus características principales destaca la integración con otros servicios de Google como Google Cloud Storage, el soporte de OAuth y acceso a través de API REST o SDKs en diferentes lenguajes.

Se suele utilizar en entornos donde se requiere integración con otros servicios de Google y en los que se pretende evitar el coste de mantenimiento de infraestructura.

- Tipo de sistema: Almacenamiento y procesamiento.
- Tipo de procesamiento: Interactivo.
- Tipo de despliegue/distribución: SaaS
- Interfaces de programación/consulta: API REST, SDKs
- Autenticación: OAuth
- Versión actual: Al ser un servicio auto-administrado por Google no se ofrece información de versiones
- Tipo de licencia/propietario: Propietario (Google)
- Driver ODBC: Sí

Cassandra
^^^^^^^^^

Apache Cassanda es un sistema de almacenamiento big data de la familia de bases de datos NoSQL, en este caso orientada a columnas.

Entre sus características destaca el estar orientada a la tolerancia a fallos y alta disponibilidad, además de escalar linealmente y ofrecer una baja latencia.

Se suele utilizar como base de datos operacional, en sistemas con gran carga de datos en los que las consultas son indexables por pocas columnas.

- Tipo de sistema: Almacenamiento y procesamiento.
- Tipo de procesamiento: Interactivo.
- Tipo de despliegue/distribución: on-premise
- Interfaces de programación/consulta: CQL (Similar a SQL)
- Autenticación: Usuario y contraseña
- Tipo de licencia/propietario: Apache 2.0
- Versión actual: 3.11.0
- Driver ODBC: Sí

SparkSQL
^^^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

Amazon Aurora
^^^^^^^^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

Oracle
^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

MemSQL
^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

Teradata
^^^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

SAP Hana
^^^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

Tabla resumen
-------------

- Sistemas de almacenamiento y procesamiento distribuido
  - Hadoop
    - HDFS
    - SQL: Hive, Impala
    - Sobre Hive hablar de todas las distribuciones (AWS, Cloudera, Horton, MapR)
  - NoSQL
    - Cassandra
    - MongoDB
  - Spark
    - SQL
  - Otros: 
    - Elastic Search/Solr
    - BigQuery
    - Redshift
    - Oracle