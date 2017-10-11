.. _conclusiones:

Conclusiones
============

En este trabajo final de máster nos habíamos propuesto solucionar el problema de conectar CARTO con los actuales sistemas de almacenamiento big data disponibles en el mercado.

La premisa era clara: *Realizar una conexión desde CARTO a estos sistemas, para importar datos y obtener lo mejor de dos mundos, el almacenamiento y procesamiento de sistemas preparados para trabajar con datos masivos y las capacidades de análisis y visualización geoespacial de CARTO*

Una vez analizado el estado del arte en cuanto a CARTO y los principales sistemas de almacenamiento y procesamiento big data (Hive, Impala, Redshift, MongoDB, Google Bigquery), encontramos un nexo de unión entre ambos: las capacidades de conectividad de PostgreSQL con sistemas de terceros a través de Foreign Data Wrappers.

Dado este nexo de unión, se pretende obtener una metodología sistemática que permita realizar conexiones desde PostgreSQL a sistemas de almacenamiento masivo y a través de la experimentación se exponen casos concretos de esta metodología para los principales sistemas de almacenamiento y procesamiento.

Una vez desarrollados los diferentes conectores, a través de un caso de uso consistente en [TODO] se demuestran las nuevas capacidades de conexión de CARTO con sistemas big data.

Por último, cabe descatar que durante este trabajo final de máster, se ha pretendido seguir la filosofía del plan de estudios del Máster Big Data Analytics de la Universidad Politécnica de Valencia, consistente en mostrar lo amplio del ecosistema big data y de las capacidades y aptitudes que deben poseer los profesionales de este sector.

En concreto, este trabajo está relacionado con los siguientes contenidos tratados durante el máster:

- BASH
- Virtualización: Docker y Vagrant
- Business/Location Intelligence
- Entornos de gestión big data: AWS, Azure, Hadoop, BigQuery, etc.
- NoSQL: Cassandra, MongoDB
- Técnicas y herramientas de visualización
