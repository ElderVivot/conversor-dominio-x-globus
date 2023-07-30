SELECT emp.cgce_emp AS 'EMPRESA',
       emp.cgce_emp AS 'FILIAL',
       fun.i_empregados AS 'REGISTRO DO FUNCIONARIO',
       depen.i_filhos AS 'COD DEPENDENTE',
       depen.nome AS 'NOME DEPENDENTE',
       DATEFORMAT(depen.data_nascto, 'DD/MM/YYYY') AS 'DT NASC DEP',
       depen.nome AS 'NOME COMPLETO',
       CASE WHEN depen.grau_parentesco = 1 THEN 'C�njuge'
               WHEN depen.grau_parentesco = 2 THEN 'Filho(a) ou enteado(a) at� 21 anos'
               WHEN depen.grau_parentesco = 3 THEN 'Filho(a) ou enteando(a) universit�rio(a) ou cursando escola t�cnica de 2� grau, at� 24 anos'
               WHEN depen.grau_parentesco = 4 THEN 'Filho(a) ou enteado(a) em qualquer idade, quando incapacitado f�sica e/ou mentalmente para o trabalho'
               WHEN depen.grau_parentesco = 5 THEN 'Irm�o(�), neto(a) ou bisneto(a) sem arrimo dos pais, do qual detenha guarda judicial, at� 21 anos'
               WHEN depen.grau_parentesco = 6 THEN 'Irm�o(�), neto(a) ou bisneto(a) sem arrimo dos pais, com idade at� 24 anos, se ainda estiver cursando estabelecimento de n�vel superior ou escola t�cnica de 2� grau, desde que tenha detido sua guarda judicial at� os 21 anos'
               WHEN depen.grau_parentesco = 7 THEN 'Irm�o(�), neto(a) ou bisneto(a) sem arrimo dos pais, do(a) qual detenha guarda judicial, em qualquer idade, quando incapacitado f�sica e/ou mentalmente para o trabalho'
               WHEN depen.grau_parentesco = 8 THEN 'Pais, av�s e bisav�s'
               WHEN depen.grau_parentesco = 9 THEN 'Menor pobre, at� 21 anos, que crie e eduque e do qual detenha guarda judicial'
               WHEN depen.grau_parentesco = 10 THEN 'A pessoa absolutamente incapaz, da qual seja tutor ou curador'
               WHEN depen.grau_parentesco = 11 THEN 'Companheiro(a) com o(a) qual tenha filho ou viva h� mais de 5 anos'
               WHEN depen.grau_parentesco = 12 THEN 'Ex-c�njuge que Receba Pens�o de Alimentos'
               ELSE ''
          END AS 'PARENTESCO',
       'SOLTEIRO' AS 'ESTADO CIVIL',
       'BRASILEIRA' AS 'NASCIONALIDADE',
       depen.CPF AS ' CPF DEPENDENTES',
       depen.dependente AS 'DEP DE IRRF',
       'N' AS 'DEP ASSIS MEDICA',
       depen.filho AS 'DEP SALARIO FAMILIA',
       'N' AS 'DEP PLANO ODONT.'



/* nao mexer daqui pra baixo */
  FROM bethadba.fofilhos AS depen
       INNER JOIN bethadba.foempregados AS fun
            ON    fun.codi_emp = depen.codi_emp
              AND fun.i_empregados = depen.i_empregados
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = fun.codi_emp

 WHERE emp.cgce_emp LIKE '07515384%'

ORDER BY emp.codi_emp, fun.i_empregados, depen.i_filhos
