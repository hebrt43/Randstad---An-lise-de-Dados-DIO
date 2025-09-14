

use e_comerce_Projeto; 
-- Inserindo clientes PF e PJ 
INSERT INTO clients (Fname, Minit, Lname, CPF, CNPJ, Address, client_type)
VALUES
('Carlos', 'S', 'Silva', '12345678901', NULL, 'Rua A, 100', 'PF'),
('Maria', 'O', 'Oliveira', '23456789012', NULL, 'Rua B, 200', 'PF'),
('Tech Solutions', NULL, 'Ltda', NULL, '12345678000199', 'Av C, 300', 'PJ'),
('Comercial Alfa', NULL, 'Ltda', NULL, '98765432000188', 'Av D, 400', 'PJ');
 
-- Inserindo fornecedores 
INSERT INTO supplier (SocialName, CNPJ, contact)
VALUES
('Fornecedor A', '11111111000101', '31911110001'),
('Fornecedor B', '22222222000102', '31922220002');

-- Inserindo produtos
INSERT INTO product (Pname, clasification_kids, category, avaliacao, size)
VALUES
('TV32', false, 'Eletronico', 4.5, '32pol'),
('Boneca', true, 'Brinquedo', 4.8, 'Médio'),
('Camiseta', false, 'Vestuario', 4.2, 'M'),
('Biscoito', true, 'Alimenticio', 3.9, '200g'),
('Sofá', false, 'Moveis', 4.7, '3lug'),
('Carrinho', true, 'Brinquedo', 4.6, 'Pequeno');

-- Inserindo estoque
INSERT INTO productStorage (storageLocation, quantity)
VALUES
('Estoque Central', 10),
('Estoque Loja B', 50),
('Estoque Loja C', 100);

-- Inserindo vendedores
INSERT INTO seller (SocialName, CNPJ, CPF, location, contact)
VALUES
('João Vendas', NULL, '98765432100', 'Loja A', '31955550001'),
('Ana Comercial', NULL, '87654321099', 'Loja B', '31955550002');

-- Inserindo terceiros (transportadoras)
INSERT INTO third_parties (name, phone, email)
VALUES
('Transportadora Rápida', '31944440001', 'contato@transportadora.com'),
('Entrega Expressa', '31944440002', 'entrega@expressa.com');

-- Inserindo pedidos
INSERT INTO orders (idOrderClient, orderStatus, orderDescription, avaliacao, sendValue, paymentCash)
VALUES
(1, 'Confirmado', 'Compra de TV32 e Biscoitos', 4.8, 50, false),
(2, 'Em processamento', 'Compra de Boneca e Biscoitos', 4.5, 20, true),
(3, 'Cancelado', 'Pedido de Sofá cancelado', 0, 0, false),
(4, 'Confirmado', 'Compra de Camiseta e Biscoito', 4.7, 12, true);

-- Inserindo itens de pedidos
INSERT INTO productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
VALUES
(1, 1, 1, 'Disponivel'),  -- TV32
(4, 1, 5, 'Disponivel'),  -- Biscoitos
(2, 2, 1, 'Disponivel'),  -- Boneca
(4, 2, 3, 'Disponivel'),  -- Biscoitos
(5, 3, 1, 'Disponivel'),  -- Sofá (cancelado)
(3, 4, 1, 'Disponivel'),  -- Camiseta
(4, 4, 1, 'Disponivel');  -- Biscoito

-- Inserindo formas de pagamento
INSERT INTO payments (idClient, typePayment, limitAvailable)
VALUES
(1, 'Cartão', 2000.00),
(1, 'Pix', 500.00),
(2, 'Dinheiro', 300.00),
(3, 'Boleto', 1500.00),
(4, 'Pix', 500.00),
(4, 'Cartão', 1500.00);

