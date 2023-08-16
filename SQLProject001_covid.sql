/* 
Data Analyst Portfolio Project / 
Data Cleaning in SQL
*/


--SELECT *
--FROM covidDeath_clean$
--WHERE continent IS NOT NULL
--order by 3,4

--SELECT *
--FROM vaccine$
--order by 3,4

--SELECT DATA THAT WE ARE GOING TO BE USING

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM covidDeath_clean$
--order by 1,2

--LOOKING AT TOTAL CASES vs Total deaths
--Shows likelihood of dying if you contract covid in your country
--SELECT location, date, total_cases, total_deaths, (total_deaths/NULLIF(total_cases,0))*100 as deathPercentage
--FROM covidDeath_clean$
--WHERE location like '%state%'
--order by 1,2


--Looking at Total Cases vs Population
--Shows what percentage of population got covid
--SELECT location, date, total_cases, population, (total_deaths/(population))*100 as PercentPopInfected
--FROM covidDeath_clean$
--WHERE location like '%states%'
--order by 1,2


--Looking at Countries with Highest Infection Rate compared to Population
--SELECT location, population, MAX(total_cases) as highestInfectionCount, MAX(total_cases/(population))*100 as PercentPopInfected
--FROM covidDeath_clean$
----WHERE location like '%states%'
--GROUP BY location, population
--order by PercentPopInfected desc



--Showing Countries with Highest Death Count per Population

--SELECT location, MAX(total_deaths) as TotalDeathCount
--FROM covidDeath_clean$
----WHERE location like '%states%'
--WHERE continent IS NOT NULL
--GROUP BY location, population
--order by TotalDeathCount desc



--LET'S BREAK THINGS DOWN by CONTINENT
--SHOWING CONTINENTS WITH HIGHEST DEATH COUNT PER POPULATION

--SELECT continent, MAX(total_deaths) as TotalDeathCount
--FROM covidDeath_clean$
----WHERE location like '%states%'
--WHERE continent IS NOT NULL
--GROUP BY continent
--order by TotalDeathCount desc



--GLOBAL NUMBERS
----SELECT date, SUM(CAST(new_cases as int))    
/* """"CAST(COLUMN_NAME as INT)"""" When column type is nvarchar, to change the type inside imported table 
(local column type conversion, specific to code line)*/
----FROM covidDeath_clean$

--SELECT SUM(new_cases) as TotalCases, SUM(new_deaths) as TotalDeaths, SUM(new_deaths)/NULLIF(SUM(new_cases),0)*100 as Deathpercentage
--FROM covidDeath_clean$
--WHERE continent IS NOT NULL
----GROUP BY date
--order by 1,2 



--JOINING TABLES
-- Looking at ToTAL POPULATION VS TOTAL VACCINATIONS
--SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
--FROM covidDeath_clean$ dea
--JOIN CovidVaccinations$ vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
----WHERE New_vaccinations IS NOT NULL
--ORDER BY 1, 2, 3



--SELECT dea.continent, dea.location, dea.date, dea.population, 
--vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location,
--dea.date) as RollingPeopleVaccinated
--FROM covidDeath_clean$ dea
--JOIN CovidVaccinations$ vac
--	ON dea.location = vac.location
--	AND dea.date = vac.date
--WHERE dea.continent IS NOT NULL
----WHERE New_vaccinations IS NOT NULL
--ORDER BY 2, 3




--USE CTE
/*
WITH PopVsvac(continent, Location, date, population, new_vaccinations, RollingPeopleVaccinated)
as (

SELECT dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location,
dea.date) as RollingPeopleVaccinated
FROM covidDeath_clean$ dea
JOIN CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--WHERE New_vaccinations IS NOT NULL
--ORDER BY 2, 3
)
SELECT *, (RollingPeopleVaccinated/population) *100
FROM PopVsvac
*/


/*
--TEMP TABLE
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingpeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location,
dea.date) as RollingPeopleVaccinated
FROM covidDeath_clean$ dea
JOIN CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (RollingpeopleVaccinated/Population) *100
FROM #PercentPopulationVaccinated
*/


--CREATING VIEW TO STORE DATA FOR LATER VISUALIZATION

CREATE VIEW PercentPopulationVaccinated as
SELECT dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location,
dea.date) as RollingPeopleVaccinated
FROM covidDeath_clean$ dea
JOIN CovidVaccinations$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3

SELECT *
FROM PercentPopulationVaccinated