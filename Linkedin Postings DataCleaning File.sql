-- DATA CLEANING PROJECT (LINKEDIN POSTINGS 2023)

-- A LOOK AT DATASET 

SELECT * FROM 
linkedin_job_posts_2023;
				-- 31597 ROWS RETURNED 

-- # DATA CLEANING

-- ALL THE COLUMNS ARE REQUIRED FOR ANALYSIS SO WE DO NOT NEED TO DROP ANY COLUMNS
               -- 1. Job_title             2. company_name           3. location 
               -- 4. hiring_status         5. date                   6. seniority_level
               -- 7. job_function          8. employment_type        9. industry

-- CREATING COPY OF DATASET FOR DATA CLEANING 

CREATE TABLE linkedin_2023_clean LIKE linkedin_job_posts_2023;	
INSERT INTO linkedin_2023_clean
SELECT * FROM linkedin_job_posts_2023;

-- STANDARDIZING COLUMNS 
-- 1. Job_title

SELECT job_title, COUNT(job_title) FROM linkedin_2023_clean
GROUP BY job_title
ORDER BY 1;
            -- 5986 ROWS RETURNED
            -- INCONSISTENICIES FOUND - BLANK VALUES , UNWANTED SPACES , IRRELEVANT JOB_TITLE 
            
SELECT TRIM(REPLACE(REPLACE(REPLACE(job_title, '\t', ''), '\n', ''), '\r', '')) FROM linkedin_2023_clean;
-- REMOVED ALL UNWANTED SPACES, LINING, TABS

-- To disbale safe update mode on MySQL
SET SQL_SAFE_UPDATES = 0;

UPDATE linkedin_2023_clean
SET job_title = TRIM(REPLACE(REPLACE(REPLACE(job_title, '\t', ''), '\n', ''), '\r', ''));

SELECT * FROM linkedin_2023_clean
WHERE job_title = "" OR job_title IS NULL;

      -- 30 BLANK VALUES FOUND IN JOB_TITLE
-- WE WILL ONLY REMOVE ROWS WHICH HAVE BLANKS IN BOTH JOB_TITLE AND JOB_FUNCTION

SELECT * FROM linkedin_2023_clean
WHERE job_title = "" AND job_function = "";
				-- 5 ROWS RETURNED 
        
DELETE FROM linkedin_2023_clean
WHERE job_title = "" AND job_function = "";
					-- 5 ROWS DELETED 
                    
SELECT job_title, COUNT(job_title) FROM linkedin_2023_clean
WHERE job_title LIKE '%?%'
GROUP BY job_title
ORDER BY 1;
            -- 173 ROWS RETURNED

SELECT * FROM linkedin_2023_clean
WHERE job_title LIKE '%?%' AND job_function = "";
            -- 19 IRRELEVANT ROWS FOUND 
            
DELETE FROM linkedin_2023_clean
WHERE job_title LIKE '%?%' AND job_function = "";

SELECT job_title, COUNT(job_title), job_function FROM linkedin_2023_clean
WHERE job_title LIKE '%?' 
GROUP BY job_title, job_function
ORDER BY 1;
           -- ALL THESE FIELDS DO NOT HAVE RELEVANT JOB_TITLE BUT RELEVANT JOB FUNTION SO WE WILL KEEP IT IN THE RECORD
           
-- REPLACING ?? WITH CHECK JOB FUNCTION 

SELECT job_title,
CASE 
	WHEN job_title LIKE '%?' THEN 'Check job funtion'
END 
FROM linkedin_2023_clean
WHERE job_title LIKE '%?'
GROUP BY job_title;
           
