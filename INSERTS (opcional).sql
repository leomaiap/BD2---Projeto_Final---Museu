-- Função auxiliar para gerar datas aleatórias
CREATE OR REPLACE FUNCTION random_date(start_date timestamp, end_date timestamp) 
RETURNS timestamp AS $$
BEGIN
    RETURN start_date + random() * (end_date - start_date);
END;
$$ LANGUAGE plpgsql;

-- Inserções
DO $$
DECLARE
	v_tipo_participacao TEXT;
    v_papel TEXT;
    v_id_objeto INTEGER;
    v_id_exposicao INTEGER;
    v_id_visitante INTEGER;
    v_id_evento INTEGER;
    v_id_funcionario INTEGER;
    v_id_curador INTEGER;
    v_id_patrocinador INTEGER;
BEGIN
    -- Inserir Objetos
    FOR i IN 1..20 LOOP
        INSERT INTO objetos (id_objeto, nome, tipo, origem, data)
        VALUES (
            i,
            'Objeto ' || i,
            (ARRAY['Pintura', 'Escultura', 'Fotografia', 'Artefato'])[floor(random() * 4 + 1)],
            (ARRAY['França', 'Brasil', 'Itália', 'Espanha', 'EUA'])[floor(random() * 5 + 1)],
            random_date('2020-01-01'::timestamp, '2023-12-31'::timestamp)
        ) RETURNING id_objeto INTO v_id_objeto;
    END LOOP;

    -- Inserir Exposições
    FOR i IN 1..10 LOOP
        INSERT INTO exposicoes (id_exposicao, nome, descricao, data_inicio, data_fim)
        VALUES (
            i,
            'Exposição ' || i,
            'Descrição da exposição ' || i,
            random_date('2024-01-01'::timestamp, '2024-06-30'::timestamp),
            random_date('2024-07-01'::timestamp, '2024-12-31'::timestamp)
        ) RETURNING id_exposicao INTO v_id_exposicao;
    END LOOP;

    -- Inserir Visitantes
    FOR i IN 1..50 LOOP
        INSERT INTO visitantes (id_visitante, nome, email, data_nascimento)
        VALUES (
            i,
            'Visitante ' || i,
            'visitante' || i || '@email.com',
            random_date('1960-01-01'::timestamp, '2005-12-31'::timestamp)
        ) RETURNING id_visitante INTO v_id_visitante;
    END LOOP;

    -- Inserir Pesquisadores
    FOR i IN 1..10 LOOP
        INSERT INTO pesquisadores (id_pesquisador, nome, especialidade, id_objeto)
        VALUES (
            i,
            'Pesquisador ' || i,
            (ARRAY['História', 'Arte', 'Arqueologia', 'Restauração'])[floor(random() * 4 + 1)],
            floor(random() * 20 + 1)
        );
    END LOOP;

    -- Inserir Coleções
    FOR i IN 1..8 LOOP
        INSERT INTO colecoes (id_colecao, nome, descricao, id_objeto)
        VALUES (
            i,
            'Coleção ' || i,
            'Descrição da coleção ' || i,
            floor(random() * 20 + 1)
        );
    END LOOP;

    -- Inserir Funcionários
    FOR i IN 1..15 LOOP
        INSERT INTO funcionarios (id_funcionario, nome, cargo, setor)
        VALUES (
            i,
            'Funcionário ' || i,
            (ARRAY['Curador', 'Guia', 'Segurança', 'Administrativo'])[floor(random() * 4 + 1)],
            (ARRAY['Exposição', 'Administrativo', 'Segurança', 'Manutenção'])[floor(random() * 4 + 1)]
        ) RETURNING id_funcionario INTO v_id_funcionario;
    END LOOP;

    -- Inserir Eventos
    FOR i IN 1..12 LOOP
        INSERT INTO eventos (id_evento, nome, descricao, data)
        VALUES (
            i,
            'Evento ' || i,
            'Descrição do evento ' || i,
            random_date('2024-01-01'::timestamp, '2024-12-31'::timestamp)
        ) RETURNING id_evento INTO v_id_evento;
    END LOOP;

    -- Inserir Patrocinadores
    FOR i IN 1..6 LOOP
        INSERT INTO patrocinadores (id_patrocinador, nome, tipo)
        VALUES (
            i,
            'Patrocinador ' || i,
            (ARRAY['Empresa', 'Fundação', 'Pessoa Física', 'Instituição'])[floor(random() * 4 + 1)]
        ) RETURNING id_patrocinador INTO v_id_patrocinador;
    END LOOP;

    -- Inserir Curadores
    FOR i IN 1..5 LOOP
        INSERT INTO curadores (id_curador, nome)
        VALUES (
            i,
            'Curador ' || i
        ) RETURNING id_curador INTO v_id_curador;
    END LOOP;

    -- Inserir Ingressos
    FOR i IN 1..100 LOOP
        INSERT INTO ingressos (id_ingresso, id_visitante, id_evento, data_compra, valor)
        VALUES (
            i,
            floor(random() * 50 + 1),
            floor(random() * 12 + 1),
            random_date('2024-01-01'::timestamp, '2024-12-31'::timestamp),
            20
        );
    END LOOP;

    -- Inserir Doações
    FOR i IN 1..30 LOOP
        INSERT INTO doacoes (id_doacao, id_visitante, id_objeto, valor_doacao, data_doacao)
        VALUES (
            i,
            floor(random() * 50 + 1),
            floor(random() * 20 + 1),
            floor(random() * 1000 + 100),
			random_date('2024-01-01'::timestamp, '2024-12-31'::timestamp)
        );
    END LOOP;

    -- Inserir Comentários
    FOR i IN 1..80 LOOP
        INSERT INTO comentarios (id_comentario, id_visitante, id_exposicao, texto_comentario)
        VALUES (
            i,
            floor(random() * 50 + 1),
            floor(random() * 10 + 1),
            'Comentário ' || i || ' sobre a exposição'
        );
    END LOOP;

    -- Inserir Transferências
    FOR i IN 1..15 LOOP
        INSERT INTO transferencias (id_transferencia, id_objeto, destino, data_transferencia)
        VALUES (
            i,
            floor(random() * 20 + 1),
            (ARRAY['Reserva Técnica', 'Restauração', 'Exposição Itinerante', 'Empréstimo'])[floor(random() * 4 + 1)],
            random_date('2024-01-01'::timestamp, '2024-12-31'::timestamp)
        );
    END LOOP;

    -- Inserir Exposições_Objetos
    FOR i IN 1..30 LOOP
    -- Gera valores aleatórios para id_exposicao e id_objeto
    v_id_exposicao := floor(random() * 10 + 1);
    v_id_objeto := floor(random() * 20 + 1);

    -- Insere apenas se a combinação ainda não existir
    IF NOT EXISTS (
        SELECT 1 
        FROM exposicoes_objetos 
        WHERE id_exposicao = v_id_exposicao 
        AND id_objeto = v_id_objeto
	    ) THEN
	        INSERT INTO exposicoes_objetos (id_exposicao, id_objeto)
	        VALUES (v_id_exposicao, v_id_objeto);
	    END IF;
	END LOOP;

    -- Inserir Patrocinadores_Exposicoes
	FOR i IN 1..15 LOOP
    -- Gera valores aleatórios para id_patrocinador e id_exposicao
    v_id_patrocinador := floor(random() * 6 + 1);
    v_id_exposicao := floor(random() * 10 + 1);

    -- Insere apenas se a combinação ainda não existir
    IF NOT EXISTS (
	        SELECT 1 
	        FROM patrocinadores_exposicoes 
	        WHERE id_patrocinador = v_id_patrocinador 
	        AND id_exposicao = v_id_exposicao
	    ) THEN
	        INSERT INTO patrocinadores_exposicoes (id_patrocinador, id_exposicao, valor_doado)
	        VALUES (v_id_patrocinador, v_id_exposicao, floor(random() * 10000 + 1000));
	    END IF;
	END LOOP;

    -- Inserir Curadores_Exposicoes
    FOR i IN 1..20 LOOP
        -- Gerar valores aleatórios
        v_id_curador := floor(random() * 5 + 1);
        v_id_exposicao := floor(random() * 10 + 1);

        -- Verificar se a combinação já existe antes de inserir
        IF NOT EXISTS (
            SELECT 1
            FROM curadores_exposicoes
            WHERE id_curador = v_id_curador
              AND id_exposicao = v_id_exposicao
        ) THEN
            INSERT INTO curadores_exposicoes (id_curador, id_exposicao)
            VALUES (v_id_curador, v_id_exposicao);
        END IF;
    END LOOP;

    -- Inserir Funcionarios_Exposicoes
    FOR i IN 1..25 LOOP
        -- Gerar valores aleatórios
        v_id_funcionario := floor(random() * 15 + 1);
        v_id_exposicao := floor(random() * 10 + 1);
        v_papel := (ARRAY['Curador', 'Guia', 'Segurança', 'Suporte'])[floor(random() * 4 + 1)];

        -- Realizar a verificação e inserção
        IF NOT EXISTS (
            SELECT 1
            FROM funcionarios_exposicoes
            WHERE id_funcionario = v_id_funcionario
              AND id_exposicao = v_id_exposicao
        ) THEN
            INSERT INTO funcionarios_exposicoes (id_funcionario, id_exposicao, papel)
            VALUES (v_id_funcionario, v_id_exposicao, v_papel);
        END IF;
    END LOOP;

    -- Inserir Funcionarios_Eventos
	FOR i IN 1..25 LOOP
	    -- Gera valores aleatórios uma vez e armazena em variáveis
	    v_id_funcionario := floor(random() * 15 + 1);
	    v_id_evento := floor(random() * 12 + 1);
	    v_papel := (ARRAY['Coordenador', 'Auxiliar', 'Suporte', 'Segurança'])[floor(random() * 4 + 1)];
	
	    -- Realiza o INSERT apenas se os valores não existirem
	    IF NOT EXISTS (
	        SELECT 1
	        FROM funcionarios_eventos
	        WHERE id_funcionario = v_id_funcionario
	          AND id_evento = v_id_evento
	    ) THEN
	        INSERT INTO funcionarios_eventos (id_funcionario, id_evento, papel)
	        VALUES (v_id_funcionario, v_id_evento, v_papel);
	    END IF;
	END LOOP;

    -- Inserir Eventos_Visitantes
    FOR i IN 1..30 LOOP
        -- Gerar valores aleatórios
        v_id_evento := floor(random() * 12 + 1);
        v_id_visitante := floor(random() * 50 + 1);
        v_tipo_participacao := (ARRAY['Participante', 'VIP', 'Convidado', 'Regular'])[floor(random() * 4 + 1)];

        -- Verificar se a combinação já existe antes de inserir
        IF NOT EXISTS (
            SELECT 1
            FROM eventos_visitantes
            WHERE id_evento = v_id_evento
              AND id_visitante = v_id_visitante
        ) THEN
            INSERT INTO eventos_visitantes (id_evento, id_visitante, tipo_participacao)
            VALUES (v_id_evento, v_id_visitante, v_tipo_participacao);
        END IF;
    END LOOP;

    -- Inserir Eventos_Exposicoes
    FOR i IN 1..50 LOOP
        -- Gerar valores aleatórios
        v_id_evento := floor(random() * 12 + 1);
        v_id_exposicao := floor(random() * 10 + 1);

        -- Verificar se a combinação já existe
        IF NOT EXISTS (SELECT 1 FROM eventos_exposicoes WHERE id_evento = v_id_evento AND id_exposicao = v_id_exposicao) THEN
            -- Inserir os dados
            INSERT INTO eventos_exposicoes (id_evento, id_exposicao)
            VALUES (v_id_evento, v_id_exposicao);
        END IF;
    END LOOP;

END $$;
