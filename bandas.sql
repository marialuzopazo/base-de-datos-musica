CREATE DATABASE Bandas;
GO

USE Bandas;
GO
-- TABLAS CATÁLOGO

-- Tabla Estados
CREATE TABLE Estados (
    EstadoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreEstado VARCHAR(50) NOT NULL UNIQUE,
    Descripcion TEXT
);

-- Tabla Géneros
CREATE TABLE Generos (
    GeneroID INT IDENTITY(1,1) PRIMARY KEY,
    NombreGenero VARCHAR(50) NOT NULL UNIQUE,
    Descripcion TEXT
);

-- Tabla Instrumentos
CREATE TABLE Instrumentos (
    InstrumentoID INT IDENTITY(1,1) PRIMARY KEY,
    NombreInstrumento VARCHAR(50) NOT NULL UNIQUE,
    Tipo VARCHAR(50),
    Descripcion TEXT
);

-- TABLAS PRINCIPALES

-- Tabla Bandas
CREATE TABLE Bandas (
    BandaID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    FechaFormacion DATE NOT NULL,
    PaisOrigen VARCHAR(50) NOT NULL,
    EstadoID INT NOT NULL,
    Biografia TEXT,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Bandas_Estados FOREIGN KEY (EstadoID) REFERENCES Estados(EstadoID)
);

-- Tabla Integrantes
CREATE TABLE Integrantes (
    IntegranteID INT IDENTITY(1,1) PRIMARY KEY,
    BandaID INT NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Rol VARCHAR(50),
    FechaIngreso DATE,
    Activo BIT DEFAULT 1,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Integrantes_Bandas FOREIGN KEY (BandaID) REFERENCES Bandas(BandaID)
);

-- TABLAS PUENTE
-- Tabla BandasGéneros (M:N)
CREATE TABLE BandasGeneros (
    BandaGeneroID INT IDENTITY(1,1) PRIMARY KEY,
    BandaID INT NOT NULL,
    GeneroID INT NOT NULL,
    EsPrincipal BIT DEFAULT 0,
    OrdenImportancia INT DEFAULT 1,
    FechaAsignacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_BG_Bandas FOREIGN KEY (BandaID) REFERENCES Bandas(BandaID),
    CONSTRAINT FK_BG_Generos FOREIGN KEY (GeneroID) REFERENCES Generos(GeneroID),
    CONSTRAINT UK_BG_Unico UNIQUE (BandaID, GeneroID)
);

-- Tabla IntegrantesInstrumentos (M:N)
CREATE TABLE IntegrantesInstrumentos (
    IntegranteInstrumentoID INT IDENTITY(1,1) PRIMARY KEY,
    IntegranteID INT NOT NULL,
    InstrumentoID INT NOT NULL,
    FechaAsignacion DATE DEFAULT GETDATE(),
    NivelDominio VARCHAR(50),
    CONSTRAINT FK_II_Integrantes FOREIGN KEY (IntegranteID) REFERENCES Integrantes(IntegranteID),
    CONSTRAINT FK_II_Instrumentos FOREIGN KEY (InstrumentoID) REFERENCES Instrumentos(InstrumentoID),
    CONSTRAINT UK_II_Unico UNIQUE (IntegranteID, InstrumentoID)
);

-- Tabla Éxitos
CREATE TABLE Exitos (
    ExitoID INT IDENTITY(1,1) PRIMARY KEY,
    BandaID INT NOT NULL,
    Titulo VARCHAR(100) NOT NULL,
    Album VARCHAR(100),
    AnioLanzamiento INT,
    Duracion TIME,
    LinkYoutube VARCHAR(200),
    LinkSpotify VARCHAR(200),
    Reproducciones BIGINT DEFAULT 0,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Exitos_Bandas FOREIGN KEY (BandaID) REFERENCES Bandas(BandaID)
);

-- DATOS DE PRUEBA

-- Estados
INSERT INTO Estados (NombreEstado, Descripcion) VALUES
('Activa', 'Banda en actividad musical'),
('Inactiva', 'Banda no activa actualmente'),
('Separada', 'Banda que se ha separado definitivamente'),
('Hiato', 'Banda en pausa temporal');

