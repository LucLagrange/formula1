{{ config(
    cluster_by = "id_driver",
) }}

SELECT
    cast(driverid AS string) AS id_driver,
    driverref AS driver_reference,
    forename AS first_name,
    surname AS last_name,
    CONCAT(forename,' ',surname) AS full_name,
    nationality,
    cast(dob AS date) AS birth_date,
    CASE WHEN number LIKE '%N' THEN NULL ELSE number END AS car_number
FROM {{ source('sources','drivers') }}
