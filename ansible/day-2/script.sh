mkdir -p .ssh/
mkdir -p /opt/tomcat/
mkdir -p /etc/ansible/facts.d/
echo "[general]" > /etc/ansible/facts.d/java.fact
echo "[general]" > /etc/ansible/facts.d/nginx.fact
chmod 755 /opt/tomcat/
cat key.pub >> ./.ssh/authorized_keys
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
