show databases;
use chinook;
show tables;

USE Chinook;

-- show table structure 
DESCRIBE Invoice;
DESCRIBE InvoiceLine;
DESCRIBE Track;
DESCRIBE Album;
DESCRIBE Artist;
DESCRIBE Customer;

-- quick counts & samples
SELECT COUNT(*) AS invoices_count FROM Invoice;
SELECT COUNT(*) AS invoice_lines_count FROM InvoiceLine;
SELECT * FROM Invoice LIMIT 5;
SELECT * FROM InvoiceLine LIMIT 5;
SELECT * FROM Track LIMIT 5;

   -- Top Selling Products(Albums)
   -- This query finds the most sold tracks by revenue and quantity
SELECT
  t.TrackId,
  t.Name AS TrackName,
  a.Title AS Album,
  ar.Name AS Artist,
  SUM(il.UnitPrice * il.Quantity) AS Revenue,
  SUM(il.Quantity) AS UnitsSold
FROM InvoiceLine il
JOIN Track t       ON il.TrackId = t.TrackId
LEFT JOIN Album a  ON t.AlbumId = a.AlbumId
LEFT JOIN Artist ar ON a.ArtistId = ar.ArtistId
JOIN Invoice i     ON il.InvoiceId = i.InvoiceId
GROUP BY t.TrackId, t.Name, a.Title, ar.Name
ORDER BY Revenue DESC
LIMIT 20;


-- Revenue per regoin
-- This query shows the amount of revenue per country
SELECT
  i.BillingCountry AS Country,
  COUNT(DISTINCT i.CustomerId) AS NumCustomers,
  SUM(i.Total) AS InvoiceTotalSum,
  SUM(il.UnitPrice * il.Quantity) AS LineRevenue
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY i.BillingCountry
ORDER BY LineRevenue DESC;

SELECT
  DATE_FORMAT(i.InvoiceDate, '%Y-%m') AS YearMonth,
  SUM(il.UnitPrice * il.Quantity) AS Revenue,
  SUM(il.Quantity) AS UnitsSold
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY YearMonth
ORDER BY YearMonth;


-- Top artists that had the highest sales 
SELECT
  ar.Name AS Artist,
  a.Title AS Album,
  t.Name AS Track,
  SUM(il.UnitPrice * il.Quantity) AS Revenue
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album a ON t.AlbumId = a.AlbumId
JOIN Artist ar ON a.ArtistId = ar.ArtistId
GROUP BY ar.Name, a.Title, t.Name
ORDER BY Revenue DESC
LIMIT 10;

SELECT * FROM (
    SELECT 
        i.BillingCountry AS Country,
        t.TrackId,
        t.Name AS TrackName,
        SUM(il.UnitPrice * il.Quantity) AS Revenue
    FROM InvoiceLine il
    JOIN Invoice i ON il.InvoiceId = i.InvoiceId
    JOIN Track t ON il.TrackId = t.TrackId
    GROUP BY i.BillingCountry, t.TrackId, t.Name
) AS track_country_revenue;



-- Bonus Task;using a window function to rank customers based on their total spending
-- This query calculates the total amount EACH customer has spent 
-- and assigns ranks using the RANK() window function
SELECT 
    c.FirstName,
    c.LastName,
    SUM(i.Total) AS TotalSpent,
    RANK() OVER (ORDER BY SUM(i.Total) DESC) AS SpendingRank
FROM Customer c
JOIN Invoice i 
    ON c.CustomerId = i.CustomerId
GROUP BY c.CustomerId, c.FirstName, c.LastName
ORDER BY SpendingRank;



