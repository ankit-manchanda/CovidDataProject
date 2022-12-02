Select * from CovidDeaths

--Total cases vs total deaths - Shows likelyhood of Infected Person Dying due to Covid

Select location, date, total_cases, new_cases, population, (total_deaths/total_cases)*100 as DeathPercentage
from ProjectPortfolio..CovidDeaths
where location = 'India'
order by 1, 2;

--Total cases vs total population - Shows percentage of People infected with Covid

Select location, date, total_cases, new_cases, population, (total_cases/population)*100 as InfectedPercentage
from ProjectPortfolio..CovidDeaths
where location = 'India'
order by 1, 2;

-- Shows countries with highest percentage of People infected with Covid in comparison to the population

Select location, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as InfectedPercentage
from ProjectPortfolio..CovidDeaths
group by location, population
order by 4 desc;

-- Showing Countries with Highest Death Count

Select location, max(cast(total_deaths as int)) as HighestDeathCount
from ProjectPortfolio..CovidDeaths
where continent is not null
group by location
order by 2 desc;

-- Showing Death Count by Continents

Select continent, max(cast(total_deaths as int)) as DeathCount
from ProjectPortfolio..CovidDeaths
where continent is not null
group by continent
order by 2 desc;

-- Showing Global Death Count
Select sum(cast(new_cases as int)) as total_cases, sum(convert(int, new_deaths)) as total_deaths, sum(convert(int, new_deaths)) / sum(new_cases) * 100 as DeathPercentage
from ProjectPortfolio..CovidDeaths
where continent is not null
order by 1, 2;

--Total vaccinations against population

Select dea.continent, dea.location, dea.date, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as sum_new_vaccinations, dea.population
from ProjectPortfolio..CovidVaccinations vac
join  ProjectPortfolio..CovidDeaths dea
on vac.location = dea.location and vac.date = dea.date
where dea.continent is not null
order by 1, 2

-- using CTE for percentage calculation

with VacVsPop (continent, location, date, new_vaccinations, sum_new_vaccinations, population)
as
(
Select dea.continent, dea.location, dea.date, vac.new_vaccinations, sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as sum_new_vaccinations, dea.population
from ProjectPortfolio..CovidVaccinations vac
join  ProjectPortfolio..CovidDeaths dea
on vac.location = dea.location and vac.date = dea.date
where dea.continent is not null
)
select * , (sum_new_vaccinations/population)*100 from VacVsPop

create view Countrywise_Death_Count as

-- Showing Countries with Highest Death Count

Select location, max(cast(total_deaths as int)) as HighestDeathCount
from ProjectPortfolio..CovidDeaths
where continent is not null
group by location;

