CREATE DATABASE InvestmentBanking;
GO

USE InvestmentBanking;
GO

-- Clients Table
CREATE TABLE Clients (
    ClientID INT PRIMARY KEY IDENTITY(1,1),
    ClientName NVARCHAR(100) NOT NULL,
    ClientType NVARCHAR(50) CHECK (ClientType IN ('Individual', 'Corporate', 'Institutional')),
    RiskProfile NVARCHAR(20) CHECK (RiskProfile IN ('Conservative', 'Moderate', 'Aggressive')),
    TotalAssets DECIMAL(18,2),
    ContactEmail NVARCHAR(100),
    DateAdded DATE DEFAULT GETDATE()
);
select * from clients

-- Securities Table
CREATE TABLE Securities (
    SecurityID INT PRIMARY KEY IDENTITY(1,1),
    Symbol NVARCHAR(20) NOT NULL UNIQUE,
    SecurityName NVARCHAR(100) NOT NULL,
    SecurityType NVARCHAR(50) CHECK (SecurityType IN ('Stock', 'Bond', 'Derivative', 'ETF', 'Commodity')),
    CurrentPrice DECIMAL(18,2) NOT NULL,
    Currency NVARCHAR(10) DEFAULT 'USD',
    Sector NVARCHAR(50),
    RiskRating INT CHECK (RiskRating BETWEEN 1 AND 10)
);
select * from securities

-- Transactions Table
CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    SecurityID INT FOREIGN KEY REFERENCES Securities(SecurityID),
    TransactionType NVARCHAR(10) CHECK (TransactionType IN ('Buy', 'Sell')),
    Quantity DECIMAL(18,4) NOT NULL,
    Price DECIMAL(18,2) NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    SettlementDate DATE,
    Commission DECIMAL(18,2) DEFAULT 0,
    Status NVARCHAR(20) DEFAULT 'Pending' CHECK (Status IN ('Pending', 'Completed', 'Cancelled'))
);
select * from Transactions

-- Portfolio Table
CREATE TABLE Portfolio (
    PortfolioID INT PRIMARY KEY IDENTITY(1,1),
    ClientID INT FOREIGN KEY REFERENCES Clients(ClientID),
    SecurityID INT FOREIGN KEY REFERENCES Securities(SecurityID),
    Quantity DECIMAL(18,4) NOT NULL,
    AverageCost DECIMAL(18,2) NOT NULL,
    CurrentValue DECIMAL(18,2),
    LastUpdated DATETIME DEFAULT GETDATE()
);
select * from Portfolio

-- ResearchReports Table
CREATE TABLE ResearchReports (
    ReportID INT PRIMARY KEY IDENTITY(1,1),
    SecurityID INT FOREIGN KEY REFERENCES Securities(SecurityID),
    AnalystName NVARCHAR(100),
    ReportDate DATE DEFAULT GETDATE(),
    Recommendation NVARCHAR(20) CHECK (Recommendation IN ('Buy', 'Sell', 'Hold', 'Strong Buy', 'Strong Sell')),
    TargetPrice DECIMAL(18,2),
    RiskAssessment NVARCHAR(50)
);
select * from ResearchReports
-- MarketData Table
CREATE TABLE MarketData (
    DataID INT PRIMARY KEY IDENTITY(1,1),
    SecurityID INT FOREIGN KEY REFERENCES Securities(SecurityID),
    PriceDate DATE NOT NULL,
    OpenPrice DECIMAL(18,2),
    HighPrice DECIMAL(18,2),
    LowPrice DECIMAL(18,2),
    ClosePrice DECIMAL(18,2),
    Volume BIGINT,
    CreatedDate DATETIME DEFAULT GETDATE()
);
select * from MarketData

