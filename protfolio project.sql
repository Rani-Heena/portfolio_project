select * from covid_deaths$
order by 3,4

select * from covid_vaccinations$
order by 3,4

--selecting data the will be used
select location,date, population ,total_cases,new_cases,total_deaths
from covid_deaths$
order by 1,2

-- totla cases vs total deaths
--likelihood of dying if you contract covid in your country
select location,date, total_cases,total_deaths, (total_deaths/total_cases)*100 as deathpercentage
from covid_deaths$
where location='india'
order by 1,2

-- total cases vs population
-- percentage of population got covid
select location,date,population,  total_cases, (total_cases/population)*100 as infectionpercentage
from covid_deaths$
where location='india'
order by 1,2

--highest infection rate  as per population  

select location,population, max( total_cases) as highestinfectioncount, max((total_cases/population))*100 as infectionpercentage
from covid_deaths$
group by location,population
order by infectionpercentage desc

--death count per population
select location,max(cast (total_deaths as int)) as totaldeathcount
from covid_deaths$
where continent is not null
group by location
order by totaldeathcount desc

--Bresking by continent
select continent,max(cast (total_deaths as int)) as totaldeathcount
from covid_deaths$
where continent  is  not null
group by continent 
order by totaldeathcount desc

--global numbers

select  sum (new_cases) as total_cases   ,sum (cast(new_deaths as int)) as total_death,sum (cast(new_deaths as int))/sum (new_cases) *100 as deathpercentage
from covid_deaths$
where continent is not null
--group by date
order by 1,2

--looking at total population vs vaccination

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert (bigint,vac.new_vaccinations) ) over (partition by dea.location order by dea.location, dea.date
)as rollingpeoplevaccinated
from covid_deaths$ as dea
join covid_vaccinations$ vac
on dea.location= vac.location
and dea.date=vac.date
where dea.continent is not null
order by 2,3



--CTE 

with popvsvac (continent,location, date,population,new_vaccinations,rollingpeoplevaccinated)
as 
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
,sum(convert (bigint,vac.new_vaccinations) ) over (partition by dea.location order by dea.location, dea.date
)as rollingpeoplevaccinated
from covid_deaths$ as dea
join covid_vaccinations$ vac
on dea.location= vac.location
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *, (rollingpeoplevaccinated/population)*100 as rollingpeoplevacctnation1_percent
from popvsvac