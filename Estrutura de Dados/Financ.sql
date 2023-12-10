CREATE DATABASE Financ;
USE Financ;

CREATE TABLE Cliente (
    ClienteID INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100),
    CPF VARCHAR(14) UNIQUE,
    UF CHAR(2),
    Celular VARCHAR(20)
);

CREATE TABLE Financiamento (
    FinanciamentoID INT AUTO_INCREMENT PRIMARY KEY,
    CPF VARCHAR(14),
    TipoFinanciamento VARCHAR(50),
    ValorTotal DECIMAL(18, 2),
    DataUltimoVencimento DATE,
    FOREIGN KEY (CPF) REFERENCES Cliente(CPF)
);

CREATE TABLE Parcela (
    ParcelaID INT AUTO_INCREMENT PRIMARY KEY,
    FinanciamentoID INT,
    NumeroParcela INT,
    ValorParcela DECIMAL(18, 2),
    DataVencimento DATE,
    DataPagamento DATE,
    FOREIGN KEY (FinanciamentoID) REFERENCES Financiamento(FinanciamentoID)
);

INSERT INTO Cliente (Nome, CPF, UF, Celular)
VALUES ('Theo', '12345678900', 'SP', '123456789');

INSERT INTO Financiamento (CPF, TipoFinanciamento, ValorTotal, DataUltimoVencimento)
VALUES ('12345678900', 'Tipo A', 5000.00, '2023-12-31');

INSERT INTO Parcela (FinanciamentoID, NumeroParcela, ValorParcela, DataVencimento, DataPagamento)
VALUES (1, 1, 5000.00, '2023-01-31', '2023-01-25');

INSERT INTO Cliente (Nome, CPF, UF, Celular)
VALUES ('Maria Silva', '11122233344', 'SP', '11987654321');

INSERT INTO Financiamento (CPF, TipoFinanciamento, ValorTotal, DataUltimoVencimento)
VALUES ('11122233344', 'Financiamento X', 7500.00, '2023-12-31');

INSERT INTO Parcela (FinanciamentoID, NumeroParcela, ValorParcela, DataVencimento, DataPagamento)
VALUES (1, 2, 1500.00, '2023-02-28', NULL);

INSERT INTO Cliente (Nome, CPF, UF, Celular)
VALUES ('João Oliveira', '55566677788', 'RJ', '2199998888');

INSERT INTO Financiamento (CPF, TipoFinanciamento, ValorTotal, DataUltimoVencimento)
VALUES ('55566677788', 'Financiamento Y', 10000.00, '2023-11-30');

INSERT INTO Parcela (FinanciamentoID, NumeroParcela, ValorParcela, DataVencimento, DataPagamento)
VALUES (2, 1, 2000.00, '2023-01-15', NULL);

INSERT INTO Cliente (Nome, CPF, UF, Celular)
VALUES ('Ana Souza', '12345678901', 'SP', '1199887766');

-- Inserção de financiamento para o cliente '12345678901'
INSERT INTO Financiamento (CPF, TipoFinanciamento, ValorTotal, DataUltimoVencimento)
VALUES ('12345678901', 'Financiamento A', 8000.00, '2023-12-31');

-- Inserção de parcelas pagas para o financiamento do cliente '12345678901'
INSERT INTO Parcela (FinanciamentoID, NumeroParcela, ValorParcela, DataVencimento, DataPagamento)
VALUES
    ((SELECT FinanciamentoID FROM Financiamento WHERE CPF = '12345678901'), 1, 2000.00, '2023-01-31', '2023-01-25'),
    ((SELECT FinanciamentoID FROM Financiamento WHERE CPF = '12345678901'), 2, 2000.00, '2023-02-28', '2023-02-20'),
    ((SELECT FinanciamentoID FROM Financiamento WHERE CPF = '12345678901'), 3, 2000.00, '2023-03-31', NULL);

-- Inserção de cliente com parcelas sem atraso
INSERT INTO Cliente (Nome, CPF, UF, Celular)
VALUES ('Carlos Oliveira', '98765432101', 'SP', '11997776666');

-- Inserção de financiamento para o cliente '98765432101'
INSERT INTO Financiamento (CPF, TipoFinanciamento, ValorTotal, DataUltimoVencimento)
VALUES ('98765432101', 'Financiamento B', 9000.00, '2023-12-31');

