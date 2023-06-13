-- 1 Crie uma tabela Pessoas que contenha as colunas id, nome, sexo e data_nascimento.
-- Crie uma Store Procedure onde sejam possíveis passar como parâmetro as informações para Nome, 
-- Sexo e Data_Nascimento. Esta Stored Procedure deverá consultar no banco de dados o último ID 
-- gerado na tabela de Pessoas, incrementar este ID e inserir um registro nesta tabela com os dados 
-- enviados por parâmetro.

CREATE PROCEDURE sp_pessoas_increment (
    IN nome VARCHAR(30)
    IN sexo CHAR(1)
    IN data_nascimento DATE
) 
BEGIN 
    DECLARE novoId INT
    SELECT novoId = MAX(id) * FROM Pessoas    
    if novoId IS NULL
        SET novoId = 1
    INSERT INTO Pessoas (id, nome, sexo, data_nascimento)
    VALUES (novoId, nome, sexo, data_nascimento)
END

call sp_pessoas_increment(1, Leonardo, M, 2004-13-03);

-- 2 Crie uma Stored Procedure que mostre quantos Homens e quantas Mulheres têm cadastrados.

CREATE PROCEDURE sp_homens_e_mulheres()
BEGIN 
    DECLARE contar_homem
    DECLARE contar_mulher

    SELECT COUNT (*) INTO contar_homem FROM Pessoas WHERE sexo = 'M' ;
    SELECT COUNT (*) INTO contar_mulher FROM Pessoas WHERE sexo = 'f' ;

    SELECT contar_homem AS "Homens" and contar_mulher AS "Mulheres"
END;    

-- 3 Crie uma Stored Procedure que mostre quantos Homens são menores e maiores de idade, 
-- e quantas Mulheres são maiores e menores de idade.

CREATE PROCEDURE sp_homem_mulher_idade()
BEGIN 
    DECLARE idade_homem
    DECLARE idade_mulher


-- trabalho PROCEDURE 1

CREATE PROCEDURE cud_medico(m_id int, m_nome VARCHAR(100), m_oper char(1))

BEGIN
declare operar char(1);

set operar = 1;


while(operar<>1)

end

	if(m_oper = '1' )then
		-- insert
        insert into medico(nome) value(m_nome);
        select concat(m_nome,'inserido com sucesso') as retorno;
    elseif(m_oper= '2') then
		-- update
        update medico set nome = m_nome where id = m_id;
    elseif(m_oper= '3') then
		-- delete
        delete from medico where id = m_id;
        select concat('medico do id', m_id,'deletado com sucesso') as retorno;
	else
		select 'insira 1 para insert, 2 para update e 3 para delete' as retorno;
    end if;

END $$
DELIMITER ;

call cud_medico(0,'Jão',1);
call cud_medico(7,'Claiton',2);

-- trabalho PROCEDURE 2

call agendar_consulta('João Frango','2023-03-15', '16:30:00', 1);

DROP PROCEDURE agendar_consulta;

CREATE PROCEDURE agendar_consulta
(
    IN nome_paciente VARCHAR(50),
    IN data_consulta DATE,
    IN hora_consulta TIME,
    IN id_medico INT
)
BEGIN
   	DECLARE id_paciente INT;
    
    -- Verifica se o médico existe na tabela de médicos
    IF NOT EXISTS (SELECT * FROM Medico WHERE ID_Medico = id_medico) THEN
        SELECT 'Médico não encontrado' AS retorno;
    ELSE
        -- Verifica se o paciente já existe na tabela de pacientes
        IF EXISTS (SELECT * FROM Paciente WHERE Nome = nome_paciente) THEN
            SELECT ID_Paciente INTO id_paciente FROM Paciente WHERE Nome = nome_paciente;
        ELSE
            -- Insere o novo paciente na tabela de pacientes
            INSERT INTO Paciente (Nome) VALUES (nome_paciente);
            SET id_paciente = LAST_INSERT_ID();
        END IF;
        
        -- Verifica se já existe uma consulta marcada na mesma data e horário
        IF NOT EXISTS (SELECT * FROM Consulta WHERE Data_Consulta = data_consulta AND Hora_Consulta = hora_consulta AND ID_Medico = id_medico) THEN
            SELECT 'Já existe uma consulta marcada para este médico nesta data e horário' AS retorno;
        ELSE
            -- Insere a nova consulta na tabela de consultas
            INSERT INTO Consulta (Data_Consulta, Hora_Consulta, ID_Paciente, ID_Medico) 
            VALUES (data_consulta, hora_consulta, id_paciente, id_medico); 
            SELECT 'Consulta agendada com sucesso' AS retorno;
        END IF;
    END IF;
END;

-- Procedure 3 Cadastro Cliente

CREATE PROCEDURE registrar_paciente
(
    IN nome_paciente VARCHAR(50),
    IN data_nascimento DATE,
    IN telefone VARCHAR(20),
    IN endereco VARCHAR(100),
    IN email VARCHAR(50)
)
BEGIN
    -- Verifica se o paciente já existe na tabela de pacientes
    IF EXISTS (SELECT * FROM Paciente WHERE nome = nome_paciente AND data_nascimento = data_nascimento) THEN
        select concat(nome_paciente,' já registrado') as retorno;
    ELSE
        -- Insere o novo paciente na tabela de pacientes
        INSERT INTO Paciente (nome, data_nascimento, telefone, endereco, email)
        VALUES (nome_paciente, data_nascimento, telefone, endereco, email);
        
        select concat(nome_paciente,' registrado com sucesso') as retorno;
        SELECT * from Paciente;
    END IF;
END 

call registrar_paciente('Endriw', '1990-06-15', '(51) 9999-7878', 'Av. Barão', 'butijao@gmail.com');

--