-- Insert sample clients
INSERT INTO Clients (ClientName, ClientType, RiskProfile, TotalAssets, ContactEmail) VALUES
('John Smith', 'Individual', 'Moderate', 500000.00, 'john.smith@email.com'),
('ABC Corporation', 'Corporate', 'Conservative', 2500000.00, 'treasury@abccorp.com'),
('XYZ Investment Fund', 'Institutional', 'Aggressive', 10000000.00, 'manager@xyzfund.com'),
('Jane Doe', 'Individual', 'Aggressive', 750000.00, 'jane.doe@email.com'),
('Global Manufacturers Inc', 'Corporate', 'Moderate', 5000000.00, 'investments@globalmfg.com'),
('Sarah Johnson', 'Individual', 'Conservative', 300000.00, 'sarahj@email.com'),
('Tech Growth Fund', 'Institutional', 'Aggressive', 15000000.00, 'contact@techgrowth.com'),
('City Bank', 'Corporate', 'Conservative', 20000000.00, 'investments@citybank.com'),
('Michael Brown', 'Individual', 'Moderate', 450000.00, 'm.brown@email.com'),
('Stable Returns Fund', 'Institutional', 'Conservative', 8000000.00, 'info@stablereturns.com');



-- Insert sample securities
INSERT INTO Securities (Symbol, SecurityName, SecurityType, CurrentPrice, Currency, Sector, RiskRating) VALUES
('AAPL', 'Apple Inc', 'Stock', 150.25, 'USD', 'Technology', 6),
('MSFT', 'Microsoft Corporation', 'Stock', 289.50, 'USD', 'Technology', 5),
('GOOGL', 'Alphabet Inc', 'Stock', 2678.30, 'USD', 'Technology', 7),
('TSLA', 'Tesla Inc', 'Stock', 850.75, 'USD', 'Automotive', 9),
('JPM', 'JPMorgan Chase & Co', 'Stock', 135.40, 'USD', 'Financial Services', 4),
('GS', 'Goldman Sachs Group Inc', 'Stock', 345.60, 'USD', 'Financial Services', 5),
('US10Y', 'US 10-Year Treasury Note', 'Bond', 98.75, 'USD', 'Government', 2),
('GLD', 'SPDR Gold Trust', 'ETF', 170.25, 'USD', 'Commodities', 3),
('AMZN', 'Amazon.com Inc', 'Stock', 3200.00, 'USD', 'E-Commerce', 7),
('NVDA', 'NVIDIA Corporation', 'Stock', 220.50, 'USD', 'Technology', 8);


-- Insert sample transactions
INSERT INTO Transactions (ClientID, SecurityID, TransactionType, Quantity, Price, TransactionDate, SettlementDate, Commission, Status) VALUES
(1, 1, 'Buy', 10, 148.50, '2023-01-15', '2023-01-17', 9.99, 'Completed'),
(2, 5, 'Buy', 100, 132.75, '2023-01-16', '2023-01-18', 29.99, 'Completed'),
(3, 3, 'Buy', 5, 2650.00, '2023-01-17', '2023-01-19', 49.99, 'Completed'),
(4, 4, 'Buy', 15, 840.25, '2023-01-18', '2023-01-20', 14.99, 'Completed'),
(5, 7, 'Buy', 1000, 98.50, '2023-01-19', '2023-01-23', 0, 'Completed'),
(1, 2, 'Buy', 5, 285.75, '2023-02-01', '2023-02-03', 9.99, 'Completed'),
(6, 9, 'Buy', 2, 3150.00, '2023-02-02', '2023-02-06', 9.99, 'Completed'),
(7, 10, 'Buy', 50, 215.25, '2023-02-03', '2023-02-07', 24.99, 'Completed'),
(8, 6, 'Buy', 200, 340.75, '2023-02-04', '2023-02-08', 39.99, 'Completed'),
(9, 8, 'Buy', 25, 168.50, '2023-02-05', '2023-02-09', 12.99, 'Completed');

