
-- 1. Customers from USA, Canada, UK, Brazil
SELECT * FROM Customer WHERE Country IN ('USA', 'Canada', 'UK', 'Brazil');

-- 2. Tracks in genres Rock, Jazz, or Pop
SELECT Track.* FROM Track JOIN Genre ON Track.GenreId = Genre.GenreId WHERE Genre.Name IN ('Rock', 'Jazz', 'Pop');

-- 3. Invoices for CustomerId 5, 8, 15, 20
SELECT * FROM Invoice WHERE CustomerId IN (5, 8, 15, 20);

-- 4. Earliest invoice date
SELECT MIN(InvoiceDate) AS EarliestInvoiceDate FROM Invoice;

-- 5. Latest invoice date
SELECT MAX(InvoiceDate) AS LatestInvoiceDate FROM Invoice;

-- 6. Customer who spent the most
SELECT CustomerId, SUM(Total) AS TotalSpent FROM Invoice GROUP BY CustomerId ORDER BY TotalSpent DESC LIMIT 1;

-- 7. Invoice amount classification
SELECT InvoiceId, Total,
  CASE
    WHEN Total > 20 THEN 'High'
    WHEN Total BETWEEN 10 AND 20 THEN 'Medium'
    ELSE 'Low'
  END AS AmountCategory
FROM Invoice;

-- 8. Customer type classification
SELECT CustomerId, FirstName, LastName, Country,
  CASE
    WHEN Country = 'USA' THEN 'Domestic'
    ELSE 'International'
  END AS CustomerType
FROM Customer;

-- 9. Track length classification
SELECT TrackId, Name, Milliseconds,
  CASE
    WHEN Milliseconds / 60000.0 < 3 THEN 'Short'
    ELSE 'Long'
  END AS DurationCategory
FROM Track;

-- 10. Album track count and size
SELECT Album.AlbumId, Album.Title, COUNT(Track.TrackId) AS TotalTracks,
  CASE
    WHEN COUNT(Track.TrackId) > 10 THEN 'Large Album'
    ELSE 'Small Album'
  END AS AlbumSize
FROM Album
JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Album.AlbumId, Album.Title;

-- 11. Top 5 customers by total spend
SELECT CustomerId, FirstName || ' ' || LastName AS FullName, SUM(Total) AS TotalSpent
FROM Invoice JOIN Customer USING(CustomerId)
GROUP BY CustomerId
ORDER BY TotalSpent DESC
LIMIT 5;

-- 12. Employees and their managers
SELECT e.FirstName || ' ' || e.LastName AS Employee, m.FirstName || ' ' || m.LastName AS Manager
FROM Employee e
LEFT JOIN Employee m ON e.ReportsTo = m.EmployeeId;

-- 13. Customers who ordered in 2009
SELECT DISTINCT c.CustomerId, c.FirstName || ' ' || c.LastName AS Name
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE strftime('%Y', i.InvoiceDate) = '2009';

-- 14. Albums with more than 10 tracks
SELECT Album.Title, COUNT(Track.TrackId) AS TrackCount
FROM Album
JOIN Track ON Album.AlbumId = Track.AlbumId
GROUP BY Album.AlbumId
HAVING COUNT(Track.TrackId) > 10;

-- 15. Employees hired after 2005
SELECT FirstName || ' ' || LastName AS Name, HireDate
FROM Employee
WHERE strftime('%Y', HireDate) > '2005';

-- 16. Most popular genre
SELECT Genre.Name, COUNT(Track.TrackId) AS TrackCount
FROM Genre
JOIN Track ON Genre.GenreId = Track.GenreId
GROUP BY Genre.GenreId
ORDER BY TrackCount DESC
LIMIT 1;

-- 17. Invoices with above-average total
SELECT InvoiceId, Total
FROM Invoice
WHERE Total > (SELECT AVG(Total) FROM Invoice);

-- 18. Tracks longer than average
SELECT Name, Milliseconds / 60000.0 AS Minutes
FROM Track
WHERE Milliseconds > (SELECT AVG(Milliseconds) FROM Track)
ORDER BY Minutes DESC;

-- 19. Customer with most invoices
SELECT CustomerId, COUNT(*) AS InvoiceCount
FROM Invoice
GROUP BY CustomerId
ORDER BY InvoiceCount DESC
LIMIT 1;

-- 20. Track with album and artist
SELECT t.Name AS TrackName, al.Title AS AlbumTitle, ar.Name AS ArtistName
FROM Track t
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId;
