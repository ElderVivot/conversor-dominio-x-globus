# coding: utf-8

from __future__ import annotations
from logging import Logger
import os
import sys
from typing import Any, Dict
import pandas as pd

currentFolder = os.path.dirname(__file__)
folderSrc = os.path.join(currentFolder, '..')
folderBeforeSrc = os.path.join(currentFolder, '..', '..')
sys.path.append(currentFolder)
sys.path.append(folderSrc)
sys.path.append(folderBeforeSrc)

from connection_db import ConnectionDB
from common.utils.read_sql import readSql
from common.exceptions.fetch_sql import FetchSQLExcepction


class ExtractData():
    def __init__(self, logger: Logger, pathSql: str, nameSql: str, args: Dict[str, Any]):
        self.__logger = logger
        self.__pathSql = pathSql
        self.__nameSql = nameSql
        self.__args = args

        self.__connectionDB = ConnectionDB(self.__logger)
        self.__connection = self.__connectionDB.getConnection()

    def __columnsList(self):
        if self.__nameSql.count('funcionarios') > 0:
            return ["EMPRESA", "FILIAL", "REGISTRO DO FUNCIONÁRIO", "NOME FUNCIONÁRIO", "SITUAÇÃO FUNCIONÁRIO", "CODIGO DE CONDIÇÃO", "DATA DESL/AFAST", "CPF", "PIS", "CHAPA ", "DATA DE NASCIMENTO", "MUNICIPIO NASC", "UF NASC", "SEXO", "GRAU DE INSTRUÇÃO", "NACIONALIDADE", "ESTADO CIVIL", "DATA DE ADMISSÃO", "BANCO ", "AGENCIA", "CONTA CORRENTE", "PAIS NASCIMENTO", "PAIS NACIONALIDADE", "APELIDO", "NOME COMPLETO", "SALARIO BASE", "FUNÇÃO", "SINDICATO", "AREA ", "DEPARTAMENTO",
                    "SETOR ", "SEÇÃO", "VINCULO EMPREGATICIO", "TIPO DE ADMISSÃO", "RAÇA", "JORNADA DIARIA", "DOCUMENTOS 3", "RG", "ORGÃO EMISSÃO ", "DATA DE EXPEDIÇÃO", "UF", "CTPS", "SERIE", "UF ", "EXPEDIÇÃO", "CNH", "CATEGORIA ", "VALIDADE ", "EXPEDIÇÃO", "UF", "CIDADE", "RESERVISTA ", "CATEGORIA", "EXPEDIÇÃO", "TITULO DE ELEITOR", "ZONA", "SEÇÃO", "EXPEDIÇÃO", "LOCAL DE RESIDENCIA", "CEP", "TIPO DE LOGRADOURO", "ENDEREÇO", "NUMERO", "COMPLEMENTO", "BAIRRO", "MUNICIPIO", "UF", "TELEFONE"]

        if self.__nameSql.count('funcao') > 0:
            return ["CODIGO FUNÇÃO", "DESCRIÇÃO FUNÇÃO", "CBO", "INFORMAÇÕES GERAIS DESCRIÇÃO DE ATIVIDADE", "ATIVIDADES ESOCIAL"]

        if self.__nameSql.count('pro_labore') > 0:
            return ["EMPRESA", "FILIAL", "REGISTRO DO PRÓ-AUT", "NOME DO PRÓ-AUT", "TIPO", "NOME COMPLETO", "DATA DE NASCIMENTO", "MUNICIPIO NASC", "UF NASC", "SEXO", "GRAU DE INSTRUÇÃO ", "NACIONALIDADE", "ESTADO CIVIL ", "RAÇA", "DATA DE ADMISSÃO", "PAIS DE NASCIMENTO", "PAIS DE NACIONALIDADE", "FUNÇÃO", "AREA ", "DEPARTAMENTO ", "SETOR ", "SEÇÃO", "SALARIO", "LOCAL DE RESIDENCIA", "CEP", "TIPO DE LOGRADOURO", "ENDEREÇO", "NUMERO", "COMPLEMENTO", "BAIRRO", "MUNICIPIO", "UF", "TELEFONE 1", "TELEFONE 2", "CPF", "PIS", "RG", "CATEGORIA"]

        if self.__nameSql.count('dependentes') > 0:
            return ["EMPRESA", "FILIAL", "REGISTRO DO FUNCIONÁRIO", "COD DEPENDENTE", "NOME DEPENDENTE", "DT NASC DEP", "NOME COMPLETO", "PARENTESCO", "ESTADO CIVIL", "NASCIONALIDADE", "CPF DEPENDENTES", "DEP DE IRRF", "DEP ASSIS MEDICA", "DEP SALARIO FAMILIA", "DEP PLANO ODONT."]

        if self.__nameSql.count('desligamento') > 0:
            return ["EMPRESA", "FILIAL", "REGISTRO DO FUNCIONÁRIO", "NOME FUNCIONÁRIO", "COMPETENCIA", "MOTIVO DE DESLIGAMENTO", "DATA DE DESLIGAMENTO"]

        if self.__nameSql.count('eventos') > 0:
            return ["CODIGO EVENTO", "DESCRIÇÃO EVENTO", "TIPO DE EVENTO", "ROTINA", "INCIDENCIA/DEDUÇÃO INSS", "INCIDENCIA/DEDUÇÃO IRRF", "INCIDENCIA/DEDUÇÃO FGTS", "RUBRICA ESOCIAL", "INCIDENCIA/DEDUÇÃO TRIBUTARIA RUBRICA INSS", "INCIDENCIA/DEDUÇÃO TRIBUTARIA RUBRICA IRRF", "INCIDENCIA/DEDUÇÃO TRIBUTARIA RUBRICA FGTS"]

        if self.__nameSql.count('historico_financeiro') > 0:
            return ["EMPRESA", "FILIAL", "REGISTRO DO FUNCIONÁRIO", "NOME FUNCIONÁRIO", "TIPO DE FOLHA ", "COMPETÊNCIA", "ENCERRADO", "SITUAÇÃO", "CONDIÇÃO", "EVENTO", "REFERENCIA ", "VALOR"]

        if self.__nameSql.count('historico_salarial') > 0:
            return ["EMPRESA", "FILIAL", "REGISTRO DO FUNCIONÁRIO", "DATA INICIO DA VIGENCIA", "MOTIVO DE ALTERAÇÃO", "SALÁRIO", "FUNÇÃO", "SINDICATO", "AREA", "DEPARTAMENTO ", "SETOR", "SEÇÃO"]

        if self.__nameSql.count('historico_ferias') > 0:
            return ["EMPRESA", "FILIAL", "REGISTRO DO FUNCIONÁRIO", "NOME FUNCIONÁRIO", "COMPETENCIA", "TIPO DE FÉRIAS", "PERIODO AQUISITIVO INICIO", "PERIODO AQUISITIVO FINAL", "PERIODO DE GOZO INICIO", "PERIODO DE GOZO FINAL", "PERIODO DE GOZO ABONO INICIO", "PERIODO DE GOZO ABONO FINAL"]

        if self.__nameSql.count('afastamento') > 0:
            return ["EMPRESA", "FILIAL", "REGISTRO DO FUNCIONÁRIO", "NOME FUNCIONÁRIO", "INICIO DE AFASTAMENTO ", "ULTIMO DIA DE TRABALHO", "CONDIÇÃO DE AFASTAMENTO", "ULTIMO DIA DE AFASTAMENTO"]

        if self.__nameSql.count('empresas') > 0:
            return ["CODIGO DOMINIO", "CNPJ", "RAZAO SOCIAL", "APELIDO", "ENDERECO", "COMPLEMENTO", "NUMBERO", "BAIRRO", "CIDADE", "ESTADO", "CEP"]

    def main(self):
        try:
            sql = readSql(self.__pathSql, self.__nameSql, self.__args)

            df = pd.read_sql_query(sql, self.__connection)
            df = df.replace({r'\n': '', r'\r': '', r'\t': '', r';': ''}, regex=True)
            df.columns = self.__columnsList()
            folderToSave = os.path.join(folderBeforeSrc, 'data', self.__nameSql.replace('.sql', '.xlsx'))

            # df.to_csv(folderToSave, sep='|', mode='a', header=False, index=False, encoding='cp1252')
            df.to_excel(folderToSave, 'data', float_format='%.2f', index=False)
        except Exception as e:
            raise FetchSQLExcepction(e)
        finally:
            self.__connectionDB.closeConnection()
