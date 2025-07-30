-- Criação do banco de dados para o cenário E-commerce

Create database if not exists ecommerce_2;

use ecommerce_2;

-- drop database ecommerce_2; 

show databases;
show tables;

-- drop table client;
-- criar tabela cliente
create table if not exists clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
	Minit varchar(3), 
    Lname varchar(20),
    CPF char(11) not null,
    Adress varchar(30),
    Constraint unique_cpf_client unique (CPF) 
    );

alter table clients auto_increment = 1; -- para possibilitar a inserção de valores

insert into clients (Fname, Minit, Lname, CPF, Adress)
	values ('Maria', 'M', 'Silva', '12346789', 'rua silva'),
		   ('Matheus', 'OM', 'Pimentel', '02346789', 'rua k'),
           ('Ricardo', 'F', 'Silva', '12246789', 'rua cidade'),
           ('Julia', 'S', 'França', '12345489', 'rua centro'),
           ('Roberta', 'G', 'Assis', '73346789', 'rua sl'),
           ('Isabela', 'M', 'Cruz', '42346789', 'rua lamatine mendes');

select * from clients;

-- criar tabela produto
-- size = dimensão do produto

create table if not exists product(
	idProduct int auto_increment primary key,
    Pname varchar(10),
	Classification_kids bool default false, 
    Category enum('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') not null,
    Avaliação float default 0,
    size varchar(10)
    );

insert into product (Pname, Classification_kids, category, avaliação, size)
	values ('Fone de ', false, 'Eletrônico', '4', null),
		   ('Barbie ', true, 'Brinquedos', '3', null),
           ('Body', true, 'Vestimenta', '3', null),
           ('Microfone', false, 'Eletrônico', '4', null),
           ('Sofá Retr', false, 'Móveis', '3', '3x57x80'),
           ('Farinha', false, 'Alimentos', '2', null),
           ('Fire St', false, 'Eletrônico', '3', null);


-- drop table payments;
-- criar tabela pedido
create table if not exists payments(
	idClient int,
    idPayment int unique,
    idOrder int,
    typePayment enum('Boleto', 'Cartão', 'Dois cartões') not null,
    limitAvaiable float,
    primary key (idClient, idPayment, idOrder)
    );



-- criar tabela pedido
create table if not exists orders(
	idOrder int auto_increment primary key,
    idOrderClient int,
    orderStatus enum('Cancelado', 'Confirmado', 'Em processamento') default 'Em processamento',
    orderDescription varchar(255),
    sendValue float default 10,
    paymentCash bool default false,
    idPayment int,
    Constraint fk_order_client foreign key (idOrderClient) references clients(idClient),
    Constraint fk_idPayment foreign key (idPayment) references payments(idPayment)
		on update cascade               -- ajusta nas demais tabelas também, relacionado as constraints/restricoes
    );
    
    insert into payments (idClient, idPayment, idOrder, typePayment, limitAvaiable)
	values (1, 1, 1, 'Boleto', 10000),
		   (2, 2, 2, 'Cartão', 5000);
    
    insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, paymentCash, idPayment)
	values (1, null, 'compra via app', null, 1, 1),
		   (2, null, 'compra via app', 50, 0, 2),
		   (3, null, 'confirmado', null, 1, null),
		   (4, null, 'compra via web', 150, 0, null);
    


-- criar tabela estoque
create table if not exists productStorage(
	idProdStorage int auto_increment primary key,
    storagyLocation varchar(255),
    quantity int default 0
    );

insert into productStorage (storagyLocation, quantity)
	values ('Rio de Janeiro', 1000),
		   ('Rio de Janeiro', 500),
           ('São Paulo', 10),
           ('São Paulo', 100),
           ('São Paulo', 10),
           ('Brasília', 60);

-- criar tabela fornecedor
create table if not exists supplier(
	idSupplier int auto_increment primary key,
    SocialName varchar(255) not null,
    CNPJ char(15) not null,
    contact char(11) not null,
    Constraint unique_supplier unique (CNPJ)
    );

