#!/bin/bash

sudo iptables -P FORWARD ACCEPT
# Network Bridges
echo "Creating bridges br0 and br1..."
sudo ip link add br0 type bridge
sudo ip link add br1 type bridge
sudo ip link set br0 up
sudo ip link set br1 up

#Create Network Namespaces 
echo "Creating namespaces ns1, ns2, and router-ns..."
sudo ip netns add ns1
sudo ip netns add ns2
sudo ip netns add router-ns


# Connect ns1 to br0
sudo ip link add veth-ns1 type veth peer name veth-br0
sudo ip link set veth-ns1 netns ns1
sudo ip link set veth-br0 master br0
sudo ip link set veth-br0 up

# Connect ns2 to br1
sudo ip link add veth-ns2 type veth peer name veth-br1
sudo ip link set veth-ns2 netns ns2
sudo ip link set veth-br1 master br1
sudo ip link set veth-br1 up

# Connect router-ns to br0
sudo ip link add veth-r0 type veth peer name veth-br0-r
sudo ip link set veth-r0 netns router-ns
sudo ip link set veth-br0-r master br0
sudo ip link set veth-br0-r up

# Connect router-ns to br1
sudo ip link add veth-r1 type veth peer name veth-br1-r
sudo ip link set veth-r1 netns router-ns
sudo ip link set veth-br1-r master br1
sudo ip link set veth-br1-r up


# NS1 (192.168.1.10)
sudo ip netns exec ns1 ip addr add 192.168.1.10/24 dev veth-ns1
sudo ip netns exec ns1 ip link set veth-ns1 up
sudo ip netns exec ns1 ip link set lo up

# NS2 (192.168.2.10)
sudo ip netns exec ns2 ip addr add 192.168.2.10/24 dev veth-ns2
sudo ip netns exec ns2 ip link set veth-ns2 up
sudo ip netns exec ns2 ip link set lo up

# Router-NS (192.168.1.1 and 192.168.2.1)
sudo ip netns exec router-ns ip addr add 192.168.1.1/24 dev veth-r0
sudo ip netns exec router-ns ip addr add 192.168.2.1/24 dev veth-r1
sudo ip netns exec router-ns ip link set veth-r0 up
sudo ip netns exec router-ns ip link set veth-r1 up
sudo ip netns exec router-ns ip link set lo up


# Enable IP Forwarding
sudo ip netns exec router-ns sysctl -w net.ipv4.ip_forward=1

sudo ip netns exec ns1 ip route add default via 192.168.1.1
sudo ip netns exec ns2 ip route add default via 192.168.2.1


echo "Testing connectivity from ns1 to ns2... \n"
sudo ip netns exec ns1 ping -c 5 192.168.2.10

echo "Testing connectivity from ns2 to ns1..."
sudo ip netns exec ns2 ping -c 5 192.168.1.10
echo "Setup Complete."