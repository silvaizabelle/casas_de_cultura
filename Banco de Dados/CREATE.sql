/*
Porte (idPorte(PK), qtdSala, metragem)

Evento(idEvento(PK), dataEvento, publicoExperado, publicoReal, localEvento)

Linguagem(idLinguagem(PK), tipo)

CasadeCultura(idCasa(PK), idPorte(FK) Referencia Porte(idPorte), nomeCasa, endereco, cordenador, capacidade)

Artista(idArtista(PK), tipoLing(FK) Referencia Linguagem(idLinguagem), nomeCompleto, email, telefone, endereco, genero, etnia, nomeArtistico)

ArtistaPF(idArtista(PK)(FK) Referencia Artista(isArtista), cpf)

ArtistaPJ(idArtista(PK)(FK) Referencia Artista(isArtista), cnpj)

Grupo(idGrupo(PK), tipoLing(FK) Referencia Linguagem(idLinguagem))

Participacao(idArtista(PK)(FK) Referencia Artista(isArtista), idGrupo(PK)(FK) Referencia Grupo(idGrupo), funcao)

ContratoEvento(idContrato(PK), idEvento(FK) Referencia Evento(idEvento), idCasa(FK) Referencia CasadeCultura(idCasa), idGrupo(FK) Referencia Grupo(idGrupo),idPagamento(FK) Referencia Pagamento(idPagamento) dataContrato)

Pagamento(idPagamento(PK), idContrato(FK) Referencia ContratoEvento(idContrato), dataAgendado, dataEfetivada)
*/

--Deixar as datas no formato Dia/Mes/Ano
SET DATESTYLE TO POSTGRES, DMY ;

--Criação tabela Porte 
DROP TABLE IF EXISTS porte CASCADE ;
CREATE TABLE porte (
	idPorte SMALLSERIAL PRIMARY KEY,
	qtdSala INT NOT NULL,
	metragem NUMERIC(8,2) NOT NULL
);

--Criação tabela Eventos
DROP TABLE IF EXISTS evento CASCADE ;
CREATE TABLE evento (
	idEvento SMALLSERIAL PRIMARY KEY,
	dataEvento DATE NOT NULL,
	publicoExperado SMALLINT, 
	publicoReal SMALLINT NOT NULL,
	localEvento VARCHAR(255) NOT NULL
);

--Criação tabela Linguagem
DROP TABLE IF EXISTS linguagem CASCADE ;
CREATE TABLE linguagem (
	idLinguagem SMALLSERIAL PRIMARY KEY,
	tipo VARCHAR(30) NOT NULL
);

--Criação tabela Casas de Cultura
DROP TABLE IF EXISTS casacultura CASCADE ;
CREATE TABLE casacultura (
	idCasa SMALLSERIAL PRIMARY KEY,
	idPorte SMALLINT NOT NULL REFERENCES porte(idPorte) ON DELETE CASCADE ON UPDATE CASCADE,
	nomeCasa VARCHAR(50),
	endereco VARCHAR(255) NOT NULL,
	regiao VARCHAR(15) NOT NULL,
	cordenador VARCHAR(50) NOT NULL,
	capacidade INT NOT NULL
);

--Criação tabela Artista
DROP TABLE IF EXISTS artista CASCADE ;
CREATE TABLE artista (
	idArtista SMALLSERIAL PRIMARY KEY,
	tipoLing SMALLINT NOT NULL REFERENCES linguagem(idLinguagem) ON DELETE CASCADE ON UPDATE CASCADE,
	nomeCompleto VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL,
	telefone VARCHAR(15) NOT NULL,
	endereco VARCHAR(100) NOT NULL,
	genero VARCHAR(30),
	etnia VARCHAR(30),
	nomeArtistico VARCHAR(50) NOT NULL
);

--Criação tabela Artista Pessoa Fisica
DROP TABLE IF EXISTS artistapf CASCADE ;
CREATE TABLE artistapf (
	idArtista SMALLINT PRIMARY KEY,
	cpf CHAR(11) NOT NULL,
	FOREIGN KEY (idArtista) REFERENCES artista(idArtista) ON DELETE CASCADE ON UPDATE CASCADE
);

--Criação tabela Artista Pessoa Juridica
DROP TABLE IF EXISTS artistapj CASCADE ;
CREATE TABLE artistapj (
	idArtista SMALLINT PRIMARY KEY,
	cnpj CHAR(14) NOT NULL,
	FOREIGN KEY (idArtista) REFERENCES artista(idArtista) ON DELETE CASCADE ON UPDATE CASCADE
);
--Criação tabela Grupo
DROP TABLE IF EXISTS grupo CASCADE ;
CREATE TABLE grupo (
	idGrupo SMALLSERIAL PRIMARY KEY,
	tipoLing SMALLINT NOT NULL REFERENCES linguagem(idLinguagem) ON DELETE CASCADE ON UPDATE CASCADE
);

--Criação tabela Participação
DROP TABLE IF EXISTS participacao CASCADE ;
CREATE TABLE participacao (
	idArtista SMALLINT,
	idGrupo SMALLINT,
	funcao VARCHAR(30) NOT NULL,
	PRIMARY KEY(idArtista, idGrupo),
	FOREIGN KEY (idArtista) REFERENCES artista(idArtista) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (idGrupo) REFERENCES grupo(idGrupo) ON DELETE CASCADE ON UPDATE CASCADE
);

--Criação tabela Contrato do Evento
DROP TABLE IF EXISTS contratoevento CASCADE ; 
CREATE TABLE contratoevento (
	idContrato SMALLSERIAL PRIMARY KEY,
	idEvento SMALLINT NOT NULL REFERENCES evento(idEvento) ON DELETE CASCADE ON UPDATE CASCADE,
	idCasa SMALLINT NOT NULL REFERENCES casacultura(idCasa) ON DELETE CASCADE ON UPDATE CASCADE,
	idGrupo SMALLINT NOT NULL REFERENCES grupo(idGrupo) ON DELETE CASCADE ON UPDATE CASCADE,
	dataContrato DATE NOT NULL
);

--Criação tabela Pagamento
DROP TABLE IF EXISTS pagamento CASCADE ;
CREATE TABLE pagamento (
	idPagamento SMALLSERIAL PRIMARY KEY,
	idContrato SMALLINT NOT NULL REFERENCES contratoevento(idContrato) ON DELETE CASCADE ON UPDATE CASCADE,
	valorPag NUMERIC(8,2),
	dataAgendado DATE NOT NULL,
	dataEfetivada TIMESTAMP NOT NULL
);

-- ****************************************************
-- VALOR TOTAL INVESTIDO POR REGIÃO da Casa de Cultura
-- ****************************************************
SELECT COUNT(p.idpagamento) as qtde_eventos,ROUND(AVG(p.valorpag),2) as valor_medio,SUM(p.valorpag),cc.regiao 
FROM contratoevento c
INNER JOIN casacultura cc ON c.idcasa = cc.idcasa
INNER JOIN pagamento p ON c.idcontrato = p.idcontrato
GROUP BY cc.regiao

-- ****************************************************
-- VALOR INVESTIDO POR TIPO DE LINGUAGEM
-- ****************************************************
SELECT COUNT(p.idpagamento) as qtde_eventos,
ROUND(AVG(p.valorpag),2) as valor_medio,SUM(p.valorpag) as valor_total,l.tipo 
FROM contratoevento cc 
INNER JOIN grupo g ON g.idgrupo = cc.idgrupo
INNER JOIN pagamento p ON cc.idcontrato = p.idcontrato
INNER JOIN linguagem l ON l.idlinguagem = g.tipoling
GROUP BY l.tipo



