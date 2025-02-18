update weather
    SET
        max_temperature_f = round((max_temperature_f - 32) * 5/9, 2),
        mean_temperature_f = round((mean_temperature_f - 32) * 5/9, 2),
        min_temperature_f = round((min_temperature_f - 32) * 5/9, 2)


UPDATE weather
    SET
        mean_wind_speed_mph = mean_wind_speed_mph*1.609344

select duration / 60 as 'duration_min' from trip
where duration < 24*60*60


select station.city, count(trip.id)
from trip
join station on trip.start_station_id = station.id
group by station.city

SELECT
    strftime('%Y-%m-%d', w.date) as trip_date,
    (SELECT
         count(*)
     from trip t
     join station s on s.id = t.start_station_id
     where strftime('%Y-%m-%d', w.date) = strftime('%Y-%m-%d', t.start_date)
     and s.city = 'San Francisco' and t.subscription_type = 'Subscriber'
     ) as trip_count,
    w.mean_temperature_f as mean_temperature,
    w.mean_humidity,
    w.mean_wind_speed_mph,
    CASE
        WHEN LOWER(w.events) LIKE '%rain%' THEN 'rain'
        ELSE 'no rain'
        END AS rain
FROM weather w
WHERE strftime('%u', w.date) NOT IN ('6', '7');


SELECT
    strftime('%Y-%m-%d', w.date) as trip_date,
    (SELECT
         count(*)
     from trip t
     join station s on s.id = t.start_station_id
     where strftime('%Y-%m-%d', w.date) = strftime('%Y-%m-%d', t.start_date)
     ) as trip_count,
    w.mean_temperature_f as mean_temperature,
    w.mean_humidity,
    w.mean_wind_speed_mph as mean_wind_speed,
    CASE
        WHEN LOWER(w.events) LIKE '%rain%' THEN 'rain'
        ELSE 'no rain'
        END AS rain
FROM weather w
WHERE strftime('%u', w.date) NOT IN ('6', '7')
and w.mean_temperature_f IS NOT NULL;

SELECT
    strftime('%Y-%m-%d', w.date) as trip_date,
    (SELECT
         count(*)
     from trip t
     join station s on s.id = t.start_station_id
     where strftime('%Y-%m-%d', w.date) = strftime('%Y-%m-%d', t.start_date)
     and s.city = 'San Francisco' and t.subscription_type = 'Subscriber'
     ) as trip_count,
    case
        when cast(strftime('%u', w.date) as integer) in (6, 7) then 'Weekend'
        else 'Dzień powszedni'
    end as day_type,
    w.mean_temperature_f as mean_temperature,
    w.mean_humidity,
    w.mean_wind_speed_mph,
    CASE
        WHEN LOWER(w.events) LIKE '%rain%' THEN 'rain'
        ELSE 'no rain'
        END AS rain
FROM weather w
WHERE w.mean_temperature_f IS NOT NULL