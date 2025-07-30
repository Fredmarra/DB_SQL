-- Criação do banco de dados do zero para o cenário Oficina

Create database if not exists carWorkshop;

use carWorkshop;

-- drop database carWorkshop; 

show databases;
show tables;

-- drop table Mechanics;

create table if not exists Mechanics(
	idMechanic int auto_increment primary key,
    NameMech varchar(20),
    CPF char(11) not null,
	Adress varchar(80), 
    Phone char (11) not null,
    Specialty enum('Bodywork', 'Electrical', 'Engine', 'Others'),
    Constraint unique_cpf_mechanic unique (CPF) 
    );

insert into Mechanics (NameMech, CPF, Adress, Phone, Specialty)
	values ('Maria', 12345678912, 'Rua f, Cannaa, MG', '61981397777', 'Bodywork'),
		   ('José', 12375678912, 'Rua kf, Guanabara, SP', '61987597777', 'Electrical'),
           ('Ana', 12345624912, 'Rua Abelardo, Aguas, DF', '61981967777', 'Engine'),
           ('Fred', 12344178912, 'Rua Risoto, Cannaa, MG', '61981392177', 'Others'),
           ('Antônio', 12393678912, 'Rua Pastel, Leblon, RJ', '61987897777', 'Engine'),
           ('Zila', 12345678292, 'Rua Doce, Cannaa, SP', '61981393337', 'Bodywork');
           
select * from mechanics;

create table if not exists teamMechanics(
	idTeamM int not null,
    idMechanic int not null,
	primary key (idTeamM, idMechanic),
    Constraint fk_TMidMechanic foreign key (idMechanic) references Mechanics (idMechanic) 
    );

insert into teamMechanics (idTeamM, idMechanic)
	values (1, 1),
		   (1, 4),
           (1, 5),
           (2, 3),
           (3, 6),
           (4, 2),
           (4, 6);
    
select * from teammechanics
	order by idTeamM;



create table if not exists parts(
	idPart int auto_increment primary key,
    partDescription varchar(80),
    qttStorage int,
    unitaryPrice float,
    Constraint unique_parts unique (idPart) 
    );

insert into parts (partDescription, qttStorage, unitaryPrice)
	values ('Motor AP para todos os tipos até 1990', 12, 5000.0),
           ('Limpador de parabrisa', 84, 35.2),
           ('Pneu 14/180', 15, 450.0),
           ('Farol completo', 10, 350.7),
           ('lampada farolete', 115, 15.0),
           ('correia dentada', 17, 317.5),
           ('Oleo', 58, 60.8),
           ('porta', 5, 1287.0);

create table if not exists clients(
	idClient int auto_increment primary key,
    Fname varchar(10),
	Minit varchar(3), 
    Lname varchar(20),
    CPF char(11) not null,
    Adress varchar(30),
    Phone char (11) not null,
    Constraint unique_cpf_client unique (CPF) 
    );

insert into clients (Fname, Minit, Lname, CPF, Adress, Phone)
	values ('Maria', 'S', 'Almeida', 17445678912, 'Rua der, Cannaa, MG', '61981397857'),
		   ('Zé', 'R', 'Santos', 17448278912, 'Rua ser, Guanabara, DF', '61981397857'),
           ('Anamelia', 'E', 'Silva', 17915678912, 'Rua ver, Aguias, MG', '61981397857'),
           ('Frederick', 'J', 'Carvalho', 17625678912, 'Rua vart, Ceilandia, DF', '61981397857'),
           ('Antônio', 'S', 'Almeida', 17445674212, 'Rua aloerer, Cannaa, MG', '61981397857'),
           ('Zuleide',  'M', 'Mota', 17445678987, 'Rua derasdas, Leblon, RJ', '61981397857');
           

-- alter table clients auto_increment = 1; -- para possibilitar a inserção de valores

select * from clients;
desc clients;

create table if not exists vehicle(
	idVehicle int auto_increment primary key,
    idClient int,
    Brand enum('Ford', 'Chevrolet', 'BYD', 'Others'),
	Model varchar(15), 
    Plate char (7) not null,
    idTeamM int,
    Constraint fk_client foreign key (idClient) references clients(idClient)
    -- Constraint fk_TMechanics foreign key (idTeamM) references teamMechanics(idTeamM)
    );

