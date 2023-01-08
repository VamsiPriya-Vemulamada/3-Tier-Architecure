if [ -z "$1" ]; then
  echo Input arugument Password is needed
  exit 1
fi

COMPONENT=mysql
source common.sh
ROBOSHOP_MYSQL_PASSWORD=$1

PRINT "Downloading MySQL Repo File"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG
STAT $?

PRINT "Disable MySQL 8 Version repo"
dnf module disable mysql -y &>>$LOG
STAT $?

PRINT "Install MySQL"
yum install mysql-community-server -y &>>LOG
STAT $?

PRINT "Enable MySql Service"
systemctl enable mysqld &>>$LOG
STAT $?

PRINT "Start MySQL Service"
systemctl restart mysqld &>>$LOG
STAT $?

PRINT "Reset Default password"
mysql_secure_installation --set-root-pass ${ROBOSHOP_MYSQL_PASSWORD}
STAT $?

APP_LOC=/tmp
CONTENT=mysql-main
DOWNLOAD_APP_CODE

cd mysql-main &>>LOG

PRINT "Loading Schema"
mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} <shipping.sql &>>$LOG
STAT $?
