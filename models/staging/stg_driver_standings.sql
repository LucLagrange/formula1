{{ config(
    cluster_by = "id_driver_standing",
) }}

SELECT
    CAST(DRIVERSTANDINGSID AS STRING) AS ID_DRIVER_STANDING
    ,
    CAST(RACEID AS STRING) AS ID_RACE,
    CAST(DRIVERID AS STRING) AS ID_DRIVER,
    SAFE_CAST(POINTS AS INT) AS POINTS_GAINED,
    SAFE_CAST(POSITION AS INT) AS END_POSITION,
    SAFE_CAST(WINS AS INT) AS WINS_NUMBER
FROM {{ source('sources','driver_standings') }}
