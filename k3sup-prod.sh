#!/bin/bash
k3sup install \
    --ip 192.168.7.41 \
    --user debian \
    --k3s-version v1.28.3+k3s1 \
    --local-path ~/.kube/config \
    --k3s-extra-args "--disable=traefik,servicelb,metrics-server,local-storage --flannel-backend=none --no-flannel --disable-network-policy" 

k3sup join --ip 192.168.7.42 --user debian --server-ip 192.168.7.41 --k3s-version v1.28.3+k3s1
k3sup join --ip 192.168.7.43 --user debian --server-ip 192.168.7.41 --k3s-version v1.28.3+k3s1
k3sup join --ip 192.168.7.46 --user debian --server-ip 192.168.7.41 --k3s-version v1.28.3+k3s1
k3sup join --ip 192.168.7.47 --user debian --server-ip 192.168.7.41 --k3s-version v1.28.3+k3s1