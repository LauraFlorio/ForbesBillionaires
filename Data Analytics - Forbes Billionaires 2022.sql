
-- Having a look at the Dataset

select top 5 
	*
from 
	forbes_billionaires_2022

-- Deleting columns I won't need

alter table forbes_billionaires_2022
drop column bio, about

select top 5 * from forbes_billionaires_2022

-- 1. Top 5 Billionaires

select top 5 
	* 
from 
	forbes_billionaires_2022
order by rank

-- 2. Top 10 countries with more Billionaires

select top 10 
	country,
	count(*) 'NumberOfBillionaires'
from 
	forbes_billionaires_2022
group by country
order by NumberOfBillionaires desc 

-- 3. Distribution of billionaires by gender

select
	gender,
	count(*) 'NumberOfBillionaires',
	format(count(*)*1.0/sum(count(*)) over(), 'P') '%'
from 
	forbes_billionaires_2022
where gender is not null
group by gender

-- 4. Distribution of billionaires by gender and country

select
	country,
	gender,
	count(*) 'NumberOfBillionaires',
	format(count(*)*1.0/sum(count(*)) over(partition by country), 'P') '%'
from 
	forbes_billionaires_2022
where gender is not null and country is not null
group by gender, country
order by country, gender

-- 5. Distribution of billionaires by age range

select
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end 'Age Range',
	count(*) 'NumberOfBillionaires',
	format(count(*)*1.0/sum(count(*)) over(), 'P') '%'
from 
	forbes_billionaires_2022
where age is not null
group by 
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end

-- 6. Distribution of billionaires by age range and country

select
	country,
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end 'age range',
	count(*) 'NumberOfBillionaires',
	format(count(*)*1.0/sum(count(*)) over(partition by country), 'P') '%'
from 
	forbes_billionaires_2022
where age is not null and country is not null
group by 
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end, country
order by country, [age range]


-- 7. Distribution of billionaires by age range and gender

select
	gender,
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end 'age range',
	count(*) 'NumberOfBillionaires',
	format(count(*)*1.0/sum(count(*)) over(partition by gender), 'P') '%'
from 
	forbes_billionaires_2022
where age is not null and gender is not null
group by 
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end, gender
order by [age range], gender

-- 8. Distribution of billionaires by gender, age range and country

select
	country,
	gender,
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end 'age range',
	count(*) 'NumberOfBillionaires',
	format(count(*)*1.0/sum(count(*)) over(partition by country), 'P') '%'
from 
	forbes_billionaires_2022
where gender is not null and age is not null and country is not null
group by 
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end, country, gender
order by country, [age range], gender

-- 9. Number of industry categories the billionaires fall into 

select
	count(distinct category) 'NumberOfCategories'
from 
	forbes_billionaires_2022

-- 11. Industry categories the bilionaires fall into

select
	category,
	count(*) 'NumberOfBillionaires',
	format(count(*)*1.0/sum(count(*)) over(), 'P') '%'
from 
	forbes_billionaires_2022
group by category
order by NumberOfBillionaires desc

-- 12. How many billionaires on the list are owners

select
	count(*) 'Billionaires who are Owners'
from
	forbes_billionaires_2022
where title like '%owner%'


-- 13. Which billionaires on the list are CEOs

select
	*
from
	forbes_billionaires_2022
where title like '%CEO%'
order by rank

-- 14. What is the most common birthmonth between the billionaires

select
	datename (month, birthDate) 'birthMonth',
	count(*) 'Billionaires'
from
	forbes_billionaires_2022
where birthDate is not null
group by datename (month, birthDate)
order by Billionaires desc

-- Alter Table values final worth is in millions and should be in billions

Select * from forbes_billionaires_2022
order by rank

update forbes_billionaires_2022
set finalWorth = finalWorth/1000

-- 16. What is the total billionaires final worth on each category

select
	category,
	sum(finalWorth) 'totalfinalWorth(Billions)'
from
	forbes_billionaires_2022
group by category
order by [totalfinalWorth(Billions)] desc

-- 17. What is the average billionaires final worth on each category

select
	category,
	avg(finalWorth)*1000 'avgFinalWorth(Billions)'
from
	forbes_billionaires_2022
group by category
order by [avgFinalWorth(Billions)] desc

-- 18. What is the total billionaires final worth by gender

select
	gender,
	sum(finalWorth)*1000 'totalFinalWorth(Billions)'
from
	forbes_billionaires_2022
where gender is not null
group by gender
order by [totalfinalWorth(Billions)] desc

-- 19. What is the average billionaires final worth by gender

select
	gender,
	avg(finalWorth)*1000 'avgFinalWorth(Billions)'
from
	forbes_billionaires_2022
where gender is not null
group by gender
order by [avgFinalWorth(Billions)] desc

-- 20. What is the total billionaires final worth by age range

select
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end 'Age Range',
	format(sum(finalWorth), 'N2') 'totalFinalWorth(Billions)'
from 
	forbes_billionaires_2022
where age is not null
group by
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end

-- 21. What is the average billionaires final worth by age range

select
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end 'Age Range',
	format(avg(finalWorth), 'N2') 'avgFinalWorth'
from 
	forbes_billionaires_2022
where age is not null
group by 
	case
		when age > 60 then 'Above 60'
		when age >= 30 then 'Between 30 and 60'
		else 'Bellow 30 '
	end
