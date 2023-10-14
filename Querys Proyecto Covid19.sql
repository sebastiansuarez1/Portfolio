
--select *
--from Portfolio..CovidDeaths$


--Selecciono INFO que voy a usar

--SELECT location, date, total_cases, new_cases, total_deaths, population
--FROM Portfolio..CovidDeaths$
--order by 1,2


--Calculo la probabilidad de sobrevivir al contraer COVID segun pais 

--SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as "Probabilidad de fallecer por covid segun pais"
--FROM Portfolio..CovidDeaths$
--order by 1,2



----Observando el total de casos vs Poblacion

--SELECT location,date, population, total_cases,  (total_cases/population)*100 as 'Porcentaje contagio segun la poblacion de cada pais'
--FROM Portfolio..CovidDeaths$
--WHERE continent is not NULL and continent not like ''
--order by 1,2


----Observando el total de casos vs muertes

--SELECT location,date, population, total_cases,  (total_deaths/population)*100 as 'Porcentaje de muertes'
--FROM Portfolio..CovidDeaths$
--WHERE continent is not NULL and continent not like ''
--order by 1,2



----Observando los paises con mas contagios respecto del total de la poblacion

--SELECT Location, Population, Max(total_cases) as 'Numero de infecciones mas alto', Max((total_cases/population))*100 as 'Porcentaje de Infectados'
--FROM Portfolio..CovidDeaths$
--WHERE continent is not NULL and continent not like ''
--GROUP BY Location,Population
--ORDER BY 'Porcentaje de Infectados' desc



--Mostrando los paises con mas cantidad de muertes por contagios

--SELECT Location, MAX(CAST(Total_deaths as float)) as TotalDeathCount
--FROM Portfolio..CovidDeaths$
--WHERE continent is not NULL and continent not like ''
--GROUP BY Location
--ORDER BY TotalDeathCount desc

--Mostrando los continentes con mas cantidad de muertes por contagios

--SELECT continent, max(total_deaths) as TotalDeathCount
--FROM Portfolio..CovidDeaths$
--WHERE continent is not NULL and continent not like ''
--GROUP BY continent
--ORDER BY TotalDeathCount desc



---- Cantidad de casos POR dia teniendo cuento todas los paises contabilizados

--Select date, SUM(new_cases) as total_cases
--From Portfolio..CovidDeaths$
----Where location like '%states%'
--where continent is not null and continent not like ''
--Group By date 
--order by date 


---- Resumen Global

--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From Portfolio..CovidDeaths$
----Where location like '%states%'
--where continent is not null and continent not like ''
----Group By date
--order by 1,2


--Observando la poblacion total vs Vacunaciones

--Corrigiendo en la columna Population

--UPDATE Portfolio..CovidDeaths$
--SET Portfolio..CovidDeaths$.population = CAST(Portfolio..CovidDeaths$.population / 10 AS float)


--Acumulado de vacunados por pais


 WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, Acumuladovacunadosporpais)
 AS (

SELECT dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations, --vac.new_vaccinations
SUM(Cast(vac.new_vaccinations as float )) 
OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as Acumuladovacunadosporpais
--(Acumuladovacunadosporpais/population)*100
FROM Portfolio..CovidDeaths$ dea
JOIN Portfolio..CovidVaccunations1$ vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent is not null and dea.continent not like ''
)

Select *, (Acumuladovacunadosporpais/Population)*100
From PopvsVac
