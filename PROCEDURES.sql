-----------------------------------------------------------
--1 Redistribuir doacoes para objetos abaixo da média de valor arrecadado
	-- # Calcular media das doacoes
	-- # Pegar 5% de cada objeto com doacoes acima da média e
	-- # Distribuir igualmente a soma desses 5% para cada objeto abaixo da média

CREATE OR REPLACE FUNCTION redistribuir_doacoes()
RETURNS void AS $$
DECLARE
    media_total numeric;
    soma_redistribuicao numeric := 0;
    total_abaixo_media integer;
    valor_redistribuicao numeric;
    obj record;
BEGIN
    -- Calcula a média total de doações
    SELECT AVG(valor_doacao) INTO media_total
    FROM "doacoes";

    -- Exibe a média total
    RAISE NOTICE 'Média total: %', media_total;

    -- Calcula a soma de 5% das doações dos objetos que arrecadaram acima da média
    FOR obj IN 
        SELECT id_objeto, SUM(valor_doacao) AS total_doacoes
        FROM "doacoes"
        GROUP BY id_objeto
        HAVING SUM(valor_doacao) > media_total
    LOOP
        -- Subtrai 5% do valor do objeto acima da média e adiciona à soma de redistribuição
        soma_redistribuicao := soma_redistribuicao + (obj.total_doacoes * 0.05);

        -- Atualiza a doação do objeto, subtraindo 5%
        UPDATE "doacoes"
        SET valor_doacao = valor_doacao - (valor_doacao * 0.05)
        WHERE id_objeto = obj.id_objeto;
    END LOOP;

    RAISE NOTICE 'Soma das doações (5%%): %', soma_redistribuicao;

    -- Conta quantos objetos estão abaixo da média
    SELECT COUNT(DISTINCT id_objeto) INTO total_abaixo_media
    FROM "doacoes"
    WHERE id_objeto IN (
        SELECT id_objeto
        FROM "doacoes"
        GROUP BY id_objeto
        HAVING SUM(valor_doacao) < media_total
    );

    RAISE NOTICE 'Quantidade de objetos abaixo da média: %', total_abaixo_media;

    -- Se houver, distribui igualmente o valor somado
    IF total_abaixo_media > 0 THEN
        valor_redistribuicao := soma_redistribuicao / total_abaixo_media;

        RAISE NOTICE 'Valor a ser redistribuido: %', valor_redistribuicao;

        -- Redistribui igualmente entre os objetos abaixo da média
        FOR obj IN
            SELECT DISTINCT id_objeto
            FROM "doacoes"
            WHERE id_objeto IN (
                SELECT id_objeto
                FROM "doacoes"
                GROUP BY id_objeto
                HAVING SUM(valor_doacao) < media_total
            )
        LOOP
            -- Atualiza as doacoes para objetos abaixo da média
            UPDATE "doacoes"
            SET valor_doacao = valor_doacao + valor_redistribuicao
            WHERE id_objeto = obj.id_objeto;
        END LOOP;
    END IF;

    RAISE NOTICE 'Redistribuição de doações realizada';
END;
$$ LANGUAGE plpgsql;


/*
 * PARA TESTES
DELETE FROM "doacoes";

INSERT INTO "doacoes" ("id_doacao", "id_visitante", "id_objeto", "valor_doacao") 
VALUES 
  (1, 1, 1, 1000),
  (2, 2, 2, 2000),
  (3, 3, 3, 3000),
  (4, 4, 4, 500),
  (5, 5, 5, 1500);
  
valores esperados apos a execução:
id_objeto | valor_doacao
--------------------------
1         | 1083.33
2         | 1900
3         | 2850
4         | 583.33
5         | 1583.33
*/

SELECT redistribuir_doacoes();

-------------------------------------------------------------------------------------------
--2 Gerar Relatório Completo de um Evento

CREATE PROCEDURE gerar_relatorio_evento(IN evento_id INT)
LANGUAGE plpgsql
AS $$
DECLARE
    v_evento_nome VARCHAR;
    v_evento_descricao VARCHAR;
    v_evento_data TIMESTAMP;
    v_visita_count INT;
    v_total_doacao NUMERIC := 0;
    patrocinador RECORD;  -- Correção: usar RECORD para o tipo de variável de laço
    objeto RECORD;        -- Correção: usar RECORD para o tipo de variável de laço
    comentario RECORD;    -- Correção: usar RECORD para o tipo de variável de laço
BEGIN
    -- 1. Obter informações gerais do evento
    SELECT nome, descricao, data
    INTO v_evento_nome, v_evento_descricao, v_evento_data
    FROM eventos
    WHERE id_evento = evento_id;

    -- Verificar se o evento existe
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Evento com ID % não encontrado.', evento_id;
    END IF;

    -- 2. Contar o número de visitantes
    SELECT COUNT(DISTINCT id_visitante)
    INTO v_visita_count
    FROM eventos_visitantes
    WHERE id_evento = evento_id;

    -- 3. Calcular o total de doações para o evento (pelos patrocinadores)
    FOR patrocinador IN
        SELECT p.nome, pe.valor_doado
        FROM patrocinadores p
        INNER JOIN patrocinadores_exposicoes pe ON p.id_patrocinador = pe.id_patrocinador
        WHERE pe.id_exposicao IN (SELECT id_exposicao FROM eventos_exposicoes WHERE id_evento = evento_id)
    LOOP
        v_total_doacao := v_total_doacao + patrocinador.valor_doado;
    END LOOP;

    -- 4. Obter todos os objetos relacionados ao evento (pelas exposições)
    FOR objeto IN
        SELECT o.nome, o.tipo, o.origem
        FROM objetos o
        INNER JOIN exposicoes_objetos eo ON o.id_objeto = eo.id_objeto
        INNER JOIN eventos_exposicoes ee ON eo.id_exposicao = ee.id_exposicao
        WHERE ee.id_evento = evento_id
    LOOP
        RAISE NOTICE 'Objeto: %, Tipo: %, Origem: %', objeto.nome, objeto.tipo, objeto.origem;
    END LOOP;

    -- 5. Obter comentários dos visitantes sobre exposições do evento
    FOR comentario IN
        SELECT v.nome AS visitante_nome, c.texto_comentario, e.nome AS exposicao_nome
        FROM comentarios c
        INNER JOIN visitantes v ON c.id_visitante = v.id_visitante
        INNER JOIN exposicoes e ON c.id_exposicao = e.id_exposicao
        INNER JOIN eventos_exposicoes ee ON e.id_exposicao = ee.id_exposicao
        WHERE ee.id_evento = evento_id
    LOOP
        RAISE NOTICE 'Visitante: %, Exposição: %, Comentário: %', comentario.visitante_nome, comentario.exposicao_nome, comentario.texto_comentario;
    END LOOP;

    -- Exibir informações gerais do evento
    RAISE NOTICE 'Evento: %, Descrição: %, Data: %, Visitantes: %, Total de Doações: %.2f',
        v_evento_nome, v_evento_descricao, v_evento_data, v_visita_count, v_total_doacao;
END;
$$;

CALL gerar_relatorio_evento(2);