USE Bandas;
--CONSulta de cuantas bandas hay en el sistema
SELECT COUNT(*) AS TotalBandas FROM Bandas;
SELECT * FROM Bandas;
--prueba pa ver si funciona links
SELECT Titulo, LinkYoutube, LinkSpotify FROM Exitos WHERE BandaID = 1;
--Cuales son las bandas que tocan mas generos
SELECT TOP 5
    b.Nombre AS Banda,
    COUNT(bg.GeneroID) AS CantidadGeneros,
    STRING_AGG(g.NombreGenero, ', ') AS Generos
FROM Bandas b
INNER JOIN BandasGeneros bg ON b.BandaID = bg.BandaID
INNER JOIN Generos g ON bg.GeneroID = g.GeneroID
GROUP BY b.BandaID, b.Nombre
ORDER BY CantidadGeneros DESC;
--Cuales son las bandas con mas integrantes?
SELECT TOP 5
    b.Nombre AS Banda,
    COUNT(i.IntegranteID) AS CantidadIntegrantes
FROM Bandas b
INNER JOIN Integrantes i ON b.BandaID = i.BandaID
WHERE i.Activo = 1
GROUP BY b.BandaID, b.Nombre
ORDER BY CantidadIntegrantes DESC;
--Hay alguna banda que tenga mas de un exito?
SELECT 
    b.Nombre AS Banda,
    COUNT(e.ExitoID) AS CantidadExitos
FROM Bandas b
INNER JOIN Exitos e ON b.BandaID = e.BandaID
GROUP BY b.BandaID, b.Nombre
HAVING COUNT(e.ExitoID) > 1
ORDER BY CantidadExitos DESC;
--Que genero es el mas tocado por las bandas?
SELECT TOP 5
    g.NombreGenero AS Genero,
    COUNT(bg.BandaID) AS CantidadBandas
FROM Generos g
LEFT JOIN BandasGeneros bg ON g.GeneroID = bg.GeneroID
GROUP BY g.GeneroID, g.NombreGenero
ORDER BY CantidadBandas DESC;
--Lista de bandas y generos ordenada
SELECT 
    b.Nombre AS Banda,
    e.NombreEstado AS Estado,
    b.PaisOrigen,
    STRING_AGG(g.NombreGenero, ', ') AS Generos
FROM Bandas b
INNER JOIN Estados e ON b.EstadoID = e.EstadoID
LEFT JOIN BandasGeneros bg ON b.BandaID = bg.BandaID
LEFT JOIN Generos g ON bg.GeneroID = g.GeneroID
GROUP BY b.BandaID, b.Nombre, e.NombreEstado, b.PaisOrigen
ORDER BY b.Nombre;
-- Bandas por Pais
SELECT 
    PaisOrigen,
    COUNT(*) AS CantidadBandas
FROM Bandas 
GROUP BY PaisOrigen
ORDER BY CantidadBandas DESC;
--los exitos mass conocidos o populares
SELECT TOP 10
    b.Nombre AS Banda,
    e.Titulo AS Cancion,
    FORMAT(e.Reproducciones, 'N0') AS Reproducciones
FROM Exitos e
INNER JOIN Bandas b ON e.BandaID = b.BandaID
ORDER BY e.Reproducciones DESC;
--Bandas mas viejas?
SELECT 
    Nombre,
    PaisOrigen,
    FechaFormacion,
    DATEDIFF(YEAR, FechaFormacion, GETDATE()) AS AniosActividad
FROM Bandas
WHERE EstadoID IN (1, 4) -- Activas o en hiato
ORDER BY AniosActividad DESC;
--resumen general de la base total de bandas, integrantes, exitos, generos,reproducciones
SELECT 
    (SELECT COUNT(*) FROM Bandas) AS TotalBandas,
    (SELECT COUNT(*) FROM Integrantes) AS TotalIntegrantes,
    (SELECT COUNT(*) FROM Exitos) AS TotalExitos,
    (SELECT COUNT(*) FROM Generos) AS TotalGeneros,
    (SELECT SUM(Reproducciones) FROM Exitos) AS TotalReproducciones,
    (SELECT AVG(Reproducciones) FROM Exitos) AS PromedioReproducciones;
