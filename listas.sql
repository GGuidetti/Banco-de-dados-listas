/* 
01- Escreva quatro triggers de sintaxe - a trigger não precisa ter funcionalidade, basta não dar erro de sintaxe. Use variável global para testar.
- Faça uma declarando variáveis e com select into; 
- Faça a segunda com uma estrutura de decisão; 
- Faça a terceira que gere erro, impedindo a ação;
- Faça a quarta que utilize a variável new e old - tente diferenciar. 
*/
DELIMITER //
    CREATE TRIGGER trg BEFORE INSERT ON cliente FOR EACH ROW
    BEGIN
        DECLARE vrv INT;
        SELECT * INTO vrv FROM cliente WHERE id = NEW.id;
    END
    //
DELIMITER ;
    
DELIMITER //
	CREATE TRIGGER trgif BEFORE INSERT ON cliente FOR EACH ROW
	BEGIN
		DECLARE cliente_ativo CHAR(1); 
		SELECT ativo INTO cliente_ativo FROM cliente WHERE id = new.cliente_id;

		IF cliente_ativo = 'N' THEN 
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Atenção cliente inativo";
		END IF;
	END
	//
DELIMITER ;
    
DELIMITER //
CREATE TRIGGER trgif BEFORE INSERT ON cliente FOR EACH ROW
BEGIN
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Tabela bloqueada";
END
//
DELIMITER ;


DELIMITER //
CREATE TRIGGER block_cidade AFTER UPDATE ON cidade FOR EACH ROW
	BEGIN    
		IF new.id <> old.id THEN
			SIGNAL SQLSTATE '45000' set MESSAGE_TEXT = "Cidades não podem ser alteradas";
		END IF;
	END;
//
DELIMITER ;

/*
02- Uma trigger que tem a função adicionar a entrada de produtos no estoque deve ser associado para qual:
•	Tabela?
•	Tempo?
•	Evento?
•	Precisa de variáveis? Quais?
•	Implemente a trigger. 
*/

/*
02- Uma trigger que tem a função adicionar a entrada de produtos no estoque deve ser associado para qual:
•	Tabela?
•	Tempo?
•	Evento?
•	Precisa de variáveis? Quais?
•	Implemente a trigger. 
*/

-- Adicionando o registro com 01 unidade no estoque
    -- Uma das opções é
    -- Tabela: produto
    -- Tempo: na inserção de um produto novo
    -- Evento: INSERT
    -- Variaveis: produto.id

DELIMITER //
CREATE TRIGGER produto_insert BEFORE INSERT ON produto FOR EACH ROW
	BEGIN
		INSERT INTO estoque (produto_id) VALUES (produto.id);
	END;
//
DELIMITER ;


/* 
03- Uma trigger que tem a função criar um registro de auditoria quando um pagamento e recebimento for alterada deve ser associado para qual(is):

*/

DELIMITER //

CREATE TRIGGER teste_1
AFTER UPDATE/DELETE/INSERT
ON tabela
FOR EACH ROW
BEGIN 
	DECLARE variavel VARCHAR(100);
    DECLARE outra_variavel INT;
	SELECT campo INTO variavel FROM tabela WHERE campo = "STRING GENERICA" ; 
	DECLARE cursor_generico CURSOR FOR
		SELECT campo_inteiro FROM tabela WHERE campo_inteiro = INTEIRO; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET acabou = TRUE;
	
	OPEN cursor_generico;
	read_loop : LOOP 
		FETCH cursor_generico INTO  outra_variavel;
		SET outra_variavel = outra_variavel + 1;
		IF outra_variavel = 10 OR acabou THEN 
			BEGIN 
				LEAVE read_loop;
			END;
		ELSE 
			BEGIN 
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "LOOP INFINITO";
			END;
		END IF;
		
	END LOOP;
	CLOSE cursor_generico;
	   
END;
// 
DELIMITER ;


/*
04- Uma trigger que tem a função impedir a venda de um produto inferior a 50% do preço de venda deve ser associado para qual:
*/

DELIMITER //
    CREATE FUNCTION verifica_desconto_abusivo(servico_realizado_id INT)
    RETURNS BOOL DETERMINISTIC
    BEGIN
        DECLARE desconto DECIMAL(12, 3);
        DECLARE preco DECIMAL(12, 3);
        DECLARE result BOOL DEFAULT FALSE;
            SELECT ios.desconto
            FROM item_ordem_servico ios
            WHERE ios.servico_realizado_id = servico_realizado_id
            LIMIT 1  AS desconto
        ,(
            SELECT s.preco
            FROM servico s
INNER JOIN servico_realizado sr
ON sr.id = servico_realizado_id
            WHERE servico_realizado.id = servico_realizado_id
            LIMIT 1
) AS preco
        IF desconto > preco/2 THEN
            SET result = TRUE;
        ELSE 
            SET result = FALSE;
        END IF;
        RETURN result;
    END;
//
DELIMITER ;

