COMPONENT=frontend
CONTENT="*"

source common.sh

PRINT "Install Nginx"
yum install nginx -y &>>LOG
STAT $?

APP_LOC=/usr/share/nginx/html

DOWNLOAD_APP_CODE

mv frontend-main/static/* .

print "Copy Roboshop Configuration File"
mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf
STAT $?

print "Enable Nginx Service"
systemctl enable nginx &>>$LOG
STAT $?

print "Start Nginx Service"
systemctl restart nginx &>>$LOG
STAT $?