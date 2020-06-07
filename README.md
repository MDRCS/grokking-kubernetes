# - Kubernetes Orchestration


    + Monolith problems :
    scaling horizontaly may require big changes in the application code and isn’t always possible—certain parts of
    an application are extremely hard or next to impossible to scale horizontally (relational databases, for example).
    If any part of a monolithic application isn’t scalable, the whole application becomes unscalable,
    unless you can split up the monolith somehow.

    + Monolith solution :
    When a monolithic application can’t be scaled out because one of its parts is unscal- able,
    splitting the app into microservices allows you to horizontally scale the parts that allow scaling out,
    and scale the parts that don’t, vertically instead of horizontally.

    + SCALING MICROSERVICES :
    Scaling microservices, unlike monolithic systems, where you need to scale the system as a whole,
    is done on a per-service basis, which means you have the option of scaling only those services that
    require more resources, while leaving others at their original scale.


![](./static/scaling_microservice.png)

    + Microservices Problems :
      Microservices also bring other problems, such as making it hard to debug and trace execution calls,
      because they span multiple processes and machines. Luckily, these problems are now being addressed with
      distributed tracing systems such as Zipkin.

      Deploying dynamically linked applications that require different versions of shared libraries,
      and/or require other environment specifics, can quickly become a night- mare for the ops team who deploys
      and manages them on production servers. The bigger the number of components you need to deploy on the same host,
      the harder it will be to manage all their dependencies to satisfy all their requirements.


    + Microservice Solution :
      To reduce the number of problems that only show up in production, it would be ideal if applications could run in
      the exact same environment during development and in production so they have the exact same operating system,
      libraries, system con- figuration, networking environment, and everything else. You also don’t want this
      environment to change too much over time, if at all. Also, if possible, you want the ability to add applications
      to the same server without affecting any of the existing applications on that server.


    + Kubernetes :
    As you’ll see, Kubernetes enables us to achieve all of this. By abstracting away the actual hardware and exposing
    it as a single platform for deploying and running apps, it allows developers to configure and deploy their applications
    without any help from the sysadmins and allows the sysadmins to focus on keeping the underlying infrastruc- ture up and
    running, while not having to know anything about the actual applications running on top of it.

![](./static/kubernetes.png)

    - Kubernetes to provide these services. This includes things such as service discovery, scaling, load-balancing, self-healing, and even leader.

    + Kubernetes Architecture :
      Kubernetes cluster is composed of many nodes, which can be split into two types:
    - The master node, which hosts the Kubernetes Control Plane that controls and manages the whole Kubernetes system
    - Worker nodes that run the actual applications you deploy


![](./static/kubernetes_cluster.png)


    + THE CONTROL PLANE :
      The Control Plane is what controls the cluster and makes it function. It consists of multiple components that can run on
      a single master node or be split across multiple nodes and replicated to ensure high availability. These components are :

      - The Kubernetes API Server, which you and the other Control Plane components communicate with
      - The Scheduler, which schedules your apps (assigns a worker node to each deploy- able component of your application)
      - The Controller Manager, which performs cluster-level functions, such as repli- cating components, keeping track of worker nodes, handling node failures, and so on
      - etcd, a reliable distributed data store that persistently stores the cluster configuration.

    The components of the Control Plane hold and control the state of the cluster, but they don’t run your applications. This is done by the (worker) nodes.

    + THE NODES
    The worker nodes are the machines that run your containerized applications. The task of running, monitoring,
    and providing services to your applications is done by the following components:

    - Docker, rkt, or another container runtime, which runs your containers
    - The Kubelet, which talks to the API server and manages containers on its node
    - The Kubernetes Service Proxy (kube-proxy), which load-balances network traffic between application components

    ++ The ability to move applications around the cluster at any time allows Kubernetes to utilize the infrastructure much better
       than what you can achieve manually. Humans aren’t good at finding optimal combinations, especially when the number of all
       possi- ble options is huge, such as when you have many application components and many server nodes they can be deployed on.
       Computers can obviously perform this work much better and faster than humans.

    + HEALTH CHECKING AND SELF-HEALING :
    Having a system that allows moving an application across the cluster at any time is also valuable in the event of server failures. As your cluster size increases,
    you’ll deal with failing computer components ever more frequently.
    Kubernetes monitors your app components and the nodes they run on and auto- matically reschedules them to other nodes in the event of a node failure.
    This frees the ops team from having to migrate app components manually and allows the team to immediately focus on fixing the node itself and returning
    it to the pool of available hardware resources instead of focusing on relocating the app.
    If your infrastructure has enough spare resources to allow normal system opera- tion even without the failed node, the ops team doesn’t even need to react
    to the failure immediately, such as at 3 a.m. They can sleep tight and deal with the failed node
    during regular work hours.


    # Node.js app example docker & kubernetes :
    $ docker build -t kubia .

![](./static/building_dockerfile.png)

    ++ TIP :
    Don’t include any unnecessary files in the build directory, because they’ll slow down
    the build process—especially when the Docker daemon is on a remote machine.

![](./static/layers_dockerfile_build.png)

    # running the container `kubia`
    $ docker run --name kubia-container -p 8080:8080 -d kubia

    $ docker exec -it kubia-container bash

    # command to display resources consumption :
    $ ps aux
    $ ps aux | grep app.js
    $ docker stop kubia-container

    + Setting up a Kubernetes cluster :
     1- how to run a single-node Kubernetes cluster on your local machine
     2- Install Kubernetes on Amazon’s AWS (Amazon Web Services). For this, you can look at the kops tool, which is built on top of kubeadm. -> http://github.com/kubernetes/kops
     3- installing a cluster with the kubeadm tool


    I- Running a local single-node Kubernetes cluster with Minikube :

       The simplest and quickest path to a fully functioning Kubernetes cluster is by using Minikube.
       Minikube is a tool that sets up a single-node cluster that’s great for both testing Kubernetes
       and developing apps locally.

    1- install minikube
    # go to https://minikube.sigs.k8s.io/docs/start/ -> macOS
    $ brew install minikube

    # Starting kubernetes VM
    $ minikube start

    + Troubleshooting :
    -> if it doesn't work minikube delete -> minikube start

    # check status
    $ minikube status
        minikube
        type: Control Plane
        host: Running
        kubelet: Running
        apiserver: Running
        kubeconfig: Configured

    2- INSTALLING THE KUBERNETES CLIENT (KUBECTL)
    # https://kubernetes.io/docs/tasks/tools/install-kubectl/

    # Download the latest release:
    $ curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"

    # Download the latest release:
    $ chmod +x ./kubectl

    # Move the binary in to your PATH.
    $ sudo mv ./kubectl /usr/local/bin/kubectl

    # Test to ensure the version you installed is up-to-date:
    $ kubectl version --client

    # check if the cluster is up
    $ kubectl cluster-info


    ++ TIP :
    You can run `minikube ssh` to log into the Minikube VM and explore it from the inside. For example,
    you may want to see what processes are run- ning on the node.

    -> you can use a managed Elastic Kubernetes Service (EKS) cluster. This way, you don’t need to manually
       set up all the cluster nodes and networking, which is usually too much for someone making their
       first steps with Kubernetes.


### - Setup Kubernetes cluster on eks aws :

![](./static/eks_kubernetes_cluster.png)

    What is Amazon EKS?
    Amazon EKS (Elastic Container Service for Kubernetes) is a managed Kubernetes service that allows you to run Kubernetes
    on AWS without the hassle of managing the Kubernetes control plane.

    Step 1: Creating an EKS Role

    + Open the IAM console, select Roles on the left and then click the Create Role button at the top of the page.
    + choose ec2, click next
    + choose this two permissions :
        - AmazonEKSServicePolicy
        - AmazonEKSClusterPolicy

    + name it `eks-role`
    + on Roles console click on `eks-role`

    + Be sure to note the Role ARN. You will need it when creating the Kubernetes cluster in the steps below.

    Step 2: Creating a VPC for EKS

    Next, we’re going to create a separate VPC for our EKS cluster. To do this, we’re going to use a CloudFormation
    template that contains all the necessary EKS-specific ingredients for setting up the VPC.

    - Open up CloudFormation, and click the Create new stack button.

    - On the Select template page, enter the URL of the CloudFormation YAML in the relevant section:

    * https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-01-09/amazon-eks-vpc-sample.yaml

    - next, name the VPC `kub8-cluster`

### - Step 3: Creating the EKS Cluster

![](./static/securitygroups_vpc.png)
![](./static/archi_vpc.png)

    $ aws eks --region us-east-1 create-cluster --name kub8-cluster --role-arn arn:aws:iam::399519370237:role/eks-role --resources-vpc-config subnetIds=subnet-0651f19c9e7a2aba0,subnet-00437eb50e6429092,subnet-0d36f598ee20441a7,securityGroupIds=sg-03d45c0d7a27c5d39
        7eb50e6429092,subnet-0d36f598ee20441a7,securityGroupIds=sg-03d45c0d7a27c5d39
        {
            "cluster": {
                "name": "kub8-cluster",
                "arn": "arn:aws:eks:us-east-1:399519370237:cluster/kub8-cluster",
                "createdAt": 1590604026.038,
                "version": "1.16",
                "roleArn": "arn:aws:iam::399519370237:role/eks-role",
                "resourcesVpcConfig": {
                    "subnetIds": [
                        "subnet-0651f19c9e7a2aba0",
                        "subnet-00437eb50e6429092",
                        "subnet-0d36f598ee20441a7"
                    ],
                    "securityGroupIds": [
                        "sg-03d45c0d7a27c5d39"
                    ],
                    "vpcId": "vpc-0c83bc572905a05c3",
                    "endpointPublicAccess": true,
                    "endpointPrivateAccess": false
                },
                "logging": {
                    "clusterLogging": [
                        {
                            "types": [
                                "api",
                                "audit",
                                "authenticator",
                                "controllerManager",
                                "scheduler"
                            ],
                            "enabled": false
                        }
                    ]
                },
                "status": "CREATING",
                "certificateAuthority": {},
                "platformVersion": "eks.1"
            }
        }


    # now you can go to eks console in aws to see you cluster just created.

    # you can status of you cluster.
    $ aws eks --region us-east-1 describe-cluster --name kub8-cluster --query cluster.status

    - Once the status changes to “ACTIVE”, we can proceed with updating our kubeconfig file with the information
      on the new cluster so kubectl can communicate with it.

    - To do this, we will use the AWS CLI update-kubeconfig command :
    $ aws eks --region us-east-1 update-kubeconfig --name kub8-cluster
        Added new context arn:aws:eks:us-east-1:399519370237:cluster/kub8-cluster to /Users/mdrahali/.kube/config

    We can now test our configurations using the kubectl get svc command:
    $ kubectl get svc

    Step 4: Launching Kubernetes Worker Nodes

    - Now that we’ve set up our cluster and VPC networking, we can now launch Kubernetes worker nodes. To do this,
      we will again use a CloudFormation template.

    # go to CloudFormation
    # Create a Stack
    # Use this template below :
    $ https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-01-09/amazon-eks-nodegroup.yaml

    # + Cluster Config

        Clicking Next, name your stack, and in the EKS Cluster section enter the following details:

        ClusterName – The name of your Kubernetes cluster (e.g. demo)
        ClusterControlPlaneSecurityGroup – The same security group you used for creating the cluster in previous step.
        NodeGroupName – A name for your node group.
        NodeAutoScalingGroupMinSize – Leave as-is. The minimum number of nodes that your worker node Auto Scaling group can scale to.
        NodeAutoScalingGroupDesiredCapacity – Leave as-is. The desired number of nodes to scale to when your stack is created.
        NodeAutoScalingGroupMaxSize – Leave as-is. The maximum number of nodes that your worker node Auto Scaling group can scale out to.
        NodeInstanceType – Leave as-is. The instance type used for the worker nodes.
        NodeImageId – The Amazon EKS worker node AMI ID for the region you’re using. For us-east-1, for example: ami-0c5b63ec54dd3fc38
        KeyName – The name of an Amazon EC2 SSH key pair for connecting with the worker nodes once they launch.
        BootstrapArguments – Leave empty. This field can be used to pass optional arguments to the worker nodes bootstrap script.
        VpcId – Enter the ID of the VPC you created in Step 2 above.
        Subnets – Select the three subnets you created in Step 2 above.

![](./static/one.png)
![](./static/two.png)
![](./static/three.png)

    -> next, click on create.

    ++ Note the value for `NodeInstanceRole` as you will need it for the next step — allowing the worker nodes to join our Kubernetes cluster.
    - Role ARN | arn:aws:iam::399519370237:role/kub8-cluster-master-worker-NodeInstanceRole-XXAUP4LH19CZ

    $ curl -O https://amazon-eks.s3-us-west-2.amazonaws.com/cloudformation/2019-01-09/aws-auth-cm.yaml

    # replace Role ARN in the right place of the file just downloaded.

    + Save the file and apply the configuration:
    $ kubectl apply -f aws-auth-cm.yaml
        configmap/aws-auth created

    # Use kubectl to check on the status of your worker nodes:
    $ kubectl get nodes --watch

    Congrats! Your Kubernetes cluster is created and set up.

    Step 5: Installing a demo app on Kubernetes

    + To take her for a spin, we’re going to deploy a simple Guestbook app written in PHP and using Redis for storing guest entries.

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-master-controller.json
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-master-service.json
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-slave-controller.json
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/redis-slave-service.json
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/guestbook-controller.json
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/examples/master/guestbook-go/guestbook-service.json

    + Blocks of the application :

        - the Redis master replication controller
        - the Redis master service
        - the Redis slave replication controller
        - the Redis slave service
        - the Guestbook replication controller
        - the guestbook service

    $ kubectl get svc
        NAME           TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
        guestbook      LoadBalancer   10.100.88.98    <pending>     3000:32565/TCP   13s
        kubernetes     ClusterIP      10.100.0.1      <none>        443/TCP          48m
        redis-master   ClusterIP      10.100.37.147   <none>        6379/TCP         39s
        redis-slave    ClusterIP      10.100.116.29   <none>        6379/TCP         26s


    $ browser enter -> https://10.100.88.98:3000

    # add ana alias
    $ vi ~/.bashrc
    $ alias k=kubectl
    4 source ~/.bashrc

+ INTRODUCING PODS

![](./static/pods.png)

    You may be wondering if you can see your container in a list showing all the running containers.
    Maybe something such as kubectl get containers? Well, that’s not exactly how Kubernetes works.
    It doesn’t deal with individual containers directly. Instead, it uses the concept of multiple
    co-located containers. This group of containers is called a Pod.
    A pod is a group of one or more tightly related containers that will always run together on
    the same worker node and in the same Linux namespace(s). Each pod is like a separate logical
    machine with its own IP, hostname, processes, and so on, running a single application.
    The application can be a single process, running in a single container, or it can be a main
    application process and additional supporting processes, each running in its own container.
    All the containers in a pod will appear to be running on the same logical machine, whereas containers
    in other pods, even if they’re running on the same worker node, will appear to be running on a differ- ent one.

    LISTING PODS
    Because you can’t list individual containers, since they’re not standalone Kubernetes objects,
    can you list pods instead? Yes, you can. Let’s see how to tell kubectl to list pods in the following listing.

    $ kubectl get pods


### + Hands-on Kubernetes | deploying real microservices :

    $ cd /simple-app
    $ vi pods.yml
    # write you first pod to deploy front-end container deployed previously on dockerhub.
    $ kubectl get all

    # deploy container to k8 cluster :
    $ kubectl apply -f pods.yml
        pod/webapp created

    $ kubectl get all
    $ minikube ip
        192.168.64.7

    # but pods are not reachable outside the cluster.

    # get infos about pod, logs ..
    $ kubectl describe pod webapp

    # execute commands against the pod
    $ kubectl exec webapp ls

    # get inside pod
    $ kubectl -it exec webapp sh
    $ wget http://localhost:80
    $ cat index.html

    # and now we can access application file index.html because we are inside the container.

+ Introduction to Services

![](./static/service.png)

    - Services have IP addresses and could connect to pods thought key:value labels.
    - we could considere services as reverse-proxies (or network endpoint | load balancer if we have too many pods in a cluster) because it allows pods to be exposed to users easily.

### + Services Types :

![](./static/service_configs.png)

    Kubernetes ServiceTypes allow you to specify what kind of Service you want. The default is ClusterIP.

    Type values and their behaviors are:

        + ClusterIP: Exposes the Service on a cluster-internal IP. Choosing this value makes the Service only reachable from within the cluster. This is the default ServiceType.

        + NodePort: Exposes the Service on each Node’s IP at a static port (the NodePort). A ClusterIP Service, to which the NodePort Service routes, is automatically created. You’ll be able to contact the NodePort Service, from outside the cluster, by requesting <NodeIP>:<NodePort>.

        + LoadBalancer: Exposes the Service externally using a cloud provider’s load balancer. NodePort and ClusterIP Services, to which the external load balancer routes, are automatically created.

        + ExternalName: Maps the Service to the contents of the externalName field (e.g. foo.bar.example.com), by returning a CNAME record
          with its value. No proxying of any kind is set up.

