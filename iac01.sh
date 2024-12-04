#!/bin/bash

echo "Esse script tem intenção/função para fins acadêmicos e foi criado para testes"


# Arquivo de log
LOG_FILE="script.log"
> "$LOG_FILE"  # Limpa o arquivo de log antes de começar

echo "Início do script..." | tee -a "$LOG_FILE"

# Função para logar erros
log_error() {
    echo "[ERROR] $1" | tee -a "$LOG_FILE"
}

# Função para criar diretórios
create_directory() {
    DIR=$1
    if [ -d "$DIR" ]; then
        echo "O diretório $DIR já existe. Excluindo..." | tee -a "$LOG_FILE"
        rm -rf "$DIR" || log_error "Falha ao excluir o diretório $DIR"
    fi
    mkdir "$DIR" && echo "Diretório $DIR criado." | tee -a "$LOG_FILE"
}

# Função para criar grupos
create_group() {
    GROUP=$1
    if getent group "$GROUP" > /dev/null; then
        echo "O grupo $GROUP já existe. Excluindo..." | tee -a "$LOG_FILE"
        groupdel "$GROUP" || log_error "Falha ao excluir o grupo $GROUP"
    fi
    groupadd "$GROUP" && echo "Grupo $GROUP criado." | tee -a "$LOG_FILE"
}

# Função para criar usuários
create_user() {
    USER=$1
    PASSWORD=$2
    GROUP=$3
    if id "$USER" &>/dev/null; then
        echo "O usuário $USER já existe. Excluindo..." | tee -a "$LOG_FILE"
        userdel -r "$USER" || log_error "Falha ao excluir o usuário $USER"
    fi
    useradd "$USER" -m -s /bin/bash -p "$(openssl passwd -crypt "$PASSWORD")" -G "$GROUP" && \
    echo "Usuário $USER criado." | tee -a "$LOG_FILE"
}

echo "Criando diretórios..."
create_directory "/publico"
create_directory "/adm"
create_directory "/ven"
create_directory "/sec"

echo "Criando grupos de usuários..."
create_group "GRP_ADM"
create_group "GRP_VEN"
create_group "GRP_SEC"

echo "Criando usuários..."
create_user "carlos" "Senha123" "GRP_ADM"
create_user "maria" "Senha123" "GRP_ADM"
create_user "joao" "Senha123" "GRP_ADM"

create_user "debora" "Senha123" "GRP_VEN"
create_user "sebastiana" "Senha123" "GRP_VEN"
create_user "roberto" "Senha123" "GRP_VEN"

create_user "josefina" "Senha123" "GRP_SEC"
create_user "amanda" "Senha123" "GRP_SEC"
create_user "rogerio" "Senha123" "GRP_SEC"

echo "Especificando permissões dos diretórios..."
chown root:GRP_ADM /adm && chmod 770 /adm || log_error "Falha ao configurar permissões para /adm"
chown root:GRP_VEN /ven && chmod 770 /ven || log_error "Falha ao configurar permissões para /ven"
chown root:GRP_SEC /sec && chmod 770 /sec || log_error "Falha ao configurar permissões para /sec"
chmod 777 /publico || log_error "Falha ao configurar permissões para /publico"

echo "Fim do script." | tee -a "$LOG_FILE"

#clear
cat script.log