UPDATE linkedin_2023_clean
SET job_title = 
	CASE 
	WHEN job_title LIKE '%?' THEN 'Check job funtion'
    WHEN job_title = "" THEN 'Check job function'
    WHEN job_title LIKE '%?_' THEN 'Check job function'
    WHEN job_title LIKE '%<SL>' THEN 'Check job function'
    WHEN job_title = '?????/Customer Service Coordinator' THEN 'Cutomer service coordinator'
    WHEN job_title = '?????????// System Engineer' THEN 'System Engineer'
    WHEN job_title LIKE '?%' THEN 'Check job function'
    WHEN job_title = '--- Programmer I' THEN 'Programmer I'
    WHEN job_title = '""' THEN 'Check job function'
    WHEN job_title = '"Data Scientist_ Perth"""' THEN 'Data Scientist_ Perth'
    WHEN job_title = '[??]???Linux?????(PG)' THEN 'Linux(PG)'
    WHEN job_title = '**Newly Opened - Support Merchandiser - Granger, IN' THEN 'Newly Opened - Support Merchandiser - Granger, IN'
	WHEN job_title = '*HYBRID* Product Manager Mid' THEN 'HYBRID Product Manager Mid'
    WHEN job_title = '*HYBRID* Product Owner Sr' THEN 'HYBRID Product Owner Sr'
    WHEN job_title = '21_070_03??????????????????(Android???HMI)' THEN '21_070_03(Android HMI)'
    WHEN job_title = 'AWS Cloud Engineer:' THEN 'AWS Cloud Engineer'
    WHEN job_title = 'AWS Systems Architect' THEN 'AWS System Architect'
    WHEN job_title = 'Cloud Architect/' THEN 'Cloud Architect'
    WHEN job_title = 'Cloud Engineer - AWS' THEN 'Cloud Engineer (AWS)'
    WHEN job_title = 'Cloud Solutions Architect' THEN 'Cloud Solution Architect'
    WHEN job_title = 'Content Writer / Copy Writer' THEN 'Content Writer / Copywriter'
    WHEN job_title = 'Content Writer/Copy Writer' THEN 'Content Writer / Copywriter'
    WHEN job_title = 'Copy Writer' THEN 'Copywriter'
    WHEN job_title = 'Copywriter:in' THEN 'Copywriter'
    WHEN job_title = 'Copywriter.' THEN 'Copywriter'
    WHEN job_title = 'Data Scientist III.' THEN 'Data Scientist III'
    WHEN job_title = 'General Sales Manager*' THEN 'General Sales Manager'
    WHEN job_title = 'Graduate Civil Engineers' THEN 'Graduate Civil Engineer'
    WHEN job_title = 'Hr Operation' THEN 'Hr operations'
    WHEN job_title = 'Junior Full-stack Developer' THEN 'Junior Fullstack Developer'
    WHEN job_title = 'Junior Software Develope' THEN 'Junior Software Developer'
    WHEN job_title = 'Lead ? Market Research/Product Analyst' THEN 'Lead-Market Research/Product Analyst'
    WHEN job_title = 'Lead Engineer - BIOS Test Automation' THEN 'Lead Engineer- BIOS Test Automation'
    WHEN job_title = 'Lead Engineer(Process)' THEN 'Lead Engineer-Process'
    WHEN job_title = 'Manager ? Business Advisory' THEN 'Manager-Business Advisory'
    WHEN job_title = 'Manual QA Enginer' THEN 'Manual QA Engineer'
    WHEN job_title = 'Marketing Campaign Manager' THEN 'Marketing Campaigns Manager'
    WHEN job_title = 'Midweight Copywriter' THEN 'Mid-Weight Copywriter'
    WHEN job_title = 'Process?Analyst' THEN 'Process Analyst'
    WHEN job_title = 'Remote:::Machine Learning Engineer' THEN 'Remote - Machine Learning Engineer'
    WHEN job_title = 'Sales Operations Manager' THEN 'Sales Operation Manager'
    WHEN job_title = 'SEO _Content Writer' THEN 'SEO Content Writer'
    WHEN job_title = 'Software Development Engineer- FullStack' THEN 'Software Development Engineer- Full Stack'
    WHEN job_title = 'Software Engineer (Full-Stack)' THEN 'Software Engineer (Full Stack)'
    WHEN job_title = 'Software Engineer (Fullstack)' THEN 'Software Engineer (Full Stack)'
    WHEN job_title = 'Software Engineer Full Stack' THEN 'Software Engineer (Full Stack)'
    WHEN job_title = 'Software Engineer, Full Stack' THEN 'Software Engineer (Full Stack)'
    WHEN job_title = 'Software Engineer, Full-Stack' THEN 'Software Engineer (Full Stack)'
    WHEN job_title = 'Software Tester (Automation)' THEN 'Software Tester - Automation'
    WHEN job_title = 'Vice President- Sales' THEN 'Vice President Sales'
    WHEN job_title = 'AI / IoT ????????? (Cloud Systems) ????IT????????? (????/??) 4.5-7.5M' THEN 'Cloud Systems'
    WHEN job_title = 'Data Engineer (m/w/d) f?r unser Public-Team' THEN 'Data Engineer (m/w/d) for unser Public-Team'
    WHEN job_title = 'DevOps Engineer (m/w/d) f?r unser Public-Team' THEN 'DevOps Engineer (m/w/d) for unser Public-Team'
    WHEN job_title = 'Full Stack Developer - 6 Month Contract - ?650 per day' THEN 'Full Stack Developer - 6 Month Contract - 650 per day'
    ELSE job_title
