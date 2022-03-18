use Faculdade;

insert into Aluno
values('19192541','413.285.938-16','Joao Henrique Santos','22/06/1992','Rua Jose Bonifacio','1303','Centro','ap 14','Araraquara','Sao Paulo','14810-193');

insert into Aluno
values('19587555','315.288.128-09','Mauricio de Souza','02/11/1998','Rua Ramos do Amaral','12','Centro','casa esq','Araraquara','Sao Paulo','14800-155');

insert into Aluno
values('19585744','219.385.124-19','Aline Munhoz','03/08/2002','Alameda Paulista','1202','Vila Xavier','casa','Araraquara','Sao Paulo','14810-139');

select * from Aluno
order by Nome;

update Aluno_Disciplina
set sub = '4'
where RA_Aluno = 19585744 and ID_Disciplina = '1' and  ano = '2020' and semestre = '2';

select * from Aluno_Disciplina
where RA_Aluno = '19585744';

insert into Disciplina
values('Banco de Dados I','40'),
('Banco de Dados II','40'),
('Engenharia de Software I','60'),
('Estatistica','50'),
('Logica','80');

select * from Disciplina;

insert into Aluno_Disciplina(ID_Disciplina,RA_Aluno,Status_AD,Ano,Semestre)
Values('4','19585744','Matriculado','2020','2');