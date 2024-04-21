{{ config(
    cluster_by = "id_status",
) }}

SELECT
    cast(statusid AS STRING) AS id_status,
    status
FROM {{ source('sources','status') }}