![](./static/nodeport_service.png)

    $ kubectl apply -f services.yml
    $ kubectl get all
    # test this one -> 10.103.151.47:30080
    $ minikube ip
    # test this one -> 192.168.64.7:30080

    !!! don't forget o add `labels:
                               app: webapp` as a label in the pod file
    and `app: webapp` as a selector in the service file.

    # Update changes of files
    $ kubectl apply -f services.yml
    $ kubectl apply -f pods.yml

    # Configure External Ip address :
    $ minikube ip
        192.168.64.7
    $ kubectl patch svc fleetman-webapp  -p '{"spec": {"type": "LoadBalancer", "externalIPs":["192.168.64.7"]}}'
    $ curl 192.168.64.7:30080

    # Other commands :
    kubectl describe svc kubernetes
    kubectl describe services fleetman-webapp

    # problem - imagine we have a new release and we want to change the pod with another version with `Zero downtime` :

    - Solution is to add `release` label to the `selector` in the `service` so if we change realease from 0 to 1 for examaple
      the selector will point directly to the new pod and after that we could delete the old one.

![](./static/release.png)
![](./static/release1.png)


    # Update changes of files
    $ kubectl apply -f services.yml
    $ kubectl apply -f pods.yml

    $ kubectl get all
    $ kubectl describe service fleetman-webapp
        Annotations:  Selector: app=webapp,release=0-5

    # if the browser keep give you the cache try to clear cache. and reaload.

    # get pods with labels
    $ kubectl get pods --show-labels

    # select pods by labels
    $ kubectl get pods --show-labels -l release=0

### + Deploying Message Queue - Apache ActiveMQ

    # Update changes of files
    $ kubectl apply -f services.yml
    $ kubectl apply -f pods.yml

    # Configure External Ip address for :

    $ minikube ip
        192.168.64.7
    $ kubectl patch svc fleetman-queue  -p '{"spec": {"type": "LoadBalancer", "externalIPs":["192.168.64.7"]}}'
    $ kubectl get all
    # check if it started successfully
    $ kubectl describe pod queue
    # go to 192.168.64.7:30010

### + ReplicaSet

    + ReplicaSet is a kind of wrapper for pods, that preserve pods from dying and not getting restart immediatly.
    + because of pods are entities that could fail at any time ReplicaSet is a config that restart pods anytime they die.

    ++ !! we can use pod or replicaset and not both for the same container.

    $ kubectl delete pods --all
    $ kubectl delete services --all

    # Update changes of files
    $ kubectl apply -f services.yml
    $ kubectl apply -f pods-replicaset.yml

    # now we will simulate pod crashing by deleting a pod
    $ kubectl delete pod webapp-44pmd
    $ kubectl get all
    # you will see that a new pod has been created. Great !!

### + Deployement

    + Deployements are a more sophisticate ReplicaSet, ReplicaSet with one more feature that is rollback
      if we got an error in our deployement and also Deployement Feature of Kubernetes help us manage ReplicaSet.


    # delete ReplicaSet
    $ kubectl delete rs webapp
    $ comment `release: "0-5"` in services.yml
    $ kubectl apply -f pods-deployement.yml
    $ kubectl apply -f services.yml
    $ kubectl get all

    # option allows us to slowstarting pods by 30sec before they are ready.
    - minReadySeconds: 30s

    # Example - Rollback

    # change version of docker container
    from image: richardchesterwood/k8s-fleetman-webapp-angular:release0-5 to image: richardchesterwood/k8s-fleetman-webapp-angular:release0
    $ kubectl apply -f pods-deployement.yml
    $ check this url http://192.168.64.7:30080/

    $ kubectl rollout history deploy webapp
    $ kubectl rollout undo deploy webapp --to-revision=2


### - Networking & Service Discovery in kubernetes :

    + pods are entities that change ip addresses each time so the java app pod should each time figure out
      what is the ip address of the mysqdb pod to communicate with, this is where Service Discovery come to solve this problem
      and in the kubernetes cluster the `kube-dns` who do this job by saving ip addresses of all pods and services in the cluster.

![](./static/service_discovery.png)


### + namespaces :

![](./static/namespaces.png)

    $ kubectl get namespaces

    - by default i'am in `default` namespace

    # get pods that are in `kube-system` namespace
    $ kubectl get pods -n kube-system
    $ kubectl get all -n kube-system
    $ kubectl describe svc kube-dns -n kube-system


### - Upgrade RAM use for Minikube :

    + I recommend before starting this section that you set up minikube with plenty of RAM. To do this:

    $ allocate 4GB of RAM for munikube.

    |Stop minikube with "minikube stop"
    |Delete your existing minikube with "minikube delete"
    |Remove any config files with "rm -r ~/.kube" and "rm -r ~/.minikube". Or, delete these folders using your file explorer.
    |The folders are stored in your home directory, which under windows will be "c:\Users\<your username>"
    |Now restart minikube with "minikube start --memory 4096".

### - Deploy Microservices Cluster Architecture :

![](./static/archi.png)

    # delete all
    $ kubectl delete -f .

![](./static/queue_ports.png)

    $ cd /microservices_deployment
    $ kubectl apply -f .

    # we can check logs of a microservice
    $ kubectl logs position-simulator-f48b877cb-s56ww
    $ kubectl get all


    # testing microservices
    $ http://192.168.64.8:30010/admin/ ActiveMQ (login admin/admin)
    $ http://192.168.64.8:30020/ api gatway
    $ http://192.168.64.8:30080/ front-end

![](./static/webapp-front.png)

### + persistence | Storing data :

    % upgarde of the system
    Problem that we had is that positions of vehicles aren't beeing stored anywhere so when we
    stop running the queue or deleting position tracker we will lose all the data.

    # update all releases of microservices containers to release2
    # just to unlock new feature of history tracker
    $ kubectl apply -f .

# new upgrade add mongodb database to store history of positions

![](./static/upgarde.png)

    # go to workloads.yml file and change richardchesterwood/k8s-fleetman-position-tracker:release2
    to richardchesterwood/k8s-fleetman-position-tracker:release3

    $ vi mongo-stack.yml -> put in it mongo image from docker and service to expose the db to other microservices (position-tracker precisely)
    $ kubectl apply -f .

    Congratulation you have, you did it

    - But here we have another scenario that we should deal with.

    - Problem 2 - if we delete the mongodb instance we will loose all our data

    + Solution - Volume Persistence :

        + startegy that we want to implement is that to store data outside the container, in a directory
          in our host machine.

    $ vi mongo-stack.yml
      add -> volumeMounts:
              - name: mongo-persistent-storage
                mountPath: /data/db

    # so now even if i destroy mongodb instance the data won't be lost.
    $ kubectl delete pod mongodb-65784d9f9d-6wh7c
    $ check http://192.168.64.8:30080/

    # get Persistence Volume
    $ kubectl get pv

    # get Persistence Volume claims
    $ kubectl get pvc

### - Deployement of K8 Microservices Cluster on AWS :

+  From Minikube to EC2 instances

![](./static/minikube.png)

![](./static/AWS_NODES.png)

- for Volume Persistence we are going to use EBS Elastic block store in AWS :

![](./static/ebs.png)

    ++ setting up kubernetes cluster in a production environement

    - we are not going to procede manually.
    - we are going to use a tool called KOPS stand for kuberenetes operations :
      https://github.com/kubernetes/kops

    - tutorial + https://kops.sigs.k8s.io/getting_started/aws/

    - getting started :

    1- create ec2 instance
    2- connect -> ssh -i swarm-cluster.pem ec2-user@3.85.177.65

    # install kops on ec2 instance :
    3- curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
    4- chmod +x kops-linux-amd64
    5- sudo mv kops-linux-amd64 /usr/local/bin/kops

    # prerequisite - install kubernetes :
      https://kubernetes.io/docs/tasks/tools/install-kubectl/

    6- curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
    7- chmod +x ./kubectl
    8- sudo mv ./kubectl /usr/local/bin/kubectl
    9- kubectl version --client

    # next, we should create an IAM user with a certains permissions :
    10- create a new group call it `kops`
    11- select this permissions :
        AmazonEC2FullAccess
        AmazonRoute53FullAccess
        AmazonS3FullAccess
        IAMFullAccess
        AmazonVPCFullAccess

    12- now go to users, and create a new user name it `kops`
        select this option -> Programmatic access
    13- then add users group click on `kops`.
        access id -> AKIAV2BJVZP67UMAEZIT

    # login new IAM user.
    14- aws configure

    # check users IAM in my account
    15- aws iam list-users
    16- # Because "aws configure" doesn't export these vars for kops to use, we export them now
        export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id)
        export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key)

        export AWS_ACCESS_KEY_ID=AKIAV2BJVZP67UMAEZIT
        export AWS_SECRET_ACCESS_KEY=<copy secret key from csv file you downloaded>


    + Setting up a S3 bucket :
    # go to the console of S3 and create a bucket name it `microservices-state-storage`.
    # you can use encryption config if you work in professional environement.

    # setup this env variables :
    export NAME=fleetman.k8s.local
    export KOPS_STATE_STORE=s3://microservices-state-storage


    + Create cluster config :
    % create availibality zone
    $ aws ec2 describe-availability-zones --region us-east-1
      {
            "AvailabilityZones": [
                {
                    "OptInStatus": "opt-in-not-required",
                    "Messages": [],
                    "ZoneId": "use1-az6",
                    "GroupName": "us-east-1",
                    "State": "available",
                    "NetworkBorderGroup": "us-east-1",
                    "ZoneName": "us-east-1a",
                    "RegionName": "us-east-1"
                },
                {
                    "OptInStatus": "opt-in-not-required",
                    "Messages": [],
                    "ZoneId": "use1-az1",
                    "GroupName": "us-east-1",
                    "State": "available",
                    "NetworkBorderGroup": "us-east-1",
                    "ZoneName": "us-east-1b",
                    "RegionName": "us-east-1"
                },
                {
                    "OptInStatus": "opt-in-not-required",
                    "Messages": [],
                    "ZoneId": "use1-az2",
                    "GroupName": "us-east-1",
                    "State": "available",
                    "NetworkBorderGroup": "us-east-1",
                    "ZoneName": "us-east-1c",
                    "RegionName": "us-east-1"
                },
                {
                    "OptInStatus": "opt-in-not-required",
                    "Messages": [],
                    "ZoneId": "use1-az4",
                    "GroupName": "us-east-1",
                    "State": "available",
                    "NetworkBorderGroup": "us-east-1",
                    "ZoneName": "us-east-1d",
                    "RegionName": "us-east-1"
                },
                {
                    "OptInStatus": "opt-in-not-required",
                    "Messages": [],
                    "ZoneId": "use1-az3",
                    "GroupName": "us-east-1",
                    "State": "available",
                    "NetworkBorderGroup": "us-east-1",
                    "ZoneName": "us-east-1e",
                    "RegionName": "us-east-1"
                },
                {
                    "OptInStatus": "opt-in-not-required",
                    "Messages": [],
                    "ZoneId": "use1-az5",
                    "GroupName": "us-east-1",
                    "State": "available",
                    "NetworkBorderGroup": "us-east-1",
                    "ZoneName": "us-east-1f",
                    "RegionName": "us-east-1"
                }
            ]
        }

    % create zones availibality
    $ kops create cluster --zones=us-east-1a,us-east-1b,us-east-1c,us-east-1d,us-east-1e,us-east-1f ${NAME}

    % specify an ssh key
    $ ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa
      passphrase ->  hello

    $ kops create secret --name ${NAME} sshpublickey admin -i ~/.ssh/id_rsa.pub

    % Customize Cluster Configuration
    # setup EDITOR ENV VARIABLE
    $ export EDITOR=vi
    $ kops edit cluster ${NAME}

    $ kops edit ig nodes --name ${NAME}
        spec:
          image: kope.io/k8s-1.16-debian-stretch-amd64-hvm-ebs-2020-01-17
          machineType: t2.micro
          maxSize: 2 -> 5
          minSize: 2 -> 3

    # we change how many instances we want for this clusters.

    # check nodes configured in the cluster.
    $ kops get ig nodes --name ${NAME}

    # check all the cluster
    $ kops get ig --name ${NAME}

    # to change something in a node (master/slave)
    $ kops edit ig master-us-east-1a --name ${NAME}

    -> if you want this example to not cost you money change machinetype to t2.micro.

    # build cluster provision machines
    $ kops update cluster ${NAME} --yes

    # to check if our cluster is live our not
    $ kops validate cluster

    # display nodes created
    $ kubectl get nodes --show-labels

### + Architecture Overview :

![](./static/wc-kube-aws-flat.png)

    + using a load balancer just if the master crashes,
      and get restarted the loadbalancer will point to
      the new one and save the high availibility of the system.

    ++ if any node crash aws will recreate a new one link it to the load balancer immediatly.


    %% Getting Started creating files that wrap our docker containers.

    # persistence volume for mongodb
    $ nano storage-aws.yml
      Copy in it ./microservices_deployment/storage-aws.yml
    $ kubectl apply -f storage-aws.yml

    # check for the volume that we created
    $ kubectl get pv -n kube-system


    # mongo docker image
    $ nano mongo-stack.yml
     Copy in it ./microservices_deployment/mongo-stack.yml
     cmd + X to save file

    $ kubectl apply -f mongo-stack.yml
    $ kubectl get all

    $ kubectl describe pod mongodb-7dc4596644-hrmxj
      -> Normal  SuccessfulAttachVolume  113s  attachdetach-controller                  AttachVolume.Attach succeeded for volume "pvc-75a09f5d-758b-4767-be37-1df9c8ad115a"
      - this line told us about mongodb database has been attanched to volume block store.

    # check logs of mongodb container
    $ kubectl logs -f pod/mongodb-7dc4596644-hrmxj

    # docker images of microservices architecture
    $ nano workloads.yml
     Copy in it ./microservices_deployment/workloads.yml
     cmd + X to save file

    $ nano services.yml
     Copy in it ./microservices_deployment/services.yml
     # Make a little changes (LoadBalancer option we could use it just in prod cloud environment that support loadbalancers and NodePort for testing and developement env)
     # for fleetman-webapp
     -> From

         ports:
            - name: http
              port: 80
              nodePort: 30080

        type: NodePort
    -> To

        ports:
            - name: http
              port: 80

        type: LoadBalancer

    # for fleetman-queue
     -> From

         ports:
        - name: http
          port: 8161
          nodePort: 30010

        - name: endpoint
          port: 61616

        type: NodePort

    -> To

         ports:
            - name: http
              port: 8161

            - name: endpoint
              port: 61616

        type: ClusterIP

    # for fleetman-api-gateway

    -> From :

        ports:
            - name: http
              port: 8080
              nodePort: 30020

        type: NodePort

    -> To :

        ports:
            - name: http
              port: 8080

        type: ClusterIP

    cmd + X to save file

    $ kubectl apply -f .
    $ kubectl get all

    # check logs
    $ kubectl logs -f pod/position-tracker-65cff5b766-85nkc
    2020-05-29 20:27:36.439  INFO 1 --- [           main] org.mongodb.driver.cluster               : Adding discovered server fleetman-mongodb.default.svc.cluster.local:27017 to client view of cluster
    # we can see that position-tracker microservice made a connection to the database mongodb.

    # To test the application in a live mode
    # go to loadbalancers
    # you will find two one you defined previousely and one it has been generated automatically
    # go to the second one -> check dns name Record A

    $ a2080664210b14eb786c418b9f2324fc-1709756137.us-east-1.elb.amazonaws.com

### - Setting up a registration domain name - Route53 dns:

    + setup a domain name :
    - go to freenom, get a domain name `pydevops.ml`
    - go to aws, Route53 craete hosted zone
    - put in domain name that you have created
    - copy NS or nameservers

        ns-994.awsdns-60.net.
        ns-1607.awsdns-08.co.uk.
        ns-1376.awsdns-44.org.
        ns-300.awsdns-37.com.

    - go to freenom -> management tools -> nameservers
    - paste them
    - go to aws Route53 -> create a recordset name -> fleetman.pydevops.ml
    - enable `alias` -> choose the second loadbalancer that you have created
    - click create
    - enter in the browser -> http://fleetman.pydevops.ml/

    ++ Congratulation !!

### + Now All Things are deployed, lets try to break the system to test resistence, resiliency and High-Availibality of the system :

    $ kubectl get pods -o wide
    # the node to delete where the webapp front-end app is hosted.
      webapp-785d5b86bf-tvzx2               1/1     Running   0          82m    100.96.3.4   ip-172-20-136-157.ec2.internal   <none>           <none>

    # node to delete -> ip-172-20-136-157.ec2.internal

    # go to the console of ec2 and delete this node.

    - Result :
    + the system was stopping for a while and the node get restarted but it took time to get live.

    ++ To solve this problem we should run two pods of the webapp image.
    $ vi workloads.yml
    # change webapp replicas from 1 to 2.
    $ kubectl apply -f workloads.yml

    # now we have two pods for webapp container
    $ kubectl get pods -o wide

    # node to delete -> ip-172-20-91-248.ec2.internal

    - !! Great, we broke the system by deleting the node and guess what there was no downtime.

    ++ to delete the cluster
    $ kops delete cluster --name ${NAME} --yes

#### + setting up ELK Stack for logging and Anaytics :

![](./static/elk.png)

---------------------

![](./static/elk-k8-cluster.png)

    + setting up ELK stack :

     here is the files that you will need them to configure elasticsearch, logstach | fluentd and kibana :
     -> https://github.com/kubernetes/kubernetes/tree/master/cluster/addons/fluentd-elasticsearch

    + What is DeamonSet
    - a deamonset is like replicatset but we don't define how many replica we are going to run, automatically
      the configuration will launch a pod for every node.

    + What is StatefulSet
    - is another kind of ReplicaSet what is diffrent is that StatefulSet give pods names like
        name: elasticsearch-logging-1
              elasticsearch-logging-2
              etc ..

    + we suppose that name of container is `name: elasticsearch-logging`


    1- nano fluentd-config.yml
       Copy ./microservices_deployement/aws/fluentd-config.yml paste.
    $ kubectl apply -f fluentd-config.yml

    2- nano elastic-stack.yml
       Copy ./microservices_deployement/aws/elastic-stack.yml paste.

    $ kubectl apply -f elastic-stack.yml

    # new elk pods are not in the default namespace so you won't see them here.
    $ kubectl get all -n kube-system

    # kubectl get po -n kube-system

    # get services of elk stack
    $ kubectl get svc -n kube-system

    # get info about front-end kibana systen
    $ kubectl describe service kibana-logging -n kube-system
    $ http://a0257e08879794a52939a263a430dfda-1054439490.us-east-1.elb.amazonaws.com:5601/

    kubectl logs -f elasticsearch-logging-0 -n kube-system

    kubectl logs -f elasticsearch-logging-0 -n kube-system

    kubectl describe svc kibana-logging -n kube-system
    kubectl get pod elasticsearch-logging-0 -n kube-system

    sudo sysctl -w vm.max_map_count=262144

![](./static/efk.png)


    - next, create an index pattern
    - name it, logstash*
    - next, select timestamps !!

### + Monitoring a CLUSTER (Grafana & Prometheus) :

![](./static/architecture-mrcv.png)

    - Easiest way to install Grafana & Prometheus in kubernetes is using Helm a package manager for k8.
      https://github.com/helm/helm

    1- install Helm on ec2 instance.
    # go to https://github.com/helm/helm/releases/tag/v3.2.1
    # copy the link of linux files
    $ wget https://get.helm.sh/helm-v3.2.1-linux-amd64.tar.gz
    $ ls

    2- unzip the folder
    $ tar zxvf helm-v3.2.1-linux-amd64.tar.gz
    $ sudo mv linux-amd64/helm /usr/local/bin
    $ rm helm-v3.2.1-linux-amd64.tar.gz
    $ rm -rf ./linux-amd64

    $ helm version

    $ helm repo add stable https://kubernetes-charts.storage.googleapis.com/
    $ helm repo update

    $ helm install monitoring stable/prometheus-operator


    # reach to prometheous by activiting a loadbalancer
    $ kubectl edit svc monitoring-prometheus-oper-prometheus
    change type: ClusterIP to type: NodePort

    $ minikube ip
    $ kubectl get svc # check the port to connect to prometheous
    % 192.168.64.8:30215


    # reach to grafana by activiting a loadbalancer
    $ kubectl edit svc monitoring-grafana
    change type: ClusterIP to type: NodePort

    $ minikube ip
    $ kubectl get svc # check the port to connect to prometheous
    % 192.168.64.8:32385

    # to get the password go to this link -> https://github.com/helm/charts/tree/master/stable/prometheus-operator
    # go to `Grafana` and search for `grafana.adminPassword`.

    # login is admin/prom-operator
    # click on home and choice for example pods


### + Alert Manager

    $ kubectl get pod
    $ kubectl get svc

    $ export EDITOR=nano
    $ kubectl edit svc monitoring-prometheus-oper-alertmanager

    -> 192.168.64.8:31156

    - Setting up a Slack Channel to send Alerts using a webhook :

    + login, and create a channel `#alerts`
    + create an app -> `Incomming Webhooks`
    + choose #alerts as a channel

    # test curl op
    $ curl -X POST --data-urlencode "payload={\"channel\": \"#alerts\", \"username\": \"webhookbot\", \"text\": \"Ceci est publié dans #alerts et provient d'un robot nommé webhookbot.\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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

    # config AlertManager
    $ vi alertmanager.yaml
    $
    $ https://prometheus.io/docs/alerting/configuration/

    + what is secrets
      secrets is just a way to store configuration, passwords, secret keys etc..

    $ kubectl get secrets
    $ kubectl get secret alertmanager-monitoring-prometheus-oper-alertmanager -o json

    $ get the token # we will try to  decrypt it to see the config file is content.

    $ echo Z2xvYmFsOgogIHJlc29sdmVfdGltZW91dDogNW0KcmVjZWl2ZXJzOgotIG5hbWU6ICJudWxsIgpyb3V0ZToKICBncm91cF9ieToKICAtIGpvYgogIGdyb3VwX2ludGVydmFsOiA1bQogIGdyb3VwX3dhaXQ6IDMwcwogIHJlY2VpdmVyOiAibnVsbCIKICByZXBlYXRfaW50ZXJ2YWw6IDEyaAogIHJvdXRlczoKICAtIG1hdGNoOgogICAgICBhbGVydG5hbWU6IFdhdGNoZG9nCiAgICByZWNlaXZlcjogIm51bGwi | base64 -D

    $ kubectl delete secret alertmanager-monitoring-prometheus-oper-alertmanager

    $ kubectl create secret generic alertmanager-monitoring-prometheus-oper-alertmanager --from-file=alertmanager.yaml

    # check if alertmanager is loaded the new config
    $ kubectl logs alertmanager-monitoring-prometheus-oper-alertmanager-0 -c alertmanager

        level=info ts=2020-05-31T02:33:28.755Z caller=coordinator.go:119 component=configuration msg="Loading configuration file" file=/etc/alertmanager/config/alertmanager.yaml
        level=info ts=2020-05-31T02:33:28.759Z caller=coordinator.go:131 component=configuration msg="Completed loading of configuration file" file=/etc/alertmanager/config/alertmanager.yaml

    !IMPORTANT! THE NAME OF THE FILE SHOULD BE `alertmanager.yaml`

