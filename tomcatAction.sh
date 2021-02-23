#!/bin/bash
source /etc/profile

case $1 in
start)
sh $CATALINA_HOME/bin/startup.sh
;;
stop)
sh $CATALINA_HOME/bin/shutdown.sh
;;
restart)
sh $CATALINA_HOME/bin/shutdown.sh
sh $CATALINA_HOME/bin/startup.sh
;;
*)
echo "Usage: $0 {start|stop|restart}"
;;
esac
exit 0
