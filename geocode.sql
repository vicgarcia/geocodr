SELECT 
  g.rating,
  ST_X(g.geomout) As lon,
  ST_Y(g.geomout) As lat,
  (addy).address As stno,
  (addy).streetname As street,
  (addy).streettypeabbrev As styp,
  (addy).location As city,
  (addy).stateabbrev As st,
  (addy).zip
FROM 
  geocode('905 W Carmen Ave, Chicago, IL 60640') AS g;

SELECT 
  g.rating,
  ST_X(g.geomout) As lon,
  ST_Y(g.geomout) As lat,
  (addy).address As stno,
  (addy).streetname As street,
  (addy).streettypeabbrev As styp,
  (addy).location As city,
  (addy).stateabbrev As st,
  (addy).zip
FROM 
  geocode('2712 N Milwaukee, 60647') AS g;

SELECT 
  g.rating,
  ST_X(g.geomout) As lon,
  ST_Y(g.geomout) As lat,
  (addy).address As stno,
  (addy).streetname As street,
  (addy).streettypeabbrev As styp,
  (addy).location As city,
  (addy).stateabbrev As st,
  (addy).zip
FROM 
  geocode('1333 W Winona, Chicago, IL') AS g;
