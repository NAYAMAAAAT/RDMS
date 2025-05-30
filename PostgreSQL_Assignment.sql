-- Active: 1748087161275@@127.0.0.1@5432@conservation_db
CREATE TABLE rangers(
    ranger_id SERIAL PRIMARY KEY,
    ranger_name VARCHAR(50),
    region  VARCHAR(100)
)

INSERT INTO rangers(ranger_name, region)VALUES
('Alice Green', 'Northern Hills'),
('Bob White','River Delta'),
('Carol King','Mountain Range')

SELECT * FROM rangers;

CREATE TABLE species(
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50),
    scientific_name VARCHAR(200),
    discovery_date DATE,
    conservation_status VARCHAR(200)
)

INSERT INTO species(common_name, scientific_name, discovery_date, conservation_status) VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');

SELECT * FROM species;

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    species_id INTEGER NOT NULL REFERENCES species(species_id),
    ranger_id  INTEGER NOT NULL REFERENCES rangers(ranger_id),
    location VARCHAR(100),
    sighting_time TIMESTAMP NOT NULL,
    notes TEXT
)

INSERT INTO sightings(species_id, ranger_id, location, sighting_time, notes) VALUES
(1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL)

select * FROM sightings;



--Problem-01

INSERT INTO rangers(ranger_name, region) VALUES
('Derek Fox','Coastal Plains');


--Problem-02

SELECT COUNT(DISTINCT species_id) as unique_count from  sightings;


--Problem-03

SELECT * FROM sightings WHERE location LIKE '%Pass%';


--Problem -04

SELECT r.ranger_name, COUNT(s.sighting_id) AS total_sightings
FROM rangers r
JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.ranger_name
ORDER BY r.ranger_name;


--Problem-05

SELECT species.common_name FROM species
LEFT JOIN sightings ON species.species_id = sightings.species_id
WHERE sightings.species_id IS NULL


--Problem-06

SELECT species.common_name, sightings.sighting_time, rangers.ranger_name
FROM sightings
JOIN species ON sightings.species_id = species.species_id
JOIN rangers ON sightings.ranger_id = rangers.ranger_id
ORDER BY sightings.sighting_time DESC
LIMIT 2;


--Problem-07

UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';


--Problem-08

SELECT sighting_id,
CASE 
    WHEN extract(HOUR FROM sighting_time ) < 12 THEN 'Morning'
    WHEN extract(HOUR FROM sighting_time)>= 12 AND extract(HOUR FROM sighting_time)<= 17 THEN 'Afternoon'
    ELSE  'Evening'
END as time_of_day
FROM sightings

--Problem-09

DELETE FROM rangers
WHERE NOT EXISTS (
  SELECT 1 
  FROM sightings 
  WHERE sightings.ranger_id = rangers.ranger_id
);