### % it was loaded succefully and notifcation has been sent :

![](./static/slack-channel-alerts.png)

    # Solving the first Error :
     + problem 1 :
         [FIRING:1] etcdInsufficientMembers (kube-etcd default/monitoring-prometheus-oper-prometheus critical)
         @canal
         summary: etcd cluster "kube-etcd": insufficient members (0).

    + Solution :

        # go to the master node where normaly etcd in and click on security
         group -> inbound -> update cutom tcp rule -> change lowerbound from 4003 to 4001.

![](./static/resolved-alerts.png)

### + Resources Allocation :

    # check resources of k8 cluster (localy)
    $ kubectl describe node minikube

    # imagine if we have a minikube vm of 4 gb memory so the limit of a 4 replicas webapp pod is 1000Mi.
    # if we add another one the launch will fail.

### + Profiling an applcation to estimate requests and limits for your pod:

    $ minikube addons list
    $ minikube addons enable metrics-server
    $ kubectl top pod
        NAME                                                     CPU(cores)   MEMORY(bytes)
        alertmanager-monitoring-prometheus-oper-alertmanager-0   3m           19Mi
        api-gateway-559c9c5f86-lf45l                             61m          494Mi
        mongodb-65784d9f9d-x462r                                 332m         358Mi
        monitoring-grafana-679fc986c4-5j5kw                      6m           86Mi
        monitoring-kube-state-metrics-96f87d848-tnzc7            3m           11Mi
        monitoring-prometheus-node-exporter-fl5fw                2m           10Mi

    % it will gave you cpu, memory usage.

    # add a dashboard to visualise metrics
    $ minikube addons list
    $ minikube addons enable dashboard
    $ minikube dashboard

    # NOW WE ARE GOING TO CHANGE JAVA APPS CONTAINERS WITH OTHERS THAT ARE MORE OPTIMIZED
    # In other words we defined for them the maximum memory to consume ( -Xms )

    - update : change all containers tags to resources

    $ kubectl apply -f workloads.yml
    $ kubectl top pod


### + Horizontal Scaling and Componenet Replication :

    - First of all, before replicating any microservice or db we should ask the question
      is this microservice repliccccable or not ?

    - for example position-simulator is not replicable because if we replice it we will ge a weird
      behaviour from the webapp, the two replca will have the same data there is no sharing
      so you get the idea.

    + Algorithm Details :

        From the most basic perspective, the Horizontal Pod Autoscaler controller operates on the ratio between desired metric value and current metric value:

        desiredReplicas = ceil[currentReplicas * ( currentMetricValue / desiredMetricValue )]
        For example, if the current metric value is 200m, and the desired value is 100m, the number of replicas will be doubled, since 200.0 / 100.0 == 2.0 If the current value is instead 50m, we’ll halve the number of replicas, since 50.0 / 100.0 == 0.5. We’ll skip scaling if the ratio is sufficiently close to 1.0 (within a globally-configurable tolerance, from the --horizontal-pod-autoscaler-tolerance flag, which defaults to 0.1).

    - the pod that is replicable is the position tracker because


![](./static/pod-replica.png)
![](./static/autoscaling-scenario.png)

    + HPA Feature simply it allows us to define rules for scaling that mean if resources requested are consumed by 50%
      we will apply the specified rules.

    $ kubectl autoscale deployment api-gateway  --cpu-percent 400 --min 1 --max 4
    $ kubectl get hpa

    - ALternative 1 - use a yml file to define autoscaling rules:

        apiVersion: apps/v1
        kind: HorizontalPodAutoscaler
        metadata:
          name: api-gateway
          namespace: default
        spec:
          maxReplicas: 4
          minReplicas: 1
          scaleTargetRef:
            apiVersion: extensions/v1beta1
            kind: Deployment
            name: api-gateway
          targetCPUUtilizationPercentage: 400

    $ kubectl appy -f autoscaling-rules.yml

    - hpa could trigger scaledown also. change takes a few minutes for the transition.

    NOTE : Stateless pods are easier to scale than Stateful pods, pods that share data
           like databses are very hard to scale and you should look at the documnetation
           of a each specific database to see how scalability works.

### + Readiness and Liveness Problems

![](./static/new_pods.png)

    - when kubernetes detect that there is a need to add more replicas (HPA), it will create this new pods
      then immediatly after pod change it status to running the service linked to this pods will start redirecting
      request to this pod but the problem is each application have starting time to be ready depends on the programming
      langage used to develope this app.

    - For example java apps take around 20 to 30o sec to start.

    + Solution :
    - not sending a request until the time set for readiness in the yaml file be complete.

    * https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

    - Add this lines to the pod description in yaml file:
            readinessProbe:
                httpGet:
                    path: /
                    port: 8080

    + to test the change :

    1- kubectl apply -f workloads.yml # with 1 replica without `readinessProbe`
    2- update replicas by scaling pods running kubectl apply -f autoscaling-rule.yml
    3- go to another terminal execute `while true; do curl http://192.168.64.9:30080/; echo; done`

    # without `readiness` you will observe that some request fail because app inside pod are not yet ready
      but pod is ready

    4- add readiness, and repeat the same steps you won't have this problem.
         readinessProbe:
                httpGet:
                    path: /
                    port: 8080


    -> for liveness prob is concept to kill a pod after 3 failure (restart it), you can look at documnetation
       to see how to configure liveness.

    * https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/

### + QoS (Quality od service & Eviction) :

![](./static/QoS.png)

    + This example illustrate how is important the definition of Memory and CPU Usage before deployment
      what we call in the jargon `QoS: Guaranteed` that mean we make it for scheduler in k8 to put the pod
      in the conveniant place.

    + but for both the other two pods they make it hard for scheduler because for the second one we precise
      requested memory usage but not the limit, and for the third we define nothing but for

    - for scheduler if the first pod by pass the limit it will be evicted | scheduled in another pod.

    ! Important : for scheduler the pod that get evicted first in node is the `QoS: BestEffort`
                   because we could not predicte it usage. second is `Burstable` and last is `Guaranteed`
                   but if first pod is bypassing the limit it will be ec=victed immediatly.

    + to test we added to queue pod :

        resources:
            requests:
                memory: 300Mi
                cpu: 100m

    $ kubectl apply -f workloads.yml
    $ kubectl describe pod queue-7fc899cf8d-tjfdw
        QoS Class:       Burstable
        * because we added just requests and not limit also. to be QoS Guarented.

    + we can set priorities for pod (but it not adviced) -> https://kubernetes.io/docs/concepts/configuration/pod-priority-preemption/

    ++ !!! we can set high priority to queue pod because :
    ++ for the queue if we kill the pod it will restart but all the data that was in it will be lost
       so it's advisable to use hosted Queue lime Amazon ActiveMQ or Amazon SQS etc..


### - RBAC Authorization

    https://kubernetes.io/docs/reference/access-authn-authz/rbac/

    + requirements
    - tomorrow we have a new joiner, and we want to give him the ability :

      # look at all resources (pods, deployments, services ..)
      # creating their own pods/deployment in there own `playground` namespace.


    # to create a new role
    $ kubectl apply -f role-for-new-joiner.yml
    $ kubectl get rolebinding
    $ kubectl describe <role_name> # to see every user linked to this role

    # Authenticating | creating a context for the user

    - to authenticate we should establish a distributed private key

    $ useradd mdrahali-linux-login-name # create a new user in linux
    $ ls /home # to see all users in linux host machine
    $ sudo passwd mdrahali-linux-login-name
    $ kubectl create ns playground
    $ su - mdrahali-linux-login-name # connect as new user

    $ kubectl get all # ops i cannot release this operation.

    $ exit # get back to ec2-user

    $ kubectl config view # copy the `server` and `cluster`
    $ su - mdrahali-linux-login-name
    $ kubectl config set-cluster `cluster` --server=`cluster`
    $ kubectl config view # check updates

    $ kubectl get all # I still cannot execute this operation.

    # set a context

    $ kubectl config set-context mycontext --user mdrahali-linux-login-name --cluster `cluster`
    $ kubectl config view # check updates

    # use the new context
    $ kubectl config use-context mycontext

    $ kubectl get all # error i should have an x509 certificate to connect to the server.
    s exit # back to ec2-user (super-user)

### + Setting up the new certificate :

![](./static/scenario-process.png)

    # ec2-user

    $ openssl genrsa -out private-key-mdrahali.key 2048
    $ openssl req -new -key private-key-mdrahali.key -out req.csr -subj "/CN=mdrahali-linux-login-name"

    # now we should get kuberenetes key from s3 bucket
    $ aws ls s3://<s3-bucket-name>/ # follow the path till finding `pki` folder inside you will find a key with this format
      32u93449509834.key

    $ aws s3 cp s3://<s3-bucket-name>/..../pki/32u93449509834.key kubernetes.key
    $ chmod 400 kubernetes.key # set file readonlu by this user
    $ chmod 400 private-key-mdrahali.key

    # now go to a folder /pki/issued/ca
    # you will find something like 32u93449509834.crt

    $ aws s3 cp s3://<s3-bucket-name>/..../pki/32u93449509834.crt kubernetes.crt
    $ openssl x509 -req -in req.csr -CA kubernetes.crt -CAkey kubernetes.key -CAcreateserial -out mdrahali.crt -days 365

    $ sudo mkdir /home/mdrahali-linux-login-name/.certs
    $ sudo mv mdrahali.crt /home/mdrahali-linux-login-name/.certs
    $ sudo mv private-key-mdrahali.key /home/mdrahali-linux-login-name/.certs
    $ sudo mv kubernetes.key /home/mdrahali-linux-login-name/.certs

    $ rm kubernetes.key
    $ rm kubernetes.srl
    $ req.csr

    # change owner of this folder
    $ sudo chown -R mdrahali-linux-login-name:mdrahali-linux-login-name /home/mdrahali-linux-login-name/.certs/

    # login as mdrahali user
    $ su - mdrahali-linux-login-name

    $ kubectl get all # I still cannot execute this operation.

    $ cd /.certs
    $ ls -la # i should get this field in my kubectl config
    $ kubectl config set-credentials mdrahali-linux-login-name --client-certificate=mdrahali.crt --client-key=private-key-mdrahali.key
    $ kubectl config set-cluster `cluster` --certificate-authority=kubernetes.crt
    $ exit # back to ec2-user

    $ kubectl apply -f role-for-new-joiner.yml # execute role file

    $ su - mdrahali-linux-login-name

    $ kubectl get pod # it work
    $ kubectl get svc # it not working i can't see deployments because they are not in the same apiGroup

    $ exit

    $ vi role-for-new-joiner.yml

    # add "autoscaling" and "extensions" to apiGroups
    $ kubectl apply -f role-for-new-joiner.yml

    $ su - mdrahali-linux-login-name
    $ kubectl get all # it work fine.

    # now we have a smal problem is that we are allowed to work just on the `default` namespace
    # to allow the new-joiner to work on every namespace you should change
        kind: Role
            metadata:
              namespace: default
              name: new-joiner


        to :

        kind: ClusterRole
            metadata:
              name: new-joiner


    And

            kind: RoleBinding
                apiVersion: rbac.authorization.k8s.io/v1
                metadata:
                  name: put-specific-user-or-users-into-new-joiner-role
                  namespace: default
            ...
            roleRef:
              # "roleRef" specifies the binding to a Role / ClusterRole
              kind: Role #this must be Role or ClusterRole
            to :

            kind: ClusterRoleBinding
                apiVersion: rbac.authorization.k8s.io/v1
                metadata:
                  name: put-specific-user-or-users-into-new-joiner-role
            ....
            roleRef:
              # "roleRef" specifies the binding to a Role / ClusterRole
              kind: ClusterRole #this must be Role or ClusterRole

    $ kubectl apply -f role-for-new-joiner.yml

    # now there is another issue is that i could not access `playground` namespace

    # to solve this problem is to add this roles to `role-for-new-joiner.yml` file

      ---
      apiVersion: rbac.authorization.k8s.io/v1
        kind: Role
        metadata:
          namespace: playground
          name: new-joiner
        rules:
        - apiGroups: ["","apps","extensions"]
          resources: ["*"]
          verbs: ["*"]

       ---

        kind: RoleBinding
        apiVersion: rbac.authorization.k8s.io/v1
        metadata:
          name: new-joiner-role-binding
          namespace: playground
        subjects:
        - kind: User
          name: mdrahali-linux-login-name
        roleRef:
          kind: Role #this must be Role or ClusterRole
          name: new-joiner # this must match the name of the Role or ClusterRole you wish to bind to
          apiGroup: rbac.authorization.k8s.io

    $ kubectl apply -f role-for-new-joiner.yml

    $ su - mdrahali-linux-login-name
    $ kubectl get all -n playground # it work

    $ vi first-pod.yml

        apiVersion: v1
        kind: Pod
        metadata:
          name: webapp
          namespace: playground # remember that this user could work just on this namespace
        spec:
          containers:
          - name: webapp
            image: richardchesterwood/k8s-fleetman-webapp-angular:release0


    $ kubectl apply -f first-pod.yml
    $ kubectl get pod -n playground # it work .. Congratulations !!

    - There is also ServiceAccount and is used to give pods access to other pods.

### + ConfigMaps & Secrets :

    - ConfigMaps allows us to store enviroment variables in kubernetes cluster.

    $ vi database.config.yml

        apiVersion: v1
        kind: ConfigMap
        metadata:
          name: global-database-config
          namespace: default
        data:
          database-url: "https://dbserver.somewhere.com:3306/"
          database-password: "password"

    $ kubectl apply -f database.config.yaml
    $ kubectl get cm
    $ kubectl describe cm global-database-config

    # now we should link this config file with file where we have images `workloads.yml`

    $ kubectl apply -f database-config.yml
    $ kubectl apply -f workloads-configmaps.yml


    # get into position-simulator image to check if envs variables are there
    $ kubectl exec -it position-tracker-f4799d975-jd4rw  -- bash
    $ root@position-simulator-5f9b8b7669-wp9ct:/# echo $DATABASE_URL
        https://dbserver.somewhere.com:3306/

    It work !!

    # there is a small issue is that if we change something in configMap it won't reflect directly
      in the images, the only solution is to kill the pod to make restart and request the new config values.

    $ kubectl get all
    $ kubectl delete pod position-simulator-5f9b8b7669-wp9ct
    $ kubectl exec -it position-simulator-5f9b8b7669-zwr4t  -- bash
    $ root@position-simulator-5f9b8b7669-wp9ct:/# echo $DATABASE_URL
        https://changed.somewhere.com:3306/

    It work !!

    ! IMPORTANT : There is another method to force peeking new values from the file, is to create a new file
      change this name `global-database-config` with a new one change it in the `worloads` file apply changes
      and automatically the image will detect that the file changed and it will peek the content of the new file.

    - The problem in this approch is that we should change this `global-database-config` to this `global-database-config-v2`
    for example in all the file (you can do it with a script).


    # Another way to config env variables :

    from this :

         - name: DATABASE_URL
          valueFrom:
            configMapKeyRef:
              name: global-database-config
              # Specify the key associated with the value
              key: database.url
        - name: DATABASE_PASSWORD
          valueFrom:
            configMapKeyRef:
              name: global-database-config
              # Specify the key associated with the value
              key: database.password

    to this :

        envFrom:
        - configMapRef:
            name: global-database-config


    # Another way to store config variables :

    $ cd volume-mounts-config
    $ kubectl apply -f .
    $ kubectl exec -it position-simulator-7b87fc5cf4-g85pz --  bash
    $ ls
    $ cd /etc/any/directory/config
    $ cat database-properties
        database-url= "https://changed.somewhere.com:3306/"
        database-password= "password"

### + Secrets :

    https://kubernetes.io/docs/concepts/configuration/secret/

    $ vi aws-credentials.yml # pay attention in secret object values in data need to be encoded in base64 plaintext is forbidden
    # or you can inplace to mark "data" -> "stringData" and put string into quotation mark.
    $ kubectl apply -f aws-credentials.yml

    # we can convert in text to base64
    $ echo "mdrahali" | base64
        bWRyYWhhbAo=

    + Problem with `secrets` is that they are not secure. i can decode accessKey and secretKey easily
    # one important thing is that encoding != encrypting
    $ kubectl get secrets
    $ kubectl get secret aws-credentials -o yaml
        data:
          accesskey: YWRtaW4=
          secretKey: MWYyZDFlMmU2N2Rm

    $ echo MWYyZDFlMmU2N2Rm | base64 -D
        1f2d1e2e67dfM

    Voila !!

### + Ingress Control - Nginx :

    https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/

![](./static/first-config.png)

    - If we want to access both services (webapp, ActiveMQ) we should config two load balancers in aws for example,
      or we could use Ingress Control concept in kubernetes to route to this services.

![](./static/ingress-control.png)

    + Ingress Control basicaly is Nginx load balancer allows us to access pods using diffrent domainname (or ip addresses in dev env).
    + The mean goal of ingress Control is to reduce number of load balancers (aws: ALB)

    # Setup domainame localy to access minikube vm

    $ minikube ip
    192.168.64.9

    $ cd /etc/
    $ sudo vi hosts
        192.168.64.9 fleetmangmt.com

    $ curl fleetmangmt.com:30080/

    #localy
    $ minikube addons enable ingress

    $ kubectl get svc # get service of webapp and port
    $ vi ngress-lb.yml # define your routes
    $ kubectl apply -f ingress-lb.yml

    $ kubectl get ingress
    $ kubectl describe ingress basic-routing

    # Adding route
    $ cd /etc/
    $ sudo vi hosts
        192.168.64.9 queue.fleetmangmt.com

    $ vi ingress-lb.yml # add this

        - host: queue.fleetmangmt.com
          http:
            paths:
              - path: /
                backend:
                  serviceName: fleetman-queue
                  servicePort: 80

    $ kubectl apply -f ingress-lb.yml
    $ kubectl describe ingress basic-routing

    # Authentification to access to a route
    https://kubernetes.github.io/ingress-nginx/examples/auth/basic/

    1- go to https://www.htaccesstools.com/htpasswd-%20generator/ (use bcrypt)
       admin:$2y$10$5Ylb5sjSPqax6NwBvRMKUOxIEx6stDgBHS5DMi7PuNNVIZtA3WRGK

    2- save under filename `auth` -> vi auth
      admin:$2y$10$5Ylb5sjSPqax6NwBvRMKUOxIEx6stDgBHS5DMi7PuNNVIZtA3WRGK

    3- kubectl create secret generic mycredentials --from-file=auth

    $ kubectl get secret mycredentials
    $ kubectl get secret mycredentials -o yaml

    4- vi ingress-secure-lb.yml
    5- kubectl apply -f ingress-secure-lb.yml
    6- kubectl describe ingress secure-routing

    # go check urls queue.fleetmangmt.com


    # I uses two files one to secure access to queue.fleetmangmt.com and one to route to webapp service fleetmangmt.com.
    $ kubectl apply -f .

    # Get Ingress LB in aws :

    # in aws cloud
    https://kubernetes.github.io/ingress-nginx/deploy/#aws

    $ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-0.32.0/deploy/static/provider/aws/deploy.yaml
    # change all services to ClusterIP, domainnames should be linked to Route53. (if you have another domain not the same as what is in ingress files changes them)
    # mycredentials should be present in the ec2 node.

    # Setting-up HTTPS on aws:
    https://www.youtube.com/watch?v=gEzCKNA-nCg&feature=youtu.be


