Introducción
============

Contexto
--------

CARTO [#f1]_ es una plataforma de *Location Intelligence* [#f2]_ que permite transformar datos geoespaciales en resultados de negocio.

Actualmente, las organizaciones que utilizan **CARTO** como herramienta de análisis geoespacial tienen multitud de fuentes de información y aplicaciones ya instaladas que generan continuamente nuevos datos.

El principal valor de **CARTO** para estas organizaciones es el de conectarse con esas fuentes de información (*datos de CRM, ERPs, hojas de cálculo, archivos con contenido geoespacial, bases de datos relacionales, etc.*) a través de una interfaz sencilla e intuitiva, para generar nueva información de valor añadido para su negocio mediante análisis geoespaciales y visualizaciones.

En determinadas organizaciones, especialmente de tamaño medio o grande, ocurre que diversos equipos gestionan sus datos con sistemas de información heterogéneos que utilizan repositorios de datos tales como:

* Hojas de cálculo y archivos CSV
* Documentos de Google Drive
* CRMs tales como Salesforce
* Herramientas de marketing digital como Mailchimp
* Servidores de datos geoespaciales como ArcGIS
* Bases de datos operacionales (relacionales o NoSQL)
* Sistemas de ficheros distribuidos HDFS
* Otros sistemas (Twitter, Dropbox, Instagram, etc.)

Definición del problema
-----------------------

Estas organizaciones utilizan **CARTO** para importar sus datos y analizar la información que generan los distintos departamentos de manera conjunta, respondiendo a sus preguntas de negocio y encontrando además respuesta a otras preguntas que no se habían planteado en un principio.

**CARTO** cuenta con la posibilidad de importar datos desde diversas fuentes de datos, pero carece de soporte nativo para conectar a muchos de estos sistemas de almacenamiento big data usados generalmente para almacenar datos operacionales y resultados agregados obtenidos por los departamentos de *data science*.

Objetivo
--------

El objetivo de este trabajo final de máster consiste en el desarrollo de conectores para **CARTO** que permitan incluir en los cuadros de mandos (*dashboards*), información proveniente de los siguientes sistemas de almacenamiento y/o procesamiento big data:

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

Los "conectores big data para **CARTO**" permitirán a las organizaciones mantener sus actuales flujos de ingestión y procesamiento de información, además de aprovechar lo mejor de dos mundos: el almacenamiento y procesamiento distribuido que ofrecen algunas de estas herramientas orientadas a big data y la visualiación y análisis geoespacial de **CARTO**.

Cabe destacar que los resultados de este trabajo no son de carácter teórico, sino que consiste en código fuente y herramientas que se incluirán en la distribución *on premise* de **CARTO**

Organización de este trabajo final de máster
--------------------------------------------

Este trabajo final de máster está organizado en capítulos, siguiendo la siguiente estructura:

1. :ref:`estado-del-arte`: Se repasan las herramientas de almacenamiento y procesamiento distribuido big data con las que se va a trabajar y se definen algunos de los conceptos teóricos que sirven de fundamentación para el trabajo.
2. :ref:`metodologia`: Metodología y plan de trabajo utilizados.
3. :ref:`desarrollo`: Desarrollo de la solución y resultados obtenidos.
4. :ref:`conclusiones`
5. :ref:`bibliografia`
6. :ref:`anexos`
7. :ref:`glosario`


Palabras clave: *BASH, Docker, Vagrant, Location Intelligence, AWS, HDFS, Hadoop, BigQuery, Hive, Impala, Spark, NoSQL, Cassandra, MongoDB, CARTO, dashboards, análisis geoespacial*

.. [#f1] https://www.carto.com
.. [#f2] :ref:`location-intelligence` Añadir directamente aquí la definición