-- Inserção de parcelas com vencimento no futuro para o cliente '98765432101'
INSERT INTO Parcela (FinanciamentoID, NumeroParcela, ValorParcela, DataVencimento, DataPagamento)
VALUES
    ((SELECT FinanciamentoID FROM Financiamento WHERE CPF = '98765432101'), 1, 3000.00, '2024-01-31', NULL),
    ((SELECT FinanciamentoID FROM Financiamento WHERE CPF = '98765432101'), 2, 3000.00, '2024-02-29', NULL);

-- Inserção de cliente com parcela sem atraso no RJ (para totalizar 4 clientes)
INSERT INTO Cliente (Nome, CPF, UF, Celular)
VALUES ('Fernanda Santos', '22233344455', 'RJ', '21998887777');

-- Inserção de financiamento para o cliente '22233344455'
INSERT INTO Financiamento (CPF, TipoFinanciamento, ValorTotal, DataUltimoVencimento)
VALUES ('22233344455', 'Financiamento C', 7500.00, '2023-11-30');

-- Inserção de parcela com vencimento no futuro para o cliente '22233344455'
INSERT INTO Parcela (FinanciamentoID, NumeroParcela, ValorParcela, DataVencimento, DataPagamento)
VALUES
    ((SELECT FinanciamentoID FROM Financiamento WHERE CPF = '22233344455'), 1, 2500.00, '2024-01-15', NULL);

#Listar todos os clientes do estado de SP que possuem mais de 60% das parcelas pagas:
SELECT C.ClienteID, C.Nome, C.CPF, COUNT(P.ParcelaID) AS TotalParcelas,
       SUM(CASE WHEN P.DataPagamento IS NOT NULL THEN 1 ELSE 0 END) AS ParcelasPagas
FROM Cliente C
JOIN Financiamento F ON C.CPF = F.CPF
LEFT JOIN Parcela P ON F.FinanciamentoID = P.FinanciamentoID
WHERE C.UF = 'SP'
GROUP BY C.ClienteID, C.Nome, C.CPF
HAVING (SUM(CASE WHEN P.DataPagamento IS NOT NULL THEN 1 ELSE 0 END) / COUNT(P.ParcelaID)) > 0.6;

#Listar os primeiros quatro clientes que possuem alguma parcela com mais de cinco dias sem atraso (Data Vencimento maior que data atual E data pagamento nula):
SELECT DISTINCT C.ClienteID, C.Nome, C.CPF
FROM Cliente C
JOIN Financiamento F ON C.CPF = F.CPF
JOIN Parcela P ON F.FinanciamentoID = P.FinanciamentoID
WHERE P.DataVencimento > CURDATE() AND P.DataPagamento IS NULL
ORDER BY P.DataVencimento ASC
LIMIT 4;

DELIMITER //

CREATE PROCEDURE InserirClienteFinanciamentoParcela(
    IN pNome VARCHAR(100),
    IN pCPF VARCHAR(14),
    IN pUF CHAR(2),
    IN pCelular VARCHAR(20),
    IN pTipoFinanciamento VARCHAR(50),
    IN pValorTotal DECIMAL(18, 2),
    IN pDataUltimoVencimento DATE,
    IN pParcelasDataVencimento DATE,
    IN pParcelasValor DECIMAL(18, 2)
)
BEGIN
    DECLARE lastClienteID INT;
    DECLARE lastFinanciamentoID INT;

    -- Inserção de Cliente
    INSERT INTO Cliente (Nome, CPF, UF, Celular)
    VALUES (pNome, pCPF, pUF, pCelular);

    -- Último ID inserido na tabela Cliente
    SET lastClienteID = LAST_INSERT_ID();

    -- Inserção de Financiamento
    INSERT INTO Financiamento (CPF, TipoFinanciamento, ValorTotal, DataUltimoVencimento)
    VALUES (pCPF, pTipoFinanciamento, pValorTotal, pDataUltimoVencimento);

    -- Último ID inserido na tabela Financiamento
    SET lastFinanciamentoID = LAST_INSERT_ID();

    -- Inserção de Parcela
    INSERT INTO Parcela (FinanciamentoID, NumeroParcela, ValorParcela, DataVencimento, DataPagamento)
    VALUES (lastFinanciamentoID, 1, pParcelasValor, pParcelasDataVencimento, NULL);
END //

DELIMITER ;

CALL InserirClienteFinanciamentoParcela(
    'Clecio',
    '287756654546',
    'SP',
    '1199877888',
    'Financiamento Z',
    8000.00,
    '2024-12-31',
    '2025-01-31',
    1000.00
);