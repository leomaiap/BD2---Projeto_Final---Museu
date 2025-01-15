--1 Um ingresso grátis no evento mais recente para o visitante fizer uma doação acima de 150 reais

CREATE OR REPLACE FUNCTION trigger_doar_ganhar_ingresso()
RETURNS TRIGGER AS $$
DECLARE
    prox_id_evento INTEGER;
    ingresso_proximo_id INTEGER;
BEGIN
    -- Verifica se a doação é maior que 150
    IF NEW.valor_doacao > 150 THEN
		RAISE NOTICE 'Voce tem direito a um ingresso grátis!'; 
        -- Encontra o evento mais recente
        SELECT id_evento INTO prox_id_evento
        FROM eventos
        --WHERE data >= CURRENT_TIMESTAMP -- se nos dados existirem a data de "Hoje" funciona, se não consideramos o evento com a maior data
        ORDER BY data DESC
        LIMIT 1;

        -- Se encontrou um evento futuro
        IF prox_id_evento IS NOT NULL THEN
            -- Pega o próximo ID disponível para ingressos
            SELECT COALESCE(MAX(id_ingresso) + 1, 1) INTO ingresso_proximo_id 
            FROM ingressos;

            -- Insere o ingresso grátis
            INSERT INTO ingressos (id_ingresso, id_visitante, id_evento, data_compra, valor) 
            VALUES (ingresso_proximo_id, NEW.id_visitante, prox_id_evento, CURRENT_TIMESTAMP, 0);
            
            RAISE NOTICE 'Ingresso grátis gerado para o visitante % no evento %', 
                         NEW.id_visitante, prox_id_evento;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criação do trigger
CREATE OR REPLACE TRIGGER tg_doar_ganhar_ingresso
AFTER INSERT ON doacoes
FOR EACH ROW
EXECUTE FUNCTION trigger_doar_ganhar_ingresso();

-- Inserir uma doação acima de 150 reais
INSERT INTO doacoes (id_doacao, id_visitante, id_objeto, valor_doacao)
VALUES (181, 1, 1, 200);

-- Verificar se o ingresso foi gerado
SELECT * FROM ingressos WHERE id_visitante = 1 AND valor = 0;

--------------------------------------------------------------------------

--2  Controle de Exclusividade de Comentários (o mesmo visitante nao pode comentar mais de uma vez em uma mesma esxposicao)
CREATE OR REPLACE FUNCTION exclusividade_comentarios()
RETURNS TRIGGER AS $$
BEGIN
    -- Verifica se já existe um comentário do mesmo visitante na mesma exposição
    IF EXISTS (
        SELECT 1 
        FROM comentarios
        WHERE id_visitante = NEW.id_visitante 
          AND id_exposicao = NEW.id_exposicao
    ) THEN
        -- Bloqueia a transação com uma mensagem de erro
        RAISE EXCEPTION 'Visitante % já comentou na exposição %', 
                         NEW.id_visitante, NEW.id_exposicao;
    END IF;

    -- Permite a inserção caso não haja conflito
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criação do trigger
CREATE OR REPLACE TRIGGER tg_exclusividade_comentarios
BEFORE INSERT ON comentarios
FOR EACH ROW
EXECUTE FUNCTION exclusividade_comentarios();

INSERT INTO comentarios (id_comentario, id_visitante, id_exposicao, texto_comentario) 
VALUES (100, 1, 2, 'Ótima exposição!');

INSERT INTO comentarios (id_comentario, id_visitante, id_exposicao, texto_comentario) 
VALUES (102, 1, 2, 'Gostei muito!');