-- Insert sample portfolio data
INSERT INTO Portfolio (ClientID, SecurityID, Quantity, AverageCost, CurrentValue, LastUpdated) VALUES
(1, 1, 10, 148.50, 1502.50, GETDATE()),
(1, 2, 5, 285.75, 1447.50, GETDATE()),
(2, 5, 100, 132.75, 13540.00, GETDATE()),
(3, 3, 5, 2650.00, 13391.50, GETDATE()),
(4, 4, 15, 840.25, 12761.25, GETDATE()),
(5, 7, 1000, 98.50, 98750.00, GETDATE()),
(6, 9, 2, 3150.00, 6400.00, GETDATE()),
(7, 10, 50, 215.25, 11025.00, GETDATE()),
(8, 6, 200, 340.75, 69120.00, GETDATE()),
(9, 8, 25, 168.50, 4256.25, GETDATE());

-- Insert research reports
INSERT INTO ResearchReports (SecurityID, AnalystName, ReportDate, Recommendation, TargetPrice, RiskAssessment) VALUES
(1, 'John Analyst', '2023-01-10', 'Buy', 165.00, 'Moderate'),
(2, 'Jane Researcher', '2023-01-11', 'Strong Buy', 310.00, 'Low'),
(3, 'Mike Strategist', '2023-01-12', 'Hold', 2700.00, 'High'),
(4, 'Sarah Economist', '2023-01-13', 'Sell', 750.00, 'Very High'),
(5, 'David Advisor', '2023-01-14', 'Buy', 145.00, 'Low'),
(6, 'Emily Analyst', '2023-01-15', 'Strong Buy', 375.00, 'Moderate'),
(7, 'Robert Researcher', '2023-01-16', 'Hold', 99.00, 'Very Low'),
(8, 'Jennifer Strategist', '2023-01-17', 'Buy', 180.00, 'Low'),
(9, 'Thomas Economist', '2023-01-18', 'Strong Buy', 3400.00, 'High'),
(10, 'Lisa Advisor', '2023-01-19', 'Buy', 250.00, 'Moderate');

-- Insert sample clients
INSERT INTO Clients (ClientName, ClientType, RiskProfile, TotalAssets, ContactEmail) VALUES
('John Smith', 'Individual', 'Moderate', 500000.00, 'john.smith@email.com'),
('ABC Corporation', 'Corporate', 'Conservative', 2500000.00, 'treasury@abccorp.com'),
('XYZ Investment Fund', 'Institutional', 'Aggressive', 10000000.00, 'manager@xyzfund.com'),
('Jane Doe', 'Individual', 'Aggressive', 750000.00, 'jane.doe@email.com'),
('Global Manufacturers Inc', 'Corporate', 'Moderate', 5000000.00, 'investments@globalmfg.com'),
('Sarah Johnson', 'Individual', 'Conservative', 300000.00, 'sarahj@email.com'),
('Tech Growth Fund', 'Institutional', 'Aggressive', 15000000.00, 'contact@techgrowth.com'),
('City Bank', 'Corporate', 'Conservative', 20000000.00, 'investments@citybank.com'),
('Michael Brown', 'Individual', 'Moderate', 450000.00, 'm.brown@email.com'),
('Stable Returns Fund', 'Institutional', 'Conservative', 8000000.00, 'info@stablereturns.com');
select * from clients

-- Insert sample securities
INSERT INTO Securities (Symbol, SecurityName, SecurityType, CurrentPrice, Currency, Sector, RiskRating) VALUES
('AAPL', 'Apple Inc', 'Stock', 150.25, 'USD', 'Technology', 6),
('MSFT', 'Microsoft Corporation', 'Stock', 289.50, 'USD', 'Technology', 5),
('GOOGL', 'Alphabet Inc', 'Stock', 2678.30, 'USD', 'Technology', 7),
('TSLA', 'Tesla Inc', 'Stock', 850.75, 'USD', 'Automotive', 9),
('JPM', 'JPMorgan Chase & Co', 'Stock', 135.40, 'USD', 'Financial Services', 4),
('GS', 'Goldman Sachs Group Inc', 'Stock', 345.60, 'USD', 'Financial Services', 5),
('US10Y', 'US 10-Year Treasury Note', 'Bond', 98.75, 'USD', 'Government', 2),
('GLD', 'SPDR Gold Trust', 'ETF', 170.25, 'USD', 'Commodities', 3),
('AMZN', 'Amazon.com Inc', 'Stock', 3200.00, 'USD', 'E-Commerce', 7),
('NVDA', 'NVIDIA Corporation', 'Stock', 220.50, 'USD', 'Technology', 8);


