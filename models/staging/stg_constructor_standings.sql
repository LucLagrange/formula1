{{ config(
    cluster_by = "id_constructor_standings",
) }}

SELECT
    CAST(CONSTRUCTORSTANDINGSID AS STRING) AS ID_CONSTRUCTOR_STANDINGS    ,
  CAST(RACEID AS STRING) AS ID_RACE    ,
  CAST(CONSTRUCTORID AS STRING) AS ID_CONSTRUCTOR    ,
  SAFE_CAST(POINTS AS INT) AS POINTS_GAINED    ,
  SAFE_CAST(POSITION AS INT) AS END_POSITION    ,
  SAFE_CAST(WINS AS INT) AS WINS_NUMBER
FROM {{ source('sources','constructor_standings') }}
