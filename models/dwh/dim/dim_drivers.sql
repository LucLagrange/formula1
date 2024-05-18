WITH
year AS (
    SELECT DISTINCT
        drivers.id_driver,
        CAST(MIN(season_year) AS INT) AS debut_year,
        CAST(MAX(season_year) AS INT) AS last_year
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
        COUNT(*) AS pole_position
    FROM
        {{ ref('stg_qualifyings') }}
    WHERE
        final_position = 1
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
)


SELECT
    d.id_driver,
    d.nationality,
    d.birth_date,
    dy.debut_year,
    dy.last_year,
    COALESCE(dy.last_year - dy.debut_year, 0) AS nb_seasons_raced,
    CONCAT(d.first_name, ' ', d.last_name) AS driver_name,
    COALESCE(w.wins, 0) AS win,
    COALESCE(p.podiums, 0) AS podium,
    COALESCE(pg.total_points, 0) AS total_points,
    COALESCE(gp.gp_finish, 0) AS gp_finish,
    COALESCE(pp.pole_position, 0) AS pole_position
FROM
    {{ ref('stg_drivers') }} AS d
LEFT JOIN
    year AS dy
    ON
        d.id_driver = dy.id_driver
LEFT JOIN
    wins AS w
    ON
        d.id_driver = w.id_driver
LEFT JOIN
    podiums AS p
    ON
        d.id_driver = p.id_driver
LEFT JOIN
    gp_finish AS gp
    ON
        d.id_driver = gp.id_driver
LEFT JOIN
    pole_position AS pp
    ON
        d.id_driver = pp.id_driver
LEFT JOIN
    total_points AS pg
    ON
        d.id_driver = pg.id_driver