.. _anexos:

Anexos
======

9. Anexos: toda aquella información que se considere relevante para la comprensión
y clarificación del trabajo desarrollado.

.. _hive_conn:

A. Código fuente de conector para Hive
--------------------------------------

::

	# encoding: utf-8

	require_relative './odbc'

	module Carto
	  class Connector

	    # Hive (HiveServer2) provider using Hortonworks driver
	    # (http://public-repo-1.hortonworks.com/HDP/hive-odbc/2.1.2.1002/debian/hive-odbc-native_2.1.2.1002-2_amd64.deb)
	    #
	    # For all supported attributes, see https://hortonworks.com/wp-content/uploads/2015/10/Hortonworks-Hive-ODBC-Driver-User-Guide.pdf
	    #
	    # Another driver compatible with this one is [Cloudera's](http://www.cloudera.com/downloads/connectors/hive/odbc/2-5-12.html)
	    #
	    # The schema acts as a database name here, and can be ommitted (default schema 'default' or '')
	    # So we'll use a `database` connection parameter for the schema for consistency with other providers.
	    # The schema parameter should not be directly used by the user.
	    class HiveProvider < OdbcProvider

	      private

	      DEFAULT_SCHEMA = 'default'.freeze # '' would also be OK

	      def fixed_connection_attributes
	        {
	          Driver: 'Hortonworks Hive ODBC Driver 64-bit'
	        }
	      end

	      def required_connection_attributes
	        {
	          server:   :HOST
	        }
	      end

	      def optional_connection_attributes
	        {
	          database: { Schema: DEFAULT_SCHEMA },
	          port: { PORT: 10000 },
	          username: { UID: nil },
	          password: { PWD: nil }
	        }
	      end

	      def non_connection_parameters
	        super.reverse_merge(schema: @connection[:database] || DEFAULT_SCHEMA)
	      end

	    end
	  end
	end

::

	# encoding: utf-8

	require_relative './odbc'

	module Carto
	  class Connector

	    class ImpalaProvider < OdbcProvider

	      def initialize(context, params)
	        super
	        if @connection
	          @dsn        = @connection[:dsn]
	          @driver     = @connection[:driver]
	        end
	      end

	      def errors(only: nil)
	        errors = super
	        if @connection.blank?
	          errors << "Missing 'connection' parameters"
	        elsif @dns.blank? && @driver.blank?
	          errors << "Must define either 'dsn' or 'driver' in 'connection'"
	        end
	        errors
	      end

	      private

	      def connection_attributes
	        @connection
	      end
	    end

	  end
	end

.. _hive_conn_conf:

B. Configuración del conector para Apache Hive
----------------------------------------------

La configuración consiste en añadir una nuevo objecto al objeto `PROVIDERS` presente en el archivo `cartodb/lib/carto/connector/providers.rb` del repositorio https://github.com/CartoDB/cartodb

::

	# encoding: utf-8

	require_relative 'providers/generic_odbc'
	require_relative 'providers/mysql'
	require_relative 'providers/postgresql'
	require_relative 'providers/sqlserver'
	require_relative 'providers/hive'
	require_relative 'providers/pg_fdw'

	module Carto
	  class Connector

	    # Here we map provider identifiers (as used in APIs, etc.) to the Provider class and basic attributes.
	    # `name` is the human-readable name
	    # `public` means that the provider is publicly announced (so it is accessible through UI, visible in lists of
	    # providers, etc.) A provider may be available or not (see Connector.limits) independently of its public status,
	    # so that a public provider may not be available for all users, and non-public providers may be available to
	    # some users (e.g. 'odbc' provider for tests)
	    PROVIDERS = {
	      'odbc' => {
	        name: 'ODBC',
	        class: GenericOdbcProvider,
	        public: false # Intended for internal development/tests
	      },
	      'postgres' => {
	        name: 'PostgreSQL',
	        class: PostgreSQLProvider,
	        public: true
	      },
	      'mysql' => {
	        name: 'MySQL',
	        class: MySqlProvider,
	        public: true
	      },
	      'sqlserver' => {
	        name: 'Microsoft SQL Server',
	        class: SqlServerProvider,
	        public: true
	      },
	      'hive' => {
	        name: 'Hive',
	        class: HiveProvider,
	        public: true
	      }
	    }
	    ...

