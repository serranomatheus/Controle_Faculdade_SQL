use Faculdade;

exec dbo.HistoricoDisciplina 1, 2020; --Exibir historico de determinada disciplina(ID) em determinado ano(ANO)
exec dbo.HistoricoAluno '19192541', 2020,2; --Exibir historico de determinado Aluno(RA) em determinado ano(ANO) e semestre(semestre)
exec dbo.AlunosReprovados 2020; --Exibir alunos reprovados por nota em determinado ano(ANO)

Alter Proc HistoricoDisciplina @id int, @ano int
as
begin
	--select * from Aluno_Disciplina
	select  A.Nome as "Nome do ALuno",RA_Aluno as "RA",D.Nome as "Disciplina",Nota1,Nota2,Sub,Media,Faltas,Status_AD as "Situacao"
	from	Aluno A join Aluno_Disciplina AD on A.Ra = AD.RA_Aluno 
			join Disciplina D on AD.ID_Disciplina = D.ID
	where ID_Disciplina = @id and ano = @ano
	order by A.Nome

end
go



Alter Proc HistoricoAluno @ra varchar(20),@ano int,@semestre int
as
begin
	
	/*select * from Aluno
	where ra = @ra
	select * from Aluno_Disciplina
	where ra_aluno =@ra and ano =@ano and semestre = @semestre
	*/
	select  A.Nome as "Nome do ALuno",RA_Aluno as "RA",D.Nome as "Disciplina",Nota1,Nota2,Sub,Media,Faltas,Status_AD as "Situacao"
	from	Aluno A join Aluno_Disciplina AD on A.Ra = AD.RA_Aluno 
			join Disciplina D on AD.ID_Disciplina = D.ID
	where	A.Ra = @ra and AD.Ano = @ano and AD.Semestre = @semestre
	order by A.Nome

end
go

Alter Proc AlunosReprovados @ano int
as
begin
	
	select  A.Nome as "Nome do ALuno",RA_Aluno as "RA",D.Nome as "Disciplina",Nota1,Nota2,Sub,Media,Faltas,Status_AD as "Situacao"
	from	Aluno A join Aluno_Disciplina AD on A.Ra = AD.RA_Aluno 
			join Disciplina D on AD.ID_Disciplina = D.ID
	where	AD.ano = @ano and AD.Status_AD = 'Reprovado por Nota'
	order by A.Nome
end
go



Alter Proc FaltaAluno @ID_Disciplina int, @RA_Aluno varchar(20),@media decimal(4,2),@ano int, @semestre int,@faltas int, @Carga_Horaria int
AS
BEGIN
	Declare
		@media_falta decimal(4,2)
		if isnull(@faltas,1)!=1
			begin
			select @media_falta = (@Carga_Horaria * 0.25)
			if @faltas >= @media_falta 
				begin
					if @media <5
					begin
					print 'Aluno Reprovado por Falta e Nota'
					update Aluno_Disciplina set Status_AD = 'Reprovado por Falta e Nota' where ano = @ano and semestre = @semestre and RA_Aluno = @RA_Aluno and ID_Disciplina = @ID_Disciplina
					end
					else
					begin
					print 'Aluno Reprovado por Falta'
					update Aluno_Disciplina set Status_AD = 'Reprovado por Falta' where ano = @ano and semestre = @semestre and RA_Aluno = @RA_Aluno and ID_Disciplina = @ID_Disciplina
					end
				end
			end
end;





Alter Proc MediaAluno @ID_Disciplina int, @RA_Aluno varchar(20), @nota1 decimal(4,2),@Nota2 decimal(4,2),@Sub decimal(4,2),@ano int, @semestre int
AS
BEGIN
	DECLARE
		@media decimal(4,2)
	if isnull(@nota1,1)!=1
	begin
		if isnull(@nota2,1)!=1
			begin
				if isnull(@sub,1) =1
				begin
					select @media=((@nota1+@nota2)/2)
						if @media<5
						begin
						print 'Aluno com nota abaixo da media 5, Prova substitutiva necessesaria'
						update Aluno_Disciplina set Media = @media  where ano = @ano and semestre = @semestre and RA_Aluno = @RA_Aluno and ID_Disciplina = @ID_Disciplina
						end
						else
						begin
						print 'Aluno Aprovado, Prova substitutiva nao necessaria'
						update Aluno_Disciplina set Status_AD = 'Aprovado', Media = @media  where ano = @ano and semestre = @semestre and RA_Aluno = @RA_Aluno and ID_Disciplina = @ID_Disciplina
						end
				end
				else
				begin
					if(@nota1 >=@nota2)
					begin
						select @media=((@nota1+@sub)/2)
					end
					else
					begin
						select @media=((@nota2+@sub)/2)
					end
					if @media<5
						begin
						print 'Aluno Reprovado por nota'
						update Aluno_Disciplina set Status_AD = 'Reprovado por Nota', Media = @media  where ano = @ano and semestre = @semestre and RA_Aluno = @RA_Aluno and ID_Disciplina = @ID_Disciplina
						end
						else
						begin
						print 'Aluno Aprovado por nota'
						update Aluno_Disciplina set Status_AD = 'Aprovado', Media = @media  where ano = @ano and semestre = @semestre and RA_Aluno = @RA_Aluno and ID_Disciplina = @ID_Disciplina
						end
			
			end
	end
end
end;


alter trigger Alterar_AD
on dbo.Aluno_Disciplina
after update
as
begin
	declare
		@ID_Disciplina int,
		@RA_Aluno varchar(20), 
		@nota1 decimal(4,2),
		@Nota2 decimal(4,2),
		@Sub decimal(4,2),
		@ano int, 
		@semestre int,
		@faltas int,
		@carga_horaria int,
		@media decimal(4,2)
	select
		@ID_Disciplina = inserted.ID_Disciplina,
		@RA_Aluno = inserted.ra_aluno,
		@nota1 = inserted.nota1,
		@Nota2 = inserted.nota2,
		@Sub = inserted.sub,
		@ano = inserted.ano,
		@semestre = inserted.semestre,
		@faltas = inserted.faltas,
		@media = inserted.Media
	
	from inserted
	select @carga_horaria = carga_horaria from Disciplina where ID = @ID_Disciplina

	exec dbo.MediaAluno  @ID_Disciplina, @RA_Aluno, @nota1 ,@Nota2 ,@Sub,@ano , @semestre
	exec dbo.FaltaAluno  @ID_Disciplina, @RA_Aluno,@media, @ano , @semestre,@faltas,@carga_horaria
end;
	