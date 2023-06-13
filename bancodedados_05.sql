CREATE TABLE Produtos (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(50) NOT NULL,
  valor DECIMAL(10, 2) NOT NULL,
  saldo INT NOT NULL
);

CREATE TABLE Orcamentos (
  id INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
  data_orc DATETIME NOT NULL,
  status_orc VARCHAR(30) NOT NULL
);

CREATE TABLE Orcamentos_itens (
  id_prod INT,
  id_orc INT,
  valor_unit DECIMAL(10, 2),
  quantidade INT,
  valor_total_item DECIMAL(10, 2),
  PRIMARY KEY (id_prod, id_orc),
  FOREIGN KEY (id_prod) REFERENCES Produtos(id),
  FOREIGN KEY (id_orc) REFERENCES Orcamentos(id)
);




INSERT INTO Produtos (nome, valor, saldo) 
VALUES
 ('Produto 1', 10.50, 100),
 ('Produto 2', 15.75, 50),
 ('Produto 3', 20.00, 200),
 ('Produto 4', 5.25, 75),
 ('Produto 5', 30.50, 150),
 ('Produto 6', 12.00, 90),
 ('Produto 7', 18.25, 120),
 ('Produto 8', 25.00, 250),
 ('Produto 9', 7.50, 60),
 ('Produto 10', 22.00, 180);

INSERT INTO Orcamentos (data_orc, status_orc)
VALUES
('2023-03-21 10:30:00', 'Pendente'),
('2023-03-20 14:20:00', 'Aprovado'),
('2023-03-19 08:45:00', 'Reprovado'),
('2023-03-18 11:15:00', 'Pendente'),
('2023-03-17 16:30:00', 'Aprovado'),
('2023-03-16 13:20:00', 'Reprovado'),
('2023-03-15 09:45:00', 'Pendente'),
('2023-03-14 10:15:00', 'Aprovado'),
('2023-03-13 11:30:00', 'Reprovado'),
('2023-03-12 15:00:00', 'Pendente');

INSERT INTO Orcamentos_itens (id_prod, id_orc, valor_unit, quantidade, valor_total_item)
VALUES 
  (1, 1, 10.50, 2, (valor_unit * quantidade)),
  (2, 1, 5.75, 3, (valor_unit * quantidade)),
  (3, 2, 8.20, 4, (valor_unit * quantidade)),
  (4, 2, 12.99, 1, (valor_unit * quantidade)),
  (5, 3, 6.80, 5, (valor_unit * quantidade)),
  (6, 3, 15.40, 2, (valor_unit * quantidade)),
  (7, 4, 11.30, 3, (valor_unit * quantidade)),
  (8, 4, 9.99, 1, (valor_unit * quantidade)),
  (9, 5, 7.50, 2, (valor_unit * quantidade)),
  (10, 5, 14.80, 1, (valor_unit * quantidade));


--Lista de orçamentos por produto

CREATE VIEW TesteView AS 
SELECT Produtos.nome, Orcamentos.data_orc, id_orc, valor_total_item
FROM Orcamentos_itens 
INNER JOIN Produtos ON Orcamentos_itens.id_prod = Produtos.id
INNER JOIN Orcamentos ON Orcamentos_itens.id_orc = Orcamentos.id
WHERE  Orcamentos.data_orc >='2023-03-01 00:00:00' and data_orc <='2023-03-31 23:59:59';

--Produtos que tem “Computador” no nome e que tem quantidade em estoque.
CREATE VIEW ViewComputador AS 
SELECT Produtos.nome, Orcamentos.data_orc, Orcamentos_itens.quantidade, id_orc, valor_total_item
FROM Orcamentos_itens 
INNER JOIN Produtos ON Orcamentos_itens.id_prod = Produtos.id
INNER JOIN Orcamentos ON Orcamentos_itens.id_orc = Orcamentos.id
WHERE Produtos.nome LIKE '%Produto%' AND Orcamentos_itens.quantidade > 0;


--Os 10 produtos mais orçados no mês de setembro de 2014 e que ainda tem saldo em estoque. Somente os produtos com o valor acima de R$ 500.00.

CREATE VIEW ProdutosOrcados AS 
SELECT Produtos.nome, SUM(Orcamentos_itens.quantidade) AS quantidade_orcada
FROM Produtos 
INNER JOIN Orcamentos_itens ON Produtos.id = Orcamentos_itens.id_prod
INNER JOIN Orcamentos ON Orcamentos_itens.id_orc = Orcamentos.id
WHERE Orcamentos.data_orc >= '2023-03-01 00:00:00' AND Orcamentos.data_orc <= '2023-03-31 23:59:59'
  AND Produtos.valor > 5
  AND Produtos.saldo > 0
GROUP BY Produtos.id
ORDER BY quantidade_orcada DESC
LIMIT 3;

--Faça uma consulta utilizando a view para acrescentar 20% nos produtos que o saldo em estoque é menor ou igual a 5.

CREATE VIEW Estoque AS
SELECT Produtos.nome, id_prod, id_orc, valor_unit, quantidade, valor_total_item
FROM Orcamentos_itens
INNER JOIN Produtos on Orcamentos_itens.id_prod = Produtos.id
WHERE quantidade <= 5;

--CRIANDO UMA NOVA VIEW PARA PUXAR OS PRODUTOS COM POUCA 

CREATE VIEW AttEstoque AS
SELECT Produtos.nome, Estoque.id_prod, Estoque.quantidade * 1.2 AS quantidadeAtualizada
FROM Estoque
INNER JOIN Produtos ON Estoque.id_prod = Produtos.id;

-- Delete todos os produtos que não foram orçados.

SELECT DISTINCT id_prod FROM Orcamentos_itens
DELETE FROM Produtos
WHERE id NOT IN (SELECT id_prod FROM Orcamentos_itens);
DROP VIEW ProdutosOrcados 

-- Explique quando utilizar o GROUP BY, de um exemplo sql.

-- R: Sempre que usamos funções de agregação, como SUM, COUNT, AVG, MAX e MIN, o GROUP BY é usado para agrupar linhas na consulta SQL. Por exemplo:

select id_vendas, SUM(valor_venda) AS total_vendas
from 	vendas
where data_vendas >='2020-05-01' and data_emissao<='2020-08-31'
group by id_vendas;

-- Explique quando utilizar o HAVING, de um exemplo sql.

-- R: HAVING é utilizada para filtrar os resultados retornados pelo GROUP BY, para efetuar restrições de informações baseadas em resultados das funções de grupo (SUM, AVG, MAX, MIN e COUNT).

select id_vendas, SUM(valor_venda) AS total_vendas 
from 	vendas
where data_venda >='2020-05-01' and data_emissao <='2020-08-31'
group by id_vendas
HAVING SUM(valor_venda) > 10000;

-- Explique quando utilizar o UNION, de um exemplo sql.

-- R: UNION é útil quando precisamos combinar dados de duas ou mais tabelas semelhantes.

SELECT nome, cargo, salário
FROM funcionarios_tempo_integral
UNION
SELECT nome, cargo, salário
FROM funcionarios_meio_periodo;

-- Explique quando utilizar o LEFT JOIN, de um exemplo sql.

-- R: usado para associar todas as tuplas da primeira tabela com apenas as coincidentes na segunda tabela.

SELECT funcionarios.nome, departamentos.nome
FROM funcionarios
LEFT JOIN departamentos ON funcionarios.id_departamento = departamentos.id;









 

