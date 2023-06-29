select * from Crop_production;
select distinct Crop_Year from crop_production
select distinct crop, season from crop_production where Season='rabi' 
select distinct crop, season from crop_production where Season='Kharif'
select distinct crop, season from crop_production where Season=''

--1. what is the overall trend in crop production over the years?

select CP.State_Name,CP.Crop_Year,sum(CP.Production) as [Total Production] 
from crop_production CP group by CP.Crop_Year,CP.State_Name 
having cp.State_Name = 'Maharashtra' Order by cp.Crop_Year  

--we can use select into statement to copy the above data as a temp table

--2. Which crops are the most commonly grown?

select distinct cp.Crop, count(cp.District_Name) as NoOfDistrict,cp.State_Name  --,sum(cp.Area) as Total_Area
from crop_production cp group by cp.State_Name,cp.Crop,cp.District_Name  order by NoOfDistrict desc

select distinct top 10  crop,sum(area) as totalArea,sum(Production) as Total_Production 
from crop_production group by crop order by totalArea desc;

SELECT Crop, COUNT(DISTINCT CONCAT(cp.State_Name, '-', cp.District_Name)) AS NumberOfAreas, 
SUM(cp.Production) AS TotalProduction
FROM crop_production as Cp
GROUP BY cp.Crop;

SELECT Crop, COUNT(*) * 100.0 / (SELECT COUNT(*) FROM crop_production) AS CropPercentage
FROM crop_production
GROUP BY Crop
ORDER BY CropPercentage DESC;

SELECT Crop_Year, SUM(Production) as TotalProduction
FROM crop_production 
GROUP BY Crop_Year
ORDER BY Crop_Year;

select season, sum(Production) as TotalProduction
from crop_production 
group by Season
order by TotalProduction desc;

--4. Which state or district has the highest crop production?

select top 5 State_Name,sum(production) as Total_Production from crop_production 
group by State_Name Order by Total_Production desc

--5. Is there any correlation between the crop area and production?

select  State_Name,sum(Area) as Total_Area,sum(production) as Total_Production from crop_production 
group by State_Name Order by Total_Production desc,Total_Area desc

select top 1 District_Name, State_Name, sum(Production) as TotalProduction
FROM crop_production
Group by District_Name, State_Name
Order by TotalProduction DESC;

--6. Are there any significant changes in crop production for specific crops or regions over time?

select  distinct c.Crop,c.Crop_Year,sum(c.Production) As Production 
from crop_production C
group by c.Crop,C.Crop_Year having c.crop = 'rice'
order by Crop_Year




Select Crop, State_Name, AVG(Production) AS AverageProduction
From crop_production
Group by Crop, State_Name
Order by Crop, State_Name;

SELECT Crop, State_Name, Crop_Year, AVG(Production) AS AverageProduction
FROM crop_production
GROUP BY Crop, State_Name, Crop_Year
ORDER BY Crop_Year, Crop, State_Name;

--8. Which crops have shown consistent growth or decline in production?
--Do not try to execuute this --

Create Function FN_GetCropProductionTrends (@CropName varchar(50))
returns table
as return (
Select top 500
    c1.Crop,
    c1.Crop_Year, c1.Production, 
	Case when c2.Production = 0 then Null
  else  (c1.Production - c2.Production) / c1.Production * 100 
  end AS PercentageChange
FROM
    crop_production c1
LEFT JOIN
    crop_production c2 ON c1.Crop = c2.Crop AND c1.Crop_Year = c2.Crop_Year + 1
	Where c1.Crop = @CropName
ORDER BY
    c1.Crop,
    c1.Crop_Year);

select * from FN_GetCropProductionTrends('Bajra')

SELECT crop,Crop_Year,Production,(Production-LAG(Production)
over(partition by crop order by crop_year))/LAG(Production)
over(partition by crop order by crop_year) * 100  as PercentageChange
from crop_production
order by crop,Crop_Year;

--8. Which Crops have shown consistent growth or decline in production over time?

select Season,Crop_Year,sum(production) as Total_Production 
from crop_production where Season='kharif' group by Season,Crop_Year order by Crop_Year

select distinct season from crop_production
select Season,Crop_Year,sum(production) as Total_Production 
from crop_production where Season='Rabi' group by Season,Crop_Year order by Crop_Year

select Season,Crop_Year,sum(production) as Total_Production 
from crop_production where Season in ('Summer','Rabi','Autumn','Kharif','Winter')
group by Season,Crop_Year order by Crop_Year

select Season,sum(Production) as totalproduction 
from crop_production where Crop_Year = 2015 and Season = 'Rabi' group by season