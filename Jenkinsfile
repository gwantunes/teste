pipeline {
    agent any
    
    stages {
        steps('Atualizar tabelas') {
            echo "executando RECALCULAR_TASY_VERSION_TRACK3..."
        }
        steps('Rodando script de clientes ativos') {
            echo "rodando script..."
        }
        steps('Exportanto resultado'){
            echo "exportando resultado e gerando .xlsx"
        }
        steps('Rodando script de todos os clientes') {
            echo "rodando script..."
        }
        steps('Exportanto resultado'){
            echo "exportando resultado e gerando .xlsx"
        }
        steps('Ajustando arquivo excel') {
            echo "ajustando arquivo excel..."
        }
    }
}
