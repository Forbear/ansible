java -version 2> /tmp/test.txt
sed -i 's/openjdk version \"/version=/g' /tmp/test.txt
sed -i 's/\"//g' /tmp/test.txt
cat /tmp/test.txt | grep version 1>> /etc/ansible/facts.d/java.fact
rm /tmp/test.txt
