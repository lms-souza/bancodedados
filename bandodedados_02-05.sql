CREATE TABLE produtos (
  prd_falta BOOLEAN,
  prd_qtd_est INTEGER,
  prd_codigo INTEGER PRIMARY KEY,
  prd_desc TEXT,
  prd_valor FLOAT,
  prd_status TEXT
);

CREATE TABLE orcamentos (
  orc_codigo INTEGER PRIMARY KEY,
  orc_data DATE,
  orc_status TEXT
);

CREATE TABLE orcamentos_produtos (
  orp_qtd INTEGER,
  orp_valor FLOAT,
  orp_status TEXT,
  prd_codigo INTEGER,
  orc_codigo INTEGER,
  FOREIGN KEY (prd_codigo) REFERENCES produtos(prd_codigo),
  FOREIGN KEY (orc_codigo) REFERENCES orcamentos(orc_codigo)
);

-- POPULANDO TABELAS PRODUTOS

INSERT INTO produtos (prd_falta, prd_qtd_est, prd_codigo, prd_desc, prd_valor, prd_status)
VALUES (false, 10, 1, 'Produto 1', 50.0, 'ativo'),
       (true, 0, 2, 'Produto 2', 20.0, 'inativo'),
       (false, 20, 3, 'Produto 3', 30.0, 'ativo');

-- POPULANDO TABELA ORÇAMENTOS

INSERT INTO orcamentos (orc_codigo, orc_data, orc_status)
VALUES (1, '2022-01-01', 'aberto'),
       (2, '2022-02-15', 'fechado'),
       (3, '2022-03-10', 'aberto');

-- POPULANDO TABELA DE orçamentos_produtos

INSERT INTO orcamentos_produtos (orp_qtd, orp_valor, orp_status, prd_codigo, orc_codigo)
VALUES (2, 50.0, 'em andamento', 1, 1),
       (1, 20.0, 'cancelado', 2, 1),
       (3, 30.0, 'concluído', 3, 1),
       (1, 50.0, 'concluído', 1, 2),
       (2, 20.0, 'em andamento', 2, 2),
       (2, 30.0, 'em andamento', 3, 2),
       (4, 50.0, 'aberto', 1, 3),
       (1, 20.0, 'aberto', 2, 3),
       (2, 30.0, 'aberto', 3, 3);

-- TRIGGER 01

CREATE TRIGGER atualiza_estoque
AFTER UPDATE ON orcamentos_produtos
FOR EACH ROW
BEGIN
  IF NEW.orp_status = 'cancelado' THEN
    UPDATE produtos
    SET prd_qtd_est = prd_qtd_est + OLD.orp_qtd
    WHERE prd_codigo = OLD.prd_codigo;
  END IF;
END;

-- TRIGGER 02

CREATE TRIGGER atualiza_produtos
BEFORE INSERT ON produtos
FOR EACH ROW
BEGIN
    DECLARE qtd_anterior INT;
    
    IF NEW.prd_qtd_est = 0 THEN
        INSERT INTO produtos_em_falta (prd_falta, prd_qtd_est, prd_codigo, prd_desc, prd_valor)
        VALUES (true, NEW.prd_qtd_est, NEW.prd_codigo, NEW.prd_desc, NEW.prd_valor);
        
        SET NEW.prd_status = NULL;
        
        UPDATE orcamentos_produtos
        SET orp_status = NULL
        WHERE prd_codigo = NEW.prd_codigo;
    ELSE
        SELECT prd_qtd_est INTO qtd_anterior FROM produtos WHERE prd_codigo = NEW.prd_codigo;
        
        INSERT INTO produtos_atualizados (prd_codigo, prd_qtd_anterior, prd_qtd_atualizada, prd_valor)
        VALUES (NEW.prd_codigo, qtd_anterior, NEW.prd_qtd_est, NEW.prd_valor);
    END IF;
END;