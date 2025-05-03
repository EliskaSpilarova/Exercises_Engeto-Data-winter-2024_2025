-- Úkol 1: Spojte tabulky czechia_price a czechia_price_category. Vypište všechny dostupné sloupce.
SELECT *
FROM czechia_price cp 
JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code; 

-- Úkol 2: Předchozí příklad upravte tak, že vhodně přejmenujete tabulky a vypíšete ID a jméno kategorie potravin a cenu.
SELECT
	cp.id, 
	cpc.name,
	cp.value
FROM czechia_price cp 
JOIN czechia_price_category cpc
	ON cp.category_code = cpc.code; 

-- Úkol 3: Přidejte k tabulce cen potravin i informaci o krajích ČR a vypište informace o cenách společně s názvem kraje.
SELECT 
	cp.*,
	cr.name
FROM czechia_price cp 
LEFT JOIN czechia_region cr 
	ON cp.region_code = cr.code;

-- Úkol 4: Využijte v příkladě z předchozího úkolu RIGHT JOIN s výměnou pořadí tabulek.
SELECT
    cp.*, 
    cr.name
FROM czechia_region AS cr
RIGHT JOIN czechia_price AS cp
    ON cp.region_code = cr.code;

-- Úkol 5: K tabulce czechia_payroll připojte všechny okolní tabulky. Využijte ERD model ke zjištění, které to jsou.
SELECT *
FROM czechia_payroll cp 
JOIN czechia_payroll_calculation cpc ON calculation_code = cpc.code 
JOIN czechia_payroll_industry_branch cpib ON industry_branch_code = cpib.code 
JOIN czechia_payroll_unit cpu ON unit_code = cpu.code 
JOIN czechia_payroll_value_type cpvt ON value_type_code = cpvt.code;

-- Úkol 6: Přepište dotaz z předchozí lekce do varianty, ve které použijete JOIN
/*SELECT
    *
FROM czechia_payroll_industry_branch
WHERE code IN (
    SELECT
        industry_branch_code
    FROM czechia_payroll
    WHERE value IN (
        SELECT
            max(value)
        FROM czechia_payroll
        WHERE value_type_code = 5958
    )
);*/
SELECT *
FROM czechia_payroll cp 
JOIN czechia_payroll_industry_branch cpib 
ON cpib.code = cp.industry_branch_code
WHERE cp.value_type_code = 5958
ORDER BY cp.value DESC
LIMIT 1;

-- Úkol 7: Spojte informace z tabulek cen a mezd (pouze informace o průměrných mzdách). 
-- Vypište z každé z nich základní informace, celé názvy odvětví a kategorií potravin a datumy měření, které vhodně naformátujete.
SELECT
    cpc.name AS food_category,
    cp.value AS price,
    cpib.name AS industry,
    cpay.value AS average_wages,
    TO_CHAR(cp.date_from, 'DD. Month YYYY') AS price_measured_from,
    TO_CHAR(cp.date_to, 'DD.MM.YYYY') AS price_measured_to,
    cpay.payroll_year
FROM
    czechia_price AS cp
JOIN czechia_payroll AS cpay
    ON date_part('year', cp.date_from) = cpay.payroll_year
    AND cpay.value_type_code = 5958    
    AND cp.region_code IS NULL
JOIN czechia_price_category AS cpc
    ON cp.category_code = cpc.code
JOIN czechia_payroll_industry_branch AS cpib    
    ON cpay.industry_branch_code = cpib.code;

-- Úkol 8: K tabulce healthcare_provider připojte informace o regionech a vypište celé názvy krajů i okresů pro místa výkonu i sídla.
SELECT
    hp.name,
    cr.name AS region_name,
    cr2.name AS residence_region_name,
    cd.name AS district_name,
    cd2.name AS residence_district_name
FROM healthcare_provider hp
LEFT JOIN czechia_region cr
    ON hp.region_code = cr.code
LEFT JOIN czechia_region cr2
    ON hp.residence_region_code = cr2.code
LEFT JOIN czechia_district cd
    ON hp.district_code = cd.code
LEFT JOIN czechia_district cd2
    ON hp.residence_district_code = cd2.code;

-- Úkol 9: Upravte předchozí dotaz tak, aby byli na výpisu pouze takoví poskytovatelé, kteří mají sídlo v jiném kraji i jiném okrese než místo poskytování služeb.
SELECT
    hp.name,
    cr.name AS region_name,
    cr2.name AS residence_region_name,
    cd.name AS district_name,
    cd2.name AS residence_district_name
FROM healthcare_provider hp
LEFT JOIN czechia_region cr
    ON hp.region_code = cr.code
LEFT JOIN czechia_region cr2
    ON hp.residence_region_code = cr2.code
LEFT JOIN czechia_district cd
    ON hp.district_code = cd.code
LEFT JOIN czechia_district cd2
    ON hp.residence_district_code = cd2.code
WHERE
    hp.region_code != hp.residence_region_code 
    AND hp.district_code != hp.residence_district_code;

-- Cvičení: Kartézský součin a CROSS JOIN
-- Úkol 1: Spojte tabulky czechia_price a czechia_price_category pomocí kartézského součinu.
SELECT *
FROM czechia_price cp, czechia_price_category cpc 
WHERE cp.category_code = cpc.code;

-- Úkol 2: Převeďte předchozí příklad do syntaxe s CROSS JOIN.
SELECT *
FROM czechia_price cp
CROSS JOIN czechia_price_category cpc
WHERE cp.category_code = cpc.code;

-- Úkol 3: Vytvořte všechny kombinace krajů kromě těch případů, kdy by se v obou sloupcích kraje shodovaly.
SELECT
    cr.name AS first_region,
    cr2.name AS second_region
FROM czechia_region cr
CROSS JOIN czechia_region cr2
WHERE cr.code != cr2.code;


