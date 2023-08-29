-- Looking at deaths table
SELECT * FROM deaths ORDER BY 3, 4;

-- Select data we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM deaths 
WHERE NOT continent IS NULL -- to account for inconsistencies in the data labeling locations as continents instead of countries
ORDER BY 1, 2; -- order by location and date

-- Looking at total cases vs total deaths and death % in U.S.
-- Gives us likelihood of dying after getting COVID-19 in the U.S.
SELECT location, date, total_cases, total_deaths, (total_deaths / total_cases) * 100 AS death_percentage
FROM deaths 
WHERE location LIKE '%States%'
ORDER BY 1, 2;

-- Looking at total cases vs population and death % in U.S.
-- Gives us likelihood of contracting COVID-19 in the U.S. population
SELECT location, date, population, total_cases, (total_cases / population) * 100 AS infection_percentage
FROM deaths 
WHERE location LIKE '%States%'
ORDER BY 1, 2;

-- Looking at countries with highest infection rates
SELECT location, population, MAX(total_cases) as highest_infection_count, MAX((total_cases / population) * 100) AS highest_infection_percentage
FROM deaths 
WHERE NOT total_cases IS NULL AND NOT population IS NULL
GROUP BY location, population
ORDER BY highest_infection_percentage DESC;

-- Looking at countries with highest death counts
SELECT location, MAX(total_deaths) AS highest_death_count
FROM deaths 
WHERE NOT total_deaths IS NULL AND NOT continent IS NULL -- to account for inconsistencies in the data labeling locations as continents instead of countries
GROUP BY location
ORDER BY highest_death_count DESC;

-- Looking at continents with highest death counts
SELECT continent, MAX(total_deaths) AS highest_death_count
FROM deaths 
WHERE NOT total_deaths IS NULL AND NOT continent IS NULL -- to account for inconsistencies in the data labeling locations as continents instead of countries
GROUP BY continent
ORDER BY highest_death_count DESC;

-- Global new cases and deaths for each day
SELECT date, SUM(new_cases) AS total_new_cases, SUM(new_deaths) AS total_new_deaths, SUM(new_deaths) / SUM(new_cases) * 100 AS daily_death_percentage
FROM deaths 
WHERE NOT continent IS NULL AND NOT total_cases IS NULL
GROUP BY date
ORDER BY 1, 2;


-- Joining with vaccinations table
-- Looking at total population vs. new vaccinations per day and cumulative vaccinations per location
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cumulative_vac_per_location
FROM deaths dea
JOIN vaccinations vac
ON dea.location = vac.location AND dea.date = vac.date
WHERE NOT dea.continent IS NULL
ORDER BY 2, 3;
