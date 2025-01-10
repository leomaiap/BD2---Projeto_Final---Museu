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

--2
