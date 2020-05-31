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