select * from Securities

-- Insert sample transactions
INSERT INTO Transactions (ClientID, SecurityID, TransactionType, Quantity, Price, TransactionDate, SettlementDate, Commission, Status) VALUES
(1, 1, 'Buy', 10, 148.50, '2023-01-15', '2023-01-17', 9.99, 'Completed'),
(2, 5, 'Buy', 100, 132.75, '2023-01-16', '2023-01-18', 29.99, 'Completed'),
(3, 3, 'Buy', 5, 2650.00, '2023-01-17', '2023-01-19', 49.99, 'Completed'),
(4, 4, 'Buy', 15, 840.25, '2023-01-18', '2023-01-20', 14.99, 'Completed'),
(5, 7, 'Buy', 1000, 98.50, '2023-01-19', '2023-01-23', 0, 'Completed'),
(1, 2, 'Buy', 5, 285.75, '2023-02-01', '2023-02-03', 9.99, 'Completed'),
(6, 9, 'Buy', 2, 3150.00, '2023-02-02', '2023-02-06', 9.99, 'Completed'),
(7, 10, 'Buy', 50, 215.25, '2023-02-03', '2023-02-07', 24.99, 'Completed'),
(8, 6, 'Buy', 200, 340.75, '2023-02-04', '2023-02-08', 39.99, 'Completed'),
(9, 8, 'Buy', 25, 168.50, '2023-02-05', '2023-02-09', 12.99, 'Completed');

-- Insert sample portfolio data
INSERT INTO Portfolio (ClientID, SecurityID, Quantity, AverageCost, CurrentValue, LastUpdated) VALUES
(1, 1, 10, 148.50, 1502.50, GETDATE()),
(1, 2, 5, 285.75, 1447.50, GETDATE()),
(2, 5, 100, 132.75, 13540.00, GETDATE()),
(3, 3, 5, 2650.00, 13391.50, GETDATE()),
(4, 4, 15, 840.25, 12761.25, GETDATE()),
(5, 7, 1000, 98.50, 98750.00, GETDATE()),
(6, 9, 2, 3150.00, 6400.00, GETDATE()),
(7, 10, 50, 215.25, 11025.00, GETDATE()),
(8, 6, 200, 340.75, 69120.00, GETDATE()),
(9, 8, 25, 168.50, 4256.25, GETDATE());

-- Insert research reports
INSERT INTO ResearchReports (SecurityID, AnalystName, ReportDate, Recommendation, TargetPrice, RiskAssessment) VALUES
(1, 'John Analyst', '2023-01-10', 'Buy', 165.00, 'Moderate'),
(2, 'Jane Researcher', '2023-01-11', 'Strong Buy', 310.00, 'Low'),
(3, 'Mike Strategist', '2023-01-12', 'Hold', 2700.00, 'High'),
(4, 'Sarah Economist', '2023-01-13', 'Sell', 750.00, 'Very High'),
(5, 'David Advisor', '2023-01-14', 'Buy', 145.00, 'Low'),
(6, 'Emily Analyst', '2023-01-15', 'Strong Buy', 375.00, 'Moderate'),
(7, 'Robert Researcher', '2023-01-16', 'Hold', 99.00, 'Very Low'),
(8, 'Jennifer Strategist', '2023-01-17', 'Buy', 180.00, 'Low'),
(9, 'Thomas Economist', '2023-01-18', 'Strong Buy', 3400.00, 'High'),
(10, 'Lisa Advisor', '2023-01-19', 'Buy', 250.00, 'Moderate');