END; 

UPDATE linkedin_2023_clean
SET job_title = TRIM(LEADING '.' FROM job_title);

UPDATE linkedin_2023_clean
SET job_title = TRIM(LEADING '#' FROM job_title);

UPDATE linkedin_2023_clean
SET job_title = TRIM(TRAILING ',' FROM job_title);

UPDATE linkedin_2023_clean
SET job_title = REPLACE (job_title , '?' , '-');
           
-- ALL INCONSISTENICIES HAS BEEN REMOVED FROM JOB TITLE  

SELECT job_title , COUNT(job_title) FROM linkedin_2023_clean
GROUP BY job_title
ORDER BY 1;
            -- 5587 JOB TITLE HAS BEEN FOUND 
            
-- CHECKING COMPANY NAME 

SELECT company_name, COUNT(company_name) FROM linkedin_2023_clean
GROUP BY company_name
ORDER BY 1; 
			-- 7182 ROWS FOUND 

SELECT company_name, COUNT(company_name) FROM linkedin_2023_clean
WHERE company_name = ""
GROUP BY company_name
ORDER BY 1;             
            -- 917 BLANK VALUES FOUND 
            
UPDATE linkedin_2023_clean
SET company_name = 'Missing' WHERE company_name = "";

-- CHECKING INCONSISTENICIES 

SELECT company_name FROM linkedin_2023_clean
WHERE company_name LIKE '%?%'
GROUP BY company_name;
            
-- REMOVING INCONSISTENCIES

UPDATE linkedin_2023_clean
SET company_name = TRIM(REPLACE(REPLACE(REPLACE(company_name, '\t', ''), '\n', ''), '\r', ''));

UPDATE linkedin_2023_clean
SET company_name =
CASE 
	WHEN company_name = 'Cl?nera' THEN 'Clenera'
    WHEN company_name = 'A?B' THEN 'A B'
    WHEN company_name = '??? INDIGO' THEN 'INDIGO'
	WHEN company_name = 'FESCO Adecco ??????' THEN 'FESCO Adecco'
    WHEN company_name = 'GUESS?, Inc.' THEN 'GUESS, Inc.'
    WHEN company_name = 'Mondel?z International' THEN 'Mondelez International'
    WHEN company_name = 'Indiana University?Purdue University Indianapolis' THEN 'Indiana University Purdue University Indianapolis'
    WHEN company_name = 'Nestl? Nespresso SA' THEN 'Nestle Nespresso SA'
    WHEN company_name = 'Aret? Collective' THEN 'Arete Collective'
    WHEN company_name = 'The Est?e Lauder Companies Inc.' THEN 'The Estee Lauder Companies Inc.'
    WHEN company_name = 'M?dialis' THEN 'Midialis'
    WHEN company_name = 'Gyllstr?m Kommunikationsbyr? AB' THEN 'Gyllstrom Kommunikationsbyra AB'
    WHEN company_name = '?URA' THEN 'AURA'
    WHEN company_name = 'Aviation Indeed™?' THEN 'Aviation Indeed'
    WHEN company_name = 'Barclay' THEN 'Barclays'
    WHEN company_name LIKE '?%' THEN 'Missing'
    WHEN company_name = 'IIDE- The Digital School' THEN 'IIDE - The Digital School'
    WHEN company_name = 'Poddar Diamond Ltd' THEN 'Poddar Diamond Ltd.'
    WHEN company_name = 'Water Corporation' THEN 'Waters Corporation'
    ELSE company_name 
