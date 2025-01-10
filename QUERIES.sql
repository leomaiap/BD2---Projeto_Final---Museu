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

--5

--6

--7

--8

--9

--10
