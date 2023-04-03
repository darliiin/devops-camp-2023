#!/bin/bash

ports=()

#TCP connections in the port range 10000-10100
while (true); do

  #getting a port
  num_port=$(ss -tan '( sport >= :10000 and sport <= :10100 )' | awk '{print $4, $5, $6, $7}' | cut -d: -f4 | cut -d' ' -f1)

  #check if we displayed information about this port
  if ! [[ "${ports[@]}" =~ "${num_port}" ]]; then

    #if the connection is new, print to stdout and add the port to the array
    connections=$(ss -tan '( sport >= :10000 and sport <= :10100 )' | awk '{print $4, $5, $6, $7}')
    echo "New connection on port $connections
    "
    ports+="${num_port}"
  else
  echo "No listening TCP sockets bound to ports in the range 10000-10100"
  fi
sleep 5;

done
