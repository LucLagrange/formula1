{{ config(
    cluster_by = "id_constructor",
) }}

SELECT
    constructorref AS constructor_reference,
    name AS constructor_name,
    nationality,
    CAST(constructorid AS STRING) AS id_constructor
FROM {{ source('sources','constructors') }}
