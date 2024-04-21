{{ config(
    cluster_by = "id_race",
) }}


SELECT
    cast(raceid AS STRING) AS id_race,
    cast(year AS STRING) AS season_year,
    safe_cast(round AS INT) AS season_round,
    CAST(circuitid AS STRING) AS id_circuit,
    CASE WHEN cast(date AS STRING) LIKE '%N' THEN NULL ELSE date END
        AS race_date,
    CASE
        WHEN cast(quali_date AS STRING) LIKE '%N' THEN NULL ELSE quali_date
    END AS qualifying_date,
    CASE
        WHEN cast(sprint_date AS STRING) LIKE '%N' THEN NULL ELSE sprint_date
    END AS sprint_date,
    CASE WHEN cast(fp1_date AS STRING) LIKE '%N' THEN NULL ELSE fp1_date END
        AS fp1_date,
    CASE WHEN cast(fp2_date AS STRING) LIKE '%N' THEN NULL ELSE fp2_date END
        AS fp2_date,
    CASE WHEN cast(fp3_date AS STRING) LIKE '%N' THEN NULL ELSE fp3_date END
        AS fp3_date
FROM {{ source('sources','races') }}