-- Insert market data
INSERT INTO MarketData (SecurityID, PriceDate, OpenPrice, HighPrice, LowPrice, ClosePrice, Volume) VALUES
(1, '2023-03-01', 149.50, 151.25, 148.75, 150.25, 12500000),
(1, '2023-03-02', 150.50, 152.00, 149.25, 151.75, 11800000),
(2, '2023-03-01', 288.75, 291.50, 287.25, 289.50, 8500000),
(2, '2023-03-02', 290.25, 293.75, 289.50, 292.25, 9200000),
(3, '2023-03-01', 2665.00, 2690.25, 2655.75, 2678.30, 2100000),
(3, '2023-03-02', 2685.50, 2710.75, 2675.25, 2702.50, 1950000),
(4, '2023-03-01', 845.50, 865.25, 840.75, 850.75, 9800000),
(4, '2023-03-02', 855.25, 875.50, 850.25, 865.75, 10200000),
(5, '2023-03-01', 134.75, 136.25, 133.50, 135.40, 7500000),
(5, '2023-03-02', 135.75, 137.50, 134.25, 136.75, 7200000);



--Here are the list of Questions to work with the above data in SQL for Analysi


-- Client Portfolio Summary View
CREATE VIEW ClientPortfolioSummary AS
SELECT
    c.ClientID,
    c.ClientName,
    c.ClientType,
    COUNT(p.SecurityID) AS NumberOfHoldings,
    SUM(p.CurrentValue) AS PortfolioValue,
    AVG(s.RiskRating) AS AverageRiskRating
FROM Clients c
JOIN Portfolio p ON c.ClientID = p.ClientID
JOIN Securities s ON p.SecurityID = s.SecurityID
GROUP BY c.ClientID, c.ClientName, c.ClientType;


select * from ClientPortfolioSummary


-- Top Performing Securities View
CREATE VIEW TopPerformingSecurities AS
SELECT
    s.SecurityID,
    s.Symbol,
    s.SecurityName,
    s.SecurityType,
    m.ClosePrice AS CurrentPrice,
    (m.ClosePrice - m.OpenPrice) / m.OpenPrice * 100 AS DailyChangePercent,
    m.Volume
FROM Securities s
JOIN MarketData m ON s.SecurityID = m.SecurityID
WHERE m.PriceDate = (SELECT MAX(PriceDate) FROM MarketData)
ORDER BY DailyChangePercent DESC;

--1. Transaction Summary View
select * from Transactions
--solution

create view  Transactionviewsummary as
select distinct  t.securityid,c.ClientID,TransactionID, c.clientname,
t.TransactionType,t.Price,
t.Quantity,t.Commission,t.Status
from Clients c
join Transactions t
on c.ClientID=t.ClientID
order by t.SecurityID


select * from Transactionviewsummary
where transactionid is not null

--2. List all clients with their total assets in descending order.
select * from Clients
---solution

select ClientID,ClientName,TotalAssets 
from Clients
order by TotalAssets desc


--3. Show all securities in the Technology sector.
select * from Securities
--solution

select * from Securities
where Sector= 'Technology'

--4. Find all completed buy transactions.
select * from Transactions
select * from Clients
---solution

select TransactionID, TransactionType,Status from Transactions
--or

select c.ClientName,t.TransactionDate,t.Status,t.TransactionType
from  Transactions t left join Clients c
on t.ClientID=c.ClientID
where status='completed' and transactiontype='buy'


--5. Calculate the total commission earned from all transactions.
select * from Transactions
--solution 

select  SUM(commission) commission_earned 
from Transactions


--6. Show each client's portfolio value and number of holdings.
select * from Clients
select * from Portfolio
select * from ResearchReports
---solution

SELECT
    c.ClientID,
    c.ClientName,
    c.ClientType,
    COUNT(p.SecurityID) AS NumberOfHoldings,
    SUM(p.CurrentValue) AS PortfolioValue,
    AVG(s.RiskRating) AS AverageRiskRating
FROM Clients c
JOIN Portfolio p ON c.ClientID = p.ClientID
JOIN Securities s ON p.SecurityID = s.SecurityID
GROUP BY c.ClientID, c.ClientName, c.ClientType;




SELECT * FROM ClientPortfolioSummary;

