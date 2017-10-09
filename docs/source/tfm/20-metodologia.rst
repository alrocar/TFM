.. _metodologia:

Metodología y plan de trabajo
=============================

Metodología
-----------

TODO: Explicar cuál es la solución propuesta en base a lo que se ha visto tras el estudio del estado del arte, FDW, drivers y cómo se va a proceder durante el desarrollo.

Para llevar a cabo el plan de trabajo se va a seguir una metodología de desarrollo iterativo incremental. Se trata de una metodología de desarrollo de software ágil que consiste en la ejecución de las distintas fases del proyecto en ciclos cortos de pocos días que se repiten en el tiempo, de manera que se va incrementando el valor de la solución final.

Esta metodología nos va a permitir validar en una frase temprana la solución propuesta, realizando una iteración que permita validar la integración de Hive e Impala con CARTO.

Una vez validado uno de estos sistemas de almacenamiento, se continúan realizando iteraciones cortas en las que se va dando soporte al resto de sistemas de almacenamiento propuestos, hasta contar con la solución completa.

En última instancia, se trabaja en la ingestión de datos y creación del dashboard a modo de demostración.

Por otra parte, como segundo objetivo metodológico, se pretende que todo el entorno sea fácilmente reproducible, así pues, se utilizan herramientas que facilitan la automatización y colaboración: Github, BASH, Vagrant, Docker, etc. Con lo que es posible reproducir todo el desarrollo realizado durante el trabajo final de máster.

Plan de trabajo
---------------

El trabajo final de máster consta de 3 grandes bloques en su desarrollo.

1. Despliegue de distintos sistemas de almacenamiento masivo en la nube de Amazon.
2. Desarrollo de conectores para CARTO.
3. Ingestión de datos de prueba y creación de un dashboard de visualización de datos geoespaciales con CARTO
provenientes de uno o más de los sistemas implementados

El plan de trabajo detallado consiste en las siguientes tareas:

Despliegue de sistemas de almacenamiento masivo en la nube de Amazon
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Esta tarea consiste en explorar las diferentes alternativas para desplegar sistemas de almacenamiento distribuido en la nube.

El objetivo no es contar con despliegues robustos, resistentes a fallos o configurados en cluster, sino contar con diferentes entornos para realizar la ingestión de datos de prueba y conexión necesaria durante el desarrollo y demostración de los conectores para CARTO.

Para el desarrollo de este bloque se realizan las siguientes tareas:

- Aprovisionamiento de máquinas virtuales utilizando el servicio EC2 de Amazon, sobre una AMI de Ubuntu 14.04 y utilizando los servicios adicionales para configuración de *firewall*, control de acceso, disco, etc.
- Despliegue con Docker de Cloudera Quickstart para contar con instancias de Hive e Impala.
- Despliegue de una instancia de Amazon Redshift.
- Despliegue con Docker de una instancia de MongoDB.
- Despliegue con Docker de una instancia de Cassandra.
- Despliegue con Docker de una instancia de Oracle.
- Configuración de una cuenta y credenciales para acceso a Google BigQuery.

Desarrollo de conectores para CARTO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Este bloque consiste en la implementación y prueba de los diferentes módulos que permitan conectar CARTO con los sistemas de almacenamiento mencionados previamente a través de su API de importación.

En este caso, el objetivo consiste en contar con conectores integrados en el código base de CARTO, de manera que sean incluidos en su versión *on premise*.

Para el desarrollo de deste bloque se realizan las siguientes tareas:

- Configuración de un entorno de desarrollo de CARTO utilizando Github, BASH y Vagrant.
- Desarrollo en Ruby del código necesario para los conectores.
- Configuración de las llamadas necesarias a la API REST de importación de CARTO.
- Documentación y scripts de configuración de los *drivers* necesarios para conectar con cada sistema de almacenamiento.
- Despliegue de CARTO en un servidor de *staging* en Amazon.

Ingestión de datos de prueba y creación de dashboard con CARTO
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Una vez desplegados diferentes sistemas de almacenamiento distribuido en la nube, desarrollados los conectores y desplegada una instancia de CARTO, el último bloque consiste en realizar una pequeña demostración sobre un *dashboard* que consuma datos obtenidos de uno o más de estos sistemas desplegados.

Para el desarrollo de deste bloque se realizan las siguientes tareas:

- Ingestión de datos en los distintos sistemas de almacenamiento provistos.
- Ejecución de las llamadas necesarias mediante la API de importación de CARTO para conectar con uno o más sistemas de almacenamiento.
- Creación de un dashboard de análisis y visualización de datos geoespaciales con CARTO
provenientes de uno o más de los sistemas implementados.

TODO: especificar un poco más qué datasets y qué sistemas de almacenamiento concreto se van a usar.
