---
kind: tutorial

title: Creating a New Uncloud Cluster

description: |
  This is a description

categories:
  - linux
  - containers

tagz:
  - uncloud

createdAt: 2025-12-02
updatedAt: 2025-12-02

cover: __static__/cover.png

# Uncomment to embed (one or more) challenges.
# challenges:
#   challenge_name_1: {}
#   challenge_name_2: {}

# Uncomment to add (one or more) background tasks.
# tasks:
#   init_task_1:
#     init: true
#     run: ...
#   regular_task_1:
#     run: ...
playground:
  name: uncloud-uninitialized-cluster-cacb63ae
---

Docs: [How to Author Tutorials on iximiuz Labs](/tutorials/sample-tutorial)

### WIP

TODOs:

- Playground should be different; 1 devmachine + 2 uninitialized machines
- Use excalidraw as service example? https://uncloud.run/docs/getting-started/deploy-demo-app

Let's create a new Uncloud cluster.

You are currently on the developer machine.

Uncloud CLI is already installed (check out https://uncloud.run/docs/getting-started/install-cli for instructions)

## Initializing new cluster

```
uc machine init root@<your-server-ip>
```

## Adding another machine to cluster

```
uc machine add root@<second-server>
```

## Running a simple service
