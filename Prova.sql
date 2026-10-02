-------------

create table aeoranaves(
id serial primary key,
modelo varchar(50) not null,
codigo_cauda varchar(10) unique not null,
capacidade int check (capacidade > 0) not null

)

create table pilotos(
id serial primary key,
nome varchar(120) not null,
codigo_anac varchar(6) unique not null,
horas_voo int default 0 check (horas_voo > 0) not null

)

create table voos(
id serial primary key,
aeronaves_id int not null,
pilotos_id int not null,
numero_voo varchar(10) not null,
origem  varchar(100) not null,
destino varchar(100) not null,
data_hora timestamp default current_timestamp,
status varchar(20) default 'Agendado' check(status in ('Agendado','Em Voo', 'Concluido', 'Cancelado')),

CONSTRAINT fk_aeronaves_id
FOREIGN key (aeronaves_id)
REFERENCES aeronaves(id)
on delete cascade,

constraint fk_pilotos_id
FOREIGN key (pilotos_id)
REFERENCES pilotos(id)
on delete restrict
)

create table passageiros(
id serial primary key,
nome varchar (120) not null,
cpf varchar(11) unique not null,
email varchar (100) unique not null

)

create table passagens(
id serial primary key,
voos_id int not null,
passageiros_id int not null,
assento varchar(4) not null,
classe varchar(20) default 'Economica' check(classe in ('Economica', 'Executiva')),
valor numeric(10,2) check (valor > 0) not null,

CONSTRAINT fk_voos_id
FOREIGN key (voos_id)
REFERENCES voos(id)
on delete cascade,

constraint fk_passageiros_id
FOREIGN key (passageiros_id)
REFERENCES passageiros(id)
on delete restrict
)

------------------------------------------------------------------

insert into aeronaves(modelo, codigo_cauda, capacidade) values
('aviaoDesert','55','10'),
('aviaoHavai','70','33'),
('aviaoWave','4','6'),
('aviaoDawb','2','7'),
('aviaoNavi','9','10')

insert into pilotos(nome, codigo_anac, horas_voo) values
('Marcus','555333','5'),
('Fernando','722998','3'),
('Ronaldo','424267','2'),
('Victor','111222','4'),
('Eduardo','990001','1')

insert into passageiros(nome, cpf, email) values
('Luiz','11168900532','Luizao@gmail.com'),
('Felipe','79093256510','Felp@gmail.com'),
('Sandra','40020076791','Sandrax@gmail.com.br'),
('Priscila','33222547897','Priscilate@gmail.com'),
('Tatiane','27892372814','Tatizinha@gmail.com.br')


insert into voos(aeronaves_id, pilotos_id, origem, destino, numero_voo, status) values
('1','1','Brasil','Canada','1','Em Voo'),
('2','2','EUA','Japao','3','Agendado'),
('3','3','Brasil','Mexico','7','Concluido'),
('4','3','Portugal','Espanha','6','Em Voo'),
('5','5','Brasil','Chile','10','Cancelado')


insert into passagens(voos_id, passageiros_id, assento, classe, valor) values
('5','42','D23','Executiva','935.00'),
('7','31','C04','Economica','432.75'),
('9','89','A10','Economica','298.00'),
('10','56','B52','Executiva','1025.60'),
('3','70','A20','Economica','300.00')

---------------------------------------------------------



SELECT
    voos.numero_voo,
    voos.origem,
    voos.destino,
    aeronaves.modelo,
    pilotos.nome AS piloto
FROM voos
JOIN aeronaves 
    ON voos.aeronaves_id = aeronaves.id
JOIN pilotos
    ON voos.pilotos_id = pilotos.id
WHERE voos.status IN ('Agendado', 'Em Voo');

SELECT
    classe,
    SUM(valor) AS valor_total
FROM passagens
GROUP BY classe;


SELECT
    classe,
    SUM(valor) AS total_arrecadado
FROM passagens
GROUP BY classe;




SELECT
    p.nome AS passageiro,
    v.numero_voo,
    pa.assento,
    pa.valor
FROM passagens pa
JOIN passageiros p
    ON pa.passageiro_id = p.id
JOIN voos v
    ON pa.voo_id = v.id
WHERE pa.classe = 'Executiva'
  AND pa.valor > 800
ORDER BY pa.valor DESC;





CREATE VIEW vw_painel_aeroporto AS
SELECT
    v.numero_voo,
    v.data_hora,
    v.origem,
    v.destino,
    a.modelo,
    a.codigo_cauda,
    v.status
FROM voos v
JOIN aeronaves a
    ON v.aeronave_id = a.id;




CREATE VIEW vw_faturamento_por_voo AS
SELECT
    v.id AS voo_id,
    v.numero_voo,
    v.destino,
    COUNT(pa.id) AS quantidade_passageiros,
    COALESCE(SUM(pa.valor), 0) AS receita_total
FROM voos v
LEFT JOIN passagens pa
    ON v.id = pa.voo_id
GROUP BY
    v.id,
    v.numero_voo,
    v.destino;


