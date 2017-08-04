#! /bin/bash
IFS=' ' read -ra ARGS <<< $(<"$1")
function vagrant_start {
  cd "$1" 
  if [ "$(vagrant_status | jq -r '.state')" == "not created" ]
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
  cat << EXEC
    {
      "changed": false,
      "name": "${INFO_1[0]}",
      "state": "${INFO_1[1]}",
      "arg": "$1"
    }
EXEC
}
function vagrant_destroy {
  cd "$1"
  if [ "$(vagrant_status | jq -r '.state')" != "not created" ]
  then
    vagrant destroy -f > /tmp/vagrant_destroy_log
    echo '{ "state": "changed" }'
    exit 0
  else 
    echo '{ "state": "ok" }'
    exit 0
  fi
}
function test_func {
  cd "$1"
  ls
}

case "${ARGS[0]}" in
  start)
    vagrant_start "${ARGS[1]}"
  ;;
  status)
    vagrant_status
  ;;
  destroy)
    vagrant_destroy "${ARGS[1]}"
  ;;
  test)
    test_func
  ;;
esac
exit 0
