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
                echo "rodando script..."
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
