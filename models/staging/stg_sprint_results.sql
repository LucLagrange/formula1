{{ config(
    cluster_by = "id_result",
) }}

SELECT
    number AS driver_number,
    SAFE_CAST(grid AS INT) AS start_position,
    SAFE_CAST(position AS INT) AS end_position,
    SAFE_CAST(positionorder AS INT) AS final_rank,
    SAFE_CAST(points AS INT) AS points_gained,
    SAFE_CAST(laps AS INT) AS laps_driven,
    CASE WHEN fastestlap LIKE '%N' THEN NULL ELSE fastestlap END
        AS fastest_lap,
    CASE WHEN fastestlaptime LIKE '%N' THEN NULL ELSE fastestlaptime END
        AS fastest_lap_time,
    CASE WHEN milliseconds LIKE '%N' THEN NULL ELSE milliseconds END
        AS total_milliseconds_elapsed,
    CAST(resultid AS STRING) AS id_result,
    CAST(raceid AS STRING) AS id_race,
    CAST(driverid AS STRING) AS id_driver,
    CAST(constructorid AS STRING) AS id_constructor,
    CAST(statusid AS STRING) AS id_status
FROM {{ source('sources','sprint_results') }}
