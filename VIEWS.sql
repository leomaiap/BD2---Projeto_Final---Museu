--1 View de Exposições e Objetos
CREATE VIEW view_exposicoes_objetos AS
SELECT e.nome AS nome_exposicao, o.nome AS nome_objeto, o.tipo, o.origem
FROM exposicoes e
JOIN exposicoes_objetos eo ON e.id_exposicao = eo.id_exposicao
JOIN objetos o ON eo.id_objeto = o.id_objeto;

SELECT * FROM view_exposicoes_objetos;

--2 Transparência Patrocinadores e seus Valores de Doação em Exposições
CREATE VIEW view_patrocinadores_exposicoes AS
SELECT p.nome AS nome_patrocinador, p.tipo, e.nome AS nome_exposicao, pe.valor_doado
FROM patrocinadores_exposicoes pe
JOIN patrocinadores p ON pe.id_patrocinador = p.id_patrocinador
JOIN exposicoes e ON pe.id_exposicao = e.id_exposicao;

SELECT * FROM view_patrocinadores_exposicoes;