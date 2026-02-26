pipeline {
    agent any
    
    stages {
        stage('Atualizar tabelas') {
            steps {
                echo "executando RECALCULAR_TASY_VERSION_TRACK3..."
            }
        }
        stage('Clientes ativos') {
            steps {
                echo "rodando script de clientes ativos..."
                dir ('sql') {
                    withCredentials([usernamePassword(credentialsId: 'ce552b44-30df-4e04-a3f7-aa2be6db2c9d', usernameVariable: 'DB_USER', passwordVariable: 'DB_PASS')]) {
                        sh "sqlplus -s ${DB_USER}/${DB_PASS}@//srv-db-phdev.whebdc.com.br:1521/phdev @clientes_ativos.sql"
                    }
                }
            }
        }
        stage('Exportar clientes ativos') {
            steps {
                echo "exportando resultado e gerando .xlsx"
            }
        }
        stage('Todos os clientes') {
            steps {
                echo "rodando script..."
            }
        }
        stage('Exportar todos os clientes') {
            steps {
                echo "exportando resultado e gerando .xlsx"
            }
        }
        stage('Ajustar Excel') {
            steps {
                echo "ajustando arquivo excel..."
            }
        }
    }
}
