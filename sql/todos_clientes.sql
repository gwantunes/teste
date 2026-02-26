set head off;
set trimspool on;
set term off;
set feedback off;
set verify off;
set pages 0;
set lines 2000;

with version_clients as (
select  z.cd_versao_atual,
         z.cd_cnpj  "Traceability Customer ID",
         z.nm_customer "Traceability Customer Name",
         z.ds_address "Traceability Address",
         z.ds_city "Traceability City",
         z.ds_state "Traceability State",
         z.nr_phone "Traceability Telephone",
         z.ds_country "Traceability Country"
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
         aplicacao_tasy_versao atv
    WHERE a.CD_CUSTOMER_ID <> '01950338000177'
      AND a.cd_versao NOT IN ('5.02.1833', '5.01.1837')
      and atv.cd_versao = a.cd_versao
      and atv.ie_versao_oficial = 'S'
    GROUP BY a.CD_CUSTOMER_ID
) x
JOIN customer_version_track b
  ON x.cd_versao_atual = b.cd_versao
  AND x.cd_cnpj = b.CD_CUSTOMER_ID
  AND b.nr_service_pack < 9999
ORDER BY x.cd_cnpj, b.cd_versao desc, b.nr_service_pack desc) z
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
