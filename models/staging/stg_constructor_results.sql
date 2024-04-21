{{ config(
    cluster_by = "id_constructor_result",
) }}

SELECT
    points AS points_gained,
    CAST(constructorresultsid AS STRING) AS id_constructor_result,
    CAST(constructorid AS STRING) AS id_constructor,
    CAST(raceid AS STRING) AS id_race,
    COALESCE(status = 'D', FALSE) AS bl_disqualified
FROM {{ source('sources','constructor_results') }}