END;

UPDATE linkedin_2023_clean
SET company_name = TRIM(TRAILING '?' FROM company_name);

UPDATE linkedin_2023_clean
SET company_name = TRIM(TRAILING '.' FROM company_name);

-- ALL INCONSISTENICIES HAS BEEN REMOVED FROM COMPANY NAME
            
-- CHECKING LOCATION COLUMN

SELECT location FROM linkedin_2023_clean;

UPDATE linkedin_2023_clean
SET location = TRIM(REPLACE(REPLACE(REPLACE(location, '\t', ''), '\n', ''), '\r', ''));

-- BREAKING LOCATION INTO 3 COLUMNS CITY , STATE , COUNTRY 

ALTER TABLE linkedin_2023_clean
ADD COLUMN city VARCHAR(255) AFTER company_name,
ADD COLUMN state VARCHAR(255) AFTER city,
ADD COLUMN country VARCHAR(255) AFTER state;

-- INSRTING NECESSARY VALUES 

UPDATE linkedin_2023_clean
SET city = SUBSTRING_INDEX(location, ',', 1),
	state = SUBSTRING_INDEX(SUBSTRING_INDEX(location, ',', 2), ',', -1),
    country =  SUBSTRING_INDEX(location, ',', -1)
WHERE location LIKE '%,%,%';

-- CHECKING NULL VALUES

SELECT city, state, country, location FROM linkedin_2023_clean
WHERE city IS NULL
GROUP BY location, city, state, country
ORDER BY location;

-- DEALING WITH NULLS 

UPDATE linkedin_2023_clean
SET city = SUBSTRING_INDEX(location, ',', 1) 
WHERE location LIKE '%,___';

UPDATE linkedin_2023_clean
SET state = SUBSTRING_INDEX(location, ',' , 1)
WHERE LENGTH(location) - LENGTH(REPLACE(location, ',', '')) = 1;

UPDATE linkedin_2023_clean
SET country = SUBSTRING_INDEX(location, ',' , -1)
WHERE LENGTH(location) - LENGTH(REPLACE(location, ',', '')) = 1 AND location <> '%Area';

UPDATE linkedin_2023_clean
SET country = 'Romania'
WHERE location LIKE '%Romania';

UPDATE linkedin_2023_clean
SET city = location 
WHERE location LIKE '%Area';

-- CHECKING ALL NULLS

SELECT city, state, country, location,count(location) FROM linkedin_2023_clean
WHERE city IS NULL AND state IS NULL AND country IS NULL
GROUP BY location, city, state, country
ORDER BY location;

-- FILLING NULLS 

UPDATE linkedin_2023_clean
SET city =
CASE 
	WHEN location = 'Brabantine City Row' THEN 'Brabantine City'
    WHEN location = 'Dallas-Fort Worth Metroplex' THEN 'Dallas-Fort Worth Metroplex'
    WHEN location = 'Gold Coast' THEN 'Gold Coast'
    WHEN location = 'Greater Boston' THEN 'Boston'
    WHEN location = 'Greater Houston' THEN 'Houston'
    WHEN location = 'Greater Indianapolis' THEN 'Indianapolis'
    WHEN location = 'Greater Nagoya' THEN 'Nagoya' 
    WHEN location = 'Greater Philadelphia' THEN 'Philadelphia'
    WHEN location = 'Greater Sacramento' THEN 'Sacramento' 
    WHEN location = 'Greater St. Louis' THEN 'St. Louis'
    WHEN location = 'Mumbai Metropolitan Region' THEN 'Mumbai'
    ELSE city
END;

UPDATE linkedin_2023_clean
SET country = location 
WHERE city IS NULL AND state IS NULL AND country IS NULL;

