--SELECTS Pedidos
--Quantidade de artistas contratatos(3 FORMAS DE SE EXECUTAR A CONSULTA)
SELECT COUNT(*) AS qtdArtistas FROM artista;

SELECT COUNT(idartista) AS qtdArtistas FROM participacao;

SELECT COUNT(p.idArtista) AS qtdArtistas 
FROM participacao p INNER JOIN grupo g
	ON p.idgrupo = g.idgrupo
INNER JOIN contratoevento ct
	ON p.idgrupo = ct.idgrupo;

--Pessoas por etnia
SELECT COUNT(*) AS qtdPessoas, a.etnia FROM Artista a
GROUP BY a.etnia
ORDER BY COUNT(*) DESC, a.etnia;

--Pessoas por genero
SELECT COUNT(a.genero) AS qtdPessoas, a.genero FROM Artista a
GROUP BY a.genero
ORDER BY COUNT(a.genero) DESC;

--Valor das Contratações por mês
SELECT EXTRACT(MONTH FROM ce.datacontrato) AS Mes, SUM(p.valorpag) AS Valor_Total_Mes 
FROM contratoevento ce INNER JOIN pagamento p
	ON p.idcontrato = ce.idcontrato
GROUP BY EXTRACT(MONTH FROM ce.datacontrato)
ORDER BY EXTRACT(MONTH FROM ce.datacontrato);

-- Total e Media investido por região das Casas de Cultura
SELECT COUNT(p.idpagamento) as qtde_eventos,ROUND(AVG(p.valorpag),2) as valor_medio,SUM(p.valorpag) AS total_investido,cc.regiao 
FROM contratoevento c
INNER JOIN casacultura cc ON c.idcasa = cc.idcasa
INNER JOIN pagamento p ON c.idcontrato = p.idcontrato
GROUP BY cc.regiao
ORDER BY qtde_eventos DESC;

-- Total e Media investido Separados por linguagem
SELECT COUNT(p.idpagamento) as qtde_eventos, ROUND(AVG(p.valorpag),2) as valor_medio,SUM(p.valorpag) as valor_total,l.tipo AS linguagem 
FROM contratoevento cc 
INNER JOIN grupo g ON g.idgrupo = cc.idgrupo
INNER JOIN pagamento p ON cc.idcontrato = p.idcontrato
INNER JOIN linguagem l ON l.idlinguagem = g.tipoling
GROUP BY l.tipo
ORDER BY qtde_eventos DESC;