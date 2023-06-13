/* Questão 1 - Sim, existe uma restrição quanto à ordem de execução da criação das tabelas, 
pois há chaves estrangeiras presentes nas tabelas que dependem da existência 
das tabelas referenciadas. A sequência correta para a criação das tabelas 
seria a seguinte: Cidade, Filial, Empregado, Produto, Vende*/

/* Questão 2 */
CREATE TABLE Cidade (
  codcid INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  uf VARCHAR(2) NOT NULL,
  PRIMARY KEY (codcid)
);

CREATE TABLE Filial (
  codfilial INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  endereco VARCHAR(100) NOT NULL,
  codcid INT NOT NULL,
  PRIMARY KEY (codfilial),
  FOREIGN KEY (codcid) REFERENCES Cidade (codcid)
);

CREATE TABLE Empregado (
  codemp INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  endereco VARCHAR(100) NOT NULL,
  codcid INT NOT NULL,
  ct VARCHAR(10) NOT NULL,
  rg VARCHAR(20) NOT NULL,
  cpf VARCHAR(11) NOT NULL,
  salario DECIMAL(10, 2) NOT NULL,
  codfilial INT NOT NULL,
  PRIMARY KEY (codemp),
  FOREIGN KEY (codcid) REFERENCES Cidade (codcid),
  FOREIGN KEY (codfilial) REFERENCES Filial (codfilial)
);

CREATE TABLE Produto (
  codprod INT NOT NULL,
  descricao VARCHAR(100) NOT NULL,
  preco DECIMAL(10, 2) NOT NULL,
  nomecategoria VARCHAR(50) NOT NULL,
  descricaocategoria VARCHAR(100) NOT NULL,
  PRIMARY KEY (codprod)
);

CREATE TABLE Vende (
  codprod INT NOT NULL,
  codfilial INT NOT NULL,
  PRIMARY KEY (codprod, codfilial),
  FOREIGN KEY (codprod) REFERENCES Produto (codprod),
  FOREIGN KEY (codfilial) REFERENCES Filial (codfilial)
);


/* Questão 3 */

/* Criar as tabelas vende e filial. */

CREATE TABLE Vende (
  codprod INT NOT NULL,
  codfilial INT NOT NULL,
  PRIMARY KEY (codprod, codfilial),
  FOREIGN KEY (codprod) REFERENCES Produto (codprod),
  FOREIGN KEY (codfilial) REFERENCES Filial (codfilial)
);

CREATE TABLE Filial (
  codfilial INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  endereco VARCHAR(100) NOT NULL,
  codcid INT NOT NULL,
  PRIMARY KEY (codfilial),
  FOREIGN KEY (codcid) REFERENCES Cidade (codcid)
);

/* Listar o valor do produto mais caro. */

SELECT MAX(preco) AS maior_preco FROM Produto;

/* Obter a média dos preços dos produtos. */

SELECT AVG(preco) AS media_preco FROM Produto;

/*Listar o nome dos produtos vendidos pela filial “f3”. (joins) */

SELECT p.descricao 
FROM Produto p 
INNER JOIN Vende v ON p.codprod = v.codprod 
INNER JOIN Filial f ON v.codfilial = f.codfilial 
WHERE f.nome = 'f3';

/* Listar os nomes e números de RG dos funcionários que moram no 
Rio Grande do Sul e tem salário superior a R$ 500,00. (joins) */

SELECT e.nome, e.rg 
FROM Empregado e 
INNER JOIN Cidade c ON e.codcid = c.codcid 
WHERE c.uf = 'RS' AND e.salario > 500.00;


/* Questão 4 */

CREATE TABLE Categoria (
  codcat INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  descricao VARCHAR(100),
  PRIMARY KEY (codcat)
);

CREATE TABLE Livro (
  codlivro INT NOT NULL,
  titulo VARCHAR(100) NOT NULL,
  codautor INT NOT NULL,
  nfolhas INT,
  editora VARCHAR(50),
  valor DECIMAL(8,2),
  codcat INT NOT NULL,
  PRIMARY KEY (codlivro),
  FOREIGN KEY (codautor) REFERENCES Autor (codautor),
  FOREIGN KEY (codcat) REFERENCES Categoria (codcat) ON DELETE CASCADE
);


/* Questão 5 */

/* Mostrar o número total de vendas realizadas. */

SELECT COUNT(*) AS total_vendas FROM Venda;

/* Listar os títulos e valores dos livros da categoria “banco de Dados’. 
Mostra também o nome da categoria. */

SELECT L.titulo, L.valor, C.nome AS categoria
FROM Livro L
INNER JOIN Categoria C ON L.codcat = C.codcat
WHERE C.nome = 'Banco de Dados';

/* Listar os  títulos e nome dos autores dos livros que custam mais que R$ 300,00.
Listar os nomes dos clientes juntamente com o nome da cidade onde moram e UF. */

SELECT L.titulo, A.nome AS autor
FROM Livro L
INNER JOIN Autor A ON L.codautor = A.codautor
WHERE L.valor > 300;


/* Listar os nomes dos clientes juntamente com os nomes 
de todos os livros comprados por ele. */

SELECT C.nome AS cliente, CI.nome AS cidade, CI.uf
FROM Cliente C
INNER JOIN Cidade CI ON C.codcid = CI.codcid;

/* Listar o código do livro, o tilulo, o nome do autor, 
dos livros que foram vendidos no mês de março de 2021. (join) */

SELECT L.codlivro, L.titulo, A.nome AS autor
FROM Livro L
INNER JOIN Autor A ON L.codautor = A.codautor
INNER JOIN Venda V ON L.codlivro = V.codlivro
WHERE MONTH(V.data) = 3 AND YEAR(V.data) = 2021;

/* Listar o título e o autor dos 5 livros mais vendidos do mês de janeiro.*/

SELECT L.titulo, A.nome AS autor
FROM Livro L
INNER JOIN Autor A ON L.codautor = A.codautor
INNER JOIN Venda V ON L.codlivro = V.codlivro
WHERE MONTH(V.data) = 1 AND YEAR(V.data) = YEAR(CURDATE())
ORDER BY V.quantidade DESC LIMIT 5;


/* Mostrar o nome do cliente que comprou o livro 
com o título ‘Banco de dados powerful’). */

SELECT C.nome AS cliente
FROM Cliente C
INNER JOIN Venda V ON C.codcliente = V.codcliente
INNER JOIN Livro L ON V.codlivro = L.codlivro
WHERE L.titulo = 'Banco de dados powerful';
