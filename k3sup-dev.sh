#!/bin/bash
k3sup install \
    --ip 192.168.7.31 \
    --user asdfgugus \
    --k3s-version v1.28.3+k3s1 \
    --local-path ~/.kube/config \
    --k3s-extra-args "--disable=traefik,servicelb,metrics-server,local-storage --flannel-backend=none --no-flannel --disable-network-policy" 

k3sup join --ip 192.168.7.36 --user asdfgugus --server-ip 192.168.7.31 --k3s-version v1.28.3+k3s1
k3sup join --ip 192.168.7.37 --user asdfgugus --server-ip 192.168.7.31 --k3s-version v1.28.3+k3s1
