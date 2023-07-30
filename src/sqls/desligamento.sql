SELECT emp.cgce_emp AS 'EMPRESA',
       emp.cgce_emp AS 'FILIAL',
       fun.i_empregados AS 'REGISTRO DO FUNCIONARIO',
       fun.nome AS 'NOME FUNCIONARIO',
       DATEFORMAT(YMD(YEAR(res.demissao), MONTH(res.demissao) + 1, 0), 'DD/MM/YYYY') AS 'COMPETENCIA',
       CASE WHEN res.motivo = 1 THEN 'Demitido COM justa causa'
            WHEN res.motivo = 2 THEN 'Demitido SEM justa causa'
            WHEN res.motivo = 3 THEN 'Rescis�o Indireta'
            WHEN res.motivo = 4 THEN 'Pedido de demiss�o SEM justa causa'
            WHEN res.motivo = 5 THEN 'Sess�o do empregado'
            WHEN res.motivo = 6 THEN 'Transfer�ncia do empregado sem �nus para a mesma empresa'
            WHEN res.motivo = 8 THEN 'Morte'
            WHEN res.motivo = 10 THEN 'Rescis�o contrato de experi�ncia antecipado pelo empregador'
            WHEN res.motivo = 11 THEN 'Rescis�o contrato de experi�ncia antecipado pelo empregado'
            WHEN res.motivo = 12 THEN 'T�rmino do contrato de experi�ncia'
            WHEN res.motivo = 13 THEN 'Morte por acidente de trabalho'
            WHEN res.motivo = 14 THEN 'Morte por doen�a profissional'
            WHEN res.motivo = 22 THEN 'T�rmino do contrato de trabalho por prazo determinado'
            WHEN res.motivo = 23 THEN 'Antecipado pelo empregador (tempo determinado)'
            WHEN res.motivo = 24 THEN 'Antecipado pelo empregado (tempo determinado)'
            WHEN res.motivo = 27 THEN 'Transfer�ncia do empregado sem �nus para outra empresa'
            WHEN res.motivo = 28 THEN 'Culpa rec�proca'
            WHEN res.motivo = 29 THEN 'Extin��o da empresa'
            WHEN res.motivo = 30 THEN 'Extin��o da empresa por for�a maior'
            WHEN res.motivo = 40 THEN 'Morte por acidente de trabalho de trajeto'
            WHEN res.motivo = 41 THEN 'Falecimento do empregador individual s/cont. da atividade da empresa'
            WHEN res.motivo = 42 THEN 'Falecimento do empregador individual por op��o do empregado'
            WHEN res.motivo = 43 THEN 'Extin��o/T�rmino de contrato de est�gio'
            WHEN res.motivo = 44 THEN 'Rescis�o por acordo entre as partes'
            WHEN res.motivo = 99 THEN 'Outros'
            ELSE STRING(res.motivo)
        END AS 'MOTIVO DESLIGAMENTO',    
       DATEFORMAT(res.demissao, 'DD/MM/YYYY') AS 'DATA DESLIGAMENTO'  


  FROM bethadba.foempregados AS fun
       INNER JOIN bethadba.forescisoes AS res
            ON    res.codi_emp = fun.codi_emp
              AND res.i_empregados = fun.i_empregados
              AND res.tipo = 1
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = fun.codi_emp


 WHERE emp.cgce_emp LIKE '07515384%'

ORDER BY emp.codi_emp, fun.i_empregados