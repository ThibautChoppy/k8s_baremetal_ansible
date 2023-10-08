# Ansible Playbook DevOps Infrastructure `[v1.2 - Stable]`

This Ansible Playbook deploys a kubernetes cluster

### Prerequisites

To run this project, you must install Ansible on your computer and have at least 2 GNU/Debian 12.2.0 servers running.
#### Warning: Kubernetes needs at least 2 cores and 2 GB of RAM to run.

Dev Env :
```
- Proxmox Server (12 Core - 32 Gb RAM)
    - Master
        - Node_1
        - Node_2
```

```
python3 -m pip install --user ansible
```

Ansible work by SSH, so it's mandatory to have an ssh key configured and added in authorized_keys file of target hosts.

### Installing

#### On your computer

First, you must edit the `hosts.ini` file with the IPs of your servers.
```
[Master]
master ansible_host=xxx.xxx.xxx.xxx

[Nodes]
node-1 ansible_host=xxx.xxx.xxx.xxx
```

Then, you need to edit the `cluster/variables.yml` file with the IPs and hostname of your servers.
```
cluster_nodes: ['xxx.xxx.xxx.xxx k8s-master', 'xxx.xxx.xxx.xxx k8s-node-1']
```

Finally, transfer your user's ssh key to all servers :
```
cat ~/.ssh/id_rsa.pub | ssh user@remote_host "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
ssh user@remote_host
su
cp -r .ssh /root/.ssh
```

## Running the tests

Once the environment is set up, you can perform this test to see if all servers are seen by your computer:
```
root@computer:~# ansible all -m ping -u root
master | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
node-1 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```
If the ping failed, check if your ssh keys are in the authorized_keys file of the root user of the unreached server.

## Deployment

To execute the main.yml playbook, run the command :
```
ansible-playbook -u root main.yml
```

> If you want all the outputs of each executed command, add the `-v` option

#### Your (small) infrastructure is now configured !

### Here are some examples of my environment to guide you :
```
root@master:~# kubectl get nodes
NAME         STATUS   ROLES           AGE     VERSION
k8s-master   Ready    control-plane   7m      v1.28.2
k8s-node-1   Ready    <none>          7m      v1.28.2
```
We can see that all nodes are currently connected.

```
root@master:~# kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-7ddc4f45bc-wxvjt   1/1     Running   0          7m
kube-system   calico-node-mjt2w                          1/1     Running   0          7m
kube-system   calico-node-mktfz                          1/1     Running   0          7m
kube-system   coredns-5dd5756b68-bhqpb                   1/1     Running   0          7m
kube-system   coredns-5dd5756b68-g2jnr                   1/1     Running   0          7m
kube-system   etcd-k8s-master                            1/1     Running   0          8m
kube-system   kube-apiserver-k8s-master                  1/1     Running   0          8m
kube-system   kube-controller-manager-k8s-master         1/1     Running   0          8m
kube-system   kube-proxy-h4qdh                           1/1     Running   0          7m
kube-system   kube-proxy-szcpz                           1/1     Running   0          7m
kube-system   kube-scheduler-k8s-master                  1/1     Running   0          8m
```
The `-A` option is for "--all-namespaces".

<!-- ```
root@Master:~# kubectl describe pod/jenkins-deployment-667fb997fb-ncdwb --namespace jenkins
Name:         jenkins-deployment-667fb997fb-ncdwb
Namespace:    jenkins
Priority:     0
Node:         node-1/192.168.1.20
Start Time:   Tue, 22 Sep 2020 01:04:45 +0200
Labels:       app=jenkins
              pod-template-hash=667fb997fb
Annotations:  <none>
Status:       Running
IP:           10.244.1.2
IPs:
  IP:           10.244.1.2
Controlled By:  ReplicaSet/jenkins-deployment-667fb997fb
[...]
```
Here is a description of the jenkins pod, it currently works on the node-1 whose IP is 192.168.1.20

```
root@master:~# kubectl get services -A
NAMESPACE     NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                  AGE
default       kubernetes   ClusterIP   10.96.0.1        <none>        443/TCP                  48m
jenkins       jenkins      NodePort    10.108.213.130   <none>        8080:30000/TCP           48m
kube-system   kube-dns     ClusterIP   10.96.0.10       <none>        53/UDP,53/TCP,9153/TCP   48m
```
And finally, the list of all services and their open ports.

With all this information, I can deduce that jenkin is accessible with a browser on IP `192.168.1.20:30000`. -->

## Built With

* [Proxmox](https://www.proxmox.com/en/) - Used to create the servers (Level 1 hypervisor)
* [Ansible](https://docs.ansible.com/ansible/latest/index.html) - Used to deploy the servers
* [Docker](https://www.docker.com/) - Used to create containers, needed for kubernetes
* [Kubernetes](https://kubernetes.io/) - Used to deploy every services of the infrastructure
* [Jenkins](https://kubernetes.io/) - Used to run the Dev test

## Authors

* **Thibaut Choppy** - *Initial work* - [Linkedin](https://www.linkedin.com/in/thibaut-choppy/)
