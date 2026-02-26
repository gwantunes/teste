set head off;
set trimspool on;
set term off;
set feedback off;
set verify off;
set pages 0;
set lines 2000;

with version_clients as (
select  z.cd_versao_atual,
        (select max(cd_udi) from corp.tasy_version_udi@whebl01_dbcorp
         where cd_version = z.cd_versao_atual
         and nr_service_pack = z.nr_service_pack) "Tasy System UDI",
         z.cd_cnpj  "Traceability Customer ID",
         pj.ds_razao_social "Tasy Customer Name",
         z.nm_customer "Traceability Customer Name",
         pj.ds_endereco "Tasy Address",
         z.ds_address "Traceability Address",
         pj.ds_municipio "Tasy City",
         z.ds_city "Traceability City",
         pj.sg_estado "Tasy State",
         z.ds_state "Traceability State",
         pj.cd_cep "Tasy Postal Code",
         pj.nr_telefone "Tasy Telephone",
         z.nr_phone "Traceability Telephone",
         p.cd_codigo_pais "Tasy Country Code",
         p.nm_pais "Tasy Country",
         z.ds_country "Traceability Country",
         pj.nm_pessoa_contato "Tasy Customer Contact",
         pj.ds_email "Tasy Customer Email",
         (select ds_valor_Dominio from valor_dominio
          where cd_dominio = 5763
          and vl_dominio = com.ie_migracao) "Tasy Platform",
         com.ie_situacao "Tasy Customer Active?",
         com.ie_classificacao "Tasy Customer Classification"
from    (
    SELECT x.cd_cnpj,
       x.cd_versao_atual,
       b.nr_service_pack,
       b.nm_customer,
       b.ds_address,
       b.ds_city,
       b.ds_state,
       b.nr_phone,
       b.ds_country,
       ROW_NUMBER() OVER (PARTITION BY x.cd_cnpj ORDER BY x.cd_cnpj) AS incrementing_column
FROM (
    SELECT a.CD_CUSTOMER_ID cd_cnpj,
           MAX(a.cd_versao) cd_versao_atual
    FROM customer_version_track a,
         corp.com_cliente@whebl01_dbcorp com,
         APLICACAO_tasy_VERSAO atv
    WHERE a.CD_CUSTOMER_ID <> '01950338000177'
      AND a.cd_versao NOT IN ('5.02.1833', '5.01.1837')
      AND a.cd_customer_id = com.cd_cnpj
      AND com.ie_classificacao = 'C'
      and com.ie_situacao = 'A'
      and A.cd_versao = atv.cd_versao
      and atv.ie_versao_oficial = 'S'
      AND ATV.DT_VERSAO > SYSDATE -1400
    GROUP BY a.CD_CUSTOMER_ID
) x
JOIN customer_version_track b
  ON x.cd_versao_atual = b.cd_versao
  AND x.cd_cnpj = b.CD_CUSTOMER_ID
ORDER BY x.cd_cnpj, b.cd_versao desc, b.nr_service_pack desc) z
join corp.PESSOA_JURIDICA@whebl01_dbcorp pj
 on CD_CGC	= z.cd_cnpj
join corp.pais@whebl01_dbcorp p
 on pj.nr_seq_pais = p.nr_sequencia
join corp.com_cliente@whebl01_dbcorp com
 on com.cd_cnpj = cd_cgc
 and com.ie_situacao = pj.ie_situacao
where z.incrementing_column = 1)
SELECT 
    cd_versao_atual,
    COUNT(*) AS qtd,
    ROUND((COUNT(*) * 100.0) / (SELECT COUNT(*) FROM version_clients), 2) AS porcentagem
FROM 
    version_clients
GROUP BY 
    cd_versao_atual
ORDER BY 
    porcentagem desc;
