# 2026-02-23 23:46:52 by RouterOS 7.20.7
# system id = wyDtwmcpgEI
#
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no
set [ find default-name=ether2 ] disable-running-check=no
set [ find default-name=ether3 ] disable-running-check=no
/ip pool
add name=dhcp_pool_cloud ranges=177.177.77.10-177.177.77.43
add name=dhcp_pool_edge ranges=192.200.11.10-192.200.11.13
/ip dhcp-server
add address-pool=dhcp_pool_cloud interface=ether3 name=dhcp_cloud
add address-pool=dhcp_pool_edge interface=ether2 name=dhcp_edge
/ip address
add address=177.177.77.1/24 interface=ether3 network=177.177.77.0
add address=192.200.11.1/24 interface=ether2 network=192.200.11.0
/ip dhcp-client
add interface=ether1
/ip dhcp-server network
add address=177.177.77.0/24 dns-server=8.8.8.8 gateway=177.177.77.1
add address=192.200.11.0/24 dns-server=8.8.8.8 gateway=192.200.11.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,4.4.4.4
/ip firewall filter
add action=accept chain=forward
/ip firewall nat
add action=masquerade chain=srcnat out-interface=ether1
add action=dst-nat chain=dstnat dst-address=192.168.235.30 dst-port=5000 \
    protocol=tcp to-addresses=192.168.40.100 to-ports=5000
