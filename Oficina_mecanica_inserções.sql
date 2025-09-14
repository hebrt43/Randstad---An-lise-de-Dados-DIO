use oficina_mecanica;
-- Clientes
INSERT INTO Cliente (nome, CPF)
VALUES
('Carlos Silva', '12345678901'),
('Maria Oliveira', '23456789012'),
('João Santos', '34567890123');

-- Veículos
INSERT INTO Veiculo (placa, modelo, idCliente)
VALUES
('ABC1234', 'Fiat Uno', 1),
('XYZ5678', 'Honda Civic', 2),
('LMN9876', 'Toyota Corolla', 3);

-- Serviços
INSERT INTO Servico (descricao, valor)
VALUES
('Troca de óleo', 150.00),
('Alinhamento e balanceamento', 120.00),
('Pintura completa', 1200.00),
('Revisão completa', 600.00),
('Substituição de freios', 300.00);

-- Funcionários
INSERT INTO Funcionario (nome, cargo)
VALUES
('Pedro', 'Mecânico'),
('Ana', 'Mecânica'),
('Carlos', 'Supervisor');

-- Ordens de Serviço
INSERT INTO OrdemServico (dataAbertura, status, idVeiculo)
VALUES
('2025-09-10', 'Aberta', 1),
('2025-09-11', 'Em andamento', 2),
('2025-09-12', 'Concluída', 3),
('2025-09-12', 'Aberta', 1);

-- OS_Servico (muitos para muitos)
INSERT INTO OS_Servico (idOS, idServico)
VALUES
(1, 1), -- Troca de óleo para OS1
(1, 2), -- Alinhamento OS1
(2, 4), -- Revisão completa OS2
(2, 5), -- Substituição de freios OS2
(3, 3), -- Pintura completa OS3
(4, 1); -- Troca de óleo OS4

-- OS_Funcionario (quem executou cada OS)
INSERT INTO OS_Funcionario (idOS, idFuncionario)
VALUES
(1, 1), -- Pedro na OS1
(1, 3), -- Carlos supervisionando OS1
(2, 2), -- Ana na OS2
(3, 1), -- Pedro na OS3
(3, 3), -- Carlos supervisionando OS3
(4, 2); -- Ana na OS4

-- Pagamentos
INSERT INTO Pagamento (idOS, tipo, valor, dataPagamento)
VALUES
(1, 'Cartão', 270.00, '2025-09-10'), -- OS1: Troca óleo + alinhamento
(2, 'Pix', 900.00, '2025-09-11'),    -- OS2: Revisão + freios
(3, 'Dinheiro', 1200.00, '2025-09-12'), -- OS3: Pintura completa
(4, 'Boleto', 150.00, NULL);         -- OS4: Troca óleo, ainda não pago

-- Histórico de OS
INSERT INTO HistoricoOS (idOS, dataStatus, status)
VALUES
(1, '2025-09-10', 'Aberta'),
(1, '2025-09-11', 'Em andamento'),
(2, '2025-09-11', 'Aberta'),
(2, '2025-09-12', 'Em andamento'),
(2, '2025-09-13', 'Concluída'),
(3, '2025-09-12', 'Aberta'),
(3, '2025-09-13', 'Concluída'),
(4, '2025-09-12', 'Aberta');




-- Pergunta: Quantas ordens cada cliente realizou?
SELECT c.nome AS Cliente, COUNT(o.idOS) AS TotalOrdens
FROM Cliente c
LEFT JOIN Veiculo v ON c.idCliente = v.idCliente
LEFT JOIN OrdemServico o ON v.idVeiculo = o.idVeiculo
GROUP BY c.idCliente
ORDER BY TotalOrdens DESC;

-- Pergunta: Quanto cada cliente gastou em serviços pagos?
SELECT c.nome AS Cliente, SUM(p.valor) AS TotalGasto
FROM Cliente c
JOIN Veiculo v ON c.idCliente = v.idCliente
JOIN OrdemServico o ON v.idVeiculo = o.idVeiculo
JOIN Pagamento p ON o.idOS = p.idOS
WHERE p.dataPagamento IS NOT NULL
GROUP BY c.idCliente
ORDER BY TotalGasto DESC;

-- Pergunta: Quantas vezes cada funcionário realizou cada serviço?
SELECT f.nome AS Funcionario, s.descricao AS Servico, COUNT(*) AS QtdeExecucoes
FROM Funcionario f
JOIN OS_Funcionario ofunc ON f.idFuncionario = ofunc.idFuncionario
JOIN OS_Servico os ON ofunc.idOS = os.idOS
JOIN Servico s ON os.idServico = s.idServico
GROUP BY f.idFuncionario, s.idServico
HAVING COUNT(*) > 0
ORDER BY f.nome, QtdeExecucoes DESC;

-- Pergunta: Listar ordens pendentes ou em execução com veículo e cliente
SELECT o.idOS, o.status, v.placa AS Veiculo, c.nome AS Cliente, o.dataAbertura
FROM OrdemServico o
JOIN Veiculo v ON o.idVeiculo = v.idVeiculo
JOIN Cliente c ON v.idCliente = c.idCliente
WHERE o.status IN ('Aberta', 'Em andamento')
ORDER BY o.dataAbertura ASC;

-- Pergunta: Qual o valor médio gasto em cada tipo de serviço?
SELECT s.descricao AS Servico, AVG(p.valor) AS ValorMedio
FROM Servico s
JOIN OS_Servico os ON s.idServico = os.idServico
JOIN Pagamento p ON os.idOS = p.idOS
WHERE p.dataPagamento IS NOT NULL
GROUP BY s.idServico
ORDER BY ValorMedio DESC;

-- Pergunta: Quais clientes já pagaram mais de uma ordem?
SELECT c.nome AS Cliente, COUNT(DISTINCT o.idOS) AS TotalPagas
FROM Cliente c
JOIN Veiculo v ON c.idCliente = v.idCliente
JOIN OrdemServico o ON v.idVeiculo = o.idVeiculo
JOIN Pagamento p ON o.idOS = p.idOS
WHERE p.dataPagamento IS NOT NULL
GROUP BY c.idCliente
HAVING COUNT(DISTINCT o.idOS) > 1
ORDER BY TotalPagas DESC;

-- Pergunta: Como evoluiu o status da OS #2 ao longo do tempo?
SELECT h.idOS, h.dataStatus, h.status
FROM HistoricoOS h
WHERE h.idOS = 2
ORDER BY h.dataStatus ASC;

-- Pergunta: Quais ordens ainda não foram pagas e por quem?
SELECT c.nome AS Cliente, o.idOS, SUM(p.valor) AS ValorPendentes
FROM Cliente c
JOIN Veiculo v ON c.idCliente = v.idCliente
JOIN OrdemServico o ON v.idVeiculo = o.idVeiculo
JOIN Pagamento p ON o.idOS = p.idOS
WHERE p.dataPagamento IS NULL
GROUP BY c.idCliente, o.idOS
ORDER BY ValorPendentes DESC;


