{{ config(
    cluster_by = "season_year",
) }}

SELECT
    url AS wikipedia_url,
    CAST(`year` AS STRING) AS season_year
FROM {{ source('sources','seasons') }}
