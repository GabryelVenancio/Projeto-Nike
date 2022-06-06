/**
	Lojinha
    @author Gabryel
    @version 1.1
*/

create database lojinhatenis2;
use lojinhatenis2;

-- unique (não permitir valores duplicados)
create table usuarios(
	idusu int primary key auto_increment,
    usuario varchar(255) not null,
    login varchar(10) not null unique,
    senha varchar(255) not null,
    perfil varchar(20) not null
);

describe usuarios;

-- para inserir uma senha com criptografia usamos md5()
insert into usuarios(usuario,login,senha,perfil)
values('Administrador','admin',md5('admin'),'admin');
insert into usuarios(usuario,login,senha,perfil)
values('gabryel','byel',md5('123456'),'user');

select * from usuarios;

select * from usuarios where login='admin' and senha=md5('admin');

create table fornecedores (
	idfor int primary key auto_increment,
    cnpj varchar(255) not null unique,
    ie varchar(255) unique,
    im varchar(255) unique,
    razao varchar(255) not null,
    fantasia varchar(255) not null,
    site varchar(255),
    fone varchar(255) not null,
    contato varchar(255),     
	email varchar(255),
    cep varchar(255) not null,
    endereco varchar(255) not null,
    numero varchar(255) not null,
    complemento varchar(255),
    bairro varchar(255) not null,
    cidade varchar(255) not null,
    uf char(2) not null,
    obs varchar(255)
);

insert into fornecedores
(cnpj,razao,fantasia,fone,cep,endereco,numero,bairro,cidade,uf)
values ('17.127.927/0001-99','Nike Inc','Nike','9999-1234','03307-000',
'Rua Tuiuti','2769','Tatuapé','São Paulo','SP');

insert into fornecedores
(cnpj,razao,fantasia,fone,cep,endereco,numero,bairro,cidade,uf)
values ('17.712.729/1001-99','Adidas Inc','Adidas','9999-3214','7330-000',
'Rua Tuiuti','2569','Tatuapé','São Paulo','SP');

select * from fornecedores;

create table produtos(
	codigo int primary key auto_increment,
    barcode varchar(255) unique,
    produto varchar(255) not null,
    descricao varchar(255) not null,
    fabricante varchar(255) not null,
    datacad timestamp default current_timestamp,
    dataval date not null,
    estoque int not null,
    estoquemin int not null,
    unidade varchar(255) not null,
    localizacao varchar(255),
    custo decimal(10,2) not null,
    lucro decimal(10,2),
    venda decimal(10,2),
    idfor int not null,
    foreign key(idfor) references fornecedores(idfor)
);

describe produtos;

insert into produtos(barcode,produto,descricao,fabricante,dataval,
estoque,estoquemin,unidade,localizacao,custo,lucro,venda,idfor)
values
('12345678910','Air Jordan','Tênis para os fans do Michael Jordan','Nike',
20240523,20,5,'UN','Prateleira 2',75.00,75.00,150.00,1);

insert into produtos(barcode,produto,descricao,fabricante,dataval,
estoque,estoquemin,unidade,localizacao,custo,lucro,venda,idfor)
values
('12345678911','Air Max 97','Referência em robustez amortecimento e conforto','Nike',
20240525,2,5,'UN','Prateleira 3',350.00,450.00,800.00,1);

insert into produtos(barcode,produto,descricao,fabricante,dataval,
estoque,estoquemin,unidade,localizacao,custo,lucro,venda,idfor)
values
('12345678912','Dunk High 1985','Criado para as quadras, mas levado às ruas','Nike',
20210525,20,5,'UN','Prateleira 5',200.00,250.00,450.00,1);

insert into produtos(barcode,produto,descricao,fabricante,dataval,
estoque,estoquemin,unidade,localizacao,custo,lucro,venda,idfor)
values
('123456789013','MB 01 RICK & MORTY','O tênis Basketball MB.01 x RICK & MORTY faz parte dessa collab icônica',
'Puma',20270525,5,10,'CX','Prateleira 7',350.00,350.00,700.00,1);

insert into produtos(barcode,produto,descricao,fabricante,dataval,
estoque,estoquemin,unidade,localizacao,custo,lucro,venda,idfor)
values
('123456789014','Air Force 1','O brilho perdura no Nike Air Force 1 o tênis original do basquete',
'Nike',20270525,50,100,'CX','Prateleira 9',250.00,250.00,500.00,1);

select * from produtos;

select sum(estoque * custo) as total from produtos;

select * from produtos where estoque < estoquemin;

select codigo as código,produto,
date_format(dataval,'%d/%m/%Y') as data_validade,
estoque, estoquemin as estoque_mínimo
from produtos where estoque < estoquemin;

select codigo as código,produto,
date_format(dataval,'%d/%m/%Y') as data_validade
from produtos;

select codigo as código,produto,
date_format(dataval,'%d/%m/%Y') as data_validade,
datediff(dataval,curdate()) as dias_restantes
from produtos;

create table clientes (
	idcli int primary key auto_increment,
    nome varchar(255) not null,
    fone varchar(255) not null,
    cpf varchar(255) unique,
    email varchar(255),
    marketing varchar(255) not null,
    cep varchar(255),
    endereco varchar(255),
    numero varchar(255),
    complemento varchar(255),
    bairro varchar(255),
    cidade varchar(255),
    uf char(2)
);

insert into clientes(nome,fone,marketing)
values('Manu','99999-4321','não');

select * from clientes;

create table pedidos (
	pedido int primary key auto_increment,
    dataped timestamp default current_timestamp,
    total decimal(10,2),
    idcli int not null,
    foreign key(idcli) references clientes(idcli)
);

insert into pedidos(idcli) values(1);

select * from pedidos;

select * from pedidos inner join clientes on pedidos.idcli = clientes.idcli;

select
pedidos.pedido,
date_format(pedidos.dataped,'%d/%m/%Y - %H:%i') as data_ped,
clientes.nome as cliente,
clientes.fone
from pedidos inner join clientes
on pedidos.idcli = clientes.idcli;

create table carrinho (
	pedido int not null,
    codigo int not null,
    quantidade int not null,
    foreign key(pedido) references pedidos(pedido),
	foreign key(codigo) references produtos(codigo)
);

insert into carrinho values (2,3,2);

insert into carrinho values (1,4,2);

select * from carrinho;

select pedidos.pedido,
carrinho.codigo as código,
produtos.produto,
carrinho.quantidade,
produtos.venda,
produtos.venda * carrinho.quantidade as sub_total
from (carrinho inner join pedidos on carrinho.pedido =
pedidos.pedido)
inner join produtos on carrinho.codigo = produtos.codigo;

select sum(produtos.venda * carrinho.quantidade) as total
from carrinho inner join produtos
on carrinho.codigo = produtos.codigo;

update carrinho
inner join produtos
on carrinho.codigo = produtos.codigo
set produtos.estoque = produtos.estoque - carrinho.quantidade
where carrinho.quantidade > 0;