.. _impala_conn_conf:

C. Configuración del conector para Apache Impala
------------------------------------------------

La configuración consiste en añadir una nuevo objecto al objeto `PROVIDERS` presente en el archivo `cartodb/lib/carto/connector/providers.rb` del repositorio https://github.com/CartoDB/cartodb

::

	# encoding: utf-8

	require_relative 'providers/generic_odbc'
	require_relative 'providers/mysql'
	require_relative 'providers/postgresql'
	require_relative 'providers/sqlserver'
	require_relative 'providers/hive'
	require_relative 'providers/pg_fdw'

	module Carto
	  class Connector

	    # Here we map provider identifiers (as used in APIs, etc.) to the Provider class and basic attributes.
	    # `name` is the human-readable name
	    # `public` means that the provider is publicly announced (so it is accessible through UI, visible in lists of
	    # providers, etc.) A provider may be available or not (see Connector.limits) independently of its public status,
	    # so that a public provider may not be available for all users, and non-public providers may be available to
	    # some users (e.g. 'odbc' provider for tests)
	    PROVIDERS = {
		  'odbc' => {
		    name: 'ODBC',
		    class: GenericOdbcProvider,
		    public: false # Intended for internal development/tests
		  },
		  'postgres' => {
		    name: 'PostgreSQL',
		    class: PostgreSQLProvider,
		    public: true
		  },
		  'mysql' => {
		    name: 'MySQL',
		    class: MySqlProvider,
		    public: true
		  },
		  'sqlserver' => {
		    name: 'Microsoft SQL Server',
		    class: SqlServerProvider,
		    public: true
		  },
		  'hive' => {
		    name: 'Hive',
		    class: HiveProvider,
		    public: true
		  },
		  'impala' => {
		    name: 'Impala',
		    class: GenericOdbcProvider,
		    public: true
		  }
		}...

.. _redshift_conn_conf:

D. Configuración del conector para Amazon Redshift
--------------------------------------------------

La configuración consiste en añadir una nuevo objecto al objeto `PROVIDERS` presente en el archivo `cartodb/lib/carto/connector/providers.rb` del repositorio https://github.com/CartoDB/cartodb

::

	# encoding: utf-8

	require_relative 'providers/generic_odbc'
	require_relative 'providers/mysql'
	require_relative 'providers/postgresql'
	require_relative 'providers/sqlserver'
	require_relative 'providers/hive'
	require_relative 'providers/pg_fdw'

	module Carto
	  class Connector

	    # Here we map provider identifiers (as used in APIs, etc.) to the Provider class and basic attributes.
	    # `name` is the human-readable name
	    # `public` means that the provider is publicly announced (so it is accessible through UI, visible in lists of
	    # providers, etc.) A provider may be available or not (see Connector.limits) independently of its public status,
	    # so that a public provider may not be available for all users, and non-public providers may be available to
	    # some users (e.g. 'odbc' provider for tests)
	    PROVIDERS = {
		  'odbc' => {
		    name: 'ODBC',
		    class: GenericOdbcProvider,
		    public: false # Intended for internal development/tests
		  },
		  'postgres' => {
		    name: 'PostgreSQL',
		    class: PostgreSQLProvider,
		    public: true
		  },
		  'mysql' => {
		    name: 'MySQL',
		    class: MySqlProvider,
		    public: true
		  },
		  'sqlserver' => {
		    name: 'Microsoft SQL Server',
		    class: SqlServerProvider,
		    public: true
		  },
		  'hive' => {
		    name: 'Hive',
		    class: HiveProvider,
		    public: true
		  },
		  'impala' => {
		    name: 'Impala',
		    class: GenericOdbcProvider,
		    public: true
		  },
		  'redshift' => {
		    name: 'Redshift',
		    class: GenericOdbcProvider,
		    public: true
		  }
		}...

.. _mongo_conn:

E. Código fuente de conector para MongoDB
-----------------------------------------