insert into supplier (SocialName, CNPJ, contact)
	values('Almeida e Filhos', 123456789123456, '21905474'),
          ('Eletronicos Silva', 854519649143457, '21905484');


-- criar tabela vendedor
create table if not exists seller(
	idSeller int auto_increment primary key,
    SocialName varchar(255) not null,
    AbsName varchar (255),
    CNPJ char(15),
    CPF char(9),
    location varchar(255),
    contact char(11) not null,
    Constraint unique_cnpj_seller unique (CNPJ),
    Constraint unique_cpf_seller unique (CPF)
    );
desc seller;

insert into seller (SocialName, AbsName, CNPJ, CPF, location, contact)
	values('Tech eletronicsAlmeida e Filhos', null, 123456789456321, null, 'RJ', '219946287'),
          ('Botique Burgas', null, null, 123456783, 'RJ', '219567895'),
          ('Kids Worls', null, 456789123654485, null, 'SP', '1190657484');



create table if not exists productSeller(
	idPseller int,
    idSproduct int,
    prodQuantity int not null default 1,
    primary key (idPSeller, idSproduct),
    Constraint fk_product_seller foreign key (idPseller) references seller(idseller), 
    Constraint fk_product_product foreign key (idSproduct) references product(idProduct) 
    );

create table if not exists productOrder(
	idPOproduct int,
    idPOorder int,
    poQuantity int not null default 1,
    poStatus enum ('Disponível', 'Sem estoque') default 'Disponível',
    primary key (idPOproduct, idPOorder),
    Constraint fk_productorder_seller foreign key (idPOproduct) references product(idProduct), 
    Constraint fk_productorder_product foreign key (idPOorder) references orders(idOrder) 
    );

select * from productOrder;
select * from Orders;

insert into productOrder (idPOproduct, idPOorder, poQuantity, poStatus)
	values (1, 1, 2, null),
		   (2, 1, 1, null),
           (3, 2, 1, null);
        
        select * from orders;
           
create table if not exists storageLocation(
	idLproduct int,
    idLstorage int,
    location varchar(255) not null,
    primary key (idLproduct, idLstorage),
    Constraint fk_storage_location_product foreign key (idLproduct) references product(idProduct), 
    Constraint fk_storage_location_storage foreign key (idLstorage) references productStorage(idProdStorage) 
    );

insert into storageLocation (idLproduct, idLstorage, location)
	values(1, 2, 'RJ'),
          (2, 6, 'GO');

create table if not exists productSupplier(
	idPsSupplier int,
    idPsProduct int,
    quantity int not null,
    primary key (idPsSupplier, idPsProduct),
    Constraint fk_product_supplier_supplier foreign key (idPsSupplier) references supplier(idSupplier), 
    Constraint fk_product_supplier_product foreign key (idPsProduct) references product(idProduct) 
    );


show tables;

show databases;
use information_schema;
show tables;
desc referential_constraints;

select * from referential_constraints
	where constraint_schema = 'ecommerce';

use ecommerce;

select * from clients;
select count(*) from clients;

desc orders;
select * from orders;
select * from clients c, orders o
	where c.idClient = idOrderClient;

select concat(Fname, ' ', Lname) as Client, orderDescription as Compra from clients c, orders o
	where c.idClient = idOrderClient;

select * from clients
	left outer join orders on idClient = idOrderClient;

select * from clients
	right outer join orders on idClient = idOrderClient;

select * from clients c
	inner join orders o on c.idClient = o.idOrderClient
    inner join productOrder p on p.idPOorder = o.idOrder;

select * from clients c
	inner join orders o on c.idClient = o.idOrderClient
    inner join productOrder p on p.idPOorder = o.idOrder
    order by Fname desc;


select c.idClient, Fname, count(*) from clients c
	inner join orders o on c.idClient = o.idOrderClient
    inner join productOrder p on p.idPOorder = o.idOrder
    group by idClient
    order by Fname asc;

select c.idClient, Fname, count(*) from clients c
	inner join orders o on c.idClient = o.idOrderClient
    inner join productOrder p on p.idPOorder = o.idOrder
    group by idClient
    having idClient > 1 #having associa-se ao group by
    order by Fname asc;