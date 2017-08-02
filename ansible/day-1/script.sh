mkdir -p .ssh/
mkdir /opt/tomcat/
chmod 755 /opt/tomcat/
cat key.pub >> ./.ssh/authorized_keys
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
