.. _metodologia:

Plan de trabajo y metodología
=============================

5. Plan de trabajo y/o metodología utilizada.

Plan de trabajo

- Configuración de un entorno de desarrollo local de CARTO con Vagrant.
- Configuración, carga de datos de prueba y despliegue con Docker en la nube de Amazon y Azure de distintos sistemas de
almacenamiento masivo (HDFS, Hive, Impala, MongoDB, Cassandra, etc.).
- Desarrollo de conectores para CARTO hacia estos sistemas de almacenamiento.
- Configuración y despliegue de CARTO Big Data Connectors en un servidor de staging con
AWS.
- Creación de un dashboard de análisis y visualización de datos geoespaciales con CARTO
provenientes de los sistemas implementados.

Metodología


Iterativa donde en cada iteración se añade un nuevo conector

El objetivo es que todo el entorno sea fácilmente reproducible por tanto se utilizan herramientas que facilitan la automatización: BASH, Vagrant, Docker, etc.