WITH pole_position AS (
    SELECT
        results.id_race,
        results.id_driver,
        drivers.full_name,
        results.id_constructor,
        races.id_circuit,
        races.race_date,
        races.season_year,
        races.season_round,
        circuits.circuit_name
    FROM
        {{ ref('stg_qualifyings') }} AS results
    LEFT JOIN
        {{ ref('stg_races') }} AS races
        ON
            results.id_race = races.id_race
    LEFT JOIN
        {{ ref('stg_drivers') }} AS drivers
        ON
            results.id_driver = drivers.id_driver
    LEFT JOIN
        {{ ref('stg_circuits') }} AS circuits
        ON
            races.id_circuit = circuits.id_circuit
    WHERE
        results.final_position = 1
)

SELECT * FROM pole_position