-- ALL NULLS ARE REMOVED 

-- CHECKING COLUMN hiring_status

SELECT hiring_status, COUNT(hiring_status) FROM linkedin_2023_clean
GROUP BY hiring_status;

-- REMOVING INCONSISTENCIES

UPDATE linkedin_2023_clean
SET hiring_status = TRIM(REPLACE(REPLACE(REPLACE(hiring_status, '\t', ''), '\n', ''), '\r', ''));

UPDATE linkedin_2023_clean
SET hiring_status = 
CASE 
	WHEN hiring_status LIKE 'Actively%' THEN 'Actively Hiring'
    WHEN hiring_status LIKE 'Be an%' THEN 'Be an early applicant'
    WHEN hiring_status LIKE 'Medical%' THEN 'Medical Insurance'
    ELSE hiring_status
END;

    -- ALL INCONSISTENICIES HAS BEEN REMOVED FROM HIRING STATUS


-- CHECKING DATE COLUMN 

SELECT date, COUNT(date) FROM linkedin_2023_clean
GROUP BY date
ORDER BY 2;
             -- DATE IS IN STRING FORMAT 
             
-- STANDARDIZING DATE FORMAT

UPDATE linkedin_2023_clean
SET `date` = STR_TO_DATE(`date`, '%Y-%m-%d');

ALTER TABLE linkedin_2023_clean
MODIFY COLUMN `date` DATE;

-- CHECKING OUTLIERS

SELECT DISTINCT EXTRACT(YEAR FROM date) 
FROM linkedin_2023_clean;   -- NO OUTLIERS FOUND
         
SELECT DISTINCT EXTRACT(MONTH FROM date) 
FROM linkedin_2023_clean
ORDER BY 1;   -- NO OUTLIERS FOUND
         
SELECT DISTINCT EXTRACT(DAY FROM date) 
FROM linkedin_2023_clean
ORDER BY 1;   -- NO OUTLIERS FOUND

 -- -- ALL INCONSISTENICIES HAS BEEN REMOVED FROM DATE COLUMN
 
-- CHECKING COLUMN SENIORITY_LEVEL 

SELECT seniority_level, COUNT(seniority_level) FROM linkedin_2023_clean
GROUP BY seniority_level
ORDER BY 1;

-- REMOVING INCONSISTENCIES

UPDATE linkedin_2023_clean
SET seniority_level = TRIM(REPLACE(REPLACE(REPLACE(seniority_level, '\t', ''), '\n', ''), '\r', ''));

-- CHECKING BLANKS

SELECT seniority_level, COUNT(seniority_level) FROM linkedin_2023_clean
WHERE seniority_level = ''
GROUP BY seniority_level;
                         -- 1284 BLANKS FOUND
                         
-- UPDATING BLANKS AS NOT APPLICABLE 

UPDATE linkedin_2023
SET seniority_level = 'Not Applicable'
WHERE seniority_level = '';
                         -- ALL BLANKS HAS BEEN REMOVED 
                         
	-- -- ALL INCONSISTENICIES HAS BEEN REMOVED FROM SENIORITY LEVEL 
    
-- CHECKING COLUMN JOB FUNCTION 

SELECT job_function, COUNT(job_function) FROM linkedin_2023_clean
GROUP BY job_function
ORDER BY 1;

-- REMOVING INCONSISTENICIES 

UPDATE linkedin_2023_clean
SET job_function = TRIM(REPLACE(REPLACE(REPLACE(job_function, '\t', ''), '\n', ''), '\r', ''));

-- CHECKLING BLANKS 

SELECT job_function, COUNT(job_function) FROM linkedin_2023_clean
WHERE job_function = ''
GROUP BY job_function;
					-- 1566 BLANKS FOUND 
                    
-- DEALING WITH NULLS 

SELECT job_function, job_title FROM linkedin_2023_clean
WHERE job_function = '';

-- UPDATING BLANK JOB FUNCTION VALUES WITH JOB TITLE 

UPDATE linkedin_2023_clean
SET job_function = job_title
WHERE job_function = '';

     -- -- ALL INCONSISTENICIES HAS BEEN REMOVED FROM JOB FUNCTION 
     
