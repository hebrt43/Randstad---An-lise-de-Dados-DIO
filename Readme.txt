Descrição do Desafio
Replique a modelagem do projeto lógico de banco de dados para o cenário de e-commerce. Fique atento as definições de chave primária e estrangeira, assim como as constraints presentes no cenário modelado. Perceba que dentro desta modelagem haverá relacionamentos presentes no modelo EER. Sendo assim, consulte como proceder para estes casos. Além disso, aplique o mapeamento de modelos aos refinamentos propostos no módulo de modelagem conceitual.

Assim como demonstrado durante o desafio, realize a criação do Script SQL para criação do esquema do banco de dados. Posteriormente, realize a persistência de dados para realização de testes. Especifique ainda queries mais complexas dos que apresentadas durante a explicação do desafio. Sendo assim, crie queries SQL com as cláusulas abaixo:

Recuperações simples com SELECT Statement
Filtros com WHERE Statement
Crie expressões para gerar atributos derivados
Defina ordenações dos dados com ORDER BY
Condições de filtros aos grupos – HAVING Statement
Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados
Diretrizes
Não há um mínimo de queries a serem realizadas;
Os tópicos supracitados devem estar presentes nas queries;
Elabore perguntas que podem ser respondidas pelas consultas;
As cláusulas podem estar presentes em mais de uma query;
O projeto deverá ser adicionado a um repositório do Github para futura avaliação do desafio de projeto. Adicione ao Readme a descrição do projeto lógico para fornecer o contexto sobre seu esquema lógico apresentado.

Objetivo:
[Relembrando] Aplique o mapeamento para o  cenário:

“Refine o modelo apresentado acrescentando os seguintes pontos”

Cliente PJ e PF – Uma conta pode ser PJ ou PF, mas não pode ter as duas informações;
Pagamento – Pode ter cadastrado mais de uma forma de pagamento;
Entrega – Possui status e código de rastreio;
Algumas das perguntas que podes fazer para embasar as queries SQL:

Quantos pedidos foram feitos por cada cliente?
Algum vendedor também é fornecedor?
Relação de produtos fornecedores e estoques;
Relação de nomes dos fornecedores e nomes dos produtos;


abaixo os queries usadas


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