/* 
05- Este é para testar a sintaxe - tente implementar sem o script
Uma trigger que tem a função de gerar o RA automático na tabela ALUNO deve ser associada para qual

*/

CREATE TRIGGER ra_automatico
AFTER INSERT 
ON aluno
FOR EACH ROW 
	BEGIN 
    DECLARE 
        id_aluno VARCHAR(100);
		DECLARE ra VARCHAR(100);
		DECLARE dt_matricula VARCHAR(100);
		DECLARE cod_curso VARCHAR(100);

		SELECT CONVERT(VARCHAR(100),aluno.data_matricula) INTO dt_matricula FROM aluno
		WHERE new.id = aluno.id;
		
		SELECT CONVERT(VARCHAR(100),aluno.curso_id) INTO cod_curso FROM aluno
		WHERE new.id = aluno.id;
		
		SELECT CONVERT(VARCHAR(100),aluno.id) INTO id_aluno FROM aluno WHERE
		new.id = aluno.id;
		
		
		SET ra = CONCAT('dt_matricula' + 'cod_curso' + 'id_aluno');
		
		UPDATE aluno FROM aluno.ra = ra WHERE aluno.id = new.id;
		
	END;

//
DELIMITER ;

-- 06- De acordo com o seu projeto de banco de dados, pense em pelo menos 3 trigger úteis. Discuta com os seus colegas em relação a relevância e implemente-as.

--BOAS VINDAS
DELIMITER //
    CREATE TRIGGER first_achievment BEFORE INSERT ON usuario FOR EACH ROW
    BEGIN
        INSERT INTO user_achievment (achievment_id, user_id) VALUES (1,user.id)
    END
    //
DELIMITER ;

DELIMITER //
    CREATE TRIGGER first_water_achievment BEFORE INSERT ON hydric_consumption FOR EACH ROW
    BEGIN
        IF SELECT user_id from hydric_consumption WHERE hydric_consumption.user_id < 1 THEN
            INSERT INTO user_achievment (achievment_id, user_id) VALUES (2, hydric_consumption.user_id)
        END IF
    END
    //
DELIMITER ;

DELIMITER //
    CREATE TRIGGER first_food_achievment BEFORE INSERT ON food_consumption FOR EACH ROW
    BEGIN
        IF SELECT user_id from food_consumption WHERE food_consumption.user_id < 1 THEN
            INSERT INTO user_achievment (achievment_id, user_id) VALUES (3, food_consumption.user_id)
        END IF
    END
    //
DELIMITER ;



---------------------- LISTA 2

/*
01- Escreva quarto procedures de sintaxe - não precisa ter funcionalidade, basta não dar erro de sintaxe. Use variável global para testar.
- Faça uma declarando variáveis e com select into; 
- Faça a segunda com uma estrutura de decisão; 
- Faça a terceira que gere erro, impedindo a ação;
- Faça a quarta com if e else. 
*/


DELIMITER // 

CREATE PROCEDURE teste_1(tabela_id INT)
BEGIN 
	DECLARE vrv VARCHAR(100);
	SELECT campo INTO vrv FROM tabela WHERE tabela.id = tabela_id;
END;

// 
DELIMITER ;


DELIMITER //
CREATE PROCEDURE atualiza_estoque(id_produto INT, qtde_comprada INT, valor_unit DECIMAL(9,2))
BEGIN
    SELECT count(*) INTO contador FROM estoque WHERE id_produto = id_prod;
    IF contador > 0 THEN
        UPDATE estoque SET qtde = qtde + qtde_comprada, valor_unitario= valor_unit
        WHERE id_produto = id_prod;
    ELSE
        INSERT INTO estoque (id_produto, qtde, valor_unitario) values (id_prod, qtde_comprada, valor_unit);
    END IF;
END //
DELIMITER ;

CREATE PROCEDURE atualiza_estoque(id_produto INT, qtde_comprada INT, valor_unit DECIMAL(9,2))
BEGIN
    SELECT count(*) INTO contador FROM estoque WHERE id_produto = id_prod;
    IF SELECT ativo from produto WHERE id = produto.id = 'n' THEN
        SIGNAL SQLSTATE '00000' SET MESSAGE_TEXT = 'PRODUTO INATIVO';
    ELSE
        IF contador > 0 THEN
            UPDATE estoque SET qtde = qtde + qtde_comprada, valor_unitario= valor_unit
            WHERE id_produto = id_prod;
        ELSE
            INSERT INTO estoque (id_produto, qtde, valor_unitario) values (id_prod, qtde_comprada, valor_unit);
        END IF;
    END IF;
END //
DELIMITER ;

/*
02 - Escreva uma procedure que registre a baixa de um produto e já atualize devidamente o estoque do produto. Antes das ações, verifique se o produto é ativo.
*/