-- CHECKING COLUMN EMPLOYMENT TYPE 

SELECT employment_type, COUNT(employment_type) FROM linkedin_2023_clean
GROUP BY employment_type;
     
-- REMOVING INCONSISTENCIES 

UPDATE linkedin_2023_clean
SET employment_type = TRIM(REPLACE(REPLACE(REPLACE(employment_type, '\t', ''), '\n', ''), '\r', ''));
 
-- STANDARDIZING EMPLOYMENT TYPE 

UPDATE linkedin_2023_clean
SET employment_type = 
CASE 
	WHEN employment_type LIKE '%Full-time%' THEN 'Full-time'
    WHEN employment_type LIKE '%Part-time%' THEN 'Part-time'
    WHEN employment_type LIKE '%Internship%' THEN 'Internship'
    WHEN employment_type LIKE '%Other%' THEN 'Other'
    WHEN employment_type LIKE '%Contract%' THEN 'Contract'
    ELSE employment_type
END;

-- CHECKING BLANKS 

SELECT employment_type FROM linkedin_2023_clean
WHERE employment_type = ''
GROUP BY employment_type;
						-- 1567 BLANKS FOUND

-- UPDATING BLANKS WITH 'NOT SPECIFIED'

UPDATE linkedin_2023_clean
SET employment_type = 'Not Specified'
WHERE employment_type = '';
						-- ALL BLANKS ARE UPDATED

     -- ALL INCONSISTENICIES HAS BEEN REMOVED FROM EMPLOYMENT TYPE
       
       -- CHECKING INDUSTRY COLUMN 

SELECT industry, COUNT(industry) FROM linkedin_2023_clean
GROUP BY industry
ORDER BY 1;
     
-- REMOVING INCONSISTENCIES 

UPDATE linkedin_2023_clean
SET industry = TRIM(REPLACE(REPLACE(REPLACE(industry, '\t', ''), '\n', ''), '\r', ''));

-- STANDARDIZING INDUSTRY 

