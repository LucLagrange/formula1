{{ config(
    cluster_by = "id_race",
) }}

SELECT
    time AS lap_time,
    CAST(raceid AS STRING) AS id_race,
    CAST(driverid AS STRING) AS id_driver,
    SAFE_CAST(lap AS INT) AS lap,
    SAFE_CAST(position AS INT) AS current_position,
    SAFE_CAST(milliseconds AS INT) AS lap_time_milliseconds
FROM {{ source('sources','lap_times') }}
