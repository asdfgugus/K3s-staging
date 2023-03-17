#!/bin/bash
k3sup install \
    --ip 192.168.7.31 \
    --user debian \
    --k3s-version v1.25.6+k3s1 \
    --k3s-extra-args "--disable=traefik,servicelb,metrics-server,local-storage --disable-selinux --flannel-backend=none --disable-network-policy" 

k3sup join --ip 192.168.7.32 --user debian --server-ip 192.168.7.31 --k3s-version v1.25.6+k3s1
k3sup join --ip 192.168.7.33 --user debian --server-ip 192.168.7.31 --k3s-version v1.25.6+k3s1
k3sup join --ip 192.168.7.34 --user debian --server-ip 192.168.7.31 --k3s-version v1.25.6+k3s1
