
 --select Data That We are going to Discuss 

select Location , date, total_cases , new_cases,total_deaths,population
from ['Death data$']
order by 1,2


-- Looaking at Total Cases VS Total Deaths 
-- Shows Liklihood of your country to get covied 

select  total_cases ,total_deaths, concat((total_deaths/total_cases)*100,'%') AS Death_Percentage
from ['Death data$']
order by 1,2

-- Looking at Total cases VS Population 
-- Shows What Percentage Of PoPulation got Covid 

select Location , date, total_cases ,population, concat((total_cases/population)*100,'%') AS Cases_Percentage
from ['Death data$']
order by 1,2

-- Looking at countries with highest infection rate compared to populatuion 

select  Location ,population,MAX(total_cases)As Highest_infection,max(concat((total_cases/population)*100,'%')) AS persentage
from ['Death data$']
--where total_cases IS NOT NULL;
Group by Location ,population 
order by persentage desc

-- Break things down by continent 
-- Showing The percentage of people Infected and Die 

select  continent ,max(cast(total_deaths as int))as Total_death_count
from ['Death data$']
where continent IS not NULL
Group by continent
order by Total_death_count  desc

-- Global Numbers 
select sum(new_cases) as Total_cases , sum(cast(new_deaths as int)) as Total_dewaths , 
sum(cast(new_deaths as int))/sum(new_cases)*100 as Percentage_of_Death
from ['Death data$']

--Looking For Total Population Vs Vaccinations

select dea.date , dea.continent , dea.population , dea.location , vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over( partition by dea.location order by dea.location,dea.Date) as RollingpeopleVaccincated 
from ['Death data$'] dea 
Join [Covid Data ].. Vaccinations vac
	on dea.date = vac.date  and  dea.location = vac.location 
where dea.continent IS not NULL
order by 1,4

--Using CTE
with popvsvac (date , continent , population ,location ,new_vaccinations, RollingpeopleVaccincated)
as(
select dea.date , dea.continent , dea.population , dea.location , vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over( partition by dea.location order by dea.location,dea.Date) as RollingpeopleVaccincated 
from ['Death data$'] dea 
Join [Covid Data ].. Vaccinations vac
	on dea.date = vac.date  and  dea.location = vac.location 
where dea.continent   is  not NULL 
--order by 1,4
)
select *  , (RollingpeopleVaccincated/population)*100
from popvsvac

--TEMP TABLE 
drop table if exists #percentpopulationvaccinateddod
create table #percentpopulationvaccinateddod
(
Date datetime,continent nvarchar(255),
population numeric ,
location nvarchar(255),new_vaccinations numeric ,
RollingpeopleVaccincated numeric)

INSERT INTO #percentpopulationvaccinateddod
select dea.date , dea.continent , dea.population , dea.location , vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over( partition by dea.location order by dea.location,dea.Date) as RollingpeopleVaccincated 
from ['Death data$'] dea 
Join [Covid Data ].. Vaccinations vac
	on dea.date = vac.date  and  dea.location = vac.location 
--ere dea.continent   is  not NULL 
--order by 1,4

select* ,(RollingpeopleVaccincated/population)*100
from  #percentpopulationvaccinateddod                          

--creating view to dtore data for visuallization 
create view percentpopulationvaccinateddod   as 
select dea.date , dea.continent , dea.population , dea.location , vac.new_vaccinations,
sum(cast(vac.new_vaccinations as bigint)) over( partition by dea.location order by dea.location,dea.Date) as RollingpeopleVaccincated 
from ['Death data$'] dea 
Join [Covid Data ].. Vaccinations vac
	on dea.date = vac.date  and  dea.location = vac.location 
where dea.continent   is  not NULL

select *
from percentpopulationvaccinateddod 












