create database e_comerce_Projeto;
use e_comerce_Projeto;

-- Tabela Clientes PF/PJ
CREATE TABLE clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    Fname VARCHAR(50),
    Minit CHAR(3),
    Lname VARCHAR(50),
    CPF CHAR(11) DEFAULT NULL,
    CNPJ CHAR(14) DEFAULT NULL,
    Address VARCHAR(255),
    client_type ENUM('PF','PJ') NOT NULL,
    CONSTRAINT unique_cpf_client UNIQUE (CPF),
    CONSTRAINT unique_cnpj_client UNIQUE (CNPJ),
    CONSTRAINT chk_client_type CHECK (
        (client_type='PF' AND CPF IS NOT NULL AND CNPJ IS NULL) OR
        (client_type='PJ' AND CNPJ IS NOT NULL AND CPF IS NULL)
    )
);
ALTER TABLE clients AUTO_INCREMENT=1;


-- Tabela Produtos
CREATE TABLE product (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    Pname VARCHAR(50) NOT NULL,
    clasification_kids BOOL DEFAULT FALSE,
    category ENUM('Eletronico','Brinquedo','Vestuario','Alimenticio','Moveis') NOT NULL,
    avaliacao FLOAT DEFAULT 0,
    size VARCHAR(10)
);


-- Tabela Fornecedores
CREATE TABLE supplier (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_supplier UNIQUE (CNPJ)
);

-- Tabela Estoque
CREATE TABLE productStorage (
    idStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(255),
    quantity INT DEFAULT 0
);

-- Tabela Vendedor
CREATE TABLE seller (
    idSeller INT AUTO_INCREMENT PRIMARY KEY,
    SocialName VARCHAR(255) NOT NULL,
    CNPJ CHAR(14),
    CPF CHAR(11),
    location VARCHAR(255),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_seller UNIQUE (CNPJ),
    CONSTRAINT unique_cpf_seller UNIQUE (CPF)
);

-- Tabela Terceiros (transportadoras, etc.)
CREATE TABLE third_parties (
    idThird INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone CHAR(11),
    email VARCHAR(100)
);

-- Tabela Pedidos
CREATE TABLE orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT NOT NULL,
    orderStatus ENUM('Cancelado','Confirmado','Em processamento') DEFAULT 'Em processamento',
    orderDescription VARCHAR(255),
    avaliacao FLOAT DEFAULT 0,
    sendValue FLOAT DEFAULT 10,
    paymentCash BOOL DEFAULT FALSE,
    FOREIGN KEY (idOrderClient) REFERENCES clients(idClient) ON UPDATE CASCADE
);

-- Tabela Itens do Pedido
CREATE TABLE productOrder (
    idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponivel','Sem Estoque') DEFAULT 'Disponivel',
    PRIMARY KEY (idPOproduct, idPOorder),
    FOREIGN KEY (idPOproduct) REFERENCES product(idProduct),
    FOREIGN KEY (idPOorder) REFERENCES orders(idOrder)
);

-- Tabela Relação Produto-Fornecedor
CREATE TABLE productSupplier (
    idPSupplier INT,
    idPSProduct INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPSupplier, idPSProduct),
    FOREIGN KEY (idPSupplier) REFERENCES supplier(idSupplier),
    FOREIGN KEY (idPSProduct) REFERENCES product(idProduct)
);

-- Tabela Produto-Vendedor
CREATE TABLE productSeller (
    idPSeller INT,
    idPProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPSeller, idPProduct),
    FOREIGN KEY (idPSeller) REFERENCES seller(idSeller),
    FOREIGN KEY (idPProduct) REFERENCES product(idProduct)
);

-- Tabela Estoque por Produto
CREATE TABLE storageLocation (
    idLProduct INT,
    idLStorage INT,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (idLProduct, idLStorage),
    FOREIGN KEY (idLProduct) REFERENCES product(idProduct),
    FOREIGN KEY (idLStorage) REFERENCES productStorage(idStorage)
);

-- Tabela Pagamentos (multi-forma por cliente/pedido)
CREATE TABLE payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT NOT NULL,
    typePayment ENUM('Boleto','Cartão','Pix','Dinheiro') NOT NULL,
    limitAvailable FLOAT DEFAULT 0,
    FOREIGN KEY (idClient) REFERENCES clients(idClient) ON DELETE CASCADE
);

-- Tabela Pagamentos de Pedidos (multi-forma)
CREATE TABLE orderPayments (
    idOrderPayment INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    idPayment INT NOT NULL,
    amount FLOAT NOT NULL,
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder) ON DELETE CASCADE,
    FOREIGN KEY (idPayment) REFERENCES payments(idPayment) ON DELETE CASCADE
);

-- Tabela Entrega
CREATE TABLE delivery (
    idDelivery INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT NOT NULL,
    deliveryStatus ENUM('Pendente','Em trânsito','Entregue','Cancelado') DEFAULT 'Pendente',
    trackingCode VARCHAR(50),
    thirdPartyID INT,
    FOREIGN KEY (idOrder) REFERENCES orders(idOrder) ON DELETE CASCADE,
    FOREIGN KEY (thirdPartyID) REFERENCES third_parties(idThird)
);


show tables;