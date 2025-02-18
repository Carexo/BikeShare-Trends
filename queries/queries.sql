select case cast (strftime('%w', trip.start_date) as integer)
  when 0 then 'Niedziela'
  when 1 then 'Poniedzialek'
  when 2 then 'Wtorek'
  when 3 then 'Sroda'
  when 4 then 'Czwartek'
  when 5 then 'Piatek'
  else 'Sobota' end as weekday,
  count(*) as trip_count
from trip
group by strftime('%u', start_date)

select
    strftime('%H', trip.start_date) as hour,
    count(*) as trip_count
from trip
group by hour

select
    strftime('%H', start_date) AS hour,
    strftime('%u', trip.start_date) as day_of_week_number,
   case cast (strftime('%u', trip.start_date) as integer)
    when 1 then 'Poniedzialek'
    when 2 then 'Wtorek'
    when 3 then 'Sroda'
    when 4 then 'Czwartek'
    when 5 then 'Piatek'
    when 6 then 'Sobota'
    else 'Niedziela' end as day_of_week,
    COUNT(*) AS trip_count
from trip
group by hour, day_of_week

select
    duration,
    strftime('%u', trip.start_date) as day_of_week_number,
  case cast (strftime('%u', trip.start_date) as integer)
    when 1 then 'Poniedzialek'
    when 2 then 'Wtorek'
    when 3 then 'Sroda'
    when 4 then 'Czwartek'
    when 5 then 'Piatek'
    when 6 then 'Sobota'
    else 'Niedziela' end as day_of_week
from trip
where duration < 2*60*60

select
  duration / 60 as 'duration_min'
from trip
where duration < 6*60*60

select
  duration / 60 as 'duration_min'
from trip
where duration < 16*60*60

select
    (
       SELECT w.mean_temperature_f
        from weather w
       where strftime('%Y-%m-%d', w.date) = strftime('%Y-%m-%d', t.start_date)
        ) as mean_temperature,
    t.id,
    case
        when cast(strftime('%u', t.start_date) as integer) in (6, 7) then 'Weekend'
        else 'Dzień powszedni'
    end as day_type
from trip t

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
and w.mean_temperature_f IS NOT NULL