UPDATE linkedin_2023_clean
SET industry = 
CASE 
	WHEN industry LIKE '%Advertising Services%' THEN 'Advertising Services'
    WHEN industry LIKE '%Appliances, Electrical, and Electronics Manufacturing%' THEN 'Electronics Manufacturing'
    WHEN industry LIKE '%Architecture and Planning%' THEN 'Architecture and Planning'
    WHEN industry LIKE '%Automation Machinery Manufacturing%' THEN 'Automation Machinery Manufacturing'
    WHEN industry LIKE '%Aviation & Aerospace%' THEN 'Aviation & Aerospace'
    WHEN industry LIKE '%Banking%' THEN 'Banking & Services'
    WHEN industry LIKE '%Biotechnology Research%' THEN 'Biotechnology Research'
    WHEN industry LIKE '%Book and Periodical Publishing%' THEN 'Book and Periodical Publishing'
    WHEN industry LIKE '%Broadcast Media Production and Distribution%' THEN 'Broadcast Media Production and Distribution'
    WHEN industry LIKE '%Business Consulting and Services%' THEN 'Business Consulting and Services'
    WHEN industry LIKE '%Capital Markets%' THEN 'Capital Markets'
    WHEN industry LIKE '%Chemical Manufacturing%' THEN 'Chemical Manufacturing'
    WHEN industry LIKE '%Civil Engineering%' THEN 'Civil Engineering'
    WHEN industry LIKE '%Computer and Network Security%' THEN 'Computer and Network Security'
    WHEN industry LIKE '%Computer Hardware Manufacturing%' THEN 'Computer Hardware Manufacturing'
    WHEN industry LIKE '%Computer Networking Products%' THEN 'Computer Networking Products' 
    WHEN industry LIKE '%Computers and Electronics Manufacturing%' THEN 'Computers and Electronics Manufacturing'
    WHEN industry LIKE '%Construction%' THEN 'Construction'
    WHEN industry LIKE '%Dairy Product Manufacturing and Farming%' THEN 'Dairy Product Manufacturing and Farming'
    WHEN industry LIKE '%Defense And Space%' THEN 'Defense And Space'
    WHEN industry LIKE '%Design Services%' THEN 'Design Services'
    WHEN industry LIKE '%E-learning%' THEN 'E-learning'
    WHEN industry LIKE '%Education%' THEN 'Education' 
    WHEN industry LIKE '%Entertainment%' THEN 'Entertainment' 
    WHEN industry LIKE '%Environmental Services%' THEN 'Environmental Services' 
    WHEN industry LIKE '%Facilities Services%' THEN 'Facilities Services'
    WHEN industry LIKE '%Financial Services%' THEN 'Financial Services'
    WHEN industry LIKE '%Food and Beverage Manufacturing%' THEN 'Food and Beverage Manufacturing'
    WHEN industry LIKE '%Food and Beverage Services%' THEN 'Food and Beverage Services'
    WHEN industry LIKE '%Furniture and Home Furnishings Manufacturing%' THEN 'Furniture and Home Furnishings Manufacturing'
    WHEN industry LIKE '%Government Administration%' THEN 'Government Administration'
    WHEN industry LIKE '%Government Relations Services%' THEN 'Government Relations Services'
    WHEN industry LIKE '%Higher Education%' THEN 'Higher Education'
    WHEN industry LIKE '%Hospitals and Health Care%' THEN 'Hospitals and Health Care'
    WHEN industry LIKE '%Human Resources%' THEN 'Human Resources'
    WHEN industry LIKE '%Individual and Family Services%' THEN 'Individual and Family Services'
    WHEN industry LIKE '%Industrial Machinery Manufacturing%' THEN 'Industrial Machinery Manufacturing'
    WHEN industry LIKE '%Information Services%' THEN 'Information Services'
    WHEN industry LIKE '%Insurance%' THEN 'Insurance' 
    WHEN industry = 'Investment Banking and Investment Management' THEN 'Investment Banking'
    WHEN industry LIKE '%IT Services and IT Consulting%' THEN 'IT Services and IT Consulting'
    WHEN industry LIKE '%Law Practice%' THEN 'Law Practice'
    WHEN industry LIKE '%Leasing Non-residential Real Estate%' THEN 'Leasing Non-residential Real Estate'
    WHEN industry LIKE '%Legal Services%' THEN 'Legal Services'
    WHEN industry LIKE '%Machinery Manufacturing%' THEN 'Machinery Manufacturing' 
    WHEN industry LIKE 'Manufacturing%' THEN 'Manufacturing'
    WHEN industry LIKE '%Market Research%' THEN 'Market Research' 
    WHEN industry LIKE '%Medical Equipment Manufacturing%' THEN 'Medical Equipment Manufacturing'
    WHEN industry LIKE '%Mental Health Care%' THEN 'Mental Health Care' 
    WHEN industry LIKE '%Metal Treatments%' THEN 'Metal Treatments' 
    WHEN industry LIKE '%Mining%' THEN 'Mining' 
    WHEN industry LIKE '%Motor Vehicle%' THEN 'Motor Vehicle Manufacturing'
    WHEN industry LIKE '%Newspaper Publishing%' THEN 'Newspaper Publishing'
    WHEN industry LIKE '%Non-profit Organization%' THEN 'Non-profit Organization'
    WHEN industry LIKE '%Oil and Gas%' THEN 'Oil and Gas' 
    WHEN industry LIKE '%Online Audio and Video Media%' THEN 'Online Audio and Video Media' 
    WHEN industry LIKE '%Outsourcing/Offshoring%' THEN 'Outsourcing and Offshoring Consulting'
    WHEN industry LIKE '%Packaging & Containers%' THEN 'Packaging & Containers' 
    WHEN industry LIKE '%Personal Care Product Manufacturing%' THEN 'Personal Care Product Manufacturing' 
    WHEN industry LIKE '%Philanthropic Fundraising Services%' THEN 'Philanthropic Fundraising Services'
    WHEN industry LIKE '%Plastics Manufacturing%' THEN 'Plastics Manufacturing' 
    WHEN industry LIKE '%Primary and Secondary Education%' THEN 'Primary and Secondary Education' 
    WHEN industry LIKE '%Printing Services%' THEN 'Printing Services' 
    WHEN industry LIKE '%Professional Training and Coaching%' THEN 'Professional Training and Coaching' 
    WHEN industry LIKE '%Public Relations and Communications Services%' THEN 'Public Relations and Communications Services'
    WHEN industry LIKE '%Renewable Energy Semiconductor Manufacturing%' THEN 'Renewable Energy Semiconductor Manufacturing'
    WHEN industry LIKE '%Research%' THEN 'Research Services'
    WHEN industry LIKE '%Restaurants%' THEN 'Restaurants'
    WHEN industry LIKE '%Retail Apparel and Fashion%' THEN 'Retail Apparel and Fashion' 
    WHEN industry LIKE '%Software Development%' THEN 'Software Development'
    WHEN industry LIKE '%Spectator Sports%' THEN 'Spectator Sports' 
    WHEN industry LIKE '%Sporting Goods%' THEN 'Sporting Goods' 
    WHEN industry LIKE '%Staffing and Recruiting%' THEN 'Staffing and Recruiting'
    WHEN industry LIKE '%Technology, Information and Internet%' THEN 'Technology, Information and Internet'
    WHEN industry LIKE '%Transportation, Logistics, Supply Chain and Storage%' THEN 'Transportation, Logistics, Supply Chain and Storage' 
    WHEN industry LIKE '%Travel Arrangements%' THEN 'Travel Arrangements' 
    WHEN industry LIKE '%Venture Capital and Private Equity Principals%' THEN 'Venture Capital and Private Equity Principals'
    WHEN industry LIKE '%Wellness and Fitness Services%' THEN 'Wellness and Fitness Services' 
    WHEN industry LIKE '%Wholesale Building Materials%' THEN 'Wholesale Building Materials' 
    WHEN industry LIKE '%Wireless Services%' THEN 'Wireless Services' 
    WHEN industry LIKE 'Writing and Editing%' THEN 'Writing and Editing' 
    ELSE industry 