### + CronJobs k8:

    - Cronjobs are jobs that are scheduled to run in a given time repeatedly.

    $ get cron from https://crontab.guru/#23_0-20/2_*_*_*

    + DeamonSet are pods that run in every nodes without specifying number of repicas and are used specificaly for logstack, fluentd (logging collectors pods) that
      needs to be present in eery node for monitoring.


![](./static/statefulSet.png)
![](./static/replicas-database.png)

    + Example scaling mongodb horizontally by adding more replicas:
      we should declare the pod of mongodb as StatefulSet with 3 replicas
      the replicas will be named sequentialy mongo-server-1, mongo-server-2, mongo-server-3
      there will be an election of the primary database there is also a communication between all
      replicas, the client application will communicate with `service` of Stateful Pod, and it will do load
      balancing between replicas, and if primary replicas crashes there will be another election
      for the next primary db.

![](./static/replicat-mongodb.png)
![](./static/lb-service-statfulset.png)

    - Client will be (js example) -> $ var url = ‘mongodb://mongo-1,mongo-2,mongo-3:27017/dbname_?’;
                     (spring example) change from one replicas to three
                     from -> spring.data.mongodb.host=fleetman-mongodb.default.svc.cluster.local
                     to -> spring.data.mongodb.uri=mongodb://mongo-0.mongo.default.svc.cluster.local,mongo-1.mongo.default.svc.cluster.local,mongo-2.mongo.default.svc.cluster.local/fleetman


### +  CI/CD :

    + Setup a dedicated jenkins server
    + Setup An organization where we will put our Microservices repos
    https://github.com/disruptive-tech-community

    # link minikube with docker daemon :

    $ minikube docker-env
    $ eval $(minikube -p minikube docker-env)
    $ cd jenkins && git clone https://github.com/disruptive-tech-community/jenkins.git

    # keep just Dockerfile and jenkins file.

    # build the image that we are going to use for this jenkins server
    $ docker build . -t myjenkins
    $ docker images

    $ kubectl apply -f jenkins.yaml

    $ kubectl get svc
    $ minikube ip
    192.168.64.9:31000

    $ kubectl get all
      pod/api-gateway-769f8d44cb-7sfrh         1/1     Running              0          117s


    # config credentials
    # go to jenkins manager -> system configure
    # go to Propriétés globales -> env variables
    # add this two variables
        ORGANIZATION_NAME : disruptive-tech-community # organization name
        YOUR_DOCKERHUB_USERNAME: mdrahali # docker hub name

    # go to new job
    # select `Multibranch pipeline`, create
    # add a name
    # go to branch sources -> add `jenkins`
    # enter login (username/password of github account), and ID `GitHub` (like this change nothing)
    # select ` Repository Scan - Deprecated Visualization`
    # owner `disruptive-tech-community` (organization name)
    # choose your repo
    # click save


    $ kubectl describe pod api-gateway-769f8d44cb-7sfrh
    # pod pulled from CD Jenkins
      Normal   Pulled     2m44s                  kubelet, minikube  Container image "mdrahali/disruptive-tech-community-fleetman-api-gateway:2" already present on machine

    # demo for pushing to minikube
    $ kubectl get pod --watch

    # go to multibranch `api-gateway` pipeline
    # click on launch a build

    IMPORTANT !! : In each repo we should have three files docker , jenkins, kubernetes (Dockerfile, jenkins.yaml, deploy.yml).

![](./static/target-process.png)

    + Another Feature of Jenkins is that we can do CI/CD for all the organization
    # go to jenkins and create a job
    # give it a name and choose `Github Organisation`.
    # specify credentials and click save.

    + Also we can create a webhook between organisation github and jenkins so evry
      commit will trigger a new build.


### +  Advanced Kubernetes :

    + Setting Up a Basic Service - Application Overview :

    The application that we will use for our sample isn’t particularly complex.
    It’s a simple journal service that stores its data in a Redis backend. It has a separate static file server using NGINX.
    It presents two web paths on a single URL. The paths are one for the journal’s RESTful application programming interface (API),
    https://my-host.io/api, and a file server on the main URL, https://my-host.io. It uses the Let’s Encrypt service for managing
    Secure Sockets Layer (SSL) certificates. Figure 1-1 presents a diagram of the application. Throughout this chapter,
    we build up this application, first using YAML configuration files and then Helm charts.


