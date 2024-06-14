WITH
year AS (
    SELECT DISTINCT
        drivers.id_driver,
        CAST(MIN(races.season_year) AS INT) AS debut_year,
        CAST(MAX(races.season_year) AS INT) AS last_year
    FROM
        {{ ref('stg_drivers') }} AS drivers
    INNER JOIN
        {{ ref('stg_results') }} AS results
        ON
            drivers.id_driver = results.id_driver
    INNER JOIN
        {{ ref('stg_races') }} AS races
        ON
            results.id_race = races.id_race
    GROUP BY
        drivers.id_driver
),

wins AS (
    SELECT
        id_driver,
        COUNT(*) AS wins
    FROM
        {{ ref('stg_results') }}
    WHERE
        final_rank = 1
    GROUP BY
        id_driver
),

podiums AS (
    SELECT
        id_driver,
        COUNT(*) AS podiums
    FROM
        {{ ref('stg_results') }}
    WHERE
        final_rank IN (1, 2, 3)
    GROUP BY
        id_driver
),

gp_finish AS (
    SELECT
        id_driver,
        COUNT(*) AS gp_finish
    FROM
        {{ ref('stg_results') }}
    GROUP BY
        id_driver
),

pole_position AS (
    SELECT
        id_driver,
        COUNT(id_race) AS pole_position
    FROM
        {{ ref('fct_pole_positions') }}
    GROUP BY
        id_driver
),

total_points AS (
    SELECT
        id_driver,
        SUM(SAFE_CAST(points_gained AS INT)) AS total_points
    FROM
        {{ ref('stg_results') }}
    GROUP BY
        id_driver
),

teams AS (
    SELECT
        results.id_driver,
        ARRAY_AGG(DISTINCT constructors.constructor_name IGNORE NULLS)
            AS teams_joigned
    FROM
        {{ ref('stg_results') }} AS results
    LEFT JOIN
        {{ ref('stg_constructors' ) }} AS constructors
        ON results.id_constructor = constructors.id_constructor
    GROUP BY
        results.id_driver
)


SELECT
    drivers.id_driver,
    drivers.nationality,
    drivers.birth_date,
    years.debut_year,
    years.last_year,
    teams_joined.teams_joigned AS list_teams_joined,
    COALESCE(years.last_year - years.debut_year, 0) AS nb_seasons_raced,
    CONCAT(drivers.first_name, ' ', drivers.last_name) AS driver_name,
    COALESCE(wins.wins, 0) AS nb_win,
    COALESCE(podiums.podiums, 0) AS nb_podium,
    COALESCE(points.total_points, 0) AS total_points,
    COALESCE(finishes.gp_finish, 0) AS gp_finish,
    COALESCE(poles.pole_position, 0) AS pole_position
FROM
    {{ ref('stg_drivers') }} AS drivers
LEFT JOIN
    year AS years
    ON
        drivers.id_driver = years.id_driver
LEFT JOIN
    wins AS wins
    ON
        drivers.id_driver = wins.id_driver
LEFT JOIN
    podiums AS podiums
    ON
        drivers.id_driver = podiums.id_driver
LEFT JOIN
    gp_finish AS finishes
    ON
        drivers.id_driver = finishes.id_driver
LEFT JOIN
    pole_position AS poles
    ON
        drivers.id_driver = poles.id_driver
LEFT JOIN
    total_points AS points
    ON
        drivers.id_driver = points.id_driver
LEFT JOIN
    teams AS teams_joined
    ON
        drivers.id_driver = teams_joined.id_driver
