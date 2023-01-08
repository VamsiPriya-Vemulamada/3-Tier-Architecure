STAT()
{
if  [ $1 -eq 0 ]; then
   echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e0m"
  echo Check the error in $LOG file
  exit 1
  #if your program detects an error and decides to abort, you would use exit(1)
fi
}

#Saving the component in temp folder

LOG=/tmp/$COMPONENT.log
rm -f $LOG
set-hostname -skip-apply $COMPONENT

# Adding a User to the application
DOWNLOAD_APP_CODE()
{
  if [ ! -z "$APP_USER" ]; then
  PRINT "Adding Application User"
  id roboshop &>>LOG
  if [ $? -ne 0 ]; then
    useradd roboshop &>>LOG
  fi
  STAT $?
  fi
}

PRINT "Download App Content"
curl -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/$COMPONENT/archive/main.zip" &>>$LOG
  STAT $?

PRINT "Remove Previous Version of App"
  cd $APP_LOC &>>$LOG
  rm -rf $CONTENT &>>$LOG
  STAT $?

PRINT "Extracting App Content"
  unzip -o /tmp/$COMPONENT.zip &>>$LOG
  STAT $?

 SYSTEMD_SETUP(){
   PRINT "Configure the Endpoints for SystemD configuration"
   sed -i -e  's/MONGO_DNSNAME/dev-mongodb.devopsb69.online/' -e 's/REDIS_ENDPOINT/dev-redis.devopsb69.online/' -e 's/CATALOGUE_ENDPOINT/dev-catalogue.devopsb69.online/' -e 's/MONGO_ENDPOINT/dev-mongodb.devopsb69.online/' -e 's/CARTENDPOINT/dev-cart.devopsb69.online/' -e 's/DBHOST/dev-mysql.devopsb69.online/' -e 's/AMQPHOST/dev-rabbitmq.devopsb69.online/' -e 's/CARTHOST/dev-cart.devopsb69.online/' -e 's/USERHOST/dev-user.devopsb69.online/' /home/roboshop/${COMPONENT}/systemd.service &>>$LOG
   mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service
   STAT $?
 }