::

	# encoding: utf-8

	require_relative './odbc'

	module Carto
	  class Connector

	    # Class for ODBC-based provider using mongo_fdw
	    #
	    # Requirements:
	    #   * mongo_fdw extension must be installed in the user database
	    # "connector": {
	    #    "provider": "mongo",
	    #    "connection": {
	    #      "username":"THE_MONGO_USER_NAME",
	    #      "password":"THE_MONGO_PASSWORD",
	    #      "server": "THE_MONGO_SERVER",
	    #      "database": "THE_MONGO_DATABASE",
	    #      "port":"THE_MONGO_PORT",
	    #      "schema": "THE_MONGO_COLLECTION"
	    #    },
	    #    "table": "THE_MONGO_TABLE",
	    #    "columns": "THE_COLUMNS_OF_THE_MONGO_TABLE"
	    #  }
	    #   "columns" is a comma separated list of column-name type.
	    #   As an example "columns" can be "_id NAME,   warehouse_id int,   warehouse_name text,   warehouse_created timestamptz
	    #
	    class MongoProvider < OdbcProvider

	      def initialize(context, params)
	        super
	      end

	      # Required connection attributes: { name: :internal_name }
	      # The :internal_name is what is passed to the driver (through odbc_fdw 'odbc_' options)
	      # The :name is the case-insensitive parameter received here trhough the API
	      # This can be redefined as needed in derived classes.
	      def required_connection_attributes
	        {
	          server:         :address
	        }
	      end

	      # Connection attributes that are optional: { name: { internal_name: default_value } }
	      # Those with non-nil default values will always be set.
	      # name/internal_name as in `required_connection_attributes`
	      # This can be redefined as needed in derived classes.
	      def optional_connection_attributes
	        {
	          database: { database: "admin" },
	          port: { port: 27017 },
	          username: { username: nil },
	          password: { password: nil },
	          schema:   { collection: nil }
	        }
	      end

	      def fdw_create_server(server_name)
	        sql = fdw_create_server_sql 'mongo_fdw', server_name, server_options_m
	        execute_as_superuser sql
	      end

	      def fdw_list_tables(server_name, limit)
	        # TODO not tested in MongoDB
	        execute %{
	          SELECT * FROM ODBCTablesList('#{server_name}',#{limit.to_i});
	        }
	      end

	      def features_information
	        {
	          "sql_queries":    true,
	          "list_databases": false,
	          "list_tables":    false,
	          "preview_table":  false
	        }
	      end

	      def fdw_create_foreign_table(server_name)
	        cmds = []
	        foreign_table_name = foreign_table_name_for(server_name)
	        if @columns.present?
	          cmds << fdw_create_foreign_table_sql(
	            server_name, foreign_table_schema, foreign_table_name, @columns, table_options_m
	          )
	        else
	          options = table_options.merge(prefix: unique_prefix_for(server_name))
	          cmds << fdw_import_foreign_schema_sql(server_name, remote_schema_name, foreign_table_schema, options)
	        end
	        cmds << fdw_grant_select_sql(foreign_table_schema, foreign_table_name, @connector_context.database_username)
	        execute_as_superuser cmds.join("\n")
	        foreign_table_name
	      end

	      SERVER_OPTIONS = %w(dsn driver host server address port).freeze
	      USER_OPTIONS   = %w(uid pwd user username password).freeze
	      TABLE_OPTIONS  = %w(database collection).freeze

	      def connection_options(parameters)
	        parameters.map { |option_name, option_value| ["#{option_name}", quoted_value(option_value)] }
	      end

	      def server_options_m
	        connection_options(connection_attributes.slice(*SERVER_OPTIONS)).parameters
	      end

	      def table_options_m
	        connection_options(connection_attributes.slice(*TABLE_OPTIONS)).parameters
	      end
	    end
	  end
	end

.. _mongo_conn_conf:

F. Configuración del conector para MongoDB
------------------------------------------

La configuración consiste en añadir una nuevo objecto al objeto `PROVIDERS` presente en el archivo `cartodb/lib/carto/connector/providers.rb` del repositorio https://github.com/CartoDB/cartodb

::

	# encoding: utf-8

	require_relative 'providers/generic_odbc'
	require_relative 'providers/mysql'
	require_relative 'providers/postgresql'
	require_relative 'providers/sqlserver'
	require_relative 'providers/hive'
	require_relative 'providers/pg_fdw'

	module Carto
	  class Connector

	    # Here we map provider identifiers (as used in APIs, etc.) to the Provider class and basic attributes.
	    # `name` is the human-readable name
	    # `public` means that the provider is publicly announced (so it is accessible through UI, visible in lists of
	    # providers, etc.) A provider may be available or not (see Connector.limits) independently of its public status,
	    # so that a public provider may not be available for all users, and non-public providers may be available to
	    # some users (e.g. 'odbc' provider for tests)
	    PROVIDERS = {
		  'odbc' => {
		    name: 'ODBC',
		    class: GenericOdbcProvider,
		    public: false # Intended for internal development/tests
		  },
		  'postgres' => {
		    name: 'PostgreSQL',
		    class: PostgreSQLProvider,
		    public: true
		  },
		  'mysql' => {
		    name: 'MySQL',
		    class: MySqlProvider,
		    public: true
		  },
		  'sqlserver' => {
		    name: 'Microsoft SQL Server',
		    class: SqlServerProvider,
		    public: true
		  },
		  'hive' => {
		    name: 'Hive',
		    class: HiveProvider,
		    public: true
		  },
		  'impala' => {
		    name: 'Impala',
		    class: GenericOdbcProvider,
		    public: true
		  },
		  'redshift' => {
		    name: 'Redshift',
		    class: GenericOdbcProvider,
		    public: true
		  },
		  'mongo' => {
	        name: 'mongo',
	        class: MongoProvider,
	        public: true
	      }
		}...

.. _bigquery_conn:

G. Código fuente de conector para BigQuery
------------------------------------------

::

	# encoding: utf-8

	require 'uri'
	require_relative './odbc'

	module Carto
	  class Connector

	    # {
	    #   "provider": "bigquery",
	    #   "connection": {
	    #     "Driver": "Google BigQuery 64",
	    #     "OAuthMechanism": 1,
	    #     "Catalog": "eternal-ship-170218",
	    #     "SQLDialect": 1,
	    #     "RefreshToken": "1/FyCbmKonlYAwx7FMjfow9QO5mdiOG3u9dfpi0ktYxOux_fFDF6ip-PERQkXYKiDc"
	    #   },
	    #   "table": "destination_table",
	    #   "sql_query": "select * from `eternal-ship-170218.test.test` limit 1;"
	    # }
	    class BigQueryProvider < OdbcProvider

	      private

	      DRIVER_NAME       = 'Google BigQuery 64'
	      SQL_DIALECT       = 1
	      USER_AUTH         = 1
	      SERVICE_AUTH      = 0

	      def initialize(context, params)
	        super
	        @oauth_config = Cartodb.get_config(:oauth, 'bigquery')
	        validate_config!(context)
	      end

	      def validate_config!(context)
	        raise 'OAuth configuration not found for bigquery provider' if @oauth_config.nil?
	        if @oauth_config['oauth_mechanism'] === SERVICE_AUTH \
	            and @oauth_config['email'].nil? \
	            and @oauth_config['key'].nil?
	          raise 'bigquery provider configured in SERVICE_AUTH mode but email or key not present'
	        else
	          begin
	          @token = context.user.oauths.select('bigquery').token
	          raise 'OAuth Token not found for bigquery provider' if @token.nil?
	          rescue => e
	            CartoDB::Logger.error(exception: e,
	                                    message: 'OAuth Token not found for "bigquery" provider',
	                                    user_id: context.user.id)
	          end
	        end
	      end

	      def fixed_connection_attributes
	        oauth_mechanism = @oauth_config['oauth_mechanism']
	        proxy_conf = create_proxy_conf

	        if oauth_mechanism === SERVICE_AUTH
	          conf = {
	            Driver:         DRIVER_NAME,
	            SQLDialect:     SQL_DIALECT,
	            OAuthMechanism: oauth_mechanism,
	            Email:          @oauth_config['email'],
	            KeyFilePath:    @oauth_config['key']
	          }
	        else
	          conf = {
	            Driver:         DRIVER_NAME,
	            SQLDialect:     SQL_DIALECT,
	            OAuthMechanism: oauth_mechanism,
	            RefreshToken:   @token
	          }
	        end

	        if !proxy_conf.nil?
	          conf = conf.merge(proxy_conf)
	        end

	        return conf
	      end

	      def required_connection_attributes
	        {
	          database:       :Catalog
	        }
	      end

	      def create_proxy_conf
	        proxy = ENV['HTTP_PROXY'] || ENV['http_proxy']
	        if !proxy.nil?
	          proxy = URI.parse(proxy)
	          {
	            ProxyHost: proxy.host,
	            ProxyPort: proxy.port
	          }
	        end
	      end

	    end
	  end
	end

.. _bigquery_conn_conf:

H. Configuración del conector para BigQuery
-------------------------------------------

La configuración consiste en añadir una nuevo objecto al objeto `PROVIDERS` presente en el archivo `cartodb/lib/carto/connector/providers.rb` del repositorio https://github.com/CartoDB/cartodb

::

	# encoding: utf-8

	require_relative 'providers/generic_odbc'
	require_relative 'providers/mysql'
	require_relative 'providers/postgresql'
	require_relative 'providers/sqlserver'
	require_relative 'providers/hive'
	require_relative 'providers/pg_fdw'

	module Carto
	  class Connector

	    # Here we map provider identifiers (as used in APIs, etc.) to the Provider class and basic attributes.
	    # `name` is the human-readable name
	    # `public` means that the provider is publicly announced (so it is accessible through UI, visible in lists of
	    # providers, etc.) A provider may be available or not (see Connector.limits) independently of its public status,
	    # so that a public provider may not be available for all users, and non-public providers may be available to
	    # some users (e.g. 'odbc' provider for tests)
	    PROVIDERS = {
		  'odbc' => {
		    name: 'ODBC',
		    class: GenericOdbcProvider,
		    public: false # Intended for internal development/tests
		  },
		  'postgres' => {
		    name: 'PostgreSQL',
		    class: PostgreSQLProvider,
		    public: true
		  },
		  'mysql' => {
		    name: 'MySQL',
		    class: MySqlProvider,
		    public: true
		  },
		  'sqlserver' => {
		    name: 'Microsoft SQL Server',
		    class: SqlServerProvider,
		    public: true
		  },
		  'hive' => {
		    name: 'Hive',
		    class: HiveProvider,
		    public: true
		  },
		  'impala' => {
		    name: 'Impala',
		    class: GenericOdbcProvider,
		    public: true
		  },
		  'redshift' => {
		    name: 'Redshift',
		    class: GenericOdbcProvider,
		    public: true
		  },
		  'mongo' => {
	        name: 'mongo',
	        class: MongoProvider,
	        public: true
	      },
	      'bigquery' => {
	        name: 'Google BigQuery 64',
	        class: BigQueryProvider,
	        public: true
	      }
		}...

.. _findloops:

I. Análisis para encontrar bucles en secuencias de puntos
---------------------------------------------------------

::

	/*
	DEP_EXT_findloops
	From a points dataset representing positions of a moving object along a track,
	this function finds the loops in the track

	Inputs managed by CARTO, common to all DEP_EXT functions:
	    operation               text: 'create' or 'populate'
	    table_name              text: the name of the previous node table
	    primary_source_query    text: the query on the previous node table
	    primary_source_columns  text: the columns of the previous node table
	User input:
	    cat_column                 text: if we have more than one track that is identified by a column value
	    temp_column       text: sorting column, usually timestamp
	Output:
	* cartodb_id bigint
	* track_id text: the track identifier, equal to cat_column of the input
	* loop_id integer: ordinal of the loop for each track
	* the_geom geometry(Geometry,4326): the circle that represents the loop
	* radius numeric: radius of
	*/
	CREATE OR REPLACE FUNCTION DEP_EXT_findloops(
	        operation text,
	        table_name text,
	        primary_source_query text,
	        primary_source_columns text[],
	        cat_column text,
	        temp_column text
	    )
	    RETURNS VOID AS $$
	        DECLARE
	            tail text;
	            categorized text;
	            cat_string text;
	            cat_string2 text;
	            sub_q text;
	            s record;
	            gSegment            geometry = NULL;
	            gLastPoint          geometry = NULL;
	            gLastTrackID        text = NULL;
	            gLoopPolygon        geometry = NULL;
	            gRadius             numeric;
	            iLoops              integer := 0;
	            cdbi                bigint := 0 ;
	        BEGIN

	            IF operation = 'create' THEN

	                EXECUTE 'DROP TABLE IF EXISTS ' || table_name;

	                EXECUTE 'CREATE TABLE ' || table_name || '(cartodb_id bigint, track_id text, loop_id integer, the_geom geometry(Geometry,4326), radius numeric)';

	            ELSEIF operation = 'populate' THEN

	                -- DEFAULTS
	                -- -- no temporal column, then use cartodb_id
	                IF  trim(temp_column) = '0' THEN
	                   temp_column := 'cartodb_id';
	                END IF;

	                -- no category, no partition
	                IF  trim(cat_column) = '0' THEN
	                    categorized := ' order by ' || temp_column;
	                    cat_string := '';
	                ELSE
	                    categorized := 'partition by ' || cat_column || ' order by ' || temp_column;
	                    cat_string := cat_column;
	                END IF;

	                -- partition and sorting of the input
	                sub_q := 'WITH '
	                    ||  'prequery as('
	                    ||      'SELECT '
	                    ||      cat_string || ' as cat,'
	                    ||      temp_column || ' as temp_column,'
	                    ||      'the_geom as point'
	                    ||      ' FROM ('
	                    ||          primary_source_query
	                    ||      ') _q'
	                    ||   '),'
	                    ||  'pts as('
	                    ||      'SELECT '
	                    ||      ' cat'
	                    ||      ', temp_column'
	                    ||      ', point'
	                    ||      ', row_number() over(partition by cat order by temp_column) as index'
	                    ||      ' FROM prequery'
	                    ||      ' ORDER BY cat, temp_column'
	                    ||  ')'
	                    ||      'SELECT '
	                    ||      ' b.cat::text as track_id'
	                    ||      ', ST_MakeLine(ARRAY[a.point, b.point]) AS geom'
	                    ||      ' FROM pts as a, pts as b'
	                    ||      ' WHERE b.index > 1'
	                    ||      ' AND a.index = b.index - 1'
	                    ||      ' AND a.cat = b.cat '
	                    ||      ' ORDER BY b.cat, b.temp_column';

	                FOR s IN EXECUTE sub_q
	                LOOP

	                    -- restart when new track
	                    if gLastTrackID <> s.track_id then
	                        gSegment := null;
	                        gLastPoint := null;
	                        iLoops := 0;
	                    end if;

	                    -- build segments
	                    if gSegment is null then
	                        gSegment := s.geom;
	                    elseif ST_equals(s.geom, gLastPoint) = false then
	                        gSegment := ST_Makeline(gSegment, s.geom);
	                    end if;

	                    gLoopPolygon := ST_BuildArea(ST_Node(ST_Force2D(gSegment)));


	                    if gLoopPolygon is not NULL and ST_Numpoints(gSegment) > 3 then

	                        iLoops := iLoops + 1;
	                        gRadius := (|/ ST_area(gLoopPolygon::geography)/PI());
	                        gSegment := null;

	                        EXECUTE
	                        'INSERT INTO '
	                        || quote_ident(table_name)
	                        || ' VALUES('
	                        || cdbi || ', '
	                        || quote_literal(s.track_id) || ', '
	                        || iLoops ||', '
	                        || 'ST_GeomFromText(' || quote_literal(ST_astext(gLoopPolygon)) || ', 4326), '
	                        || gRadius || ')';

	                        cdbi := cdbi +1;

	                    end if;

	                    IF  trim(cat_column) <> '0' THEN
	                        gLastTrackID = s.track_id;
	                    END IF;

	                    gLastPoint := s.geom;

	                END LOOP;


	            END IF;

	        END;
	$$ LANGUAGE plpgsql;
