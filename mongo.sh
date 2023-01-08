COMPONENT=mongodb
source common.sh

PRINT "Download YUM Repo File"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG
STAT $?

# Installing mongo
PRINT "Install MongoDB"
yum install -y mongodb-org &>>$LOG
STAT $?

PRINT "Configure MongoDB Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>LOG
STAT $?

PRINT "Enable MongoDB"
systemctl enable mongod &>>LOG
STAT $?

PRINT "Start MangoDB"
systemctl restart mongodb &>>LOG
STAT $?

APP_LOC=/tmp
CONTENT=mongodb-main
DOWNLOAD_APP_CODE


cd mongodb-main &>>LOG

#PRINT "Loading Catalogue Schema"
#mongo < catalogue.js &&>>LOG
#STAT $?
#
#PRINT "Load Users Schema"
#mongo < users.js &>>LOG
#STAT $?