DELIMITER //
CREATE PROCEDURE inserir_venda_ativo(ID_PRODUTO INT, QUANTIDADE INT)
BEGIN
	DECLARE ATIVO CHAR;
    DECLARE QUANT INT; 
    SELECT P.ATIVO INTO ATIVO FROM PRODUTO P;
    IF ATIVO = 'I' THEN
		BEGIN 
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PRODUTO INATIVO';
        END;
	ELSE 
		BEGIN 
			INSERT  INTO VENDA VALUES (ID_PRODUTO, QUANTIDADE);
            
            UPDATE PRODUTO SET SALDO = QUANTIDADE WHERE ID_PRODUTO = ID_PRODUTO;
        END;
    END IF;
END;
// 
DELIMITER ;

/*
03 - Escreva uma procedure que altere o preço de um produto vendido (venda já realizada - necessário verificar a existência da venda). Não permita altearções abusivas - preço de venda abaixo do preço de custo. É possível implementar esta funcionalidade sem a procedure? Se sim, indique como, bem como as vantagens e desvantagens.
*/

DELIMITER //
CREATE PROCEDURE alterar_preco_venda(id_produto INT, preco_venda DECIMAL(8,2))
BEGIN
    DECLARE preco_custo DECIMAL(8,2);
    SELECT produto.preco_custo INTO preco_custo FROM produto WHERE produto.id = id_produto;
    IF preco_venda > preco_custo THEN
    BEGIN
        UPDATE produto SET preco_venda = preco_venda WHERE produto.id = id_produto;
    END;
    END IF;
END; //
DELIMITER ;

/*
04 - Escreva uma procedure que registre vendas de produtos e já defina o total da venda. É possível implementar a mesma funcionalidade por meio da trigger? Qual seria a diferença?
*/
DELIMITER //
	CREATE PROCEDURE registrar_venda(id_produto INT, id_venda INT, quatidade INT, preco_unidade DECIMAL(8,2))
	BEGIN
		DECLARE soma_total DECIMAL (8,2);
        DECLARE preco DECIMAL (8,2);
        DECLARE quantidade FLOAT;
        SELECT iv.preco_unidade INTO preco FROM item_venda iv;
        SELECT iv.quantidade INTO quantidade FROM item_venda iv;
        SET soma_total = preco * quantidade;
    END;
//
DELIMITER ;

/*
05- Para o controle de salário de funcionários de uma empresa e os respectivos adiantamentos (vales):
 - quais tabelas são necessárias?
*/
--FUNCIONARIOS, SALARIOS e FUNCIONARIOS_SALARIOS

-- 06- De acordo com o seu projeto de banco de dados, pense em pelo menos 3 procedures úteis. Discuta com os seus colegas em relação a relevância e implemente-as.

DELIMITER //
    CREATE PROCEDURE unlock_first_water_achievment (user_id)
    BEGIN  
        INSERT INTO user_achievment (achievment_id, user_id) VALUES (2, hydric_consumption.user_id)
        END IF
    END
    //
DELIMITER ;

DELIMITER //
    CREATE PROCEDURE unlock_first_food_achievment (user_id)
    BEGIN  
        INSERT INTO user_achievment (achievment_id, user_id) VALUES (3, food_consumption.user_id)
        END IF
    END
    //
DELIMITER ;

DROP PROCEDURE IF EXISTS unlock_water_achievement_cursor;
DELIMITER //
CREATE PROCEDURE unlock_water_achievement_cursor()
    RETURNS BOOL DETERMINISTIC
    BEGIN
        DECLARE acabou INT DEFAULT FALSE; 
        DECLARE water_cursor CURSOR FOR

        SELECT user.id
        FROM user

        DECLARE CONTINUE HANDLER FOR NOT FOUND SET acabou = TRUE; 
        
            OPEN water_cursor;
                read_loop : LOOP
                FETCH water_cursor INTO id;
                unlock_water_achievement(id);
                    IF acabou THEN 
                        BEGIN
                        LEAVE read_loop;
                        END;
                    END IF;
                END LOOP;
            CLOSE water_cursor;
    END;
//
DELIMITER;

-- 7- Explique as diferenças entre trigger, função e procedure. Indique as vantagens e desvantagens em utilizar a procedure.

Uma função precisa ser chamada manualmente e deve obrigatoriamente ter retorno, diferente de uma procedure que como o próprio nome diz, trata-se de um procedimento, logo não é necessário retorno. Já a trigger, "gatilho" em português, tem esse nome porque é "disparada" sempre que determinado evento ocorre no banco de dados, não precisando ser chamada diretamente como as outras citadas.
A grande vantagem de se utilizar Stored Procedures é a produtividade, que leva diretamente à facilidade de manutenção, facilidade de uso e escalabilidade, pois imagine que ao invés de criar códigos no backend da aplicação e\ou realizar vários comandos para manipular os dados de um banco você pudesse construir uma rotina dinâmica que pode ou não receber parâmetros para ser executada sempre que quiser, podendo ser reutilizada infinitamente: isso são Procedures. Porém, isso traz também a pequena desvantagem que é a dificuldade na escrita (pois a sintaxe não é tão conhecida) 