-- Inserindo pagamentos dos pedidos
INSERT INTO orderPayments (idOrder, idPayment, amount)
VALUES
(1, 1, 1500.00),  -- Carlos pagou TV com Cartão
(1, 2, 80.00),    -- Carlos pagou Biscoitos com Pix
(2, 3, 120.00),   -- Maria pagou em Dinheiro
(3, 4, 1200.00),  -- Tech Solutions tentou boleto (cancelado)
(4, 5, 40.00),    -- Comercial Alfa Pix
(4, 6, 10.00);    -- Comercial Alfa Cartão

-- Inserindo entregas
INSERT INTO delivery (idOrder, deliveryStatus, trackingCode, thirdPartyID)
VALUES
(1, 'Em trânsito', 'TRK12345', 1),
(2, 'Pendente', 'TRK12346', 2),
(3, 'Cancelado', NULL, 1),
(4, 'Entregue', 'TRK12347', 2);
 -- Recuperação com Select
SELECT idClient, Fname, Lname, client_type, CPF, CNPJ
FROM clients;

SELECT Pname, category, avaliacao
FROM product;

-- Filtro com where
SELECT Fname, Lname, CPF
FROM clients
WHERE client_type = 'PF';

SELECT Pname, category, avaliacao
FROM product
WHERE clasification_kids = TRUE AND avaliacao > 4;

-- Nome completo do cliente
SELECT CONCAT(Fname, ' ', COALESCE(Minit,''), ' ', Lname) AS FullName
FROM clients;

-- valor total de cada pedido (somando itens + frete)
SELECT o.idOrder, SUM(oi.poQuantity * p.avaliacao) + o.sendValue AS TotalOrderValue
FROM orders o
JOIN productOrder oi ON o.idOrder = oi.idPOorder
JOIN product p ON oi.idPOproduct = p.idProduct
GROUP BY o.idOrder;

-- listar clientes por sobrenome em ordem alfabética:
SELECT Fname, Lname
FROM clients
ORDER BY Lname ASC;

-- listar produtos por avaliação decrescente:
SELECT Pname, category, avaliacao
FROM product
ORDER BY avaliacao DESC;

-- quantos pedidos cada cliente fez (somente clientes com mais de 1 pedido):
SELECT c.Fname, c.Lname, COUNT(o.idOrder) AS TotalOrders
FROM clients c
LEFT JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient
HAVING COUNT(o.idOrder) > 1;

-- produtos com estoque total acima de 50 unidades:
SELECT p.Pname, SUM(s.quantity) AS TotalStock
FROM product p
JOIN storageLocation sl ON p.idProduct = sl.idLProduct
JOIN productStorage s ON sl.idLStorage = s.idStorage
GROUP BY p.idProduct
HAVING SUM(s.quantity) > 50;

-- relação de produtos, fornecedores e quantidade em estoque:
SELECT p.Pname, s.SocialName AS SupplierName, ps.quantity AS SupplierQuantity, SUM(st.quantity) AS StockQuantity
FROM product p
JOIN productSupplier ps ON p.idProduct = ps.idPSProduct
JOIN supplier s ON ps.idPSupplier = s.idSupplier
LEFT JOIN storageLocation sl ON p.idProduct = sl.idLProduct
LEFT JOIN productStorage st ON sl.idLStorage = st.idStorage
GROUP BY p.idProduct, s.idSupplier;

-- nomes dos fornecedores e produtos que fornecem:
SELECT s.SocialName AS SupplierName, p.Pname AS ProductName
FROM supplier s
JOIN productSupplier ps ON s.idSupplier = ps.idPSupplier
JOIN product p ON ps.idPSProduct = p.idProduct
ORDER BY s.SocialName, p.Pname;

-- total de pedidos por cliente com valor total:
SELECT c.Fname, c.Lname, COUNT(o.idOrder) AS TotalOrders, SUM(o.sendValue) AS TotalSpent
FROM clients c
JOIN orders o ON c.idClient = o.idOrderClient
GROUP BY c.idClient
ORDER BY TotalSpent DESC;
