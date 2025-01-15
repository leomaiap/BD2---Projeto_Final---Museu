--1 Visitantes que fizeram doações e também deixaram comentários
SELECT DISTINCT v.nome,
       v.email,
       o.nome as objeto_doado,
       e.nome as exposicao_comentada,
       c.texto_comentario
FROM visitantes v
JOIN doacoes d ON v.id_visitante = d.id_visitante
JOIN comentarios c ON v.id_visitante = c.id_visitante
JOIN objetos o ON d.id_objeto = o.id_objeto
JOIN exposicoes e ON c.id_exposicao = e.id_exposicao;

--2 Visitantes que compraram ingressos para múltiplos eventos
SELECT v.nome,
       v.email,
       e.nome as evento,
       i.data_compra,
       i.valor
FROM visitantes v
JOIN ingressos i ON v.id_visitante = i.id_visitante
JOIN eventos e ON i.id_evento = e.id_evento
WHERE v.id_visitante IN (
    SELECT id_visitante
    FROM ingressos
    GROUP BY id_visitante
    HAVING COUNT(DISTINCT id_evento) > 1
)
ORDER BY v.nome, i.data_compra;

--3 Objetos sem pesquisador associado em exposições
SELECT o.nome as objeto,
       o.tipo,
       e.nome as exposicao
FROM objetos o
JOIN exposicoes_objetos eo ON o.id_objeto = eo.id_objeto
JOIN exposicoes e ON eo.id_exposicao = e.id_exposicao
LEFT JOIN pesquisadores p ON o.id_objeto = p.id_objeto
WHERE p.id_pesquisador IS NULL;

--4 Exposições mais comentadas e média de comentários por visitante
SELECT e.nome as exposicao,
       COUNT(c.id_comentario) as total_comentarios,
       COUNT(DISTINCT c.id_visitante) as visitantes_unicos,
       COUNT(c.id_comentario)::float / COUNT(DISTINCT c.id_visitante) as media_comentarios_por_visitante
FROM exposicoes e
LEFT JOIN comentarios c ON e.id_exposicao = c.id_exposicao
GROUP BY e.nome
ORDER BY total_comentarios DESC;

--5 Funcionários e seus papéis em exposições
SELECT f.nome AS funcionario, fe.papel, e.nome AS exposicao
FROM funcionarios f
JOIN funcionarios_exposicoes fe ON f.id_funcionario = fe.id_funcionario
JOIN exposicoes e ON fe.id_exposicao = e.id_exposicao
ORDER BY e.nome, fe.papel;

--6 Lista de pesquisadores e os objetos que estudam
SELECT p.nome AS pesquisador, p.especialidade, o.nome AS objeto
FROM pesquisadores p
LEFT JOIN objetos o ON p.id_objeto = o.id_objeto
ORDER BY p.nome;

--7 Ingressos vendidos para um evento específico
SELECT i.id_ingresso, v.nome AS visitante, i.data_compra, i.valor
FROM ingressos i
JOIN visitantes v ON i.id_visitante = v.id_visitante
JOIN eventos e ON i.id_evento = e.id_evento
WHERE e.nome = 'Evento 1';

--8 Comentários deixados por visitantes em exposições específicas
SELECT v.nome AS visitante, ex.nome AS exposicao, c.texto_comentario
FROM comentarios c
JOIN visitantes v ON c.id_visitante = v.id_visitante
JOIN exposicoes ex ON c.id_exposicao = ex.id_exposicao
WHERE ex.nome = 'Nome da Exposição';

--9  Eventos e exposições que ocorreram em um período específico
SELECT e.nome AS evento, ex.nome AS exposicao
FROM eventos e
JOIN eventos_exposicoes ee ON e.id_evento = ee.id_evento
JOIN exposicoes ex ON ee.id_exposicao = ex.id_exposicao
WHERE e.data BETWEEN '2024-01-01' AND '2024-7-31';

--10 Objetos transferidos para um destino específico
SELECT o.nome AS objeto, t.destino, t.data_transferencia
FROM objetos o
JOIN transferencias t ON o.id_objeto = t.id_objeto
WHERE t.destino = 'Restauração'
ORDER BY t.data_transferencia DESC;