SELECT fun.codi_emp AS 'EMPRESA',
       fun.codi_emp AS 'FILIAL',
       fun.i_empregados AS 'REGISTRO DO FUNCIONÁRIO',
       fun.nome AS 'NOME FUNCIONÁRIO',
       '' AS '',
       fun.cpf AS 'CPF',
       fun.pis AS 'PIS',
       fun.data_nascimento AS 'DATA DE NASCIMENTO',
       fun.uf_nascimento AS 'UF NASC',
       fun.sexo AS 'SEXO',
       fun.grau_instrucao AS 'GRAU DE INSTRUÇÃO',
       fun.nacionalidade AS 'NACIONALIDADE',
       fun.estado_civil AS 'ESTADO CIVIL',
       fun.admissao AS 'DATA DE ADMISSÃO',
       fun.i_bancos AS 'BANCO ',
       fun.conta_corr AS 'CONTA CORRENTE',
       fun.nome AS 'NOME COMPLETO',
       fun.salario AS 'SALARIO BASE',
       fun.emprego_ant AS 'TIPO DE ADMISSÃO',
       fun.cor AS 'RAÇA',
       fun.org_exp_ident AS 'ORGÃO EMISSÃO',
       fun.dt_exp_ident AS 'DATA DE EXPEDIÇÃO',
       fun.uf_exp_ident AS 'UF IDENTIDADE',
       fun.cart_prof AS 'CTPS',
       fun.serie_cart_prof AS 'SERIE',
       fun.dt_exp_cprof AS 'EXPEDIÇÃO',
       fun.CODIGO_UF_CARTEIRA_MOTORISTA AS 'UF CNH',
       fun.cart_reservista AS 'RESERVISTA',
       fun.cate_reservista AS 'CATEGORIA'

       



/* nao mexer daqui pra baixo */
  FROM bethadba.foempregados AS fun
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = fun.codi_emp

 WHERE emp.cgce_emp LIKE '07515384%'
