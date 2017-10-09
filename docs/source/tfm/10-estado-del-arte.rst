.. _estado-del-arte:

Estado del arte
===============

En este capítulo se presenta un informe sobre los diferentes sistemas de almacenamiento y procesamiento big data para los que se van a realizar conectores para CARTO y una breve definición de los conceptos teóricos que sirven de fundamentación para el trabajo.

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

Para el motivo de este trabajo, no es necesario conocer otros detalles como mecanismos de replicación, particionamiento, tolerancia a fallos, etc. ya que el objetivo no consiste en administrar este tipo de sistemas.

Sin embargo, el objetivo es doble:

1. Por una parte, contar con una visión general de los sistemas con los que se va a trabajar.
2. Por otra parte, poder identificar similitudes y diferencias entre ellos.
3. Por último, dar soporte al mayor número posible de tecnologías de almacenamiento y procesamiento big data, especialmente aquellas de carácter libre.

Apache Hive
^^^^^^^^^^^

Apache Hive es una infraestructura de almacenamiento y procesamiento de datos almacenados sobre HDFS de Hadoop y otros sistemas compatibles como Amazon S3.

Ofrece un lenguaje de consulta basado en SQL llamado HiveQL que convierte las consultas en trabajos MapReduce, Tez o Spark.

Actualmente, como gran parte de los sistemas batch es considerado un sistema *legacy*, aunque por otra parte es un sistema apliamente establecido en la industria que cuenta con gran cantidad de herramientas integradoras dentro del sistema Hadoop tales como: Pig, Sqoop, Flume, etc.

- Tipo de sistema: Almacenamiento y procesamiento.
- Tipo de procesamiento: Batch.
- Tipo de despliegue/distribución: Nube pública y privada (on-premises) con multitud de distribuciones (Amazon EMR, Cloudera, Hortonworks, MapR)
- Interfaces de programación/consulta: HiveQL compatible con SQL
- Autenticación: Usuario y contraseña, HTTP/HTTPS, Kerberos/LDAP
- Tipo de licencia/propietario: Apache 2.0
- Versión actual: 2.3.0

Impala
^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

Amazon Redshift
^^^^^^^^^^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

MongoDB
^^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

Google BigQuery
^^^^^^^^^^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

Cassandra
^^^^^^^^^

- Tipo de sistema
- Tipo de procesamiento
- Tipo de despliegue/distribución
- Interfaces de programación/consulta
- Autenticación
- Tipo de licencia/propietario

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