insert into vehicle (idClient, Brand, Model, Plate, idTeamM)
	values (1 , 'Ford', 'Fiesta', 'AEF7423', 2),
           (2 , 'Ford', null, 'AAS7423', 1),
           (1 , 'BYD', 'Dolphin', 'AEF7773', 3),
           (3 , 'Chevrolet', 'Onix', 'AEF6633', 2),
           (4 , 'Others', 'Miura Saga', 'ASD7423', 1);

select * from vehicle;
-- drop table serviceOrder;

create table if not exists serviceOrder(
	idSO int auto_increment primary key,
    idVehicle int,
    startDate date,
    Price float,
    StatusSO enum('Aberta', 'Em execução', 'Concluída'),
	ExpectEndDate date,
    idTeamM int
    -- idMechanic int,
    -- Constraint fk_SO_TMechanics foreign key (idTeamM, idMechanic) references teamMechanics(idTeamM, idMechanic)
    );

select * from serviceOrder;

insert into serviceOrder (idVehicle, startDate, Price, StatusSO, ExpectEndDate, idTeamM)
	values (1 , '2025-01-15', 5750.0, 'Concluída', '2025-01-18', 2),
           (2 , '2024-10-22', null, 'Em execução', '2025-08-15', 1),
           (3 , '2025-06-27', null, 'Aberta', '2025-09-03', 3);
 
 
 create table if not exists serviceOrderParts(
	idSO int,
    idPart int,
    Constraint fk_SOP_serviceOrder foreign key (idSO) references serviceOrder(idSO),
    Constraint fk_SOP_parts foreign key (idPart) references parts(idPart)
    );

  
insert into serviceOrderParts (idSO, idPart)
	values (1, 1),
           (1, 2),
           (1, 4),
           (1, 8),
           (2, 6),
           (2, 5);
           

show tables;

select * from vehicle;
select count(*) from serviceOrder;

select * from teamMechanics t
	inner join mechanics m on t.idMechanic = m.idMechanic
    order by idTeamM;

select * from teamMechanics t
	inner join mechanics m on t.idMechanic = m.idMechanic
    where m.specialty = 'Engine'
	order by idTeamM;

select concat(c.Fname, ' ', c.Lname) as Client, v.Brand as Car, s.idSO, s.price
	from clients c
	inner join vehicle v on c.idClient = v.idClient
    inner join serviceOrder s on v.idVehicle = s.idVehicle;
    

	select v.Brand as Car, sum(s.price)
	from vehicle v
    inner join serviceOrder s on v.idVehicle = s.idVehicle
    where v.brand = 'Ford'
    group by car;
 
 	select * from vehicle v
		inner join serviceOrder s on v.idVehicle = s.idVehicle
		inner join serviceOrderParts p on s.idSO = p.idSO
        inner join parts pa on p.idPart = pa.idPart;
 
  
 	select v.Brand as Car, sum(s.price), count(p.IdPart) from vehicle v
		inner join serviceOrder s on v.idVehicle = s.idVehicle
		inner join serviceOrderParts p on s.idSO = p.idSO
		group by v.Brand;
  --  where v.brand = 'Ford'
  --  group by car;
 
 select v.idClient, v.brand as car, count(p.idPart), round((sum(pa.unitaryPrice)),2) from vehicle v
		inner join serviceOrder s on v.idVehicle = s.idVehicle
		inner join serviceOrderParts p on s.idSO = p.idSO
        inner join parts pa on p.idPart = pa.idPart
        Group BY v.idClient, v.brand
        Having count(p.idPart) > 2
        Order by car asc
        ;
 
 
desc mechanics;
desc teamMechanics;
desc clients;
desc vehicle;
desc serviceOrder;
desc parts;
desc serviceOrderParts;



use information_schema;
show tables;
desc referential_constraints;

select * from referential_constraints
	where constraint_schema = 'carWorkshop';