-- Géneros
INSERT INTO Generos (NombreGenero, Descripcion) VALUES
('Rock', 'Género musical tradicional del rock'),
('Pop', 'Música popular comercial'),
('Metal', 'Heavy metal y subgéneros'),
('Jazz', 'Música jazz y sus variantes'),
('Electrónica', 'Música electrónica y EDM'),
('Hip Hop', 'Rap y hip hop'),
('Reggae', 'Reggae y derivados'),
('Blues', 'Blues tradicional y moderno'),
('Funk', 'Música funk y soul'),
('Indie', 'Música independiente'),
('Grunge', 'Rock alternativo de los 90s'),
('Hard Rock', 'Rock pesado y energético'),
('Progressive Rock', 'Rock progresivo y experimental'),
('Punk Rock', 'Rock punk y contestatario'),
('Alternative Rock', 'Rock alternativo'),
('Cumbia', 'Música tropical latinoamericana');

-- Instrumentos
INSERT INTO Instrumentos (NombreInstrumento, Tipo, Descripcion) VALUES
('Guitarra Eléctrica', 'Cuerda', 'Guitarra eléctrica'),
('Bajo', 'Cuerda', 'Bajo eléctrico'),
('Batería', 'Percusión', 'Batería completa'),
('Teclado', 'Teclado', 'Teclado o piano eléctrico'),
('Voz', 'Voz', 'Vocalista principal'),
('Guitarra Acústica', 'Cuerda', 'Guitarra acústica'),
('Saxofón', 'Viento', 'Saxofón'),
('Violín', 'Cuerda', 'Violín'),
('Armónica', 'Viento', 'Armónica'),
('Tambor', 'Percusión', 'Tambor y percusiones menores'),
('Piano', 'Teclado', 'Piano acústico o digital'),
('Trompeta', 'Viento', 'Trompeta'),
('Sintetizador', 'Electrónico', 'Sintetizador electrónico'),
('Trombón', 'Viento', 'Trombón'),
('Acordeón', 'Viento', 'Acordeón');