END;

-- CHECKING BLANK VALUES 

SELECT industry, COUNT(industry) FROM linkedin_2023_clean
WHERE industry = ''
GROUP BY industry;
				-- 1987 BLANK VALUES FOUND 
                
-- UPDATING BLANK VALUES 

UPDATE linkedin_2023_clean
SET industry = 'Not specified'
WHERE industry = '';
				-- ALL BLANKS REPLACED 
                
-- ALL INCONSISTENICIES HAS BEEN REMOVED FROM INDUSTRY

-- CHECKING DUPLICATES IN DATA

WITH Duplicate_ AS
(
SELECT * , 
ROW_NUMBER () OVER
(PARTITION BY job_title , job_function, company_name, city, state, country , hiring_status, `date`, seniority_level, employment_type, industry) AS row_num
FROM linkedin_2023_clean
) 
SELECT * FROM Duplicate_
WHERE row_num > 1;
			-- 11135 DUPLICATE RECORDS FOUND
            
-- REMOVING DUPLICATE DATA

CREATE TABLE `linkedin_2023_cleaned` (
  `job_title` text,
  `company_name` text,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `location` text,
  `hiring_status` text,
  `date` date DEFAULT NULL,
  `seniority_level` text,
  `job_function` text,
  `employment_type` text,
  `industry` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO linkedin_2023_cleaned
SELECT * , 
ROW_NUMBER () OVER
(PARTITION BY job_title , job_function, company_name, city, state, country , hiring_status, `date`, seniority_level, employment_type, industry) AS row_num
FROM linkedin_2023_clean;

DELETE FROM linkedin_2023_cleaned
WHERE row_num > 1;
			   -- 11135 RECORDS DELETED 

-- REMOVING UNNECESSARY COLUMNS 

ALTER TABLE linkedin_2023_cleaned
DROP COLUMN location,
DROP COLUMN row_num;
               
-- A LOOK INTO CLEANED DATASET 

SELECT * FROM linkedin_2023_cleaned;
            


            
            
            
            
            
            
            
            
            
            
               
