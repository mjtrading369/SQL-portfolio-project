--- Select Data that we are going to be using

/*Select Location, date,total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2

this is how to change collumn type

/*select*  
from CovidDeaths

EXEC sp_help 'dbo.CovidDeaths';

ALTER TABLE dbo.CovidDeaths
ALTER COLUMN total_deaths float*/


-- Looking at the Total Cases Vs Total Deaths*/
Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from Coviddeaths
Where location like '%states%'
Order by 1,2;

---Looking at total cases vs Population, shows what percentage of population got Covid.  

Select Location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
from Coviddeaths
Where location like '%states%'
Order by 1,2;

--Looking at countries with highest infection rate compare to population

Select Location, population, Max(total_cases) as HighestInfectionCount,  MAX((total_cases/population))*100 as PercentPopulationInfected
from Coviddeaths
--Where location like '%states%'
Group by Location, population
Order by PercentPopulationInfected DESC;


--Showing countries with the highest Death count per population

Select Location, MAX(Cast(total_deaths as int)) as TotalDeathCount
from Coviddeaths
--Where location like '%states%'
Where continent is not null
Group by Location
Order by TotalDeathCount DESC;

-- LET'S BREAK THINGS DOWN BY CONTINENT

Select continent, MAX(Cast(total_deaths as int)) as TotalDeathCount
from Coviddeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount DESC;

--Showing continents with the highest death count per population

Select continent, MAX(Cast(total_deaths as int)) as TotalDeathCount
from Coviddeaths
--Where location like '%states%'
Where continent is not null
Group by continent
Order by TotalDeathCount DESC;


---Global numbers

/*Select --date,
SUM(new_cases) as Total_cases, 
SUM(cast(new_deaths as int)) as Total_deaths, 
(SUM(cast(new_deaths as int)))/(SUM(New_Cases))*100  as DeathPercentage
From dbo.CovidDeaths
--Where location like '%states%'--
where continent is not null
--group by date
Order by 1,2*//



-- Looking at Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

From dbo.CovidDeaths dea
join dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
Where dea.continent is not null
order by 2,3

--USE CTE

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated

From dbo.CovidDeaths dea
join dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100 
from PopvsVac

--Creating View to store data for later visualizations
create view RollingPeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From dbo.CovidDeaths dea
join dbo.CovidVaccinations vac
on dea.location = vac.location and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
