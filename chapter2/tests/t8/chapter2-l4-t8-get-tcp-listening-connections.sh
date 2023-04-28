#!/bin/bash

ports=()
first_port=10000
last_port=10100
time_sleep=5

# TCP connections in the port range 10000-10100
while (true); do

  connections=$(ss -ltnp -at "( sport >= "${first_port}" and sport <= "${last_port}" )")

  # getting a port
   num_port=$(echo "${connections}" | cut -d: -f4 | cut -d' ' -f1)

  # check if we displayed information about this port
  if ! [[ "${ports[@]}" =~ "${num_port}" ]]; then

    # if the connection is new, print to stdout and add the port to the arraylast_port
    echo "New connection on port ${connections}" | awk '{print $4, $5, $6, $7}'
    ports+="${num_port}"
  else
  echo "No listening TCP sockets bound to ports in the range 10000-10100"
  fi
sleep "${time_sleep}";

done
