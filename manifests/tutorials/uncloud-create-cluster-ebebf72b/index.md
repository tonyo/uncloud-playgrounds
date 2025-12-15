---
kind: tutorial

title: "Uncloud: How to Set Up a New Cluster"

description: |
  Learn how to create and manage a multi-machine Uncloud cluster from scratch. This hands-on tutorial walks you through initializing a cluster, adding machines, managing contexts, and deploying your first containerized service.

categories:
  - linux
  - containers

tagz:
  - uncloud

createdAt: 2025-12-02
updatedAt: 2025-12-02

cover: __static__/cluster-diagram.png

playground:
  name: uncloud-uninitialized-cluster-cacb63ae
---

<!--
Docs: [How to Author Tutorials on iximiuz Labs](https://labs.iximiuz.com/tutorials/sample-tutorial)

Source code: https://github.com/iximiuz/labs-content-samples/blob/main/sample-tutorial/index.md?plain=1
-->

In this tutorial, you'll learn how to create and manage an Uncloud cluster from scratch. By the end, you'll have a working multi-machine cluster ready to run containerized applications that looks like this:

<!-- prettier-ignore-start -->
::image-box
---
:src: __static__/cluster-diagram.png
:alt: 'Initialized Uncloud Cluster'
:max-width: 600px
---

_Click on the image to zoom in._
::
<!-- prettier-ignore-end -->

::remark-box
💡 **What is Uncloud?** [Uncloud](https://uncloud.run/docs/) is a lightweight clustering and container orchestration tool that lets you deploy and manage web applications across cloud VMs and bare metal servers. Among other things, it creates a secure [WireGuard](https://www.wireguard.com/) mesh network between Docker hosts and provides automatic service discovery, load balancing, and HTTPS ingress — all without the complexity of Kubernetes.
::

## Tutorial Environment

It is highly encouraged to take advantage of the interactive features of the iximiuz Labs platform and follow the tutorial by executing the commands in the interactive. To get started, click the "Start Tutorial" button at the left side

After you start the linked playground, you'll on the developer machine, which will serve as your control node for managing the cluster.

Uncloud CLI (`uc` for short) is already installed. If you're setting this up on your own machine, check out the [installation guide](https://uncloud.run/docs/getting-started/install-cli) for instructions.

## Initializing a New Cluster

Let's initialize our first cluster by setting up `server-1` as the first machine.
Run the following commands on `dev-machine`:

```bash
uc machine init laborant@server-1 --public-ip none --no-dns
```

This command will install Docker, the Uncloud daemon (`uncloudd`), and all necessary dependencies on the remote machine. One critical component which is also installed automatically is the [Corrosion](https://github.com/superfly/corrosion) service which will helpfully handle state synchronization and service discovery as soon as there's more than one machine in the cluster. Documentation on the `machine init` command can be found [here](https://uncloud.run/docs/cli-reference/uc_machine_init/).

::remark-box
**Why use `--public-ip none`?** The `--public-ip none` flag tells Uncloud not to configure this machine for ingress (incoming internet traffic). In the iximiuz Labs environment the node
::

::remark-box
**Why use `--no-dns`?** The `--no-dns` flag skips reserving a free `*.uncld.dev` subdomain via Uncloud's managed DNS service. In the iximiuz Labs environment, you may not need external DNS. You can always reserve a domain later with `uc dns reserve` if needed.
::

You can get the list of machines in the cluster along with their configuration and status via `uc machine ls` (or `uc m ls`, if you want to save a few keystrokes) command:

```bash
laborant@dev-machine:~$ uc machine ls
NAME           STATE   ADDRESS         PUBLIC IP        WIREGUARD ENDPOINTS                      MACHINE ID
machine-incv   Up      10.210.0.1/24   -                172.16.0.3:51820, 65.109.107.161:51820   6cec579e3d6fb7ffb51c5503d163f1be
```

As we can see, `server-1` became the first (and the only so far) machiine in our new cluster. Uncloud

- `NAME: machine-incv`
- `STATE: UP` --
- `ADDRESS: 10.210.0.1/24` --
-

## Adding Another Machine to the Cluster

One initialized server isn't really a cluster, right? A proper cluster typically consists of multiple machines working together.

Let's add a second machine (`server-2`) to the cluster. The command is quite similar — the main difference is that we use [`add`](https://uncloud.run/docs/cli-reference/uc_machine_add) instead of [`init`](https://uncloud.run/docs/cli-reference/uc_machine_init):

```sh
uc machine add laborant@server-2
```

Similar to `server-1`, `server-2` now has all the important components (Docker, Uncloud daemon, etc.) up and running. The two machines are automatically connected via a secure WireGuard mesh network, allowing containers to communicate across machines.

Let's check the current state of the cluster:

```bash
laborant@dev-machine:~$ uc machine ls
NAME           STATE   ADDRESS         PUBLIC IP        WIREGUARD ENDPOINTS                      MACHINE ID
machine-incv   Up      10.210.0.1/24   -                172.16.0.3:51820, 65.109.107.161:51820   6cec579e3d6fb7ffb51c5503d163f1be
machine-m4wy   Up      10.210.1.1/24   -                172.16.0.4:51820, 65.109.107.161:51820   e84e115eff8570ecccc54947aa482f5c
```

Our cluster now consists of two nodes.

## Renaming Cluster Machines

By default, cluster nodes are assigned internal names with randomized suffixes such as `machine-incv` or `machine-m4wy`.
It is possible to override those names by using `-n/--name` option during `add` or `init` steps.

You can also rename the cluster nodes via `uc machine rename` command, for example:

```bash
laborant@dev-machine:~$ uc machine rename machine-incv s1
Machine "machine-incv" renamed to "s1" (ID: 42866c05a37171dbbc1165216e8f886e)
laborant@dev-machine:~$ uc machine rename machine-m4wy s2
Machine "machine-m4wy" renamed to "s2" (ID: 4c453ff7a1c870456cfd69f78e74a34a)
laborant@dev-machine:~$ uc machine ls
NAME   STATE   ADDRESS         PUBLIC IP        WIREGUARD ENDPOINTS                      MACHINE ID
s1     Up      10.210.0.1/24   -                172.16.0.3:51820, 65.109.107.161:51820   42866c05a37171dbbc1165216e8f886e
s2     Up      10.210.1.1/24   -                172.16.0.4:51820, 65.109.107.161:51820   4c453ff7a1c870456cfd69f78e74a34a

```

## Context Management and Connections

It's possible to manage more than one cluster from a single control node. Uncloud CLI has context support, letting you switch between multiple clusters when necessary.

`uc ctx` is the subcommand used for context management. Here's how you can list all available contexts on your control node:

```bash
laborant@dev-machine:~$ uc ctx ls
NAME      CURRENT   CONNECTIONS
default   ✓         2
```

As we see, only one context (`default`) is available, and it's set as the current context (it will be used by default when the commands you run don't include the `--context` option).

The output also shows that the context has two connections. This means the current configuration is aware of two nodes in the corresponding cluster and knows how to connect to either of them.

To view the full context configuration including connection information, you can check the generated configuration file, which is by default placed in `~/.config/uncloud/config.yaml` on your control node:

```yaml [~/.config/uncloud/config.yaml]
current_context: default
contexts:
  default:
    connections:
      - ssh: laborant@server-1
        ssh_key_file: ~/.ssh/id_ed25519
      - ssh: laborant@server-2
        ssh_key_file: ~/.ssh/id_ed25519
```

**Note:** A cluster context can have one or more connections, and each connection represents a way to reach a machine in the cluster via SSH. When you run commands, Uncloud automatically uses one of the available connections to communicate with the cluster. If one machine is unreachable, Uncloud will try another connection, making your cluster more resilient.

## Running a Simple Service

Now that we have a working cluster, let's deploy a simple web application to see everything in action. We'll use [Excalidraw](https://excalidraw.com), a popular sketching and diagramming tool.

Run the following command to deploy Excalidraw:

```bash
uc run --name excalidraw --publish 80/http excalidraw/excalidraw
```

This command will:

- Pull the `excalidraw/excalidraw` Docker image
- Create a service named `excalidraw` with one container
- Publish container port 80 as an HTTP endpoint

After a few moments, you'll see output showing the service is running:

```
[+] Running service excalidraw (replicated mode) 2/2
 ✔ Container excalidraw-azpc on s1  Started
   ✔ Image excalidraw/excalidraw on s1  Pulled

excalidraw endpoints:
 • http://excalidraw.internal → :80
```

**Accessing the service:** Since we initialized the cluster with `--no-dns` and `--public-ip none`, the service isn't accessible from the internet. However, you can access it within the cluster network using the internal DNS name `excalidraw.internal` or simply `excalidraw`.

**Checking service status:** Use `uc inspect excalidraw` to see detailed information about your running service, including which machine it's running on and its health status.

Congratulations! You've successfully created a multi-machine Uncloud cluster and deployed your first service. You can now explore more advanced features like scaling services across machines, using Docker Compose files, and setting up HTTPS ingress with custom domains.

**Next steps:**

- Try scaling your service: `uc scale excalidraw 3`
- Deploy services using Docker Compose files with `uc deploy`
- Learn about [publishing services](https://uncloud.run/docs/concepts/ingress/publishing-services) to the internet
