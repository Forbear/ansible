#! /bin/bash
function vagrant_up {
  if [ "$V_STATE" == "not created" ] || [ "$V_STATE" == "poweroff" ]
  then
    vagrant up > /tmp/vagrant_up_log
    echo '{ "state": "changed" }'
    exit 0
  else 
    echo '{ "state": "ok" }'
    exit 0
  fi
}
function vagrant_status {
  IFS=' ' read -ra INFO_1 <<< "$(vagrant status | grep virtualbox)"
  if [ "${INFO_1[1]}" == "not" ]
  then
    INFO_1[1]="not created"
  fi
  if [ -e "/tmp/vagrant_up_log" ]
  then
    USER="$(vagrant ssh-config | grep -Po '(?<=User\s)\w+')"
    PORT="$(vagrant ssh-config | grep -Po '(?<=Port\s)\w+')"
    IP="$(vagrant ssh-config | grep -Po '(?<=HostName\s).+')"
    MEMORY="$(VBoxManage showvminfo ansible | grep 'Memory size:' | cut -c18-81)"
    GUEST_OS="$(VBoxManage showvminfo ansible | grep 'Guest OS:' | cut -c18-81)"
    cat << EXEC
    {
      "name": "${INFO_1[0]}",
      "state": "${INFO_1[1]}",
      "user": "$USER",
      "port": "$PORT",
      "memory": "$MEMORY",
      "guest os": "$GUEST_OS",
      "ip": "$IP"
    }
EXEC
  else
    cat << EXEC
    {
      "name": "${INFO_1[0]}",
      "state": "${INFO_1[1]}"
    }
EXEC
  fi
}
function vagrant_destroy {
  if [ "$V_STATE" != "not created" ]
  then
    vagrant destroy -f > /tmp/vagrant_destroy_log
    rm -f /tmp/vagrant_up_log
    echo '{ "state": "changed" }'
    exit 0
  else 
    echo '{ "state": "ok" }'
    exit 0
  fi
}
function vagrant_halt {
  if [ "$V_STATE" == "not created" ]
  then
    echo '{ "state": "ok" }'
    exit 0
  else 
    vagrant halt > /tmp/vagrant_halt_log
    echo '{ "state": "changed" }'
    exit 0
  fi
}
function test_func {
  USER="$(vagrant ssh-config | grep -Po '(?<=User\s)\w+')"
  PORT="$(vagrant ssh-config | grep -Po '(?<=Port\s)\w+')"
  echo '{ "user":' '"'"$USER"'",' '"port":' '"'"$PORT"'"' "}"
}
source $1
if [ ! -d "$path" ]
then
  echo '{ "msg": "Folder does not exist" }'
  exit 1
fi
cd "$path"
if [ ! -e "Vagrantfile" ]
then
  echo '{ "msg": "No Vagrantfile" }'
  exit 1
fi
V_STATE="$(vagrant_status | jq -r '.state')"
case "$stat" in
  start)
    vagrant_up
  ;;
  status)
    vagrant_status
  ;;
  destroy)
    vagrant_destroy
  ;;
  halt)
    vagrant_halt
  ;;
  test)
    test_func
  ;;
esac
exit 0
