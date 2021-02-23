#!/bin/bash

#root check
if [ "$EUID" -ne 0 ]
  then echo "Do not run this as the root user"
  exit
else
  echo "Run as root user"

  #jdk insall
  if rpm -qa | grep jdk ; then
    echo "Java installed."
  else
    echo "Java NOT installed!"
    yum install java-1.8.0-openjdk-devel.x86_64
    echo -e "export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.275.b01-1.el8_3.x86_64/bin/javac" >> /etc/profile
    echo -e "export CLASSPATH=.:$JAVA_HOME/lib/tools.jar" >> /etc/profile
    echo -e "export PATH=$PATH:$JAVA_HOME/bin" >> /etc/profile
  fi

  #tomcat insall
  TOMCAT_PATH=/home/hansj

  echo -e "Please input Tomcat install Path(Enter if you don't want to): c "
  read tempTomcatPath

  if [ ! -z $tempTomcatPath ]; then
    TOMCAT_PATH=$tempTomcatPath
  fi

  wget - np http://archive.apache.org/dist/tomcat/tomcat-8/v8.5.9/bin/apache-tomcat-8.5.9.tar.gz -P $TOMCAT_PATH
  cd $TOMCAT_PATH
  tar xzf apache-tomcat-8.5.9.tar.gz
  echo -e "export CATALINA_HOME=$TOMCAT_PATH/apache-tomcat-8.5.9" >> /etc/profile

  #port_check
  NOW_TOMCAT_PORT=`echo syslog12 | sed -n '69p' $TOMCAT_PATH/apache-tomcat-8.5.9/conf/server.xml | sed 's/protocol.*$//' | sed 's/[^0-9{4}]//g'`
  echo "The current port is $NOW_TOMCAT_PORT"

  #port_change
  echo -e "Please input Tomcat Port: c "
  read  tomcatPort

  STAT=`netstat -na | grep $tomcatPort`
  if [ "$STAT" = "LISTEN" ]; then
    echo "$tomcatPort PORT IS IN USE"
  else
    echo "$tomcatPort PORT IS NOT IN USE"
    sed -i "s|$NOW_TOMCAT_PORT|$tomcatPort|" $TOMCAT_PATH/apache-tomcat-8.5.9/conf/server.xml
    echo "TOMCAT PORT IS CHANGED"
  fi

  #firewarll
  firewall-cmd --permanent --zone=public --add-port=$tomcatPort/tcp
  firewall-cmd --reload
  firewall-cmd --permanent --list-all
fi

exit 0
