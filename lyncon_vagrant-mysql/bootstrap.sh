#Installing and enabling mysql

sudo yum -y install wget
sudo wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
sudo rpm -ivh mysql57-community-release-el7-9.noarch.rpm
sudo yum -y install mysql-server
sudo systemctl enable --now mysqld
sudo systemctl status mysqld

#Defining Variables - must be placed after installing MySQL

TEMP_PWD=$(sudo grep 'A temporary password is generated for root@localhost:' /var/log/mysqld.log | awk '{print $NF}') #This is the temporary password automatically generated when installing mysql
NEW_PWD='SenhaMBA@rqu!t3tur@'
NEW_PWD_LENGHT=${#NEW_PWD}

#Configuring /etc/my.cnf

sudo echo "skip-grant-tables" >> /etc/my.cnf
sudo echo "bind-address = 0.0.0.0" >> /etc/my.cnf

#Configuring password and privileges
mysql -uroot -p$TEMP_PWD --connect-expired-password -e "SET password FOR root@localhost=password('$TEMP_PWD');"
mysql -uroot -p$TEMP_PWD -e "SET GLOBAL validate_password_length=($NEW_PWD_LENGHT);"
mysql -uroot -p$TEMP_PWD -e "SET GLOBAL validate_password_policy=LOW;"
mysql -uroot -p$TEMP_PWD -e "SET password for root@localhost=password('$NEW_PWD');"
mysql -uroot -p$NEW_PWD -e "SELECT host FROM mysql.user WHERE User = 'root';"
mysql -uroot -p$NEW_PWD -e "CREATE USER 'root'@'%' IDENTIFIED BY '$NEW_PWD';"
mysql -uroot -p$NEW_PWD -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'"
mysql -uroot -p$NEW_PWD -e "flush privileges;"
mysql -uroot -p$NEW_PWD -e "SELECT host FROM mysql.user WHERE User = 'root';"

###Criando database e objetos de banco de dados

mysql -uroot -p$NEW_PWD -e "CREATE DATABASE DB_LNCN_MBA;"
mysql -uroot -p$NEW_PWD DB_LNCN_MBA -e "CREATE TABLE TB_LNCN_MBA (id INT NOT NULL, nome VARCHAR(50) NOT NULL, curso VARCHAR(50) NOT NULL, instituto VARCHAR(50) NOT NULL, PRIMARY KEY (id));"
mysql -uroot -p$NEW_PWD DB_LNCN_MBA -e "INSERT INTO TB_LNCN_MBA (id,nome,curso,instituto) VALUES(1,'Lyncon de Oliveira Pio', 'Arquitetura de Soluções Digitais', 'Faculdade Impacta de Tecnologia');"
mysql -uroot -p$NEW_PWD DB_LNCN_MBA -e "SELECT * FROM TB_LNCN_MBA;"