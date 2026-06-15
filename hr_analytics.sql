CREATE TABLE employees (
    age INT,
    attrition VARCHAR(10),
    businesstravel VARCHAR(50),
    dailyrate INT,
    department VARCHAR(50),
    distancefromhome INT,
    education INT,
    educationfield VARCHAR(50),
    employeecount INT,
    employeenumber INT PRIMARY KEY,
    environmentsatisfaction INT,
    gender VARCHAR(20),
    hourlyrate INT,
    jobinvolvement INT,
    joblevel INT,
    jobrole VARCHAR(100),
    jobsatisfaction INT,
    maritalstatus VARCHAR(30),
    monthlyincome INT,
    monthlyrate INT,
    numcompaniesworked INT,
    over18 VARCHAR(5),
    overtime VARCHAR(10),
    percentsalaryhike INT,
    performancerating INT,
    relationshipsatisfaction INT,
    standardhours INT,
    stockoptionlevel INT,
    totalworkingyears INT,
    trainingtimeslastyear INT,
    worklifebalance INT,
    yearsatcompany INT,
    yearsincurrentrole INT,
    yearssincelastpromotion INT,
    yearswithcurrmanager INT
);

select * from employees
limit 1;

select count(*) from employees;

--Attrition Count
select attrition, count(*) from employees
group by attrition;

--1. Attrition Rate
select round(100.0 * sum(case when attrition='Yes' then 1 else 0 end)
/ count(*),2 ) as attrition_rate
from employees;

--2. Attrition by Department
select department, count(*) as employees,
sum(case when attrition='Yes' then 1 else 0 end) as attrition_count
from employees
group by department;

--3. Average Salary by Department
select  round(avg(monthlyincome),2),department
from employees
group by department
order by avg(monthlyincome) desc;

--4. Does working overtime increase employee attrition?
select overtime, count(*) as total_emp,
sum(case when attrition = 'Yes' then 1 else 0 end)
as attrition
from employees
group by overtime;

--5. Top Paying Job Roles
select jobrole, round(avg(monthlyincome),2) as avg_salary	
from employees
group by jobrole
order by avg_salary desc;

--6. Attrition by Age Group
select
case 	
	when age< 30 then 'under 30'
	when age between 30 and 40 then '30-40'
	else '40+'
	end age_group,
count(*) employees,
sum(case when attrition = 'Yes' then 1 else 0 end) as attrition
from employees
group by age_group;	 

--7. Salary Ranking
with salary_ranking as(
select employeenumber, jobrole, monthlyincome,
rank() over (order by monthlyincome desc) as salary_rank
from employees
)
select * from salary_ranking
where salary_rank <= 10;

--8. Which department pays the highest average salary?
select department, round(avg(monthlyincome),2) as avg_salary
from employees
group by department;

--9. Who are the most experienced employees in the company?
select employeenumber,jobrole, totalworkingyears
from employees
order by totalworkingyears desc
limit 10;

--10.How satisfied are employees with their jobs?
select jobsatisfaction, count(*) as employee
from employees
group by jobsatisfaction
order by jobsatisfaction;

--11. Who has worked for many years but hasn't been promoted recently?
select employeenumber, jobrole, yearsatcompany, yearssincelastpromotion
from employees
where yearsatcompany >= 5
and yearssincelastpromotion >= 3
order by yearsatcompany desc
limit 10;

--12. Employee Segmentation
select
case
    when monthlyincome < 5000 then 'Low Salary'
    when monthlyincome between 5000 and 10000 then 'Medium Salary'
    else 'High Salary'
end salary_group,
count(*) total_employees
from employees
group by salary_group;

--13. Attrition Rate by Department
select
    department,
    ROUND(100.0 * sum(case when attrition='Yes' then 1 else 0 end)
        / count(*),2) as attrition_rate
from employees
group by department
order by attrition_rate desc;

--14. Most Experienced Employee in Each Department
with exp_rank as (
    select department,employeenumber,totalworkingyears,
        row_number() over(
            partition by department
            order by totalworkingyears desc
        ) rn
    from employees
)
select * from exp_rank
where rn = 1;