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

- Hive
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
- Tipo de despliegue/distribución: Nube pública, privada, SaaS, etc.
- Interfaces de programación/consulta: SQL, SDKs en diferentes lenguajes, APIs REST, etc.
- Autenticación: HTTP/HTTPS, Kerberos/LDAP, OAuth, etc.
- Tipo de licencia/propietario: Software libre (Apache, GPL, etc.), propietaria (Google, Amazon, Oracle, etc.)

Para el motivo de este trabajo, no es necesario conocer otros detalles como mecanismos de replicación, particionamiento, tolerancia a fallos, etc. ya que el objetivo no consiste en administrar este tipo de sistemas.

Sin embargo, el objetivo es doble:

1. Por una parte, contar con una visión general de los sistemas con los que se va a trabajar.
2. Por otra parte, poder identificar similitudes y diferencias entre ellos.
3. Por último, dar soporte al mayor número posible de tecnologías de almacenamiento y procesamiento big data, especialmente aquellas de carácter libre.

Hive
^^^^

Impala
^^^^^^

Amazon Redshift
^^^^^^^^^^^^^^^

MongoDB
^^^^^^^

Google BigQuery
^^^^^^^^^^^^^^^

Cassandra
^^^^^^^^^

SparkSQL
^^^^^^^^

Amazon Aurora
^^^^^^^^^^^^^

Oracle
^^^^^^

MemSQL
^^^^^^

Teradata
^^^^^^^^

SAP Hana
^^^^^^^^

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