SELECT emp.cgce_emp AS 'EMPRESA',
       emp.cgce_emp AS 'FILIAL',
       fun.i_empregados AS 'REGISTRO PRO-AUT',
       fun.nome AS 'NOME DO PRO-AUT',
       '' AS 'TIPO',
       fun.nome AS 'NOME COMPLETO',
       DATEFORMAT(fun.data_nascimento, 'DD/MM/YYYY') AS 'DATA DE NASCIMENTO',
       ( SELECT mun.codigo_ibge || '-' || mun.nome_municipio 
           FROM bethadba.gemunicipio AS mun 
          WHERE mun.codigo_municipio = fun.municipio_nascimento ) AS 'MUNICIPIO NASC',
       fun.uf_nascimento AS 'UF NASC',
       fun.sexo AS 'SEXO',
       fun.grau_instrucao || '-' || CASE WHEN fun.grau_instrucao = 1 THEN 'Analfabeto'
                               WHEN fun.grau_instrucao = 2 THEN 'Ensino Fundamental até 5° ano Incompleto'
                               WHEN fun.grau_instrucao = 3 THEN 'Ensino Fundamental 5° Completo'
                               WHEN fun.grau_instrucao = 4 THEN 'Ensino Fundamental 6° ao 9°'
                               WHEN fun.grau_instrucao = 5 THEN 'Ensino Fundamental Completo'
                               WHEN fun.grau_instrucao = 6 THEN 'Ensino Médio Incompleto'
                               WHEN fun.grau_instrucao = 7 THEN 'Ensino Médio Completo'
                               WHEN fun.grau_instrucao = 8 THEN 'Ensino Superior Incompleto'
                               WHEN fun.grau_instrucao = 9 THEN 'Ensino Superior Completo'
                               WHEN fun.grau_instrucao = 10 THEN 'Pós Graduação'
                               WHEN fun.grau_instrucao = 11 THEN 'Mestrado'
                               WHEN fun.grau_instrucao = 12 THEN 'Doutorado'
                               WHEN fun.grau_instrucao = 13 THEN 'Ph. D'
                               ELSE ''
                          END AS 'GRAU DE INSTRUCAO',
       'BRASILEIRA' AS 'NACIONALIDADE',
       CASE WHEN fun.estado_civil = 'S' THEN 'Solteiro'
             WHEN fun.estado_civil = 'C' THEN 'Casado'
             WHEN fun.estado_civil = 'V' THEN 'Viúvo'
             WHEN fun.estado_civil = 'D' THEN 'Divorciado' 
             WHEN fun.estado_civil = 'O' THEN 'Concubinato'
             WHEN fun.estado_civil = 'J' THEN 'Separado judicialmente'
             WHEN fun.estado_civil = 'U' THEN 'Uniao estavel'
             ELSE ''
        END AS 'ESTADO CIVIL',
       CASE WHEN fun.cor = 0 THEN 'INDIGENA'
            WHEN fun.cor = 2 THEN 'BRANCA'
            WHEN fun.cor = 4 THEN 'NEGRA'
            WHEN fun.cor = 6 THEN 'AMARELA'
            WHEN fun.cor = 8 THEN 'PARDA'
            ELSE 'NAO INFORMADO'
       END AS 'RACA',
       DATEFORMAT(fun.admissao, 'DD/MM/YYYY') AS 'DATA DE ADMISSAO',
       ( SELECT p.nome_pais 
           FROM bethadba.gepais AS p
          WHERE p.codigo_pais = fun.pais_nascimento ) AS 'PAIS NASCIMENTO',
       ( SELECT p.nome_pais 
           FROM bethadba.gepais AS p
          WHERE p.codigo_pais = fun.pais_nacionalidade ) AS 'PAIS NACIONALIDADE',
       ( SELECT emp.cgce_emp || '-' || cargo.i_cargos || '-' || cargo.nome 
           FROM bethadba.focargos AS cargo 
          WHERE cargo.codi_emp = fun.codi_emp 
            AND cargo.i_cargos = fun.i_cargos ) AS 'FUNCAO',
       'GERAL' AS 'AREA',
       fun.i_depto || '-' || ( SELECT depto.nome 
                                 FROM bethadba.fodepto AS depto
                                WHERE depto.codi_emp = fun.codi_emp 
                                  AND depto.i_depto = fun.i_depto ) AS 'DEPARTAMENTO',
       fun.i_ccustos || '-' || ( SELECT ccusto.nome 
                                 FROM bethadba.foccustos AS ccusto
                                WHERE ccusto.codi_emp = fun.codi_emp 
                                  AND ccusto.i_ccustos = fun.i_ccustos ) AS 'SETOR',
       'GERAL' AS 'SECAO',
       fun.salario AS 'SALARIO',      
       ( SELECT p.nome_pais 
           FROM bethadba.gepais AS p
          WHERE p.codigo_pais = fun.PAIS_ENDERECO ) AS 'LOCAL DE RESIDENCIA',
       fun.cep AS 'CEP',
       COALESCE( CASE fun.tipo_endereco 
		WHEN 1 THEN 'Aeroporto'
        WHEN 45 THEN 'AEROPORTO'
        WHEN 2 THEN 'Alameda'
        WHEN 46 THEN 'ALAMEDA'
        WHEN 3 THEN 'Área'
        WHEN 47 THEN 'ÁREA'
        WHEN 4 THEN 'Avenida'
        WHEN 48 THEN 'AVENIDA'
        WHEN 89 THEN 'Balneário'
        WHEN 90 THEN 'BALNEÁRIO'
        WHEN 91 THEN 'Bloco'
        WHEN 92 THEN 'BLOCO'
        WHEN 5 THEN 'Campo'
        WHEN 49 THEN 'CAMPO'
        WHEN 6 THEN 'Chácara'
        WHEN 50 THEN 'CHÁCARA'
        WHEN 7 THEN 'Colônia'
        WHEN 51 THEN 'COLÔNIA'
        WHEN 8 THEN 'Condomínio'
        WHEN 52 THEN 'CONDOMÍNIO'
        WHEN 9 THEN 'Conjunto'
        WHEN 53 THEN 'CONJUNTO'
        WHEN 10 THEN 'Distrito'
        WHEN 54 THEN 'DISTRITO'
        WHEN 11 THEN 'Esplanada'
        WHEN 55 THEN 'ESPLANADA'
        WHEN 12 THEN 'Estação'
        WHEN 56 THEN 'ESTAÇÃO'
        WHEN 13 THEN 'Estrada'
        WHEN 57 THEN 'ESTRADA'
        WHEN 14 THEN 'Favela'
        WHEN 58 THEN 'FAVELA'
        WHEN 15 THEN 'Fazenda'
        WHEN 59 THEN 'FAZENDA'
        WHEN 16 THEN 'Feira'
        WHEN 60 THEN 'FEIRA'
        WHEN 93 THEN 'Galeria'
        WHEN 94 THEN 'GALERIA'
        WHEN 95 THEN 'Granja'
        WHEN 96 THEN 'GRANJA'
        WHEN 17 THEN 'Jardim'
        WHEN 61 THEN 'JARDIM'
        WHEN 18 THEN 'Ladeira'
        WHEN 62 THEN 'LADEIRA'
        WHEN 19 THEN 'Lago'
        WHEN 63 THEN 'LAGO'
        WHEN 20 THEN 'Lagoa'
        WHEN 64 THEN 'LAGOA'
        WHEN 21 THEN 'Largo'
        WHEN 65 THEN 'LARGO'
        WHEN 22 THEN 'Loteamento'
        WHEN 66 THEN 'LOTEAMENTO'
        WHEN 23 THEN 'Morro'
        WHEN 67 THEN 'MORRO'
        WHEN 24 THEN 'Núcleo'
        WHEN 68 THEN 'NÚCLEO'
        WHEN 25 THEN 'Parque'
        WHEN 69 THEN 'PARQUE'
        WHEN 26 THEN 'Passarela'
        WHEN 70 THEN 'PASSARELA'
        WHEN 27 THEN 'Pátio'
        WHEN 71 THEN 'PÁTIO'
        WHEN 28 THEN 'Praça'
        WHEN 72 THEN 'PRAÇA'
        WHEN 97 THEN 'Praia'
        WHEN 98 THEN 'PRAIA'
        WHEN 29 THEN 'Quadra'
        WHEN 73 THEN 'QUADRA'
        WHEN 30 THEN 'Recanto'
        WHEN 74 THEN 'RECANTO'
        WHEN 31 THEN 'Residencial'
        WHEN 75 THEN 'RESIDENCIAL'
        WHEN 32 THEN 'Rodovia'
        WHEN 76 THEN 'RODOVIA'
        WHEN 33 THEN 'Rua'
        WHEN 77 THEN 'RUA'
        WHEN 34 THEN 'Setor'
        WHEN 78 THEN 'SETOR'
        WHEN 35 THEN 'Sítio'
        WHEN 79 THEN 'SÍTIO'
        WHEN 36 THEN 'Travessa'
        WHEN 80 THEN 'TRAVESSA'
        WHEN 37 THEN 'Trecho'
        WHEN 81 THEN 'TRECHO'
        WHEN 38 THEN 'Trevo'
        WHEN 82 THEN 'TREVO'
        WHEN 39 THEN 'Vale'
        WHEN 83 THEN 'VALE'
        WHEN 40 THEN 'Vereda'
        WHEN 84 THEN 'VEREDA'
        WHEN 41 THEN 'Via'
        WHEN 85 THEN 'VIA'
        WHEN 42 THEN 'Viaduto'
        WHEN 86 THEN 'VIADUTO'
        WHEN 43 THEN 'Viela'
        WHEN 87 THEN 'VIELA'
        WHEN 44 THEN 'Vila'
        WHEN 88 THEN 'VILA'
        WHEN 99 THEN 'Outro'
		ELSE 'RUA' END , 'RUA' ) AS 'TIPO DE LOGRADOURO',
       fun.endereco AS 'ENDERECO',
       COALESCE(STRING(fun.numero_end), 'SN') AS 'NUMERO',
       fun.complemento AS 'COMPLEMENTO',
       fun.bairro AS 'BAIRRO',
       ( SELECT mun.codigo_ibge || '-' || mun.nome_municipio 
           FROM bethadba.gemunicipio AS mun 
          WHERE mun.codigo_municipio = fun.municipio_endereco ) AS 'MUNICIPIO ENDERECO',
       fun.estado AS 'UF ENDERECO',
       COALESCE(fun.DDD_CELULAR, '') || COALESCE(fun.celular, '') AS 'TELEFONE 1',
       '' AS 'TELEFONE 2',
       fun.cpf AS 'CPF',
       fun.pis AS 'PIS',
       fun.identidade AS 'RG', 
       fun.vinculo AS 'CATEGORIA'



/* nao mexer daqui pra baixo */
  FROM bethadba.foempregados AS fun
       INNER JOIN bethadba.geempre AS emp
            ON    emp.codi_emp = fun.codi_emp

 WHERE emp.cgce_emp LIKE '07515384%'
   AND fun.tipo_epr = 2

ORDER BY emp.codi_emp, fun.i_empregados
