Create database Faculdade ;
use  Faculdade ;

create table Aluno
(
Ra varchar(20) not null,
Cpf varchar(14) not null,
Nome varchar(50) not null,
Data_Nascimento date not null,
End_Logradouro varchar(30) NOT NULL,
End_Numero varchar(10) NOT NULL,
End_Bairro varchar(20) NOT NULL,
End_Complemento varchar(20) NOT NULL,
End_Cidade varchar(20) NOT NULL,
End_Uf varchar(20) NOT NULL,
End_Cep varchar(10) NOT NULL

CONSTRAINT PK_Aluno PRIMARY KEY (Ra)
);

Create table Disciplina
(
ID int identity(1,1),
Nome varchar(30) not null,
Carga_Horaria int not null,

CONSTRAINT PK_Disciplina PRIMARY KEY (ID)
);

Create table Aluno_Disciplina
(
ID_Disciplina int not null,
RA_Aluno varchar(20) not null,
Nota1 decimal(4,2) null,
Nota2 decimal(4,2) null,
Sub decimal(4,2) null,
Faltas int null,
Media decimal(4,2) null,
Status_AD varchar(20) not null,
Ano int not null,
Semestre int not null

CONSTRAINT PK_Aluno_Disciplina PRIMARY KEY (ID_Disciplina,RA_Aluno,Ano,Semestre),
CONSTRAINT FK_ID_Disciplina FOREIGN KEY (ID_Disciplina) REFERENCES Disciplina(ID),
CONSTRAINT FK_RA_Aluno FOREIGN KEY (RA_Aluno) REFERENCES Aluno(Ra)

);