-- INSERTAR 25 BANDAS COMPLETAS CON LINKS REALES
-- 1. The Beatles
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('The Beatles', '1960-01-01', 'Reino Unido', 3, 'Banda legendaria de rock que revolucionó la música popular');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (1, 1, 1, 1), (1, 2, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(1, 'John', 'Lennon', 'Vocalista, Guitarrista', '1960-01-01'),
(1, 'Paul', 'McCartney', 'Vocalista, Bajista', '1960-01-01'),
(1, 'George', 'Harrison', 'Guitarrista, Vocalista', '1960-01-01'),
(1, 'Ringo', 'Starr', 'Baterista, Vocalista', '1962-08-18');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(1, 'Hey Jude', 'Hey Jude', 1968, 'https://youtu.be/A_MjCqQoLLA', 'https://open.spotify.com/track/0aym2LBJBk9DAYuHHutrIl', 1000000000),
(1, 'Let It Be', 'Let It Be', 1970, 'https://youtu.be/2xDzVZcqtYI', 'https://open.spotify.com/track/7iN1s7xHE4ifF5povM6A48', 800000000),
(1, 'Yesterday', 'Help!', 1965, 'https://youtu.be/vo7Tz4JpJvs', 'https://open.spotify.com/track/3BQHpFgAp4l80e1XslIjNI', 750000000);

-- 2. Metallica
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Metallica', '1981-10-28', 'Estados Unidos', 1, 'Iconos del heavy metal y thrash metal');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (2, 3, 1, 1), (2, 1, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(2, 'James', 'Hetfield', 'Vocalista, Guitarrista', '1981-10-28'),
(2, 'Kirk', 'Hammett', 'Guitarrista', '1983-04-01'),
(2, 'Robert', 'Trujillo', 'Bajista', '2003-02-24'),
(2, 'Lars', 'Ulrich', 'Baterista', '1981-10-28');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(2, 'Enter Sandman', 'Metallica', 1991, 'https://youtu.be/CD-E-LDc384', 'https://open.spotify.com/track/5s2W2S1oPuv5oHl2wQdmBH', 900000000),
(2, 'Nothing Else Matters', 'Metallica', 1991, 'https://youtu.be/tAGnKpE4NCI', 'https://open.spotify.com/track/0nLiqZ6A27jJri2VCalIUs', 850000000);

-- 3. Coldplay
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Coldplay', '1996-01-01', 'Reino Unido', 1, 'Banda de rock alternativo con toques de pop y electrónica');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES 
(3, 1, 1, 1), (3, 2, 0, 2), (3, 10, 0, 3), (3, 5, 0, 4);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(3, 'Chris', 'Martin', 'Vocalista, Pianista', '1996-01-01'),
(3, 'Jonny', 'Buckland', 'Guitarrista', '1996-01-01'),
(3, 'Guy', 'Berryman', 'Bajista', '1996-01-01'),
(3, 'Will', 'Champion', 'Baterista', '1996-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(3, 'Yellow', 'Parachutes', 2000, 'https://youtu.be/yKNxeF4KMsY', 'https://open.spotify.com/track/3AJwUDP919kvQ9QcozQPxg', 600000000),
(3, 'Viva la Vida', 'Viva la Vida or Death and All His Friends', 2008, 'https://youtu.be/dvgZkm1xWPE', 'https://open.spotify.com/track/1mea3bSkSGXuIRvnydlB5b', 700000000);

-- 4. Nirvana
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Nirvana', '1987-01-01', 'Estados Unidos', 3, 'Pioneros del grunge y símbolo de la Generación X');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (4, 11, 1, 1), (4, 1, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(4, 'Kurt', 'Cobain', 'Vocalista, Guitarrista', '1987-01-01'),
(4, 'Krist', 'Novoselic', 'Bajista', '1987-01-01'),
(4, 'Dave', 'Grohl', 'Baterista', '1990-09-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(4, 'Smells Like Teen Spirit', 'Nevermind', 1991, 'https://youtu.be/hTWKbfoikeg', 'https://open.spotify.com/track/5ghIJDpPoe3CfHMGu71E6T', 950000000);

-- 5. Korn
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Korn', '1993-01-01', 'Estados Unidos', 1, 'Pioneros del nu metal con sonidos pesados y experimentales');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (5, 3, 1, 1), (5, 6, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(5, 'Jonathan', 'Davis', 'Vocalista', '1993-01-01'),
(5, 'James', 'Shaffer', 'Guitarrista', '1993-01-01'),
(5, 'Brian', 'Welch', 'Guitarrista', '1993-01-01'),
(5, 'Reginald', 'Arvizu', 'Bajista', '1993-01-01'),
(5, 'Ray', 'Luzier', 'Baterista', '2007-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(5, 'Freak on a Leash', 'Follow the Leader', 1998, 'https://youtu.be/jRGrNDV2mKc', 'https://open.spotify.com/track/5l28dKdl9F1Y8dZ1fvFqeM', 450000000),
(5, 'Blind', 'Korn', 1994, 'https://youtu.be/CVKulG61H4I', 'https://open.spotify.com/track/1prC1XURfpMX2hKQ9Y4xxR', 300000000);

-- 6. Bon Jovi
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Bon Jovi', '1983-01-01', 'Estados Unidos', 1, 'Iconos del rock melódico y hard rock');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (6, 12, 1, 1), (6, 1, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(6, 'Jon', 'Bon Jovi', 'Vocalista', '1983-01-01'),
(6, 'Richie', 'Sambora', 'Guitarrista', '1983-01-01'),
(6, 'David', 'Bryan', 'Tecladista', '1983-01-01'),
(6, 'Tico', 'Torres', 'Baterista', '1983-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(6, 'Livin on a Prayer', 'Slippery When Wet', 1986, 'https://youtu.be/lDK9QqIzhwk', 'https://open.spotify.com/track/0J6mQxEZnlRt9ymzFntA6z', 850000000),
(6, 'Its My Life', 'Crush', 2000, 'https://youtu.be/vx2u5uUu3DE', 'https://open.spotify.com/track/0v1XpBHnsbkCn7iJ9Ucr1l', 900000000);

-- 7. AC/DC
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('AC/DC', '1973-11-01', 'Australia', 1, 'Leyendas del hard rock con riffs icónicos');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (7, 12, 1, 1), (7, 1, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(7, 'Angus', 'Young', 'Guitarrista', '1973-11-01'),
(7, 'Brian', 'Johnson', 'Vocalista', '1980-04-01'),
(7, 'Malcolm', 'Young', 'Guitarrista', '1973-11-01'),
(7, 'Cliff', 'Williams', 'Bajista', '1977-05-01'),
(7, 'Phil', 'Rudd', 'Baterista', '1975-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(7, 'Back in Black', 'Back in Black', 1980, 'https://youtu.be/pAgnJDJN4VA', 'https://open.spotify.com/track/08mG3Y1vljYA6bvDt4Wqkj', 1200000000),
(7, 'Highway to Hell', 'Highway to Hell', 1979, 'https://youtu.be/l482T0yNkeo', 'https://open.spotify.com/track/2zYzyRzz6pRmhPzyfMEC8s', 800000000);

-- 8. Guns N Roses
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Guns N Roses', '1985-03-01', 'Estados Unidos', 1, 'Iconos del hard rock con actitud rebelde');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (8, 12, 1, 1), (8, 1, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(8, 'Axl', 'Rose', 'Vocalista', '1985-03-01'),
(8, 'Slash', 'Saul Hudson', 'Guitarrista', '1985-03-01'),
(8, 'Duff', 'McKagan', 'Bajista', '1985-03-01'),
(8, 'Dizzy', 'Reed', 'Tecladista', '1990-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(8, 'Sweet Child O Mine', 'Appetite for Destruction', 1987, 'https://youtu.be/1w7OgIMMRc4', 'https://open.spotify.com/track/7snQQk1zcKl8gZ92AnueZW', 1100000000),
(8, 'November Rain', 'Use Your Illusion I', 1991, 'https://youtu.be/8SbUC-UaAxE', 'https://open.spotify.com/track/3YRCqOhFifThpSRFJ1VWFM', 900000000);

-- 9. Aerosmith
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Aerosmith', '1970-01-01', 'Estados Unidos', 1, 'La banda de rock americana por excelencia');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (9, 12, 1, 1), (9, 1, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(9, 'Steven', 'Tyler', 'Vocalista', '1970-01-01'),
(9, 'Joe', 'Perry', 'Guitarrista', '1970-01-01'),
(9, 'Tom', 'Hamilton', 'Bajista', '1970-01-01'),
(9, 'Joey', 'Kramer', 'Baterista', '1970-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(9, 'I Dont Want to Miss a Thing', 'Armageddon', 1998, 'https://youtu.be/JkK8g6FMEXE', 'https://open.spotify.com/track/225xvV8r1yKMHErSWivnow', 750000000),
(9, 'Dream On', 'Aerosmith', 1973, 'https://youtu.be/89dGC8de0CA', 'https://open.spotify.com/track/5MxNLUsfh7uzROypsoO5qe', 600000000);

-- 10. Queen
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Queen', '1970-01-01', 'Reino Unido', 3, 'Banda legendaria con Freddie Mercury como ícono');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (10, 1, 1, 1), (10, 13, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(10, 'Freddie', 'Mercury', 'Vocalista, Pianista', '1970-01-01'),
(10, 'Brian', 'May', 'Guitarrista', '1970-01-01'),
(10, 'Roger', 'Taylor', 'Baterista', '1970-01-01'),
(10, 'John', 'Deacon', 'Bajista', '1971-03-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(10, 'Bohemian Rhapsody', 'A Night at the Opera', 1975, 'https://youtu.be/fJ9rUzIMcZQ', 'https://open.spotify.com/track/7tFiyTwD0nx5a1eklYtX2J', 2000000000),
(10, 'We Will Rock You', 'News of the World', 1977, 'https://youtu.be/-tJYN-eG1zk', 'https://open.spotify.com/track/54flyrjcdnQdco7300avMJ', 1200000000);

-- 11. Los Ángeles Azules
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Los Ángeles Azules', '1976-01-01', 'México', 1, 'Iconos de la cumbia mexicana con sonido característico');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (11, 16, 1, 1);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(11, 'Jorge', 'Mejía Avante', 'Director, Acordeón', '1976-01-01'),
(11, 'Elías', 'Mejía Avante', 'Bajo', '1976-01-01'),
(11, 'Cristian', 'Mejía', 'Vocalista', '2010-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(11, 'Nunca Es Suficiente', 'Una Lluvia de Rosas', 1998, 'https://youtu.be/T2eVWp0e6qY', 'https://open.spotify.com/track/4x5Si6qQT4Mb2y2xW1eY3r', 800000000),
(11, 'El Listón de Tu Pelo', 'Una Lluvia de Rosas', 1998, 'https://youtu.be/VOZ1XpA5p8w', 'https://open.spotify.com/track/3uUo1jXrKpE6OjGg3kO2bK', 500000000);

-- 12. The Rolling Stones
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('The Rolling Stones', '1962-01-01', 'Reino Unido', 1, 'Los abuelos del rock que siguen en activo');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (12, 1, 1, 1), (12, 8, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(12, 'Mick', 'Jagger', 'Vocalista', '1962-01-01'),
(12, 'Keith', 'Richards', 'Guitarrista', '1962-01-01'),
(12, 'Ronnie', 'Wood', 'Guitarrista', '1975-01-01'),
(12, 'Charlie', 'Watts', 'Baterista', '1963-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(12, 'Satisfaction', 'Out of Our Heads', 1965, 'https://youtu.be/nrIPxlFzDi0', 'https://open.spotify.com/track/2RvNisL2DeeDdGsbuSf9p8', 850000000),
(12, 'Paint It Black', 'Aftermath', 1966, 'https://youtu.be/O4irXQhgMqg', 'https://open.spotify.com/track/63T7DJ1AFDD6Bn8VzG6JE8', 700000000);

-- 13. Ramones
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Ramones', '1974-01-01', 'Estados Unidos', 3, 'Pioneros del punk rock con canciones rápidas');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (13, 14, 1, 1);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(13, 'Joey', 'Ramone', 'Vocalista', '1974-01-01'),
(13, 'Johnny', 'Ramone', 'Guitarrista', '1974-01-01'),
(13, 'Dee Dee', 'Ramone', 'Bajista', '1974-01-01'),
(13, 'Tommy', 'Ramone', 'Baterista', '1974-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(13, 'Blitzkrieg Bop', 'Ramones', 1976, 'https://youtu.be/KZY9fq-2p2I', 'https://open.spotify.com/track/4b6qD7E1d4sQxQ0F6YIc6t', 400000000),
(13, 'I Wanna Be Sedated', 'Road to Ruin', 1978, 'https://youtu.be/bm51ihfi1P4', 'https://open.spotify.com/track/29Z3qj4hb8F4qM2J5Vp7fS', 350000000);

-- 14. Pink Floyd
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Pink Floyd', '1965-01-01', 'Reino Unido', 3, 'Masters del rock progresivo y psicodélico');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (14, 13, 1, 1), (14, 1, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(14, 'Roger', 'Waters', 'Bajista, Vocalista', '1965-01-01'),
(14, 'David', 'Gilmour', 'Guitarrista, Vocalista', '1968-01-01'),
(14, 'Richard', 'Wright', 'Tecladista', '1965-01-01'),
(14, 'Nick', 'Mason', 'Baterista', '1965-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(14, 'Another Brick in the Wall', 'The Wall', 1979, 'https://youtu.be/HrxX9TBj2zY', 'https://open.spotify.com/track/7rG0YfKa1C09LRI7XlXA1l', 900000000),
(14, 'Wish You Were Here', 'Wish You Were Here', 1975, 'https://youtu.be/hjpF8ukSrvk', 'https://open.spotify.com/track/6aFhC3Gg8v0pM3EmvwRgcg', 800000000);

-- 15. Led Zeppelin
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Led Zeppelin', '1968-01-01', 'Reino Unido', 3, 'Pioneros del hard rock y heavy metal');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (15, 12, 1, 1), (15, 8, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(15, 'Robert', 'Plant', 'Vocalista', '1968-01-01'),
(15, 'Jimmy', 'Page', 'Guitarrista', '1968-01-01'),
(15, 'John Paul', 'Jones', 'Bajista, Tecladista', '1968-01-01'),
(15, 'John', 'Bonham', 'Baterista', '1968-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(15, 'Stairway to Heaven', 'Led Zeppelin IV', 1971, 'https://youtu.be/QkF3oxiDcdk', 'https://open.spotify.com/track/5CQ30WqJwcep0pYcV4AMNc', 1500000000),
(15, 'Whole Lotta Love', 'Led Zeppelin II', 1969, 'https://youtu.be/HQmmM_qwG4k', 'https://open.spotify.com/track/0hCB0YR03f6AmQaHbwWDe8', 700000000);

-- 16. KISS
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('KISS', '1973-01-01', 'Estados Unidos', 1, 'Iconos del hard rock con maquillaje y espectáculo pirotécnico');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (16, 12, 1, 1), (16, 3, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(16, 'Paul', 'Stanley', 'Vocalista, Guitarrista', '1973-01-01'),
(16, 'Gene', 'Simmons', 'Bajista, Vocalista', '1973-01-01'),
(16, 'Ace', 'Frehley', 'Guitarrista', '1973-01-01'),
(16, 'Peter', 'Criss', 'Baterista', '1973-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(16, 'I Was Made For Lovin You', 'Dynasty', 1979, 'https://youtu.be/7LbI1vh7eUI', 'https://open.spotify.com/track/07q0QVgO56EorrSGHC48y3', 600000000),
(16, 'Rock And Roll All Nite', 'Dressed to Kill', 1975, 'https://youtu.be/4sVxQj3C8U0', 'https://open.spotify.com/track/6KTv0Z8BmVqM7DPxbGzpVC', 550000000);

-- 17. Oasis
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Oasis', '1991-01-01', 'Reino Unido', 3, 'Íconos del Britpop con hermanos Gallagher');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (17, 1, 1, 1), (17, 2, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(17, 'Liam', 'Gallagher', 'Vocalista', '1991-01-01'),
(17, 'Noel', 'Gallagher', 'Guitarrista, Compositor', '1991-01-01'),
(17, 'Gem', 'Archer', 'Guitarrista', '1999-01-01'),
(17, 'Andy', 'Bell', 'Bajista', '1999-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(17, 'Wonderwall', '(Whats the Story) Morning Glory?', 1995, 'https://youtu.be/bx1Bh8ZvH84', 'https://open.spotify.com/track/2CT3r93YuSHtm57mjxvjhH', 1200000000),
(17, 'Dont Look Back In Anger', '(Whats the Story) Morning Glory?', 1995, 'https://youtu.be/r8OipmKFDeM', 'https://open.spotify.com/track/7ppPZa3TRUSGKaks9wH7VT', 800000000);

-- 18. Radiohead
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Radiohead', '1985-01-01', 'Reino Unido', 1, 'Pioneros del rock alternativo y experimental');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (18, 15, 1, 1), (18, 13, 0, 2), (18, 5, 0, 3);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(18, 'Thom', 'Yorke', 'Vocalista, Guitarrista', '1985-01-01'),
(18, 'Jonny', 'Greenwood', 'Guitarrista, Tecladista', '1985-01-01'),
(18, 'Colin', 'Greenwood', 'Bajista', '1985-01-01'),
(18, 'Ed', 'OBrien', 'Guitarrista', '1985-01-01'),
(18, 'Philip', 'Selway', 'Baterista', '1985-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(18, 'Creep', 'Pablo Honey', 1992, 'https://youtu.be/XFkzRNyygfk', 'https://open.spotify.com/track/70LcF31zb1H0PyJoS1Sx1r', 1100000000),
(18, 'Karma Police', 'OK Computer', 1997, 'https://youtu.be/LBqKA6MApZ4', 'https://open.spotify.com/track/63OQupATfueTdZMWTxW03A', 500000000);

-- 19. Foo Fighters
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Foo Fighters', '1994-01-01', 'Estados Unidos', 1, 'Banda de rock alternativo formada por Dave Grohl');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (19, 1, 1, 1), (19, 15, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(19, 'Dave', 'Grohl', 'Vocalista, Guitarrista', '1994-01-01'),
(19, 'Nate', 'Mendel', 'Bajista', '1995-01-01'),
(19, 'Taylor', 'Hawkins', 'Baterista', '1997-01-01'),
(19, 'Pat', 'Smear', 'Guitarrista', '1995-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(19, 'Everlong', 'The Colour and the Shape', 1997, 'https://youtu.be/eBG7P-K-r1Y', 'https://open.spotify.com/track/5UWwZ5lm5PKu6eKsHAGxOk', 800000000),
(19, 'The Pretender', 'Echoes, Silence, Patience & Grace', 2007, 'https://youtu.be/SBjQ9tuuTJQ', 'https://open.spotify.com/track/7x8dCjCr0x6x2lXKujYD34', 600000000);

-- 20. Linkin Park
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Linkin Park', '1996-01-01', 'Estados Unidos', 3, 'Pioneros del nu metal y rock alternativo');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (20, 15, 1, 1), (20, 3, 0, 2), (20, 6, 0, 3);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(20, 'Chester', 'Bennington', 'Vocalista', '1999-01-01'),
(20, 'Mike', 'Shinoda', 'Vocalista, Tecladista', '1996-01-01'),
(20, 'Brad', 'Delson', 'Guitarrista', '1996-01-01'),
(20, 'Dave', 'Farrell', 'Bajista', '1996-01-01'),
(20, 'Rob', 'Bourdon', 'Baterista', '1996-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(20, 'In the End', 'Hybrid Theory', 2000, 'https://youtu.be/eVTXPUF4Oz4', 'https://open.spotify.com/track/60a0Rd6pjrkxjPbaKzXjfq', 1500000000),
(20, 'Numb', 'Meteora', 2003, 'https://youtu.be/kXYiU_JCYtU', 'https://open.spotify.com/track/2nLtzopw4rPReszdYBJU6h', 1300000000);

-- 21. Green Day
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Green Day', '1987-01-01', 'Estados Unidos', 1, 'Iconos del punk rock y pop punk');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (21, 14, 1, 1), (21, 2, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(21, 'Billie Joe', 'Armstrong', 'Vocalista, Guitarrista', '1987-01-01'),
(21, 'Mike', 'Dirnt', 'Bajista', '1987-01-01'),
(21, 'Tré', 'Cool', 'Baterista', '1990-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(21, 'Basket Case', 'Dookie', 1994, 'https://youtu.be/NUTGr5t3MoY', 'https://open.spotify.com/track/6L89mwZXSOwYl76YXfX13s', 900000000),
(21, 'American Idiot', 'American Idiot', 2004, 'https://youtu.be/Ee_uujKuJMI', 'https://open.spotify.com/track/6nTiIhLmQ3FWhvrGafw2zj', 700000000);

-- 22. Red Hot Chili Peppers
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Red Hot Chili Peppers', '1983-01-01', 'Estados Unidos', 1, 'Fusión de funk, rock alternativo y punk');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (22, 9, 1, 1), (22, 1, 0, 2), (22, 15, 0, 3);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(22, 'Anthony', 'Kiedis', 'Vocalista', '1983-01-01'),
(22, 'Flea', 'Balzary', 'Bajista', '1983-01-01'),
(22, 'John', 'Frusciante', 'Guitarrista', '1988-01-01'),
(22, 'Chad', 'Smith', 'Baterista', '1988-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(22, 'Californication', 'Californication', 1999, 'https://youtu.be/YlUKcNNmywk', 'https://open.spotify.com/track/48UPSzbZjgc449aqz8bxox', 1000000000),
(22, 'Under the Bridge', 'Blood Sugar Sex Magik', 1991, 'https://youtu.be/GLvohMXgcBo', 'https://open.spotify.com/track/3d9DChrdc6BOeFsbrZ3Is0', 900000000);

-- 23. Daft Punk
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Daft Punk', '1993-01-01', 'Francia', 3, 'Duo francés de música electrónica con cascos icónicos');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (23, 5, 1, 1), (23, 2, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(23, 'Thomas', 'Bangalter', 'Productor, DJ', '1993-01-01'),
(23, 'Guy-Manuel', 'de Homem-Christo', 'Productor, DJ', '1993-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(23, 'Get Lucky', 'Random Access Memories', 2013, 'https://youtu.be/5NV6Rdv1a3I', 'https://open.spotify.com/track/69kOkLUCkxIZYexIgSG8rq', 1200000000),
(23, 'One More Time', 'Discovery', 2000, 'https://youtu.be/FGBhQbmPwH8', 'https://open.spotify.com/track/0DiWol3AO6WpXZgp0goxAV', 800000000);

-- 24. Papa Roach
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Papa Roach', '1993-01-01', 'Estados Unidos', 1, 'Bandas de nu metal y rock alternativo');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (24, 3, 1, 1), (24, 15, 0, 2);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(24, 'Jacoby', 'Shaddix', 'Vocalista', '1993-01-01'),
(24, 'Jerry', 'Horton', 'Guitarrista', '1993-01-01'),
(24, 'Tobin', 'Esperance', 'Bajista', '1999-01-01'),
(24, 'Tony', 'Palermo', 'Baterista', '2007-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(24, 'Last Resort', 'Infest', 2000, 'https://youtu.be/j0l1N1Q_3aY', 'https://open.spotify.com/track/5W8YXBz9MTIDyrpYaCg2Ky', 700000000),
(24, 'Scars', 'Getting Away With Murder', 2004, 'https://youtu.be/n1SArRo3M_s', 'https://open.spotify.com/track/4QeFlQkOUW54Ck1ykue1Uy', 400000000);

-- 25. Twenty One Pilots
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Twenty One Pilots', '2009-01-01', 'Estados Unidos', 1, 'Dúo de rock alternativo con fusiones de hip hop y electrónica');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (25, 15, 1, 1), (25, 6, 0, 2), (25, 5, 0, 3);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(25, 'Tyler', 'Joseph', 'Vocalista, Multiinstrumentista', '2009-01-01'),
(25, 'Josh', 'Dun', 'Baterista', '2011-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(25, 'Stressed Out', 'Blurryface', 2015, 'https://youtu.be/pXRviuL6vMY', 'https://open.spotify.com/track/3CRDbSIZ4r5MsZ0YwxuEkn', 2000000000),
(25, 'Ride', 'Blurryface', 2015, 'https://youtu.be/Pw-0pbY9JeU', 'https://open.spotify.com/track/2Z8WuEywRWYTKe1NybPQEW', 1200000000);

-- 26. Maroon 5
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Maroon 5', '1994-01-01', 'Estados Unidos', 1, 'Banda de pop rock con influencias funk');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (26, 2, 1, 1), (26, 1, 0, 2), (26, 9, 0, 3);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(26, 'Adam', 'Levine', 'Vocalista, Guitarrista', '1994-01-01'),
(26, 'Jesse', 'Carmichael', 'Tecladista', '1994-01-01'),
(26, 'James', 'Valentine', 'Guitarrista', '2001-01-01'),
(26, 'Mickey', 'Madden', 'Bajista', '1994-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(26, 'Sugar', 'V', 2014, 'https://youtu.be/09R8_2nJtjg', 'https://open.spotify.com/track/2iuZJX9X9P0GKaE93xcPjk', 3500000000),
(26, 'Moves Like Jagger', 'Hands All Over', 2010, 'https://youtu.be/iEPTlhBmwRg', 'https://open.spotify.com/track/7qC4QT9f1LLu6wsTZyR68l', 1800000000);

-- 27. Imagine Dragons
INSERT INTO Bandas (Nombre, FechaFormacion, PaisOrigen, EstadoID, Biografia) 
VALUES ('Imagine Dragons', '2008-01-01', 'Estados Unidos', 1, 'Banda de pop rock y rock alternativo');
INSERT INTO BandasGeneros (BandaID, GeneroID, EsPrincipal, OrdenImportancia) VALUES (27, 1, 1, 1), (27, 2, 0, 2), (27, 15, 0, 3);
INSERT INTO Integrantes (BandaID, Nombre, Apellido, Rol, FechaIngreso) VALUES
(27, 'Dan', 'Reynolds', 'Vocalista', '2008-01-01'),
(27, 'Wayne', 'Sermon', 'Guitarrista', '2009-01-01'),
(27, 'Ben', 'McKee', 'Bajista', '2009-01-01'),
(27, 'Daniel', 'Platzman', 'Baterista', '2011-01-01');
INSERT INTO Exitos (BandaID, Titulo, Album, AnioLanzamiento, LinkYoutube, LinkSpotify, Reproducciones) VALUES
(27, 'Radioactive', 'Night Visions', 2012, 'https://youtu.be/ktvTqknDobU', 'https://open.spotify.com/track/4G8gkOterJn0Ywt6uhqbhp', 1800000000),
(27, 'Believer', 'Evolve', 2017, 'https://youtu.be/7wtfhZwyrcc', 'https://open.spotify.com/track/0pqnGHJpmpxLKifKRmU6WP', 2500000000);

PRINT '27 BANDAS INSERTADAS mi amooooorrrr al fiiiiin wiiiii';
PRINT 'Todas con links reales oficiales delñ youtube';
PRINT 'Base de datos lista para agregarle todas las consultas';
