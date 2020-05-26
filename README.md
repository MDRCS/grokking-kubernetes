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


