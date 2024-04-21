{{ config(
    cluster_by = "id_circuit",
) }}

SELECT
    cast(circuitid AS string) AS id_circuit,
    circuitref AS circuit_reference,
    name AS circuit_name,
    location AS circuit_location,
    country AS circuit_country,
    lat AS lattitude,
    lng AS longitude,
    safe_cast(alt AS int) AS altitude
FROM {{ source('sources','circuits') }}