![](./static/simple-webapp.png)


    + App description :
      application exposes an HTTP service on port 8080 that serves requests to the /api/* path and uses the Redis backend to add,
      delete, or return the current journal entries. This application can be built into a container image using the included
      Dockerfile and pushed to your own image repository. Then, substitute this image name in the YAML examples that follow.


    + Security Risks :
      In general, the image build process can be vulnerable to “supply-chain attacks.” In such attacks, a malicious user injects
      code or binaries into some dependency from a trusted source that is then built into your application. Because of the risk
      of such attacks, it is critical that when you build your images you base them on only well-known and trusted image providers.
      Alternately, you can build all your images from scratch. Building from scratch is easy for some languages (e.g., Go)
      that can build static binaries, but it is significantly more complicated for interpreted languages like Python, JavaScript, or Ruby.”

    + Naming Problems of docker images :
      In particular, some combination of the semantic version and the SHA hash of the commit where the image was built is a good practice
      for naming images (e.g., v1.0.1-bfeda01f). If you don’t specify an image version, latest is used by default. Although this can be
      convenient in development, it is a bad idea for production usage because latest is clearly being mutated every time a
      new image is built.


    + Replication of Stateless pods :
      Though our application is unlikely to sustain large-scale usage, it’s still a good idea to run with at least two replicas so
      that you can handle an unexpected crash or roll out a new version of the application without downtime.

    + ReplicaSet vs Deployment :
      Though in Kubernetes, a ReplicaSet is the resource that manages replicating a containerized application,
      so it is not a best practice to use it directly. Instead, you use the Deployment resource. A Deployment
      combines the replication capabilities of ReplicaSet with versioning and the ability to perform a staged
      rollout. By using a Deployment you can use Kubernetes’ built-in tooling to move from one version of
      the application to the next.

    $ rm -r ~/.kube
    $ rm -r ~/.minikube

    $ minikube start --cpus 2 --memory 4096

    $ cd journal-webapp/frontend
    $ docker build -t journal-server .
    $ docker tag journal-server mdrahali/journal-server:v1
    $ docker push mdrahali/journal-server:v1

    $ kubectl apply -f frontend.yml
    $ kubectl describe deployment.apps/frontend

    + Git Best practices - GitOps :
      It is also a best practice to ensure that the contents of your cluster exactly match the contents of your source control.
      The best pattern to ensure this is to adopt a GitOps approach and deploy to production only from a specific branch of your
      source control, using Continuous Integration (CI)/Continuous Delivery (CD) automation. In this way you’re guaranteed that
      source control and production match.

    + Setting Up an External Ingress for HTTP Traffic
    The containers for our application are now deployed, but it’s not currently possible for anyone to access the application.
    By default, cluster resources are available only within the cluster itself. To expose our application to the world,
    we need to create a Service and load balancer to provide an external IP address and to bring traffic to our containers.
    For the external exposure we are actually going to use two Kubernetes resources. The first is a Service that load-balances
    Transmission Control Protocol (TCP) or User Datagram Protocol (UDP) traffic. In our case, we’re using the TCP protocol.
    And the second is an Ingress resource, which provides HTTP(S) load balancing with intelligent routing of requests based
    on HTTP paths and hosts. With a simple application like this, you might wonder why we choose to use the more complex Ingress,
    but as you’ll see in later sections, even this simple application will be serving HTTP requests from two different services.
    Furthermore, having an Ingress at the edge enables flexibility for future expansion of our service.”

    Before the Ingress resource can be defined, there needs to be a Kubernetes Service for the Ingress to point to.
    We’ll use Labels to direct the Service to the pods that we created in the previous section. The Service is significantly
    simpler to define than the Deployment and looks as follows:

    # first step is to enable ingress in minikube
    $ minikube addons list
    $ minikube addons enable ingress
    $ minikube addons enable ingress-dns

    $ kubectl apply -f services.yml
    $ kubectl apply -f ingress-lb.yml
    $ minikube ip
        192.168.64.10
    $ cd /etc
    $ vi hosts
    # add this two lines
        192.168.64.10 api.journal.com
        192.168.64.10 journal.com
    $ kubectl get all

    + Configuration in DEMAND :
      In Kubernetes this sort of configuration is represented by a resource called a ConfigMap. A ConfigMap contains multiple
      key/value pairs representing configuration information or a file. This configuration information can be presented
      to a container in a pod via either files or environment variables. Imagine that you want to configure your online
      journal application to display a configurable number of journal entries per page. To achieve this, you can define
      a ConfigMap as follows:

      $ kubectl create configmap frontend-config --from-literal=journalEntries=10

    - and add this to frontend.yml :

        env:
        - name: JOURNAL_ENTRIES
          valueFrom:
            configMapKeyRef:
              name: frontend-config
              key: journalEntries


    $ kubectl apply -f frontend.yml
    $ kubectl exec -it pod/frontend-77c77f678f-bslj2 -- bash
    $ -> # echo $JOURNAL_ENTRIES
    $ printenv # print all env variables

    IMPORTANT !! changing the configuration doesn’t actually trigger an update to existing pods. Only when the pod is
    restarted is the configuration applied. Because of this, the rollout isn’t health based and can be ad hoc or random.

    + Changing ConfigMaps Best practice :
      A better approach is to put a version number in the name of the ConfigMap itself. Instead of calling it frontend-config,
      call it frontend-config-v1. When you want to make a change, instead of updating the ConfigMap in place, you create a
      new v2 ConfigMap, and then update the Deployment resource to use that configuration. When you do this, a Deployment
      rollout is automatically triggered, using the appropriate health checking and pauses between changes.
      thermore, if you ever need to rollback, the v1 configuration is sitting in the cluster and rollback is
      as simple as updating the Deployment again.


    + create a secret to limit access to redis :
    $ kubectl create secret generic redis-passwd --from-literal=passwd=${RANDOM}

    $ vi frontend.yml
    $ add this to the deployment (we should mount a volume to persiste secrets)
        volumeMounts:
          - name: passwd-volume
            readOnly: true
            mountPath: "/etc/redis-passwd
        ...
        volumes:
        - name: passwd-volume
          secret:
            secretName: redis-passwd

    $ kubectl apply -f .

    + Deploying a Simple Stateful Database :
    Although conceptually deploying a stateful application is similar to deploying a client like our frontend, state brings with it more complications.
    The first is that in Kubernetes a pod can be rescheduled for a number of reasons, such as node health, an upgrade, or rebalancing. When this happens,
    the pod might move to a different machine. If the data associated with the Redis instance is located on any particular machine or within the container itself,
    that data will be lost when the container migrates or restarts. To prevent this, when running stateful workloads in Kubernetes its important to use remote
    PersistentVolumes to manage the state associated with the application.

    There is a wide variety of different implementations of PersistentVolumes in Kubernetes, but they all share common characteristics. Like secret volumes
    described earlier, they are associated with a pod and mounted into a container at a particular location. Unlike secrets, PersistentVolumes are generally
    remote storage mounted through some sort of network protocol, either file based, such as Network File System (NFS) or Server Message Block (SMB), or block based
    (iSCSI, cloud-based disks, etc.). Generally, for applications such as databases, block-based disks are preferable[…]”

    $ kubectl apply -f redis-statfulset.yml

    # to push secret to every redis replica (redis-0, redis-1, redis-2)
    $ kubectl create configmap redis-config --from-file=redis-launch.sh

    + You then add this ConfigMap to your StatefulSet and use it as the command for the container.
      Let’s also add in the password for authentication that we created earlier in the chapter.

         volumeMounts:
                  - name: data
                    mountPath: /data
                  - name: script
                    mountPath: /script/redis-launch.sh
                    subPath: redis-launch.sh
                  - name: passwd-volume
                    mountPath: /etc/redis-passwd
                  command:
                    - sh
                    - -c
                    - /script/redis-launch.sh
                  volumes:
                    - name: script
                      configMap:
                        name: redis-config
                        defaultMode: 0777
                    - name: passwd-volume
                      secret:
                        secretName: redis-passwd
                  volumeClaimTemplates:
                    - metadata:
                        name: data
                      spec:
                        accessModes: [ "ReadWriteOnce" ]
                        resources:
                          requests:
                            storage: 10Gi

    $ kubectl apply -f redis-statfulset.yml

    + Creating a TCP Load Balancer by Using Services :

    - Redis read config (check services.yml)
      Now that we’ve deployed the stateful Redis service, we need to make it available to our frontend.
      To do this, we create two different Kubernetes Services. The first is the Service for reading data
      from Redis. Because Redis is replicating the data to all three members of the StatefulSet,
      we don’t care which read our request goes to. Consequently, we use a basic Service for the reads:

    - Redis write config (check services.yml)

      To enable writes, you need to target the Redis master (replica #0). To do this, create a headless Service.
      A headless Service doesn’t have a cluster IP address; instead, it programs a DNS entry for every pod
      in the StatefulSet. This means that we can access our master via the redis-0.redis DNS name:

    + Using Ingress to Route Traffic to a Static File Server
    The final component in our application is a static file server. The static file server is responsible for serving HTML, CSS, JavaScript, and image files.
    It’s both more efficient and more focused for us to separate static file serving from our API serving frontend described earlier.
    We can easily use a high-performance static off-the-shelf file server like NGINX to serve files while we allow our development teams to focus on the code
    needed to implement our API.

    $ kubectl create configmap redis-config --from-file=redis-launch.sh


    + Deploying Services Best Practices :

    Kubernetes is a powerful system that can seem complex. But setting up a basic application for success can be straightforward if you use the following best practices:
    Most services should be deployed as Deployment resources. Deployments create identical replicas for redundancy and scale.
    Deployments can be exposed using a Service, which is effectively a load balancer. A Service can be exposed either within a cluster (the default) or externally.
    If you want to expose an HTTP application, you can use an Ingress controller to add things like request routing and SSL.
    Eventually you will want to parameterize your application to make its configuration more reusable in different environments. Packaging tools like Helm are the best
    choice for this kind of parameterization.

### + Developer Workflows - Building a Development Cluster :

    - Setting Up a Shared Cluster for Multiple Developers
      When setting up a large cluster, the primary goal is to ensure that multiple users can simultaneously use the cluster without
      stepping on one another’s toes. The obvious way to separate your different developers is with Kubernetes namespaces.
      Namespaces can serve as scopes for the deployment of services so that one user’s frontend service doesn’t interfere
      with another user’s frontend service. Namespaces are also scopes for RBAC, ensuring that one developer cannot
      accidentally delete another developer’s work. Thus, in a shared cluster it makes sense to use a namespace as a
      developer’s workspace.

    + Generate Certificate FOR NEW DEV :
    $ cd developer_workflow
    $ go run generate_certificate.go client dev1

     This creates files called client-key.pem and client.csr. You then can run the following script to create and download
     a new certificate :

    $ vi ndev-kubeconfig
    $ chmod +x ndev-kubeconfig.sh # make the file an executable
    $ bash ndev-kubeconfig.sh #run the script `ndev-kubeconfig` to generate config for the cluster.

    This script prints out the final information that you can add to a kubeconfig file to enable that user.
    Of course, the user has no access privileges, so you will need to apply Kubernetes RBAC for the user in order to
    grant them privileges to a namespace.


    + Create a namespace
     ns='my-namespace'
     kubectl create namespace ${ns}
     kubectl annotate namespace ${ns}
     annotation_key=annotation_value

    + RBAC Authorization :
    + When the namespace is created, you want to secure it by ensuring that you can grant access to the namespace to a specific user.
      To do this, you can bind a role to a user in the context of that namespace. You do this by creating a RoleBinding object within
      the namespace itself. The RoleBinding might look like this:

    $ vi role-binding.yaml

        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          name: example
          namespace: my-namespace
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: edit
        subjects:
        - apiGroup: rbac.authorization.k8s.io
          kind: User
          name: myuser

    $ kubectl create -f role-binding.yaml

    + If you want to limit the amount of resources consumed by a particular namespace, you can use the ResourceQuota
      resource to set a limit to the total number of resources that any particular namespace consumes. For example,
      the following quota limits the namespace to 10 cores and 100 GB of memory for both Request and Limit for
      the pods in the namespace:

        apiVersion: v1
        kind: ResourceQuota
        metadata:
          name: limit-compute
          namespace: my-namespace
        spec:
          hard:
            requests.cpu: "10"
            requests.memory: 100Gi
            limits.cpu: "10"
            limits.memory: 100Gi

    + Namespace management
      making the developer’s namespace too persistent encourages the developer to leave things lying around in the namespace
      after they are done with them, and garbage-collecting and accounting individual resources is more complicated.
      An alternate approach is to temporarily create and assign a namespace with a bounded time to live (TTL).
      This ensures that the developer thinks of the resources in the cluster as transient and that it is
      easy to build automation around the deletion of entire namespaces when their TTL has expired.


    + In this model, when the developer wants to begin a new project, they use a tool to allocate a new namespace for the project.
      When they create the namespace, it has a selection of metadata associated with the namespace for management and accounting.
      Obviously, this metadata includes the TTL for the namespace, but it also includes the developer to which it is assigned,
      the resources that should be allocated to the namespace (e.g., CPU and memory), and the team and purpose of the namespace.
      This metadata ensures that you can both track resource usage and delete the namespace at the right time.

    + you can use ScheduledJobs to acheive allocation of new namespaces and doing garbage collecting for Experied TTL namespaces.


    + App Initial Startup - Best Practices :
    best solution is to have a startup script like startup.sh that create all depandencies
    within a namespace to ensure that all of the application’s dependencies are correctly created, example (node.js) :

        kubectl create my-service/database-stateful-set-yaml
        kubectl create my-service/middle-tier.yaml
        kubectl create my-service/configs.yaml

        You then could integrate this script with npm by adding the following to your package.json:
        {
            ...
            "scripts": {
                "setup": "./setup.sh",
                ...
            }
        }


    + Containers - Best Practices
    the best practice is to delete and re-create the Deployment. for new release of a docker image.

    Just like installing dependencies, it is also a good practice to make a script for performing this deployment.
    An example deploy.sh script might look like the following:

    kubectl delete -f ./my-service/deployment.yaml
    perl -pi -e 's/${old_version}/${new_version}/' ./my-service/deployment.yaml
    kubectl create -f ./my-service/deployment.yaml

    + Setting Up a Development Environment Best Practices
    Setting up successful workflows on Kubernetes is key to productivity and happiness. Following these best practices will help to ensure that developers are up and running quickly:
    Think about developer experience in three phases: onboarding, developing, and testing. Make sure that the development environment you build supports all three of these phases.
    When building a development cluster, you can choose between one large cluster and a cluster per developer. There are pros and cons to each, but generally a single large cluster
    is a better approach.
    When you add users to a cluster, add them with their own identity and access to their own namespace. Use resource limits to restrict how much of the cluster they can use.
    When managing namespaces, think about how you can reap old, unused resources. Developers will have bad hygiene about deleting unused things. Use automation to clean it up for them.
    Think about cluster-level services like logs and monitoring that you can set up for all users. Sometimes, cluster-level dependencies like databases are also useful to set up on behalf
    of all users using templates like Helm charts.

### + Monitoring and Logging in Kubernetes


    - Metrics Versus Logs :
    You first need to understand the difference between log collection and metrics collection.
    They are complementary to each other but serve different purposes.

    + Metrics :
    A series of numbers measured over a period of time

    + Logs :
    Used for exploratory analysis of a system
    An example of where you would need to use both metrics and logging is when an application is performing poorly.
    Our first indication of the issue might be an alert of high latency on the pods hosting the application,
    but the metrics might not give a good indication of the issue. We then can look into our logs to perform an
    investigation of errors that are being emitted from the application.

    - Monitoring Techniques :
    Black-box monitoring focuses on monitoring from the outside of an application and is what’s been used traditionally when monitoring systems for components
    like CPU, memory, storage, and so on. Black-box monitoring can still be useful for monitoring at the infrastructure level, but it lacks insights and context
    into how the application is operating. For example, to test whether a cluster is healthy, we might schedule a pod, and if it’s successful, we know that the
    scheduler and service discovery are healthy within our cluster, so we can assume the cluster components are healthy.
    White-box monitoring focuses on the details in the context of the application state, such as total HTTP requests, number of 500 errors, latency of requests,
    and so on. With white-box monitoring, we can begin to understand the “Why” of our system state. It allows us to ask, “Why did the disk fill up?” and not just,
    “The disk filled up.”

    + There are a couple of different monitoring patterns to focus on when monitoring distributed systems.
    The USE method, popularized by Brendan Gregg, focuses on the following:

        U—Utilization
        S—Saturation
        E—Errors

    + Another monitoring approach, called the RED method, was popularized by Tom Willke. The RED method approach is focused on the following:
        R—Rate
        E—Errors
        D—Duration

    + The philosophy was taken from Google’s Four Golden Signals:
        Latency (how long it takes to serve a request)
        Traffic (how much demand is placed on your system)
        Errors (rate of requests that are failing)
        Saturation (how utilized your service is)

    As an example, you could use this method to monitor a frontend service running in Kubernetes to calculate the following:
        How many requests is my frontend service processing?
        How many 500 errors are users of the service receiving?
        Is the service overutilized by requests?

    As you can see from the previous example, this method is more focused on the experience of the users and their experience with the service.
    The USE and RED methods are complementary to each other given that the USE method focuses on the infrastructure components and the RED method
    focuses on monitoring the end-user experience for the application.

    + Monititoring your kuberenetes cluster :
    monitoring in your Kubernetes cluster. A Kubernetes cluster consists of control-plane components and worker-node components.
    The control-plane components consist of the API Server, etcd, scheduler, and controller manager. The worker nodes consist of the kubelet,
    container runtime, kube-proxy, kube-dns, and pods. You need to monitor all these components to ensure a healthy cluster and application.

    +cAdvisor
    Container Advisor, or cAdvisor, is an open source project that collects resources and metrics for containers running on a node.
    cAdvisor is built into the Kubernetes kubelet, which runs on every node in the cluster. It collects memory and CPU metrics through
    the Linux control group (cgroup) tree. If you are not familiar with cgroups, it’s a Linux kernel feature that allows isolation of
    resources for CPU, disk I/O, or network I/O. cAdvisor will also collect disk metrics through statfs, which is built into the Linux kernel.
    These are implementation details you don’t really need to worry about, but you should understand how these metrics are exposed and the
    type of information you can collect. You should consider cAdvisor as the source of truth for all container metrics.

    + kube-state-metrics:

    kube-state-metrics is a Kubernetes add-on that monitors the object stored in Kubernetes. Where cAdvisor and metrics server are used to
    provide detailed metrics on resource usage, kube-state-metrics is focused on identifying conditions on Kubernetes objects deployed to your cluster.
    Following are some questions that kube-state-metrics can answer for you:

    Pods
    How many pods are deployed to the cluster?
    How many pods are in a pending state?
    Are there enough resources to serve a pods request?

    Deployments
    How many pods are in a running state versus a desired state?
    How many replicas are available?
    What deployments have been updated?

    Nodes
    What’s the status of my worker nodes?
    What are the allottable CPU cores in my cluster?
    Are there any nodes that are unschedulable?

    Jobs
    When did a job start?
    When did a job complete?
    How many jobs failed?


    + Monitoring Tools :
    There are many monitoring tools that can integrate with Kubernetes, and more arriving every day, building on their feature set to have better
    integration with Kubernetes. Following are a few popular tools that integrate with Kubernetes:

    Prometheus
    Prometheus is an open source systems monitoring and alerting toolkit originally built at SoundCloud. Since its inception in 2012,
    many companies and organizations have adopted Prometheus, and the project has a very active developer and user community. It is now a
    standalone open source project and maintained independent of any company. To emphasize this, and to clarify the project’s governance structure,
    Prometheus joined the Cloud Native Computing Foundation (CNCF) in 2016 as the second hosted project, after Kubernetes.

    InfluxDB
    InfluxDB is a time-series database designed to handle high write and query loads. It is an integral component of the TICK (Telegraf, InfluxDB, Chronograf, and Kapacitor)
    stack. InfluxDB is meant to be used as a backing store for any use case involving large amounts of timestamped data, including DevOps monitoring, application metrics,
    IoT sensor data, and real-time analytics.

    Datadog
    Datadog provides a monitoring service for cloud-scale applications, providing monitoring of servers, databases, tools, and services through a SaaS-based data analytics platform.

    + Monitoring Kubernetes Using Prometheus :

     To collect metrics, Prometheus uses a pull model in which it scrapes a metrics endpoint to collect and ingest the metrics into the Prometheus server.
     Systems like Kubernetes already expose their metrics in a Prometheus format, making it simple to collect metrics. Many other Kubernetes ecosystem
     projects (NGINX, Traefik, Istio, LinkerD, etc.) also expose their metrics in a Prometheus format. Prometheus also can use exporters, which
     allow you to take emitted metrics from your service and translate them to Prometheus-formatted metrics.

![](./static/prometheus_architecture.png)

    #TIP
    You can install Prometheus within the cluster or outside the cluster. It’s a good practice to monitor your cluster from a “utility cluster”
    to avoid a production issue also affecting your monitoring system. There are tools like Thanos that provide high availability for Prometheus
    and allow you to export metrics into an external storage system.

    In this chapter we install the Prometheus Operator:

    - Prometheus Server :
    Pulls and stores metrics being collected from systems.

    - Prometheus Operator :
    Makes the Prometheus configuration Kubernetes native, and manages and operates Prometheus and Alertmanager clusters. Allows you to create, destroy, and configure Prometheus resources through native Kubernetes resource definitions.

    - Node Exporter :
    Exports host metrics from Kubernetes nodes in the cluster.

    - kube-state-metrics :
    Collects Kubernetes-specific metrics.

    - Alertmanager :
    Allows you to configure and forward alerts to external systems.

    - Grafana :
    Provides visualization on dashboard capabilities for Prometheus.

    $ helm repo update
    $ helm install prom stable/prometheus-operator
    $ kubectl --namespace default get pods -l "release=prom"
    $ kubectl get pods

    # let's take a look at prometeus server to see how you can run some queries
      to retreive kubernetes metrics :

    # Create a tunnel to our localhost on port 9090
    $ kubectl port-forward svc/prom-prometheus-operator-prometheus 9090
    $ check -> 127.0.0.1:9090

    # we will explore metrics with USE method (Utilization, Saturation, Error) on CPU :
    #Query Language of Prometeus is PromQL :

    # Average CPU Utilization on the cluster :
    $ avg(rate(node_cpu_seconds_total[5m]))

    # Average CPU Utilization per Node | it will return one value because Minikube VM is one node:
    $ avg(rate(node_cpu_seconds_total[5m])) by (node_name)

    + You’ll now need to create a port-forward tunnel to the Grafana pod so that you can access it from your local machine:
    $ kubectl port-forward svc/prom-grafana 3000:80
    $ check -> 127.0.0.1:3000

    # to get the password go to this link -> https://github.com/helm/charts/tree/master/stable/prometheus-operator
    # go to `Grafana` and search for `grafana.adminPassword`.
    # login admin/prom-operator

    # next, Click on Home choose `USE Method/Cluster` This dashboard gives you a good overview of
      the utilization and saturation of the kubernetes Cluster.

    # Stress CPU with request
    $ for ((i=1;i<=100000;i++)); do curl http://journal.com/api; echo ; done


    #TIP
    Avoid creating too many dashboards (aka “The Wall of Graphs”) because this can be difficult for engineers to reason with in troubleshooting situations.
    You might think having more information in a dashboard means better monitoring, but the majority of the time it causes more confusion for a user looking at the dashboard.
    Focus your dashboard design on outcomes and time to resolution.

    + Logging Overview :

    you also need to collect and centralize logs from the Kubernetes cluster and the applications deployed to your cluster.
    - With logging, it might be easy to say, “Let’s just log everything,” but this can cause two issues:

    1- There is too much noise to find issues quickly.
    2- Logs can consume a lot of resources and come with a high cost.

    There is no clear-cut answer to what exactly you should log because debug logs become a necessary evil.
    Over time you’ll start to understand your environment better and learn what noise you can tune out from the logging system.
    Also, to address the ever-increasing amount of logs stored, you will need to implement a retention and archival policy.
    From an end-user experience, having somewhere between 30 and 45 days worth of historical logs is a good fit.
    This allows for investigation of problems that manifest over a longer period of time, but also reduces the amount
    of resources needed to store logs. If you require longer-term storage for compliance reasons, you’ll want to archive the logs
    to more cost-effective resources.
    In a Kubernetes cluster, there are multiple components to log.
    Following is a list of components from which you should be collecting metrics:

    - Node logs
    - Kubernetes, control-plane, logs

    - API server
    - Controller manager
    - Scheduler
    - Kubernetes audit logs
    - Application container logs

    - Tools for Logging :
    Like collecting metrics there are numerous tools to collect logs from Kubernetes and applications running in the cluster.
    You might already have tooling for this, but be aware of how the tool implements logging. The tool should have
    the capability to run as a Kubernetes DaemonSet and also have a solution to run as a sidecar for applications
    that don’t send logs to STDOUT. Utilizing an existing tool can be advantageous because you will already
    have a lot of operational knowledge of the tool.

    + Some of the more popular tools with Kubernetes integration are:
        Elastic Stack
        Datadog
        Sumo Logic
        Sysdig
        Cloud provider services (GCP Stackdriver, Azure Monitor for containers, and Amazon CloudWatch)

    When looking for a tool to centralize logs, hosted solutions can provide a lot of value because they offload a lot of the operational
    cost. Hosting your own logging solution seems great on day N, but as the environment grows, it can be very time consuming
    to maintain the solution.

    - Logging by Using an EFK Stack :
    For the purposes of this book, we use an Elasticsearch, Fluentd, and Kibana (EFK) stack to set up monitoring for our cluster.
    Implementing an EFK stack can be a good way to get started, but at some point you’ll probably ask yourself, “Is it really worth
    managing my own logging platform?” Typically it’s not worth the effort because self-hosted logging solutions are great on day one,
    but they become overly complex by day 365. Self-hosted logging solutions become more operationally complex as your environment scales.
    There is no one correct answer, so evaluate whether your business requirements need you to host your own solution. There are also a number of

    - Setup EFK on your Cluster :
      check config files source -> https://github.com/upmc-enterprises/elasticsearch-operator -> example (efk stack)

    !IMPORTANT Putting EFK Stack in the same namespace is a rule.

    $ cd efk-logging
    $ kubectl create namespace logging
    $ kubectl apply -f elasticsearch-operator.yaml -n logging
    $ kubectl apply -f efk.yaml -n logging

    # if you have a apiVersion Problem triggred from an update of k8 api
    # you can check the new one with this command
    $ kubectl api-resources | grep -i daemon

    $ kubectl get pods -n logging

    # Let's connect to Kibana thought port forwarding

    $ export POD_NAME=$(kubectl get pods --namespace logging -l "app=kibana,release=efk" -o jsonpath="{.items[0].metadata.name}")
    $ kubectl port-forward $POD_NAME -n logging 5601:5601
    $ kubectl port-forward elasticsearch-operator-566d9c948b-p9ncx  -n logging 9200:9200

    #  Prob 1 :
    - Unable to connect to Elasticsearch at http://elasticsearch-efk-cluster:9200/

    #solution :
    - go to efk.yaml -> change elasticsearch.url from http://elasticsearch-efk-cluster:9200/ to http://127.0.0.1:9200

    $ netstat -a -n | grep tcp | grep 9200


    Alerting :

    - An example would be generating an alert any time a pod fails.
    - if your SLO for a frontend service is a 20-ms response time and
      you are seeing higher latency than average, you want to be alerted on the problem.

    - One way to handle alerts that don’t need immediate action is to focus on automating the remediation of the cause.
      For example, when a disk fills up, you could automate the deletion of logs to free up space on the disk. Also,
      utilizing Kubernetes liveness probes in your app deployment can help autoremediate issues with a process that
      is not responding in the application.

    - You also need to build notification channels to route alerts that are fired. When thinking about
     “Who do I notify when an alert is triggered?” you should ensure that notifications are not just sent
     to a distribution list or team emails. What tends to happen if alerts are sent to larger groups is that
     they end up getting filtered out because users see these as noise. You should route notifications to the
     user who is going to take responsibility for the issue.

    - Philosophy of alerting : https://docs.google.com/document/d/199PqyG3UsyXlwieHaqbGiWVa8eMWi8zzAn0YfcApr8Q/edit

### + Configuration, Secrets, and RBAC

    + Example in ./configMaps_Secret is of creating a configmap and secret as volume.
      Each property name in the ConfigMap/Secret will become a new file in the mounted directory,
      and the contents of each file will be the value specified in the ConfigMap/Secret. Second,
      avoid mounting ConfigMaps/Secrets using the volumeMounts.subPath property. This will prevent
      the data from being dynamically updated in the volume if you update a ConfigMap/Secret with new data.

### + Continuous Integration, Testing, and Deployment

    + We will go through an example CI/CD pipeline, which consists of the following tasks:
        - Pushing code changes to the Git repository
        - Running a build of the application code
        - Running test against the code
        - Building a container image on a successful test
        - Pushing the container image to a container registry
        - Deploying the application to Kubernetes
        - Running a test against a deployed application
        - Performing rolling upgrades on Deployments

    - Optimized base images
    These are images that focus on removing the cruft out of the OS layer and provide a slimmed-down image. For example,
    Alpine provides a base image that starts at just 10 MB, and it also allows you to attach a local debugger for local development.
    Other distros also typically offer an optimized base image, such as Debian’s Slim image. This might be a good option for you
    because its optimized images give you capabilities you expect for development while also optimizing for image size and lower security exposure.
    Optimizing your images is extremely important and often overlooked by users. You might have reasons due to company standards for OSes
    that are approved for use in the enterprise, but push back on these so that you can maximize the value of containers.

    - Container Image Tagging
    Another step in the CI pipeline is to build a Docker image so that you have an image artifact to deploy to an environment.
    It’s important to have an image tagging strategy so that you can easily identify the versioned images you have deployed
    to your environments. One of the most important things we can’t preach enough about is not to use “latest” as an image tag.
    Using that as an image tag is not a version and will lead to not having the ability to identify what code change belongs to
    the rolled-out image. Every image that is built in the CI pipeline should have a unique tag for the built image.

    + Tagging Strategies :

        BuildID
        When a CI build kicks off, it has a buildID associated with it. Using this part of the tag allows you to reference which build assembled the image.

        Build System-BuildID
        This one is the same as BuildID but adds the Build System for users who have multiple build systems.

        Git Hash
        On new code commits, a Git hash is generated, and using the hash for the tag allows you to easily reference which commit generated the image.

        githash-buildID
        This allows you to reference both the code commit and the buildID that generated the image. The only caution here is that the tag can be kind of long.

    + Deployement Strategies :
        Rolling updates
        Blue/green deployments
        Canary deployments

    - Rolling updates are built into Kubernetes and allow you to trigger an update to the currently running application without downtime.
      For example, if you took your frontend app that is currently running frontend:v1 and updated the Deployment to frontend:v2, Kubernetes
      would update the replicas in a rolling fashion to frontend:v2. Figure below depicts a rolling update.

![](./static/rolling_update.png)

    - A Deployment object also lets you configure the maximum amount of replicas to be updated and the maximum unavailable pods during the rollout.
    - You need to be cautious with rolling updates because using this strategy can cause dropped connections. To deal with this issue, you can utilize readiness probes and preStop life cycle hooks.

    - Blue/green deployments allow you to release your application in a predictable manner. With blue/green deployments, you control when the traffic
      is shifted over to the new environment, so it gives you a lot of control over the rollout of a new version of your application.
      With blue/green deployments, you are required to have the capacity to deploy both the existing and new environment at the same time.
      These types of deployments have a lot of advantages, such as easily switching back to your previous version of the application.
      There are some things that you need to consider with this deployment strategy, however:

        + Database migrations can become difficult with this deployment option because you need to consider in-flight transactions
        and schema update compatibility.

        + There is the risk of accidental deletion of both environments.
        + You need extra capacity for both environments.
        + There are coordination issues for hybrid deployments in which legacy apps can’t handle the deployment.

       Figure below depicts a blue/green deployment.

![](./static/canary_deployment.png)

    - NOTE
      Canary releases also suffer from having multiple versions of the application running at the same time. Your database schema needs
      to support both versions of the application. When using these strategies, you’ll need to really focus on how to handle dependent
      services and having multiple versions running. This includes having strong API contracts and ensuring that your data services
      support the multiple versions you have deployed at the same time.

    + Testing in Production tools :
      distributed tracing, instrumentation, chaos engineering, and traffic shadowing. To recap, here are the tools we have already mentioned:
        Canary deployments
        A/B testing
        Traffic shifting
        Feature flags

    - Chaos engineering was developed by Netflix. It is the practice of deploying experiments into live production systems to discover weaknesses
      within those systems. Chaos engineering allows you to learn about the behavior of your system by observing it during a controlled experiment.

     + Setting Up a Pipeline and Performing a Chaos Experiment

    $ repo /chaos_engineering
    $ go to drone.io -> create an account -> choose /chaos_engineering repo

    # configure drone.io to push images to dockerhub and kubernetes
    1- first step is to configure this secrets :
        docker_username -> mdrahali
        docker_password -> ******
        kubernetes_server -> kubectl cluster-info (Kubernetes master is running https://192.168.64.11:8443)
        kubernetes_cert -> Step 2 ( generating certificate)
        kubernetes_token -> step 2 ( $TOKEN )

    2- create a service for drone.io
       $ kubectl create serviceaccount drone

        - Now use the following command to create a clusterrolebinding for the serviceaccount:
        kubectl create clusterrolebinding drone-admin \
          --clusterrole=cluster-admin \
          --serviceaccount=default:drone

        Next, retrieve your serviceaccount token:
        TOKENNAME=`kubectl -n default get serviceaccount/drone -o jsonpath='{.secrets[0].name}'`
        TOKEN=`kubectl -n default get secret $TOKENNAME -o jsonpath='{.data.token}' | base64 -D`
        echo $TOKEN

    + You’ll want to store the output of the token in the kubernetes_token secret.

    - You will also need the user certificate to authenticate to the cluster, so use the following command and paste the ca.crt for the kubernetes_cert secret:

    $ kubectl get secret $TOKENNAME -o yaml | grep 'ca.crt:'

    3- Now, build your app in a Drone pipeline and then push it to Docker Hub.
        The first step is the build step, which will build your Node.js frontend. Drone utilizes container images to run its steps, which gives you a
        lot of flexibility in what you can do with it. For the build step, use a Node.js image from Docker Hub:

        look at the file ./drone.yaml

        pipeline:
          build:
            image: node
            commands:
              - cd frontend
              - npm i redis --save

    When the build completes, you’ll want to test it, so we include a test step, which will run npm against the newly built app:
    test:
        image: node
        commands:
          - cd frontend
          - npm i redis --save
          - npm test

    Now that you have successfully built and tested your app, you next move on to a publish step to create a Docker image of the app and push it to Docker Hub.
    In the .drone.yml file, make the following code change:
    repo: <your-registry>/frontend

    publish:
        image: plugins/docker
        dockerfile: ./frontend/Dockerfile
        context: ./frontend
        repo: mdrahali/frontend
        tags: [latest, v2]
        secrets: [ docker_username, docker_password ]

    After the Docker build step finishes, it will push the image to your Docker registry.

![](./static/drone.io.png)

    # when deployment is finished :
    $ kubectl get pods

    - A Simple Chaos Experiment :

    There are a variety of tools in the Kubernetes ecosystem that can help with performing chaos experiments in your environment. They range from sophisticated hosted Chaos as a Service solutions to basic chaos experiment tools that kill pods in your environment. Following are some of the tools with which we’ve seen users have success:

    Gremlin
    Hosted chaos service that provides advanced features for running chaos experiments

    PowerfulSeal
    Open source project that provides advanced chaos scenarios

    Chaos Toolkit
    Open source project with a mission to provide a free, open, and community-driven toolkit and API to all the various forms of chaos engineering tools

    KubeMonkey
    Open source tool that provides basic resiliency testing for pods in your cluster.

    - Let’s set up a quick chaos experiment to test the resiliency of your application by automatically terminating pods.
      For this experiment, we’ll use Chaos Toolkit:

        pip3 install -U chaostoolkit
        pip3 install chaostoolkit-kubernetes
        //export FRONTEND_URL="http://$(kubectl get svc frontend -o jsonpath="{.status.loadBalancer.ingress[*].ip}"):8080/api/"
        export FRONTEND_URL=http://journal.com/api
        chaos run experiment.json

    - The experiment will allows you to determine bottlenicks of your cluster.

### + Versioning, Releases, and Rollouts

    - One of the main complaints of traditional monolithic applications is that over time they begin to grow too large and unwieldy to properly upgrade,
      version, or modify at the speed the business requires. Many can argue that this is one of the main critical factors that led to more Agile development
      practices and the advent of microservice architectures. Being able to quickly iterate on new code, solve new problems, or fix hidden problems before
      they become major issues, as well as the promise of zero-downtime upgrades, are all goals that development teams strive for in this ever-changing
      internet economy world. Practically, these issues can be solved with proper processes and procedures in place, no matter the type of system,
      but this usually comes at a much higher cost of both technology and human capital to maintain.


### + Pod and Container Security :

    - in Kubernetes API There is two choices :
    + PodSecurityPolicy and RuntimeClass.

    + PodSecurityPolicy API (Beta vers) :
      This cluster-wide resource creates a single place to define and manage all of the security-sensitive fields found in pod specifications.
      Prior to the creation of the PodSecurityPolicy resource, cluster administrators and/or users would need to independently define individual
      SecurityContext settings for their workloads or enable bespoke admission controllers on the cluster to enforce some aspects of pod security.

    however, strongly suggest taking the time to fully understand PodSecurityPolicy because it’s one of the single most effective means to reduce
    your attack surface area by limiting what can run on your cluster and with what level of privilege.

    - There are two main components that you need to complete in order to start using PodSecurityPolicy:

    1- Ensure that the PodSecurityPolicy API is enabled
      (this should already be done if you’re on a currently supported version of Kubernetes).
        You can confirm that this API is enabled by running `kubectl get psp`. As long as the response
        isn’t the server doesn't have a resource type "PodSecurityPolicies, you are OK to proceed.

    2- Enable the PodSecurityPolicy admission controller via the api-server flag --enable-admission-plugins.


    !WARNING!
    If you are enabling PodSecurityPolicy on an existing cluster with running workloads, you must create all necessary policies,
    service accounts, roles, and role bindings before enabling the admission controller.

    We also recommend the addition of the --use-service-account-credentials=true flag to kube-controller-manager,
    which will enable service accounts to be used for each individual controller within kube-controller-manager.
    This allows for more granular policy control even within the kube-system namespace. You can simply
    run the following command to determine whether the flag has been set. It demonstrates that there is
    indeed a service account per controller:

    $ kubectl get serviceaccount -n kube-system | grep '.*-controller'

    !WARNING!
    It’s extremely important to remember that having no PodSecurityPolicies defined will result in an implicit deny.
    This means that without a policy match for the workload, the pod will not be created.

    # Testing PodSecurityPolicy
    $ cd ./PodSecurityPolicy
    $ kubectl apply -f pause-deployment.yaml

    + By running the following command, you can verify that you have a Deployment and a corresponding ReplicaSet but NO pod:
    $ kubectl get deploy,rs,pods -l app=pause

    $ kubectl describe replicaset -l app=pause

    + This is because there are either no pod security policies defined or the service account is not allowed access to use the PodSecurityPolicy.
    $ kubectl delete deploy -l app=pause

    # now we will define pod security policies :
    $ kubectl apply -f podsecuritypolicy-1.yaml
    $ kubectl apply -f podsecuritypolicy-2.yaml

    $ kubectl get psp

### + Managing Multiple Clusters :

    - Following are concerns to think about when deciding to use multicluster versus a single-cluster architecture:
        Blast radius
        Compliance
        Security
        Hard multitenancy
        Regional-based workloads
        Specialized workloads

    Blast radius
    For example, if you have one cluster that serves 500 applications and you have a platform issue, it takes out 100% of the 500
    applications. If you had a platform layer issue with 5 clusters serving those 500 applications, you affect only 20% of the applications.
    The downside to this is that now you need to manage five clusters, and your consolidation ratios will not be as good with a single cluster.
    Dan Woods wrote a great article about an actual cascading failure in a production Kubernetes environment. It is a great example of why you will
    want to consider multicluster architectures for larger environments.

    Security
    Security in large Kubernetes clusters can become difficult to manage. As you start onboarding more and more teams to a Kubernetes cluster each team may have
    different security requirements and it can become very difficult to meet those needs in a large multi-tenant cluster. Even just managing RBAC, network policies,
    and pod security policies can become difficult at scale in a single cluster. A small change to a network policy can inadvertently open up security risk to other
    users of the cluster. With multiple clusters you can limit the security impact with a misconfiguration. If you decide that a larger Kubernetes cluster fits your
    requirements, then ensure that you have a very good operational process for making security changes and understand the blast radius of making a change to RBAC,
    network policy, and pod security policies.

    Regional-based workloads
    When running workloads that need to serve traffic from in-region endpoints, your design will include multiple clusters that are based per region.
    When you have a globally distributed application, it becomes a requirement at that point to run multiple clusters. When you have workloads
    that need to be regionally distributed, it’s a great use case for cluster federation of multiple clusters, which we dig into further
    later in this chapter.

    Specialized workloads
    Specialized workloads, such as high-performance computing (HPC), machine learning (ML), and grid computing, also need to be addressed in the multicluster architecture.
    These types of specialized workloads might require specific types of hardware, have unique performance profiles, and have specialized users of the clusters.
    We’ve seen this use case to be less prevalent in the design decision because having multiple Kubernetes node pools can help address specialized hardware and performance profiles.
    When you have the need for a very large cluster for an HPC or machine learning workload, you should take into consideration just dedicating clusters for these workloads.
    With multicluster, you get isolation for “free,” but it also has design concerns that you need to address at the outset.

    Multicluster Design Concerns
    When choosing a multicluster design there are some challenges that you’ll run into. Some of these challenges might deter you from attempting a multicluster
    design given that the design might overcomplicate your architecture. Some of the common challenges we find users running into are:

        Data replication
        Service discovery
        Network routing
        Operational management
        Continuous deployment

    Data replication and consistency has always been the crux of deploying workloads across geographical regions and multiple clusters. When running
    these services, you need to decide what runs where and develop a replication strategy. Most databases have built-in tools to perform the replication,
    but you need to design the application to be able to handle the replication strategy. For NoSQL-type database services this can be easier because they
    can can handle scaling across multiple instances, but you still need to ensure that your application can handle eventual consistency across geographic
    regions or at least the latency across regions. Some cloud services, such as Google Cloud Spanner and Microsoft Azure CosmosDB, have built database
    services to help with the complications of handling data across multiple geographic regions.

    Each Kubernetes cluster deploys its own service discovery registry, and registries are not synchronized across multiple clusters. This complicates
    applications being able to easily identify and discover one another. Tools such as HashiCorp’s Consul can transparently synchronize services from
    multiple clusters and even services that reside outside of Kubernetes. There are other tools like Istio, Linkerd, and Cillium that are building on
    multiple cluster architectures to extend service discovery between clusters.

    + Operator Pattern
      When utilizing the Operator pattern, you can build in automation to operational tasks that need to be performed on operational tooling in multiclusters.
      Let’s take the following Elasticsearch operator as an example. we utilized the Elasticsearch, Logstash, and Kibana (ELK) stack to perform log aggregation
      of our cluster. The Elasticsearch operator can perform the following operations:

        Replicas for master, client, and data nodes
        Zones for highly available deployments
        Volume sizes for master and data nodes
        Resizing of cluster
        Snapshot for backups of the Elasticsearch cluster

      As you can see, the operator provides automation for many tasks that you would need to perform when managing Elasticsearch, such as automating snapshots
      for backup and resizing the cluster. The beauty of this is that you manage all of this through familiar Kubernetes objects.

    + The GitOps Approach to Managing Clusters :

        GitOps was popularized by the folks at Weaveworks, and the idea and fundamentals were based on their experience of running Kubernetes in production.
        GitOps takes the concepts of the software development life cycle and applies them to operations. With GitOps, your Git repository becomes your source of truth,
        and your cluster is synchronized to the configured Git repository. For example, if you update a Kubernetes Deployment manifest, those configuration changes
        are automatically reflected in the cluster state.
        By using this method, you can make it easier to maintain multiclusters that are consistent and avoid configuration drift across the fleet. GitOps allows
        you to declaratively describe your clusters for multiple environments and drives to maintain that state for the cluster. The practice of GitOps can apply to
        both application delivery and operations, but in this chapter, we focus on using it to manage clusters and operational tooling.
        Weaveworks Flux was one of the first tools to enable the GitOps approach, and it’s the tool we will use throughout the rest of the chapter.
        There are many new tools that have been released into the cloud-native ecosystem that are worth a look, such as Argo CD, from the folks at Intuit,
        which has also been widely adopted for the GitOps approach.

![](./static/GitOps.png)

    + Setup GitOps :

    $ git clone https://github.com/weaveworks/flux
    $ cd flux
    $ vim deploy/flux-deployment.yaml

    - Modify the following line with your Git repository:
    $ --git-url=git@github.com:weaveworks/flux-get-started
      (ex. --git-url=git@github.com:MDRCS/chaos_engineering.git)

    # Now, go ahead and deploy Flux to your cluster:
    # kubectl create ns flux
    $ cd deploy
    $ kubectl apply -f .

    When Flux installs, it creates an SSH key so that it can authenticate with the Git repository.
    Use the Flux command-line tool to retrieve the SSH key so that you can configure access to your
    forked repository; first, you need to install fluxctl.

    For MacOS:
        brew install fluxctl

    # generate a public key
    $ fluxctl identity --k8s-fwd-ns flux

    # Setup Pipeline between flux and Github repo
    Open GitHub, navigate to repo `chaos_engineering`, go to Setting > “Deploy keys,” click “Add deploy key,” give it a Title, select
    the “Allow write access” checkbox, paste the Flux public key, and then click “Add key.” See the GitHub documentation for more
    information on how to manage deploy keys.

    Now, if you view the Flux logs, you should see that it is synchronizing with your GitHub repository:

    $ kubectl logs -f deployment/flux -n flux

    $ fluxctl --k8s-fwd-ns=flux sync

    After you see that it’s synchronizing with your GitHub repository, you should see that the Elasticsearch,
    Prometheus, Redis, and frontend pods are created:

    $ kubectl get pods -w
    With this example complete, you should be able to see how easy it is for you to synchronize your GitHub repository state with your
    Kubernetes cluster. This makes managing the multiple operational tools in your cluster much easier,
    because multiple clusters can synchronize with a single repository and remove the situation of having snowflake clusters.


    helm repo add fluxcd https://charts.fluxcd.io

    kubectl create namespace flux
    helm upgrade -i flux fluxcd/flux \
    --set git.url=git@github.com:MDRCS/chaos_engineering.git \
    --namespace flux

    Multicluster Management Tools
    When working with multiple clusters, using Kubectl can immediately become confusing because you need to set different contexts
    to manage the different clusters. Two tools that you will want to install right away when dealing with multiple clusters are
    kubectx and kubens, which allow you to easily change between multiple contexts and namespaces.

    When you need a full-fleged multicluster management tool, there are a few within the Kubernetes ecosystem to look at
    for managing multiple clusters. Following is a summary of some of the more popular tools:

    + Rancher centrally manages multiple Kubernetes clusters in a centrally managed user interface (UI). It monitors, manages,
      backs up, and restores Kubernetes clusters across on-premises, cloud, and hosted Kubernetes setups. It also has tools for
      controlling applications deployed across multiple clusters and provides operational tooling.

    + KQueen provides a multitenant self-service portal for Kubernetes cluster provisioning and focuses on auditing, visibility,
      and security of multiple Kubernetes clusters. KQueen is an open source project that was developed by the folks at Mirantis.

    + Gardener takes a different approach to multicluster management in that it utilizes Kubernetes primitives to provide Kubernetes
      as a Service to your end users. It provides support for all major cloud vendors and was developed by the folks at SAP.
      This solution is really geared toward users who are building a Kubernetes as a Service offering.


    + KubeFed is not necessarily about multicluster management, but providing high availability (HA) deployments across multiple clusters. It allows you to combine multiple clusters into a single management endpoint for delivering applications on Kubernetes. For example, if you have a cluster that resides in multiple public cloud environments, you can combine these clusters into a single control plane to manage deployments to all clusters to increase the resiliency of your application.
        As of this writing, the following Federated resources are supported:
        Namespaces
        ConfigMaps
        Secrets
        Ingress
        Services
        Deployments
        ReplicaSets
        Horizontal Pod Autoscalers
        DaemonSets

![](./static/KubFed.png)

    # as an example in the file ./KubFed/federated-deployement.yaml we have a config :
    That creates a federated Deployment of an NGINX pod with five replicas,
    which are then spread across our clusters in Azure and another cluster in Google.
    KubeFed is still in alpha, so keep an eye on it, but embrace the tools that
    you already have or can implement now so that you can be successful with
    Kubernetes HA and multicluster deployments.

    ++ Managing Multiple Clusters Best Practices
    Consider the following best practices when managing multiple Kubernetes clusters:

    1- Limit the blast radius of your clusters to ensure cascading failures don’t have a bigger impact on your applications.
    2- If you have regulatory concerns such as PCI, HIPPA, or HiTrust, think about utilizing multiclusters to ease the complexity
       of mixing these workloads with general workloads.
    3- If hard multitenancy is a business requirement, workloads should be deployed to a dedicated cluster.
    4- If multiple regions are needed for your applications, utilize a Global Load Balancer to manage traffic between clusters.
    5- You can break out specialized workloads such as HPC into their own individual clusters to ensure that the specialized needs for
       the workloads are met.
    6- If you’re deploying workloads that will be spread across multiple regional datacenters, first ensure that there is a data
       replication strategy for the workload. Multiple clusters across regions can be easy, but replicating data across regions
       can be complicated, so ensure that there is a sound strategy to handle asynchronous and synchronous workloads.
    7- Utilize Kubernetes operators like the prometheus-operator or Elasticsearch operator to handle automated operational tasks.
    8- When designing your multicluster strategy, also consider how you will do service discovery and networking between clusters.
       Service mesh tools like HashiCorp’s Consul or Istio can help with networking across clusters.
    9- Be sure that your CD strategy can handle multiple rollouts between regions or multiple clusters.
    10- Investigate utilizing a GitOps approach to managing multiple cluster operational components to ensure consistency between
       all clusters in your fleet. The GitOps approach doesn’t always work for everyone’s environment, but you should at least
       investigate it to ease the operational burden of multicluster environments.


### + Integrating External Services and Kubernetes

    - most of the services that we build will need to interact with systems and services that exist outside of the Kubernetes
      cluster in which they’re running. This might be because we are building new services that are being accessed by legacy
      infrastructure running in virtual or physical machines. Conversely, it might be because the services that we are building
      might need to access preexisting databases or other services that are likewise running on physical infrastructure in an
      on-premises datacenter. Finally, you might have multiple different Kubernetes clusters with services that you need
      to interconnect. For all of these reasons, the ability to expose, share, and build services that span the boundary of
      your Kubernetes cluster is an important part of building real-world applications.

     - After you’ve established network connectivity between pods in the Kubernetes cluster and the on-premises resource,
       the next challenge is to make the external service look and feel like a Kubernetes service. In Kubernetes,
       service discovery occurs via Domain Name System (DNS) lookups and, thus, to make our external database feel
       like it is a native part of Kubernetes, we need to make the database discoverable in the same DNS.

    + Selector-Less Services for Stable IP Addresses :
    The first way to achieve this is with a selector-less Kubernetes Service. When you create a Kubernetes Service
    without a selector, there are no Pods that match the service; thus, there is no load balancing performed.
    Instead, you can program this selector-less service to have the specific IP address of the external resource
    that you want to add to the Kubernetes cluster. That way, when a Kubernetes pod performs a lookup for your-database,
    the built-in Kubernetes DNS server will translate that to a service IP address of your external service.
    Here is an example of a selector-less service for an external database:

        apiVersion: v1
        kind: Service
        metadata:
          name: my-external-database
        spec:
          ports:
          - protocol: TCP
            port: 3306
            targetPort: 3306

    When the service exists, you need to update its endpoints to contain the database IP address serving at 24.1.2.3:
        apiVersion: v1
        kind: Endpoints
        metadata:
          # Important! This name has to match the Service.
          name: my-external-database
        subsets:
          - addresses:
              - ip: 24.1.2.3
            ports:
              - port: 3306

![](./static/externaldb-kub.png)

    + CNAME-Based Services for Stable DNS Names :
    The previous example assumed that the external resource that you were trying to integrate with your Kubernetes
    cluster had a stable IP address. Although this is often true of physical on-premises resources, depending on
    the network toplogy, it might not always be true, and it is significantly less likely to be true in a cloud environment
    where virtual machine (VM) IP addresses are more dynamic. Alternatively, the service might have multiple replicas sitting
    behind a single DNS-based load balancer. In these situations, the external service that you are trying to bridge into your
    cluster doesn’t have a stable IP address, but it does have a stable DNS name.
    In such a situation, you can define a CNAME-based Kubernetes Service. If you’re not familiar with DNS records, a CNAME, or Canonical Name,
    record is an indication that a particular DNS address should be translated to a different Canonical DNS name. For example,
    a CNAME record for foo.com that contains bar.com indicates that anyone looking up foo.com should perform a recursive lookup
    for bar.com to obtain the correct IP address. You can use Kubernetes Services to define CNAME records in the Kubernetes DNS server.
    For example, if you have an external database with a DNS name of database.myco.com, you might create a CNAME Service that
    is named myco-database. Such a Service looks like this:
        kind: Service
        apiVersion: v1
        metadata:
          name: my-external-database
        spec:
          type: ExternalName
          externalName: database.myco.com

    With a Service defined in this way, any pod that does a lookup for myco-database will be recursively resolved to database.myco.com.
    Of course, to make this work, the DNS name of your external resource also needs to be resolveable from the Kubernetes DNS servers.
    If the DNS name is globally accessible (e.g., from a well-known DNS service provider), this will simply automatically work. However,
    if the DNS of the external service is located in a company-local DNS server (e.g., a DNS server that services only internal traffic),
    the Kubernetes cluster might not know by default how to resolve queries to this corporate DNS server.


    + Exporting Services from Kubernetes
    In the previous section, we explored how to import preexisting services to Kubernetes, but you might also need to export services
    from Kubernetes to the preexisting environments. This might occur because you have a legacy internal application for customer
    management that needs access to some new API that you are developing in a cloud-native infrastructure. Alternately, you might
    be building new microservice-based APIs but you need to interface with a preexisting traditional web application firewall (WAF)
    because of internal policy or regulatory requirements. Regardless of the reason, being able to expose services from a Kubernetes
    cluster out to other internal applications is a critical design requirement for many applications.

    + Exporting Services by Using Internal Load Balancers
    The easiest way to export from Kubernetes is by using the built-in Service object. If you have had any previous experience with Kubernetes,
    you have no doubt seen how you can connect a cloud-based load balancer to bring external traffic to a collection of pods in the cluster. However,
    you might not have realized that most clouds also offer an internal load balancer. The internal load balancer provides the same capabilities to map
    a virtual IP address to a collection of pods, but that virtual IP address is drawn from an internal IP address space (e.g., 10.0.0.0/24) and thus is
    only routeable from within that virtual network. You activate an internal load balancer by adding a cloud-specific annotation to your Service load balancer.
    For example, in Microsoft Azure, you add the service.beta.kubernetes.io/azure-load-balancer-internal: "true" annotation. On Amazon Web Services (AWS),
    the annotation is service.beta.kubernetes.io/aws-load-balancer-internal: 0.0.0.0/0. You place annotations in the metadata field in the Service resource as follows:

        apiVersion: v1
        kind: Service
        metadata:
          name: my-service
          annotations:
            # Replace this as needed in other environments
            service.beta.kubernetes.io/azure-load-balancer-internal: "true"
            ...

    When you export a Service via an internal load balancer, you receive a stable, routeable IP address that is visible on the virtual network outside of the cluster.
    You then can either use that IP address directly or set up internal DNS resolution to provide discovery for your exported service.

![](./static/NodePort_External.png)

    Here’s an example YAML file for a NodePort service:
        apiVersion: v1
        kind: Service
        metadata:
          name: my-node-port-service
        spec:
          type: NodePort
          ...

    - Following the creation of a Service of type NodePort, Kubernetes automatically selects a port for the service; you can get that port from the Service by looking
      at the spec.ports[*].nodePort field. If you want to choose the port yourself, you can specify it when you create the service, but the NodePort must be within the
      configured range for the cluster. The default for this range are ports between 30000 and 30999.

    ++ Sharing Services Between Kubernetes
    The previous sections have described how to connect Kubernetes applications to outside services and how to connect outside services to Kubernetes applications,
    but another significant use case is connecting services between Kubernetes clusters. This may be to achieve East-West failover between different regional Kubernetes
    clusters, or it might be to link together services run by different teams. The process of achieving this interaction is actually a combination of the designs described
    in the previous sections.
    First, you need to expose the Service within the first Kubernetes cluster to enable network traffic to flow. Let’s assume that you’re in a cloud environment that supports
    internal load balancers, and that you receive a virtual IP address for that internal load balancer of 10.1.10.1. Next, you need to integrate this virtual IP address into the second
    Kubernetes cluster to enable service discovery. You achieve this in the same manner as importing an external application into Kubernetes (first section). You create a selector-less
    Service and you set its IP address to be 10.1.10.1. With these two steps you have integrated service discovery and connectivity between services within your two Kubernetes clusters.
    These steps are fairly manual, and although this might be acceptable for a small, static set of services, if you want to enable tighter or automatic service integration between clusters,
    it makes sense to write a cluster daemon that runs in both clusters to perform the integration. This daemon would watch the first cluster for Services with a particular annotation,
    say something like myco.com/exported-service; all Services with this annotation would then be imported into the second cluster via selector-less services. Likewise, the same daemon would
    garbage-collect and delete any services that are exported into the second cluster but are no longer present in the first. If you set up such daemons in each of your regional clusters,
    you can enable dynamic, East-West connectivity between all clusters in your environment.

    About Third-parties -> for connectivity and networking between clusters you can use service mesh tools like istio.

### - Running Machine Learning in Kubernetes



![](./static/ml_workflow.png)

    + Machine learning workflow

    Dataset preparation
    This phase includes the storage, indexing, cataloging, and metadata associated with the dataset that is used to train the model. For the purposes of this book, we consider only the storage aspect.
    Datasets vary in size, from hundreds of megabytes to hundreds of terabytes. The dataset needs to be provided to the model in order for the model to be trained. You must consider storage that provides
    the appropriate properties to meet these needs. Typically, large-scale block and object stores are required and must be accessible via Kubernetes native storage abstractions or directly accessible APIs.

    Machine learning algorithm development
    This is the phase in which data scientists write, share, and collaborate on machine learning algorithms. Open source tools like JupyterHub are easy to install on Kubernetes because they typically
    function like any other workload.

    Training
    This is the process by which the model will use the dataset to learn how to perform the tasks for which it has been designed. The resulting artifact of training process is usually a checkpoint
    of the trained model state. The training process is the piece that takes advantage of all of the capabilities of Kubernetes at the same time. “Scheduling, access to specialized hardware,
    dataset volume management, scaling, and networking will all be exercised in unison in order to complete this task. We cover more of the specifics of the training phase in the next section.

    Serving
    This is the process of making the trained model accessible to service requests from clients so that it can make predictions based on the the data supplied from the client. For example,
    if you have an image-recognition model that’s been trained to detect dogs and cats, a client might submit a picture of a dog, and the model should be able to determine whether it is a dog,
    with a certain level of accuracy.

    “Let’s take a look at the main problem areas you’ll need to address when preparing a cluster for machine learning workloads.

    Model Training on Kubernetes
    Training machine learning models on Kubernetes requires conventional CPUs and graphics processing units (GPUs). Typically, the more resources you apply, the faster the training will be completed.
    In most cases, model training can be achieved on a single machine that has the required resources. Many cloud providers offer multi-GPU virtual machine (VM) types, so we recommend scaling VMs
    vertically to four to eight GPUs before looking into distributed training. Data scientists use a technique known as hyperparameter tuning when training models. Hyperparameter tuning is the
    process of finding the optimal set of hyperparameters for model training. A hyperparameter is simply a parameter that has a set value before the training process begins. The technique involves
    running many of the same training jobs with a different set of hyperparameters.

    Training your first model on Kubernetes
    In this example, you are going to use the MNIST dataset to train an image-classification model. The MNIST dataset is publicly available and commonly used for image classification.
    To train the model, you are going to need “GPUs. Let’s confirm that your Kubernetes cluster has GPUs available. The following output shows that this Kubernetes cluster has four GPUs available:
    $ kubectl get nodes -o yaml | grep -i nvidia.com/gpu
          nvidia.com/gpu: "1"
          nvidia.com/gpu: "1"
          nvidia.com/gpu: "1"
          nvidia.com/gpu: "1"

        i have amd gpu -> kubectl get nodes -o yaml | grep -i amd.com/gpu
    To run your training, you are going to using the Job kind in Kubernetes, given that training is a batch workload. You are going to run your training for 500 steps and use a single GPU.

    # Training our model on mnist dataset
    $ vi mnist-training-demo.yaml # dump the config
    $ kubectl create -f mnist-training-demo.yaml
    $ kubectl get jobs
    $ kubectl get pods

    - Looking at the pod logs, you can see the training happening:
    $ kubectl logs mnist-demo-hv9b2”

    - Finally, you can see that the training has completed by looking at the job status:
    $ kubectl get jobs

    - To clean up the training job, simply run the following command:
    $ kubectl delete -f mnist-demo.yaml

    #Congratulations! You just ran your first model training job on Kubernetes.

    Distributed Training on Kubernetes
    Distributed training is still in its infancy and is difficult to optimize. Running a training job
    that requires eight GPUs will almost always be faster to train on a single eight-GPU machine compared to two
    machines each with four GPUs. The only time that you should resort to using distributed training is when the model
    doesn’t fit on the biggest machine available. If you are certain that you must run distributed training, it is important
    to understand the architecture. Figure 14-2 depicts the distributed TensorFlow architecture, and you can see how the
    model and the parameters are distributed.

![](./static/distributed_training.png)

    Machine learning workloads demand very specific configurations across all aspects of your cluster. The training phases
    are most certainly the most resource intensive. It’s also important to note, as we mentioned a moment ago, that machine
    learning algorithm training is almost always a batch-style workload. Specifically, it will have a start time and a finish time.
    The finish time of a training run depends on how quickly you can meet the resource requirements of the model training.
    This means that scaling is almost certainly a quicker way to finish training jobs faster, but scaling has its own set of bottlenecks.

    Specialized Hardware
    Training and serving a model is almost always more efficient on specialized hardware. A typical example of such specialized hardware
    would be commodity GPUs. Kubernetes allows you to access GPUs via device plug-ins that make the GPU resource known to the Kubernetes
    scheduler and therefore able to be scheduled. There is a device plug-in framework that facilitates this capability, which means that
    vendors do not need to modify the core Kubernetes code to implement their specific device. These device plug-ins typically run as DaemonSets
    on each node, which are processes that are responsible for advertising these specific resources to the Kubernetes API. Let’s take a look
    t the NVIDIA device plug-in for Kubernetes, which enables access to NVIDIA GPUs. After they’re running, you can create a pod as follows,
    and Kubernetes will ensure that it is scheduled to a node that has these resource available:

        apiVersion: v1
        kind: Pod
        metadata:
          name: gpu-pod
        spec:
          containers:
            - name: digits-container
              image: nvidia/digits:6.0
              resources:
                limits:
                  nvidia.com/gpu: 2 # requesting 2 GPUs

    Device plug-ins are not limited to GPUs; you can use them wherever specialized hardware is needed—for example, Field Programmable Gate Arrays (FPGAs) or InfiniBand.

    + Storage
    Storage is one of the most critical aspects of the machine learning workflow. You need to consider storage because it directly affects the following pieces of the machine learning workflow:

        - Dataset storage and distribution among worker nodes during training
        - Checkpoints and saving models

    Dataset storage and distribution among worker nodes during training
    During training, the dataset must be retrievable by every worker node. The storage needs are read-only, and, typically, the faster the disk, the better. The type of disk
    that’s providing the storage is almost completely dependent on the size of the dataset. Datasets of hundreds of megabytes or gigabytes might be perfect for block storage,
    but datasets that are several or hundreds of terabytes in size might be better suited to object storage. Depending on the size and location of the disks that hold the datasets,
    there might be a performance hit on your networking.

    Checkpoints and saving models
    Checkpoints are created as a model is being trained, and saving models allows you to use them for serving. In both cases, you need storage attached to each of the worker nodes
    to store this data. The data is typically stored under a single directory, and each worker node is writing to a specific checkpoint or save file. Most tools expect the checkpoint
    and save data to be in a single location and require ReadWriteMany. ReadWriteMany simply means that the volume can be mounted as read-write by many nodes.
    When using Kubernetes PersistentVolumes, you will need to determine the best storage platform for your needs. The Kubernetes documentation keeps a list
    of volume plug-ins that support ReadWriteMany.

    * https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes

    Networking
    The training phase of the machine learning workflow has a large impact on the network (specifically, when running distributed training). If we consider TensorFlow’s distributed architecture,
    there are two discrete phases to consider that create a lot of network traffic: variable distribution from each of the parameter servers to each of the worker nodes, and also the application
    of gradients from each worker node back to the parameter server (see Figure 14-2). The time it takes for this exchange to happen directly affects the time it takes to train a model. So, it’s
    a simple game of the faster, the better (within reason, of course). With most public clouds and servers today supporting 1-Gbps, 10-Gbps, and sometimes 40-Gbps network interface cards, generally
    network bandwidth is only a concern at lower bandwidths. You might also consider InfiniBand if you need high network bandwidth.”

    While raw network bandwidth is more often than not a limiting factor, there are also instances for which getting the data onto the wire from the kernel in the first place is the problem.
    There are open source projects that take advantage of Remote Direct Memory Access (RDMA) to further accelerate network traffic without the need to modify your worker nodes or application
    code. RDMA allows computers in a network to exchange data in main memory without using the processor, cache, or operating system of either computer. You might consider the open source project
    Freeflow, which boasts of having high network performance for container network overlays.

    Specialized Protocols
    There are other specialized protocols that you can consider when using machine learning on Kubernetes. These protocols are often vendor specific, but they all seek to address distributed
    training scaling issues by removing areas of the architecture that quickly become bottlenecks, for example, parameter servers. These protocols often allow the direct exchange of information
    between GPUs on multiple nodes without the need to involve the node CPU and OS. Here are a couple that you might want to look into to more efficiently scale your distributed training:

    + Message Passing Interface (MPI) is a standardized portable API for the transfer of data between distributed processes.

    + NVIDIA Collective Communications Library (NCCL) is a library of topology-aware multi-GPU communication primitives.

    Data Scientist Concerns
    In the previous discussion, we shared considerations that you need to make in order to be able to run machine learning workloads on your Kubernetes cluster.
    But what about the data scientist? Here we cover some popular tools that make it

    Achieving linear scaling with distributed training. This is the holy grail of distributed model training. Most libraries unfortunately don’t scale in a
    linear fashion when distributed. There is lots of work being done to make scaling better, but it’s important to understand the costs because this isn’t as
    simple as throwing more hardware at the problem. In our experience, it’s almost always the model itself and not the infrastructure supporting it that is
    the source of the bottleneck. It is, however, important to review the utilization of the GPU, CPU, network, and storage before pointing fingers at
    the model itself. Open source tools such as Horovod seek to improve distributed training frameworks and provide better model scaling.


### + Managing State and Stateful Applications

    - In the early days of container orchestration, the targeted workloads were usually stateless applications that used external systems to store state if necessary.
      The thought was that containers are very temporal, and orchestration of the backing storage needed to keep state in a consistent manner was difficult at best.
      Over time the need for container-based workloads that kept state became a reality and, in select cases, might be more performant. Kubernetes adapted over many
      iterations to not only allow for storage volumes mounted into the pod, but those volumes being managed by Kubernetes directly was an important component in orchestration
      of storage with the workloads that require it.

    + Volumes and Volume Mounts
    Not every workload that requires a way to maintain state needs to be a complex database or high throughput data queue service. Often, applications that are being
    moved to containerized workloads expect certain directories to exist and read and write pertinent information to those directories.

    Every major container runtime, such as Docker, rkt, CRI-O, and even Singularity, allows for mounting volumes into a container that is mapped to an external storage
    system. At its simplest, external storage can be a memory location, a path on the container’s host, or an external filesystem such as NFS, Glusterfs, CIFS, or Ceph.
    Why would this be needed, you might wonder? A useful example is that of a legacy application that was written to log application-specific information to a local filesystem.
    There are many possible solutions including, but not limited to, updating the application code to log out to a stdout or stderr sidecar container that can stream log data
    to an outside source via a shared pod volume or using a host-based logging tool that can read a volume for both host logs and container application logs. The last scenario
    can be attained by using a volume mount in the container using a Kubernetes hostPath mount, as shown in the following:

    + Volume Best Practices
    Try to limit the use of volumes to pods requiring multiple containers that need to share data, for example adapter or ambassador type patterns.
    Use the emptyDir for those types of sharing patterns.
    Use hostDir when access to the data is required by node-based agents or services.
    Try to identify any services that write their critical application logs and events to local disk, and if possible change those to stdout or stderr and let a
    true Kubernetes-aware log aggregation system stream the logs instead of leveraging the volume map.

    + Kubernetes manages storage for pods using two distinct APIs, the PersistentVolume and PersistentVolumeClaim.

    - PersistentVolume
    It is best to think of a PersistentVolume as a disk that will back any volumes that are mounted to a pod. A PersistentVolume will have a claim policy
    that will define the scope of life of the volume independent of the life cycle of the pod that uses the volume. Kubernetes can use either dynamic or
    statically defined volumes. To allow for dynamically created volumes, there must be a StorageClass defined in Kubernetes. PersistentVolumes can be
    created in the cluster of varying types and classes, and only when a PersistentVolumeClaim matches the PersistentVolume will it actually be assigned to a
    pod. The volume itself is backed by a volume plug-in. There are numerous plug-ins supported directly in Kubernetes, and each has different configuration parameters to adjust:

    - PersistentVolumeClaims
    PersistentVolumeClaims are a way to give Kubernetes a resource requirement definition for storage that a pod will use. Pods will reference the claim, and then
    if a persistentVolume that matches the claim request exists, it will allocate that volume to that specific pod. At minimum, a storage request size and access
    mode must be defined, but a specific StorageClass can also be defined. Selectors can also be used to match certain PersistentVolumes that meet a certain criteria will be allocated:

    The preceding claim will match the PersistentVolume created earlier because the storage class name, the selector match, the size, and the access mode are all equal.
    Kubernetes will match up the PersistentVolume with the claim and bind them together. Now to use the volume, the pod.spec should just reference the claim by name, as follows:

    - Storage Classes
    Instead of manually defining the PersistentVolumes ahead of time, administrators might elect to create StorageClass objects,
    which define the volume plug-in to use and any specific mount options and parameters that all PersistentVolumes of that class will use.
    This then allows the claim to be defined with the specific StorageClass to use, and Kubernetes will dynamically create the PersistentVolume
    based on the StorageClass parameters and options:

        kind: StorageClass
        apiVersion: storage.k8s.io/v1
        metadata:
        name: nfs
        provisioner: cluster.local/nfs-client-provisioner
        parameters:
          archiveOnDelete: True

    Kubernetes also allows operators to create a default storage class using the DefaultStorageClass admission plug-in. If this has been enabled on the API server,
    then a default StorageClass can be defined and any PersistentVolumeClaims that do not explicitly define a StorageClass. Some cloud providers will include a default
    storage class to map to the cheapest storage allowed by their instances.

    Container Storage Interface and FlexVolume
    Often referred to as “Out-of-Tree” volume plug-ins, the Container Storage Interface (CSI) and FlexVolume enable storage vendors to create custom storage plug-ins
    without the need to wait for direct code additions to the Kubernetes code base like most volume plug-ins today.
    The CSI and FlexVolume plug-ins are deployed on Kubernetes clusters as extensions by operators and can be updated by the storage vendors when needed to expose new functionality.

    Kubernetes also allows operators to create a default storage class using the DefaultStorageClass admission plug-in. If this has been enabled on the API server, then a default StorageClass
    can be defined and any PersistentVolumeClaims that do not explicitly define a StorageClass. Some cloud providers will include a default storage class to map to the cheapest storage allowed by their instances.

    Container Storage Interface and FlexVolume
    Often referred to as “Out-of-Tree” volume plug-ins, the Container Storage Interface (CSI) and FlexVolume enable storage vendors to create custom storage plug-ins without the need to wait for direct
    code additions to the Kubernetes code base like most volume plug-ins today.
    The CSI and FlexVolume plug-ins are deployed on Kubernetes clusters as extensions by operators and can be updated by the storage vendors when needed to expose new functionality.

    Kubernetes Storage Best Practices
    Cloud native application design principles try to enforce stateless application design as much as possible; however,
    the growing footprint of container-based services has created the need for data storage persistence. These best practices around storage
    in Kubernetes in general will help to design an effective approach to providing the required storage implementations to the application design:

    1- If possible, enable the DefaultStorageClass admission plug-in and define a default storage class. Many times,
       Helm charts for applications that require PersistentVolumes default to a default storage class for the chart,
       which allows the application to be installed without too much modification.
    2- When designing the architecture of the cluster, either on-premises or in a cloud provider, take into consideration zone and
       connectivity between the compute and data layers using the proper labels for both nodes and PersistentVolumes, and using affinity
       to keep the data and workload as close as possible. The last thing you want is a pod on a node in zone A trying to mount a volume
       that is attached to a node in zone B.
    3- Consider very carefully which workloads require state to be maintained on disk. Can that be handled by an outside service like a database system or,
       if running in a cloud provider, by a hosted service that is API consistent with currently used APIs, say a mongoDB or mySQL as a service?

    4- Determine how much effort would be involved in modifying the application code to be more stateless.

    5- While Kubernetes will track and mount the volumes as workloads are scheduled, it does not yet handle redundancy and backup of the data that is stored
       in those volumes. The CSI specification has added an API for vendors to plug in native snapshot technologies if the storage backend can support it.

    6- Verify the proper life cycle of the data that volumes will hold. By default the reclaim policy is set to for dynamically provisioned persistentVolumes which
       will delete the volume from the backing storage provider when the pod is deleted. Sensitive data or data that can be used for forensic analysis should be set to reclaim.

    -> Operators are a great concept in kubernetes basicaly it is an encapsulation of the complex config of stateful tools, ready to setup.
    https://operatorhub.io/

    TIPS

     -  If a node in the cluster becomes unresponsive, any pods that are part of a StatefulSet are not not automatically deleted; they instead will
        enter a Terminating or Unkown state after a grace period. The only way to clear this pod is to remove the node object from the cluster, the
        kubelet beginning to work again and deleting the pod directly, or an Operator force deleting the pod. The force delete should be the
        last option and great care should be taken that the node that had the deleted pod does not come back online, because there will now
        be two pods with the same name in the cluster. You can use kubectl delete pod nginx-0 --grace-period=0 --force to force delete the pod.

     -  Even after force deleting a pod, it might stay in an Unknown state, so a patch to the API server will delete the entry and cause the StatefulSet controller
        to create a new instance of the deleted pod: kubectl patch pod nginx-0 -p '{"metadata":{"finalizers":null}}'.

     -  If you’re running a complex data system with some type of leader election or data replication confirmation processes, use preStop hook to properly close any connections,
        force leader election, or verify data synchronization before the pod is deleted using a graceful shutdown process.

     -  When the application that requires stateful data is a complex data management system, it might be worth a look to determine whether an Operator exists to help manage
        the more complicated life cycle components of the application. If the application is built in-house, it might be worth investigating whether it would be useful
        to package the application as an Operator to add additional manageability to the application. Look at the CoreOS Operator SDK for an example.


    - Most organizations look to containerize their stateless applications and leave the stateful applications as is.

### + Automating The container orchestration :

    - An Operator extends Kubernetes to automate the management of the entire lifecycle of a particular application. Operators serve as a
      packaging mechanism for distributing applications on Kubernetes, and they monitor, maintain, recover, and upgrade the software they deploy.

    - Other open source tools available for building Operators include Kopf for Python, Kubebuilder from the Kubernetes project, and the Java Operator SDK.

![](./static/kub8_control_plane.png)

    - An Operator is like an automated Site Reliability Engineer for its application. It encodes in software the skills of an expert administrator.
      An Operator can manage a cluster of database servers, for example. It knows the details of configuring and managing its application,
      and it can install a database cluster of a declared software version and number of members. An Operator continues to monitor its application
      as it runs, and can back up data, recover from failures, and upgrade the application over time, automatically. Cluster users employ
      kubectl and other standard tools to work with Operators and the applications they manage, because Operators extend Kubernetes.

    + How Operators Work
    Operators work by extending the Kubernetes control plane and API. In its simplest form, an Operator adds an endpoint to the Kubernetes API,
    called a custom resource (CR), along with a control plane component that monitors and maintains resources of the new type. This Operator
    can then take action based on the resource’s state.

![](./static/howworks_operators.png)

    + Kubernetes CRs :
    CRs are the API extension mechanism in Kubernetes. A custom resource definition (CRD) defines a CR; it’s analogous to a schema for the CR data.
    Unlike members of the official API, a given CRD doesn’t exist on every Kubernetes cluster. CRDs extend the API of the particular cluster where
    they are defined. CRs provide endpoints for reading and writing structured data. A cluster user can interact with CRs with kubectl or another
    Kubernetes client, just like any other API resource.

    + How Operators Are Made :
    Kubernetes compares a set of resources to reality; that is, the running state of the cluster. It takes actions to make reality match the desired state
    described by those resources. Operators extend that pattern to specific applications on specific clusters. An Operator is a custom Kubernetes controller
    watching a CR type and taking application-specific actions to make reality match the spec in that resource.
    Making an Operator means creating a CRD and providing a program that runs in a loop watching CRs of that kind. What the Operator does in response to changes
    in the CR is specific to the application the Operator manages. The actions an Operator performs can include almost anything: scaling a complex app, application
    version upgrades, or even managing kernel modules for nodes in a computational cluster with specialized hardware.

    - Example: The etcd Operator
    - etcd is a distributed key-value store. In other words, it’s a kind of lightweight database cluster. An etcd cluster usually requires a knowledgeable administrator to manage it.
      An etcd administrator must know how to:
        1- Join a new node to an etcd cluster, including configuring its endpoints, making connections to persistent storage, and making existing members aware of it.
        2- Back up the etcd cluster data and configuration.
        3- Upgrade the etcd cluster to new etcd versions.

    The etcd Operator knows how to perform those tasks. An Operator knows about its application’s internal state, and takes regular action to align that state with the desired state
    expressed in the specification of one or more custom resources.

    - deploy the etcd Operator and put it through its paces while using the etcd API to read and write data. For now, it’s worth remembering that adding a member to a running etcd
      cluster isn’t as simple as just running a new etcd pod, and the etcd Operator hides that complexity and automatically heals the etcd cluster.

    + Who Are Operators For?
    The Operator pattern arose in response to infrastructure engineers and developers wanting to extend Kubernetes to provide features specific to their sites and software.
    Operators make it easier for cluster administrators to enable, and developers to use, foundation software pieces like databases and storage systems with less management overhead.
    If the “killernewdb” database server that’s perfect for your application’s backend has an Operator to manage it, you can deploy killernewdb without needing to become an expert killernewdb DBA.

    Setting Up an Operator Lab
    To build, test, and run Operators in the following chapters, you’ll need cluster- admin access to a cluster running Kubernetes version v1.11.0 or later.

    # Upgrade kubectl tool :

    $ curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.0/bin/linux/amd64/kubectl
    $ chmod +x ./kubectl
    $ sudo mv ./kubectl /usr/local/bin/kubectl

    # check if you have cluster-admin role
    $ kubectl describe clusterrole cluster-admin

    A Common Starting Point

    etcd (https://github.com/coreos/etcd) is a distributed key-value store with roots at CoreOS, now under the auspices of the Cloud Native Computing Foundation.
    It is the underlying data store at the core of Kubernetes, and a key piece of several dis‐ tributed applications. etcd provides reliable storage by implementing
    a protocol called Raft (https://raft.github.io/) that guarantees consensus among a quorum of members.
    The etcd Operator often serves as a kind of “Hello World” example of the value and mechanics of the Operator pattern, and we follow that tradition here. We return
    to it because the most basic use of etcd is not difficult to illustrate, but etcd cluster setup and administration require exactly the kind of application-specific
    know-how you can bake into an Operator. To use etcd, you put keys and values in, and get them back out by name. Creating a reliable etcd cluster of the minimum three
    or more nodes requires configuration of endpoints, auth, and other concerns usually left to an etcd expert (or their collection of custom shell scripts). Keeping
    etcd running and upgra‐ ded over time requires continued administration. The etcd Operator knows how to do all of this.

    Fetching the etcd Operator Manifests

    $ cd Operators_Pattern
    $ git clone https://github.com/kubernetes-operators-book/chapters.git
    $ cd etcd_operator

    CRs: Custom API Endpoints
    As with nearly everything in Kubernetes, a YAML manifest describes a CRD. A CR is a named endpoint in the Kubernetes API. A CRD named etcdclusters.etcd.data base.coreos.com represents the new type of endpoint.

    $ kubectl create -f etcd-operator-crd.yaml
    $ kubectl get crd

    Who Am I: Defining an Operator Service Account
    we give an overview of Kubernetes authorization and define service accounts, roles, and other authorization concepts. For now, we just want to take a first look at basic declarations
    for a service account and the capabilities that account needs to run the etcd Operator.

    The file etcd-operator-sa.yaml defines the service account:
        apiVersion: v1
        kind: ServiceAccount
        metadata:
        name: etcd-operator-sa
    Create the service account by using kubectl create:

    $ kubectl create -f etcd-operator-sa.yaml
    serviceaccount/etcd-operator-sa created

    $ kubectl get serviceaccounts

    $ kubectl create -f etcd-operator-role.yaml

    Role binding
    The last bit of RBAC configuration, RoleBinding, assigns the role to the service account for the etcd Operator.
    It’s declared in the file etcd-operator-rolebinding.yaml:

    NB: Wherever you are, the namespace value in this RoleBinding must match the namespace on the cluster where you are working.

    $ kubectl create -f etcd-operator-rolebinding.yaml

    # deploy
    $ kubectl create -f etcd-operator-deployment.yaml
    $ kubectl get deployments
    $ kubectl get pods

    Declaring an etcd Cluster
    Earlier, you created a CRD defining a new kind of resource, an EtcdCluster. Now that you have an Operator watching
    EtcdCluster resources, you can declare an EtcdClus‐ ter with your desired state. To do so, provide the two spec elements
    the Operator rec‐ ognizes: size, the number of etcd cluster members, and the version of etcd each of those members should run.

    This brief manifest declares a desired state of three cluster members, each running version 3.1.10 of the etcd server.
    Create this etcd cluster using the familiar kubectl syntax:

    $ kubectl create -f etcd-cluster-cr.yaml
      etcdcluster.etcd.database.coreos.com/example-etcd-cluster created
    $ kubectl get pods -w

    Try kubectl describe to report on the size, etcd version, and status of your etcd cluster, as shown here:
    $ kubectl describe etcdcluster/example-etcd-cluster

    Operator constructs the name of the service used by clients of the etcd API by appending -client to the
    etcd cluster name defined in the CR. Here, the client ser‐ vice is named example-etcd-cluster-client, and
    it listens on the usual etcd client IP port, 2379. Kubectl can list the services associated with the etcd cluster:

    $ kubectl get services --selector etcd_cluster=example-etcd-cluster

    You can run the etcd client on the cluster and use it to connect to the client service and interact with the etcd API.
    The following command lands you in the shell of an etcd container:

    $ kubectl run --rm -i --tty etcdctl --image quay.io/coreos/etcd --restart=Never -- /bin/sh

    From the etcd container’s shell, create and read a key-value pair in etcd with etcdctl’s put and get verbs:
    $ export ETCDCTL_API=3
    $ export ETCDCSVC=http://example-etcd-cluster-client:2379
    $ etcdctl --endpoints $ETCDCSVC put foo bar
    $ etcdctl --endpoints $ETCDCSVC get foo

    Repeat these queries or run new put and get commands in an etcdctl shell after each of the changes you go on to make.
    You’ll see the continuing availability of the etcd API service as the etcd Operator grows the cluster, replaces members,
    and upgrades the version of etcd.

    Scaling the etcd Cluster
    You can grow the etcd cluster by changing the declared size specification. Edit etcd- cluster-cr.yaml and change size from 3 to 4 etcd members. Apply the changes to the EtcdCluster CR:

    $ vi etcd-cluster-cr.yaml # change size from 3 to 4
    $ kubectl apply -f etcd-cluster-cr.yaml

    Checking the running pods shows the Operator adding a new etcd member to the
    etcd cluster:

    $ kubectl get pods

    ++ You can also try $ kubectl edit etcdcluster/example-etcd-cluster
    to drop into an editor and make a live change to the clus‐ ter size.

    Failure and Automated Recovery
    You saw the etcd Operator replace a failed member back in Chapter 1. Before you see it live, it’s worth reiterating the general
    steps you’d have to take to handle this man‐ ually. Unlike a stateless program, no etcd pod runs in a vacuum. Usually, a human etcd
    “operator” has to notice a member’s failure, execute a new copy, and provide it with configuration so it can join the etcd cluster
    with the remaining members. The etcd Operator understands etcd’s internal state and makes the recovery automatic.

    Recovering from a failed etcd member
    Run a quick $ kubectl get pods -l app=etc to get a list of the pods in your etcd cluster. Pick one you don’t like the looks of, and tell Kubernetes to delete it:
    $ kubectl delete pod example-etcd-cluster-9lmg4p6lpd

    The Operator notices the difference between reality on the cluster and the desired state, and adds an etcd member to replace the one you deleted.
    You can see the new etcd cluster member in the PodInitializing state when retrieving the list of pods, as shown here:

    $ kubectl get pods -w

    # check the changes on your cluster
    $ kubectl describe etcdcluster/example-etcd-cluster
        he dead member example-etcd-cluster-9lmg4p6lpd is being replaced

    Throughout the recovery process, if you fire up the etcd client pod again, you can make requests to the etcd cluster,
    including a check on its general health:

    $ kubectl run --rm -i --tty etcdctl --image quay.io/coreos/etcd --restart=Never -- /bin/sh
    If you don't see a command prompt, try pressing enter.
    $ etcdctl --endpoints http://example-etcd-cluster-client:2379 cluster-health
      cluster is healthy

    The etcd Operator recovers from failures in its complex, stateful application the same way Kubernetes automates recoveries for stateless
    apps. That is conceptually simple but operationally powerful. Building on these concepts, Operators can perform more advanced tricks,
    like upgrading the software they manage. Automating upgrades can have a positive impact on security, just by making sure things stay up to date.
    When an Operator performs rolling upgrades of its application while maintaining service availability, it’s easier to keep software
    patched with the latest fixes.

    Upgrading etcd Clusters
    If you happen to be an etcd user already, you may have noticed we specified an older version, 3.1.10. We contrived this so we could explore
    the etcd Operator’s upgrade skills.

    Upgrading the hard way
    At this point, you have an etcd cluster running version 3.1.10. To upgrade to etcd 3.2.13, you need to perform a series of steps. Since this
    book is about Operators, and not etcd administration, we’ve condensed the process presented here, leaving aside networking and host-level
    concerns to outline the manual upgrade process. The steps to follow to upgrade manually are:

    1. Check the version and health of each etcd node.
    2. Create a snapshot of the cluster state for disaster recovery.
    3. Stop one etcd server. Replace the existing version with the v3.2.13 binary. Start the new version.
    4. Repeat for each etcd cluster member—at least two more times in a three-member cluster.

    The easy way: Let the Operator do it
    With a sense of the repetitive and error-prone process of a manual upgrade, it’s easier to see the power of
    encoding that etcd-specific knowledge in the etcd Operator. The Operator can manage the etcd version, and an
    upgrade becomes a matter of declaring a new desired version in an EtcdCluster resource.

    Triggering etcd upgrades
    Get the version of the current etcd container image by querying some etcd-cluster pod, filtering the output to see just the version:
    $ kubectl get pod example-etcd-cluster-9zkz9qbrt6 -o yaml | grep "image:" | uniq
        image: quay.io/coreos/etcd:v3.1.10

    Or, since you added an EtcdCluster resource to the Kubernetes API, you can instead summarize the Operator’s picture of example-etcd-cluster
    directly by using kubectl describe as you did earlier:

    $ kubectl describe etcdcluster/example-etcd-cluster

    You’ll see the cluster is running etcd version 3.1.10, as specified in the file
    etcd-cluster-cr.yaml and the CR created from it.
    Edit etcd-cluster-cr.yaml and change the version spec from 3.1.10 to 3.2.13.
    Then apply the new spec to the resource on the cluster:
    $ kubectl apply -f etcd-cluster-cr.yaml

    $ kubectl describe etcdcluster/example-etcd-cluster
         Member example-etcd-cluster-x2mjxt6sqf upgraded from 3.1.10 to 3.2.13

    Upgrade the upgrade
    With some kubectl tricks, you can make the same edit directly through the Kuber‐ netes API. This time, let’s upgrade from 3.2.13
    to the latest minor version of etcd available at the time of this writing, version 3.3.12:

    $ kubectl patch etcdcluster example-etcd-cluster --type='json' -p='[{"op": "replace", "path": "/spec/version", "value":3.3.12}]'

    - Cleanup :
    $ cd ./Operators_Pattern/etcd-operator
    $ kubectl delete -f .

    Custom Resources
    CRs, as extensions of the Kubernetes API, contain one or more fields, like a native resource, but are not part of a default Kubernetes deployment.
    CRs hold structured data, and the API server provides a mechanism for reading and setting their fields as you would those in a native resource,
    by using kubectl or another API client. Users define a CR on a running cluster by providing a CR definition. A CRD is akin to a schema for a CR,
    defining the CR’s fields and the types of values those fields contain.

    CR or ConfigMap?
    Kubernetes provides a standard resource, the ConfigMap (https://oreil.ly/ba0uh), for making configuration data available to applications. ConfigMaps seem to overlap
    with the possible uses for CRs, but the two abstractions target different cases.
    ConfigMaps are best at providing a configuration to a program running in a pod on the cluster—think of an application’s config file, like httpd.conf or MySQL’s mysql.cnf.
    Applications usually want to read such configuration from within their pod, as a file or the value of an environment variable, rather than from the Kubernetes API.
    Kubernetes provides CRs to represent new collections of objects in the API. CRs are created and accessed by standard Kubernetes clients, like kubectl, and they obey Kubernetes
    conventions, like the resources .spec and .status. At their most useful, CRs are watched by custom controller code that in turn creates, updates, or deletes other cluster objects
    or even arbitrary resources outside of the cluster.


    Cluster-Scoped Operators
    There are some situations where it is desirable for an Operator to watch and manage an application or services throughout a cluster. For example, an Operator that man‐ ages
    a service mesh, such as Istio (https://oreil.ly/jM5q2), or one that issues TLS certif‐ icates for application endpoints, like cert-manager (https://oreil.ly/QT8tE), might
    be most effective when watching and acting on cluster-wide state.
    By default, the Operator SDK used in this book creates deployment and authorization templates that limit the Operator to a single namespace. It is possible to change most
    Operators to run in the cluster scope instead. Doing so requires changes in the Oper‐ ator’s manifests to specify that it should watch all namespaces in a cluster and that it
    should run under the auspices of a ClusterRole and ClusterRoleBinding, rather than the namespaced Role and RoleBinding authorization objects.

    Service accounts
    on the other hand, are managed by Kubernetes and can be created and manipulated through the Kubernetes API. A service account is a special type of cluster user for authorizing
    programs instead of people. An Operator is a program that uses the Kubernetes API, and most Operators should derive their access rights from a service account. Creating a service
    account is a standard step in deploying an Operator. The service account identifies the Operator, and the account’s role denotes the powers granted to the Operator.

    RoleBindings
    A RoleBinding ties a role to a list of one or more users. Those users are granted the permissions defined in the role referenced in the binding. A RoleBinding can refer‐ ence
    only those roles in its own namespace. When deploying an Operator restricted to a namespace, a RoleBinding binds an appropriate role to a service account identi‐ fying the Operator.

    ClusterRoles and ClusterRoleBindings
    As discussed earlier, most Operators are confined to a namespace. Roles and Role‐ Bindings are also restricted to a namespace. ClusterRoles and ClusterRoleBindings are their cluster-wide
    equivalents. A standard, namespaced RoleBinding can refer‐ ence only roles in its namespace, or ClusterRoles defined for the entire cluster. When a RoleBinding references a ClusterRole,
    the rules declared in the ClusterRole apply to only those specified resources in the binding’s own namespace. In this way, a set of common roles can be defined once as ClusterRoles, but
    reused and granted to users in just a given namespace.

    The ClusterRoleBinding grants capabilities to a user across the entire cluster, in all namespaces. Operators charged with cluster-wide responsibilities will often tie a ClusterRole to an
    Operator service account with a ClusterRoleBinding.
