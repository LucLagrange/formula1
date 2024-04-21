{{ config(
    cluster_by = "id_qualifying",
) }}

SELECT
    number AS car_number,
    CAST(qualifyid AS STRING) AS id_qualifying,
    CAST(raceid AS STRING) AS id_race,
    CAST(driverid AS STRING) AS id_driver,
    CAST(constructorid AS STRING) AS id_constructor,
    SAFE_CAST(position AS INT) AS final_position,
    CASE WHEN CAST(q1 AS STRING) LIKE '%N' THEN NULL ELSE q1 END
        AS q1_best_time,
    CASE WHEN CAST(q2 AS STRING) LIKE '%N' THEN NULL ELSE q2 END
        AS q2_best_time,
    CASE WHEN CAST(q3 AS STRING) LIKE '%N' THEN NULL ELSE q3 END
        AS q3_best_time
FROM {{ source('sources','qualifyings') }}
