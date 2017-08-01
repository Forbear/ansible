mkdir -p .ssh/
cat key.pub >> ./.ssh/authorized_keys
chmod 700 .ssh
chmod 600 .ssh/authorized_keys
