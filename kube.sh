#!/bin/bash

services_dir="kubernetes"
services_filter="kube-*.yml"

cmd=$1; shift

function get_services {
  for file in ${services_dir}/${services_filter}; do
    echo -n "$file "
  done
}

function kubectl_cmd {
  local cmd="$1"; shift
  local service_file="$1"; shift
  kubectl "$cmd" -f "$service_file"
  return $?
}

function services_cmd {
  local cmd="$1"; shift
  local services_list="$1"; shift

  if [ "X" = "X${services_list}" ]; then
    services_list=$(get_services)
  fi

  for service in ${services_list}; do
    kubectl_cmd "${cmd}" "${service}"
    if [ $? -ne 0 ]; then
      echo "ERROR: Operation FAILED"
    else
      echo ""
    fi
  done
}

function usage {
  echo "Usage:"
  echo "$1 <command> [<service_file> [<service_file>] ...]"
  echo
  echo "where:"
  echo "<command>       One of the commands from list: list, create, delete, recreate"
  echo "  list          List all the services in the '${services_dir}' folder"
  echo
  echo "  status        Show kubernetes Pods status (equivalent to 'kubectl get pods')"
  echo
  echo "  create        Run kubectl create or delete command respectively"
  echo "  delete"
  echo
  echo "  recreate      A shortcat for delete and create commands"
  echo
  echo "<service_file>  One or more services to work on specified as kubernetes files"
  echo
  echo "NOTE: If no <service_file> specified, the script will work with all the services in '${services_dir}' folder"
  echo
}

case "$cmd" in
  create)
    services_cmd create "$@"
    ;;
  delete)
    services_cmd delete "$@"
    ;;
  recreate)
    services_cmd delete "$@"
    services_cmd create "$@"
    ;;
  list)
    services_list=$(get_services)
    echo "List of available services:"
    for service in ${services_list}; do
      echo "  ${service}"
    done
    ;;
  status)
    echo "Pods list:"
    kubectl get pods
    ;;
  *)
    echo "ERROR: Invalid command(s) provided"
    usage "$0"
    exit 1
    ;;
esac
