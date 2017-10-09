.. _metodologia:

Plan de trabajo y metodología
=============================

Plan de trabajo
---------------

El trabajo final de máster consta de 3 grandes bloques en su desarrollo.

1. Despliegue de distintos sistemas de almacenamiento masivo en la nube de Amazon.
2. Desarrollo de conectores para CARTO.
3. Ingestión de datos de prueba y creación de un dashboard de visualización de datos geoespaciales con CARTO
provenientes de uno o más de los sistemas implementados



1. Configuración de entorno de desarrollo de CARTO

Para esta tarea se provee un script Vagrant que permite aprovisionar una máquina virtual con el entorno de desarrollo de CARTO.

2. Despliegue de distintos sistemas de almacenamiento masivo en la nube de Amazon. Esta tarea incluye:

- Aprovisionamiento de máquinas virtuales utilizando el servicio EC2 de Amazon, sobre una AMI de Ubuntu 14.04 y utilizando los servicios adicionales para configuración de *firewall*, control de acceso, disco, etc.
- Despliegue con Docker de Cloudera Quickstart para contar con instancias de Hive e Impala.
- Despliegue de una instancia de Amazon Redshift.
- Despliegue con Docker de una instancia de MongoDB.
- Despliegue con Docker de una instancia de Cassandra.
- Despliegue con Docker de una instancia de Oracle.
- Configuración de una cuenta y credenciales para acceso a Google BigQuery.

3. Ingestión de datos en los distintos sistemas de almacenamiento provistos.
4. Desarrollo de conectores para CARTO hacia estos sistemas. 
5. Configuración y despliegue de una instancia de CARTO en un servidor de staging.
6. Creación de un dashboard de análisis y visualización de datos geoespaciales con CARTO
provenientes de uno o más de los sistemas implementados.


Metodología


Iterativa donde en cada iteración se añade un nuevo conector

El objetivo es que todo el entorno sea fácilmente reproducible por tanto se utilizan herramientas que facilitan la automatización: BASH, Vagrant, Docker, etc.