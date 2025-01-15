DROP INDEX idx_doacoes_id_visitante, idx_comentarios_id_visitante;

CREATE EXTENSION IF NOT EXISTS pg_trgm;

--Primeira consulta
CREATE INDEX idx_doacoes_id_visitante ON doacoes(id_visitante);
CREATE INDEX idx_comentarios_id_visitante ON comentarios(id_visitante);
CREATE INDEX idx_doacoes_id_objeto ON doacoes(id_objeto);
CREATE INDEX idx_comentarios_id_exposicao ON comentarios(id_exposicao); --Usado na quarta Consulta

--Segunda Consulta
CREATE INDEX idx_ingressos_id_visitante ON ingressos(id_visitante);
CREATE INDEX idx_ingressos_id_evento ON ingressos(id_evento);

--Terceira Consulta
CREATE INDEX idx_exposicoes_objetos_id_objeto ON exposicoes_objetos(id_objeto);
CREATE INDEX idx_exposicoes_objetos_id_exposicao ON exposicoes_objetos(id_exposicao);

CREATE INDEX idx_pesquisadores_id_objeto ON pesquisadores(id_objeto)
WHERE id_pesquisador IS NULL;

--Quarta Consulta utiliza um dos índices criados para a primeira

--Quinta Consulta
CREATE INDEX idx_funcionarios_exposicoes_id_funcionario ON funcionarios_exposicoes(id_funcionario);
CREATE INDEX idx_funcionarios_exposicoes_id_exposicao ON funcionarios_exposicoes(id_exposicao);

--Sexta Consulta
CREATE INDEX idx_objetos_id_objeto ON objetos(id_objeto);

--Sétima Consulta
CREATE INDEX idx_eventos_nome ON eventos USING gin(nome gin_trgm_ops);

--Oitava Consulta
CREATE INDEX idx_exposicoes_nome ON exposicoes USING gin(nome gin_trgm_ops);

--Nona Consulta
CREATE INDEX idx_eventos_data ON eventos(data);

--Décima Consulta
CREATE INDEX idx_transferencias_destino ON transferencias(destino);




