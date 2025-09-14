create database oficina_mecanica;
use oficina_mecanica;
-- Tabela de cliente
CREATE TABLE Cliente (
    idCliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    CPF CHAR(11) UNIQUE
);

-- Tabela de veiculo
CREATE TABLE Veiculo (
    idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa CHAR(7) UNIQUE,
    modelo VARCHAR(50),
    idCliente INT,
    FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente)
);
-- Tabela de OS
CREATE TABLE OrdemServico (
    idOS INT AUTO_INCREMENT PRIMARY KEY,
    dataAbertura DATE,
    status ENUM('Aberta','Em andamento','Concluída','Cancelada') DEFAULT 'Aberta',
    idVeiculo INT,
    FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo)
);

-- Tabela serviço
CREATE TABLE Servico (
    idServico INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255),
    valor DECIMAL(10,2)
);
-- Tabela OS_serviço
CREATE TABLE OS_Servico (
    idOS INT,
    idServico INT,
    PRIMARY KEY (idOS, idServico),
    FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    FOREIGN KEY (idServico) REFERENCES Servico(idServico)
);

-- Tabela Funcionario
CREATE TABLE Funcionario (
    idFuncionario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cargo VARCHAR(50)
);

-- Tabela Os por Funcionario

CREATE TABLE OS_Funcionario (
    idOS INT,
    idFuncionario INT,
    PRIMARY KEY (idOS, idFuncionario),
    FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS),
    FOREIGN KEY (idFuncionario) REFERENCES Funcionario(idFuncionario)
);
-- Tabela Pagamentos
CREATE TABLE Pagamento (
    idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    idOS INT,
    tipo ENUM('Dinheiro','Cartão','Pix','Boleto'),
    valor DECIMAL(10,2),
    dataPagamento DATE,
    FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS)
);
-- Tabela Historicos de serviços
CREATE TABLE HistoricoOS (
    idHistorico INT AUTO_INCREMENT PRIMARY KEY,
    idOS INT,
    dataStatus DATE,
    status ENUM('Aberta','Em andamento','Concluída','Cancelada'),
    FOREIGN KEY (idOS) REFERENCES OrdemServico(idOS)
);
	