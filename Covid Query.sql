SELECT *
FROM CovidProject..coviddeaths
WHERE continent is not null
ORDER BY 3,4 

--SELECT *
--FROM CovidProject..covidvaccinations
--ORDER BY 3,4 


SELECT Location, Date, Total_cases, new_cases, total_deaths, population
FROM CovidProject..coviddeaths
WHERE continent is not null
ORDER BY 1,2 

-- Total cases vs total deaths
-- % chance of death from covid

SELECT Location, Date, Total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
FROM CovidProject..coviddeaths
WHERE location like '%states%'
WHERE continent is not null
ORDER BY 1,2 

--Total cases vs population
-- % chance of covid per country population

SELECT Location, Date, Population, total_cases, (total_cases/population)*100 as CovidPercentage
FROM CovidProject..coviddeaths
--WHERE location like '%states%'
WHERE continent is not null
ORDER BY 1,2 


--Countries with highest infection rate compared to population

SELECT Location, Population,  MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 as CovidPercentage
FROM CovidProject..coviddeaths
--WHERE location like '%states%'
WHERE continent is not null
GROUP BY Location, population
ORDER BY CovidPercentage desc

--Countries with highest death rate

SELECT Location, Population,  MAX(cast(total_deaths as int)) AS TotalDeathCount, MAX((total_deaths/population))*100 as DeathPercentage
FROM CovidProject..coviddeaths
WHERE continent is not null
GROUP BY Location, population
ORDER BY TotalDeathCount desc

--Highest Death Count By Continent

SELECT location,  MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM CovidProject..coviddeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathCount desc


-- Highest Death Count By Country

SELECT location,  MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM CovidProject..coviddeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount desc

--Global Numbers

SELECT date, SUM(new_cases) as Total_Cases, SUM(Cast(new_deaths as bigint)) as Total_Deaths, SUM(Cast(new_deaths as bigint))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidProject..coviddeaths
WHERE continent is not null
GROUP BY date
order by 1,2


SELECT SUM(new_cases) as Total_Cases, SUM(Cast(new_deaths as bigint)) as Total_Deaths, SUM(Cast(new_deaths as bigint))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidProject..coviddeaths
WHERE continent is not null
--GROUP BY date
order by 1,2




--Total population vs people vaccinations 

	--At least one dose:

Select d.location, population, MAX(CONVERT(bigint,v.people_vaccinated)) AS Vaccination, (MAX(CONVERT(bigint,v.people_vaccinated))/population )*100 AS Vaccination__Rate
FROM CovidProject..coviddeaths d 
JOIN CovidProject..covidvaccinations v
	ON	d.location = v.location
	and d.date = v.date
WHERE d.continent is not null
GROUP BY d.location, population
order by 4 DESC

	--Fully Vaccinated:

Select d.location, population, MAX(CONVERT(bigint,v.people_fully_vaccinated)) AS Vaccination, (MAX(CONVERT(bigint,v.people_fully_vaccinated))/population )*100 AS Vaccination__Rate
FROM CovidProject..coviddeaths d 
JOIN CovidProject..covidvaccinations v
	ON	d.location = v.location
	and d.date = v.date
WHERE d.continent is not null
GROUP BY d.location, population
order by 2 DESC


--Common Table Expression (CTE)

With PopvsVac (Continent, Location, Population, Vaccination__Rate)
AS
(
Select d.location, population, MAX(CONVERT(bigint,v.people_fully_vaccinated)) AS Vaccination, (MAX(CONVERT(bigint,v.people_fully_vaccinated))/population )*100 AS Vaccination__Rate
FROM CovidProject..coviddeaths d 
JOIN CovidProject..covidvaccinations v
	ON	d.location = v.location
	and d.date = v.date
WHERE d.continent is not null
GROUP BY d.location, population
)
Select *
FROM PopvsVac


--Tableau Views:

CREATE VIEW Deaths_Per_Country as
SELECT location,  MAX(cast(total_deaths as int)) AS TotalDeathCount
FROM CovidProject..coviddeaths
WHERE continent is not null
GROUP BY location;
--ORDER BY TotalDeathCount desc


Create View onedose as
Select d.location, population, MAX(CONVERT(bigint,v.people_vaccinated)) AS Vaccination, (MAX(CONVERT(bigint,v.people_vaccinated))/population )*100 AS Vaccination__Rate
FROM CovidProject..coviddeaths d 
JOIN CovidProject..covidvaccinations v
	ON	d.location = v.location
	and d.date = v.date
WHERE d.continent is not null
GROUP BY d.location, population
--order by 4 DESC

Create View fullyvac as
Select d.location, population, MAX(CONVERT(bigint,v.people_fully_vaccinated)) AS Vaccination, (MAX(CONVERT(bigint,v.people_fully_vaccinated))/population )*100 AS Vaccination__Rate
FROM CovidProject..coviddeaths d 
JOIN CovidProject..covidvaccinations v
	ON	d.location = v.location
	and d.date = v.date
WHERE d.continent is not null
GROUP BY d.location, population
--order by 2 DESC