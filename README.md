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
      check config files source -> https://github.com/upmc-enterprises/elasticsearch-operator/tree/master/example

    !IMPORTANT Putting EFK Stack in the same namespace is a rule.

    - prerequisites - K8 API Version v1.13.3
        curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.3/bin/darwin/amd64/kubectl
        chmod +x ./kubectl
        sudo mv ./kubectl /usr/local/bin/kubectl

    $ cd efk-logging
    $ kubectl create namespace logging
    $ kubectl apply -f elasticsearch-operator.yaml -n logging
    $ kubectl apply -f efk.yaml -n logging

    # if you have a apiVersion Problem triggred from an update of k8 api
    # you can check the new one with this command
    $ kubectl api-resources | grep -i daemon





