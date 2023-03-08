
select *
from bootcamp..covidvaccine order by 3,4;

select *
from bootcamp..coviddata order by 3,4;
 
--show likelihood of deaths in china or in your country
select location,date,total_deaths,population
from bootcamp..coviddata 
where location like '%china%' order by 3,4;

--total_cases vs population
--what population got covid as percentage
select location,date,population,total_cases,(total_cases/population)*100 as cases_percentage
from bootcamp..coviddata 
where location like '%canada%' order by 1,2;

--show countries with highest infection rate 
select location,population,max(total_cases)as highest_infection_rate ,max((total_cases/population)*100) as population_infected_percentage
from bootcamp..coviddata 
--where location like '%canada%' 
where continent is not null
group by location ,population
order by 4 desc;


--lets see all data by continent
select  continent,max(total_cases)as highest_infection_rate ,max((total_cases/population)*100) as population_infected_percentage
from bootcamp..coviddata 
--where location like '%canada%' 
where continent is not null
group by continent
order by 3 desc;

--lets see total cases by continent
select  continent,max(total_cases)as total_cases
from bootcamp..coviddata 
--where location like '%canada%' 
where continent is not null
group by continent
order by 2 ;

--continent breakdown by location
select  location,max(total_cases)as total_cases
from bootcamp..coviddata 
--where location like '%canada%' 
where continent is  null
group by location
order by 2 desc ;

--GLOBAL NUMBERS
select sum(new_cases)as total_cases
from bootcamp..coviddata 
--where location like '%canada%' 
where continent is  not null
--group by date
--order by 2 desc ;

--Looking total population vs new_vaccinations
select da.location,da.continent,da.date,da.population,va.new_vaccinations,
sum(va.new_vaccinations) over (partition by da.location order by  da.location) as rollingpeoplevaccinated
from bootcamp..coviddata da
join bootcamp..covidvaccine va
  on da.location = va.location
  and da.date=va.date
where da.continent is not null
order by 2,3 desc;

--population vs new vaccine using cte functions

with popvsvacc (location,continent,date,population,vaccinations,rollingpeoplevaccinated)
as
(
select da.location,da.continent,da.date,da.population,va.new_vaccinations,
sum(va.new_vaccinations) over (partition by da.location order by  da.location) as rollingpeoplevaccinated
from bootcamp..coviddata da
join bootcamp..covidvaccine va
  on da.location = va.location
  and da.date=va.date
where da.continent is not null
--order by 2,3 desc
)
select *,(rollingpeoplevaccinated/population) as percentage_ofvaccine_over_population from popvsvacc

--using temp table

create table #popvsvaccinepercentage
(location nvarchar(255),
continent nvarchar(255),
date datetime ,
population numeric,

)

insert into #popvsvaccinepercentage 
select da.location,da.continent,da.date,da.population
from bootcamp..coviddata da
join bootcamp..covidvaccine va
  on da.location = va.location
  and da.date=va.date
where da.continent is not null

select * from #popvsvaccinepercentage

--view is created later can acess without write query as permanenet query used for visualisations

create view continentbreakdown as
select  location,max(total_cases)as total_cases
from bootcamp..coviddata 
--where location like '%canada%' 
where continent is  null
group by location
--order by 2 desc 

select * from continentbreakdown
