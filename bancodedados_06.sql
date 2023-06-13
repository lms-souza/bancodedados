CREATE TABLE Clientes (
  id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  nome VARCHAR(30) NOT NULL
);

CREATE TABLE Livros (
  id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  titulo VARCHAR(30) NOT NULL,
  valor_unit DECIMAL(10, 2)
);

CREATE TABLE Autores (
  id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  nome VARCHAR(30) NOT NULL
);

CREATE TABLE Autores_livros (
  id_autor INT,
  id_livro INT,
  PRIMARY KEY (id_autor, id_livro),
  FOREIGN KEY (id_autor) REFERENCES Autores(id),
  FOREIGN KEY (id_livro) REFERENCES Livros(id)
);

CREATE TABLE Vendas (
 id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
 data DATETIME NOT NULL,
 id_cliente INT,
 FOREIGN KEY (id_cliente) REFERENCES Clientes(id)  
);

CREATE TABLE vendas_livros (
 id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
 id_livro INT,
 qtd INT,
 valor_unit DECIMAL(10, 2),
 FOREIGN KEY (id_livro) REFERENCES Livros(id)
);

INSERT INTO Clientes (nome) 
VALUES
 ('João Frango'),
 ('João Bambu'),
 ('João Malaquias'),
 ('João Forte'),
 ('João Goleiro'),
 ('João Piru'),
 ('João Da Silva'),
 ('Marcola'),
 ('Fernandinho Beiramar'),
 ('Pedrinho Matador');

INSERT INTO Livros (titulo, valor_unit) 
VALUES
 ('Código Limpo', 87.90),
 ('Vidigal', 17.90),
 ('Clean Code', 27.90),
 ('PCC e CV', 37.90),
 ('Raw Dinossauro', 47.90),
 ('Do Milhão ao Mil', 57.90),
 ('Harry Maguire', 1.90),
 ('Messi THE GOAT', 99.90),
 ('Menino NEY', 97.90),
 ('Penaldo', 1.99);

INSERT INTO Autores (nome) 
VALUES
 ('Luladrão'),
 ('Bolzo Jóias'),
 ('Ana Konda'),
 ('Dilma Estocavento'),
 ('Sérgio Berranteiro'),
 ('Fabiano Chupasseios'),
 ('Fe Zanal'),
 ('Elma Maria'),
 ('Giuseppe Camoles'),
 ('Davi Agra');

INSERT INTO Autores_livros (id_autor, id_livro)
VALUES 
  (1, 1),
  (2, 1),
  (3, 2),
  (4, 2),
  (5, 3),
  (6, 3),
  (7, 4),
  (8, 4),
  (9, 5),
  (10, 5);

INSERT INTO Vendas (data, id_cliente) 
VALUES
 ('2023-03-21', 1),
 ('2023-03-20', 2),
 ('2023-03-19', 3),
 ('2023-03-18', 4),
 ('2023-03-17', 5),
 ('2023-03-16', 6),
 ('2023-03-15', 7),
 ('2023-03-14', 8),
 ('2023-03-13', 9), 
 ('2023-03-12', 10);

INSERT INTO vendas_livros (id_livro, qtd) 
VALUES
 (1, 3),
 (1, 2),
 (2, 1),
 (2, 3),
 (3, 2),
 (3, 1),
 (4, 3),
 (4, 2),
 (5, 1),
 (5, 3);

-- Crie uma view chamada "livros_mais_vendidos" que exiba o título, autor, preço e a quantidade de vezes que cada livro foi vendido.

CREATE VIEW livros_mais_vendidos AS 
SELECT Livros.titulo, Autores.nome AS autor, Livros.valor_unit AS preco, SUM(vendas_livros.qtd) AS quantidade
FROM vendas_livros 
INNER JOIN Livros ON vendas_livros.id_livro = Livros.id
INNER JOIN Autores ON vendas_livros.id = Autores.id
GROUP BY Livros.id;

-- Crie uma view que lista os autores que nunca venderam livros.

CREATE VIEW autores_nao_venderam AS 
SELECT Autores.id, Autores.nome
FROM Autores
LEFT JOIN Livros ON Livros.id = Autores.id
LEFT JOIN vendas_livros ON vendas_livros.id = Livros.id
WHERE vendas_livros.id_livro IS NULL;

-- ou sem

SELECT Autores.id, Autores.nome
FROM Autores
LEFT JOIN Livros ON Livros.id = Autores.id
LEFT JOIN vendas_livros ON vendas_livros.id.livro = Livros.id
WHERE vendas_livros.id_livro IS NULL;

-- Use a sua criatividade e crie uma view que se aplique nessa modelagem. (Cliente que comprou o livro mais barato)

CREATE VIEW compra_mais_barata AS 
SELECT Clientes.nome AS cliente, Livros.titulo AS livro, Livros.valor_unit AS compra_mais_barata
FROM vendas_livros
INNER JOIN Livros ON vendas_livros.id_livro = Livros.id
INNER JOIN Clientes ON vendas_livros.id = Clientes.id
ORDER BY Livros.valor_unit ASC
LIMIT 1;

-- sem o limit vai aparecer todas as compras, porém do menor valor até o maior, também poderia criar outra forma usando MIN e GROUP BY

CREATE VIEW compra_mais_barata AS 
SELECT Clientes.nome AS cliente, Livros.titulo AS livro, MIN(Livros.valor_unit) AS compra_mais_barata
FROM vendas_livros
INNER JOIN Livros ON vendas_livros.id_livro = Livros.id
INNER JOIN Clientes ON vendas_livros.id = Clientes.id
GROUP BY Clientes.id, Livros.id;