--7. Find securities with a current price above their target price in research reports.
select * from Securities
select * from ResearchReports
select * from Clients
---solution

select s.SecurityName,s.SecurityType,s.CurrentPrice,r.TargetPrice
from  Securities s 
left join ResearchReports r
on s.SecurityID=r.SecurityID
where s.CurrentPrice>r.TargetPrice


--8. Show the daily price change percentage for each security.
select * from MarketData
select * from Securities
--solution
SELECT
    s.SecurityID,
    s.Symbol,
    s.SecurityName,
    s.SecurityType,
    m.ClosePrice AS CurrentPrice,
    (m.ClosePrice - m.OpenPrice) / m.OpenPrice * 100 AS DailyChangePercent,
    m.Volume
FROM Securities s
JOIN MarketData m ON s.SecurityID = m.SecurityID
ORDER BY DailyChangePercent DESC

--9. List clients who have both conservative risk profile and holdings with high risk rating (?7).
select * from Clients
select * from Securities
select * from Portfolio
 
--solution
select   c.ClientID,s.SecurityID,c.ClientName,RiskProfile,s.RiskRating 
from Clients c
left join Portfolio p
on c.ClientID= p.ClientID
left join Securities s
on p.SecurityID=s.SecurityID
where c.RiskProfile='conservative' and s.RiskRating>='7'


--10. Calculate the unrealized gain/loss for each position in client portfolios.
select * from clients
select * from Portfolio
select * from Securities
select * from marketdata
--solution
select c.ClientID, c.ClientName,s.Symbol, p.Quantity,p.AverageCost,s.CurrentPrice,
    (s.CurrentPrice - p.AverageCost) * p.Quantity  Unrealizedgain_loss
FROM Portfolio p
left join Clients c on p.ClientID = c.ClientID
left join Securities s ON p.SecurityID = s.SecurityID



--11. Create a ranked list of securities by trading volume.
select * from Securities
select * from MarketData
--solution
--use
with  ranked_list_of_securities
AS
( 
select  s.securityid,m.volume, sum(m.volume)  sum_volume,rank() over( order by m.volume desc) ranked_list
from Securities s
join MarketData m
on s.SecurityID=m.SecurityID
group by s.SecurityID,m.Volume
 
)
select s.securityid,s.securitytype,r.sum_volume,r.ranked_list
from Securities s join ranked_list_of_securities r
on s.SecurityID =r.securityid

--or


select s.SecurityID,SecurityName,s.SecurityType,m.Volume,dense_rank() over(order by m.volume desc) rank_securities
from Securities s
join MarketData m
on s.SecurityID=m.SecurityID
where m.Volume is not null
order by rank_securities 


--12. Create a stored procedure to add a new transaction and update the portfolio.--execute the above Procedure

select * from Clients
select * from Transactions

create procedure transaction_data
as
begin
select c.ClientName,t.TransactionID,t.TransactionDate,t.Commission,t.Status from Clients c
join Transactions t
on c.ClientID=t.ClientID
order by t.TransactionID
end

--13. Calculate the moving average of closing prices for each security.
select * from clients
select * from securities
select * from marketdata
---solution
select s.securityid,s.securitytype,s.SecurityName,m.closeprice,m.pricedate, avg(m.closeprice) over(partition by s.securityid order by m.priceDate)  movingavg_clossingprice
from securities s
 join marketdata m
on s.securityid=m.securityid

group by s.securityid,s.securitytype,s.SecurityName,m.closeprice,m.pricedate
order by s.securityid

--14. Identify clients with the most diversified portfolios.
select * from clients
select * from portfolio
select * from Securities
----solution
with diversified_portofolio
as
(
select c.ClientID, c.ClientName,count(DISTINCT p.SecurityID) as Numof_Securities
from Clients c
  join Portfolio p 
 on c.ClientID = p.ClientID
group by c.ClientID, c.ClientName
)
select c.ClientID,c.ClientName ,d.numof_Securities from Clients c
join diversified_portofolio d
on c.ClientID= d.clientid
order by Numof_Securities desc






  


