-- 1

CREATE PROCEDURE sp_quantidade_livros_por_autor (IN nome_autor VARCHAR(30))
BEGIN
    SELECT COUNT(*) AS quantidade_livros
    FROM Livros 
    WHERE a.nome = nome_autor
END;

call sp_quantidade_livros_por_autor('Giuseppe Camoles');

-- 2

CREATE PROCEDURE sp_atualizar_data_lancamento(IN codigo_livro INT, IN data_lancamento DATE)
BEGIN
    UPDATE Livros
    SET data = data_lancamento
    WHERE id = codigo_livro;
END;

call sp_atualizar_data_lancamento('1', '2023-03-21');

-- 3

-- a)
CREATE PROCEDURE sp_inserir_livro (
  IN titulo VARCHAR(30),
  IN valor_unit DECIMAL(10, 2),
  IN data DATE,
  IN autor_nome VARCHAR(30)
)
BEGIN
  DECLARE autor_id INT;
  INSERT INTO Autores (nome) VALUES (autor_nome);
  SET autor_id = LAST_INSERT_ID();
  INSERT INTO Livros (titulo, valor_unit, data_lancamento) VALUES (titulo, valor_unit, data_lancamento);
  INSERT INTO Autores_livros (id_autor, id_livro) VALUES (autor_id, LAST_INSERT_ID());
END;

-- b)

CREATE PROCEDURE sp_excluir_livro (IN id_livro INT)
BEGIN
  DELETE FROM Autores_livros WHERE id_livro = id_livro;
  DELETE FROM Livros WHERE id = id_livro;
END;

-- c) 

CREATE PROCEDURE sp_atualizar_livro (
  IN id_livro INT,
  IN titulo VARCHAR(30),
  IN valor_unit DECIMAL(10, 2),
  IN data_lancamento DATE,
  IN autor_nome VARCHAR(30)
)
BEGIN
  DECLARE autor_id INT;
  UPDATE Livros SET titulo = titulo, valor_unit = valor_unit, data_lancamento = data_lancamento WHERE id = id_livro;
  SELECT id INTO autor_id FROM Autores WHERE nome = autor_nome;
  IF autor_id IS NULL THEN
    INSERT INTO Autores (nome) VALUES (autor_nome);
    SET autor_id = LAST_INSERT_ID();
  END IF;
  DELETE FROM Autores_livros WHERE id_livro = id_livro;
  INSERT INTO Autores_livros (id_autor, id_livro) VALUES (autor_id, id_livro);
END;

-- 4 muito dificil

CREATE PROCEDURE sp_alterar_preco_livros_editora(
    IN nome_editora VARCHAR(30),
    IN valor_alteracao DECIMAL(10, 2),
    IN tipo_alteracao ENUM('percentual', 'valor')
)
BEGIN
    DECLARE id_editora INT;
    DECLARE preco_novo DECIMAL(10, 2);



