## Implementación infraestructura y despliegue del producto WSO2ESB

El objetivo de este proyecto es realizar la implementación del la infraestructura y despliegue del producto WSO2ESB dentro de infraestructura en la nube azure, implementando infraestructura en código por medio de terraform, creación de la imagen de Docker, despliegue de los contendedores de Kubernetes por medio de archivos yaml y un ejemplo de despliegue para un proyecto de WSO2ESB por medio de Maven.

**Contenido:**

- Infraestructura en código – Terraform
- Creación de imagen por medio de Docker
- Despliegue en kubernetes
- Proyecto de despliegue continuo en WSO2ESB

----------------------------------------------------------------------------------------------

## Infraestructura en código – Terraform

**Requerimientos**

- [Terraform](https://www.terraform.io/downloads.html)



Para el ejecutar la infraestructura en código es requerido la instalación de terraforn en la maquina donde se ejecutara el proyecto. Para esto seguir las instrucciones de terrafor.io según la plataforma de instalación. [https://www.terraform.io/downloads.html](https://www.terraform.io/downloads.html)

En el proyecto se encuentra el directorio **azureInfraestructure** dentro de este directorio puedes encontrar el archivo **bash.sh** , este archivo tiene los comandos de EXPORT para hacer un SET de las variables de entorno que requiere terraform para ejecutar los comandos. Este archivo contiene las siguientes variables.

- **ARM\_SUBSCRIPTION\_ID**
- **ARM\_CLIENT\_ID**
- **ARM\_CLIENT\_SECRET**
- **ARM\_TENANT\_ID**

En caso de ser requerido para instalar la infraestructura en otra suscripción o con otro usuario se deben modificar los datos del archivo.

Una ves se ejecuten y se carguen las variables de entorno se debe ejecutar el comando de init de terraform

```sh
terraform init
```

Este comando permite iniciar el proceso de infraestructura en codigo.

Luego se debe ejecutar el plan del codigo.
```sh
terraform plan -out out.plan
```
En el archivo out.plan se encuentran las instrucciones que terraform aplicara para la creación de la infraestructura. Si el comando corre sin ningún problema se debe ejecutar la aplicación del plan para esto se emplea el comando applay
```sh
terraform apply out.plan
```
Al final se debe mostrar el proceso ejecutado, las caracteristicas de infraestuctura creadas y los datos de la misma.

----------------------------------------------------------------------------------------------

**Creación de imagen por medio de Doker**

**Requerimientos**

- [Docker](https://docs.docker.com/install/)

La configuración y creación de las imagenes de Docker se encuentran en el directorio **wso2-dockerfiles**


**WSO2 Dockerfiles**

Los Dockerfiles de WSO2 definen los recursos e instrucciones para construir las imágenes de Docker con los productos WSO2 y las configuraciones de tiempo de ejecución.

**Configuración detallada**

* [Introducción] (https://docs.wso2.com/display/DF120/Introduction)

* [Construir imágenes docker] (https://docs.wso2.com/display/DF120/Building+Docker+Images)

* [Correr imagenes docker] (https://docs.wso2.com/display/DF120/Running+WSO2+Docker+Images)

Para este caso especifico estamos usando la creación de imagenes de wso2esb.

**Dockerfile for WSO2 Enterprise Service Bus**
The Dockerfile defines the resources and instructions to build the Docker images with the WSO2 products and runtime configurations.

The cloned local copy of WSO2 Dockerfiles will be referred as `DOCKERFILES_HOME`.

* Add product packs and dependencies
    - Download and copy JDK 1.7 ([jdk-7u80-linux-x64.tar.gz](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html)) pack to `<DOCKERFILES_HOME>/common/provision/default/files`.
    - Download the WSO2 Enterprise Service Bus zip file (http://wso2.com/products/enterprise-service-bus/) and copy it to `<DOCKERFILES_HOME>/common/provision/default/files`.

* Build the docker image
    - Navigate to `<DOCKERFILES_HOME>/wso2esb`.
    - Execute `build.sh` script and provide the product version.
        + `./build.sh -v 4.9.0`

* Docker run
    - Navigate to `<DOCKERFILES_HOME>/wso2esb`.
    - Execute `run.sh` script and provide the product version.
        + `./run.sh -v 4.9.0`

* Access management console
    -  To access the management console, use the docker host IP and port 9443.
        + `https://<DOCKER_HOST_IP>:9443/carbon`

**Detailed Configuration**

* [Introduction] (https://docs.wso2.com/display/DF120/Introduction)

* [Building docker images] (https://docs.wso2.com/display/DF120/Building+Docker+Images)

* [Running docker images] (https://docs.wso2.com/display/DF120/Running+WSO2+Docker+Images)

Paga agregar la imagen a el contenedor de registro de Azure se deben seguir los siguientes comandos.

```sh
docker login --username <USERNAME> --password <PASSWORD> acrwso2prod.azurecr.io

docker tag wso2esb:5.0.0 acrwso2prod.azurecr.io/wso2esb:5.0.0

docker push acrwso2prod.azurecr.io/wso2esb:5.0.0
```

-----------------------------------------------------------------------------------------------

## Despliegue en kubernetes

**Requerientos**
- [Azure Cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
- [Kubernetes Cli para azure](https://docs.microsoft.com/es-es/cli/azure/aks?view=azure-cli-latest#az-aks-install-cli)

Para el despliegue de kubernetes se implementa la estrategia creada por WSO2 como parte de su estrategia, para esto se usa los archivos de comandos encontrados en el directorio **wso2esb** y que se apoya por el directorio **common** donde se encuentran los archivos de configuración y scprit de despliegue del cluster.

Antes de iniciar el proceso de despliegue se debe hacer login en azure hacer set en la infraestrctura de kuberenetes creada

```sh
az login
az aks get-credentials --resource-group azure-wso2prod --name wso2prod
```

* Kubernetes Artifacts for WSO2 Enterprise Service Bus *
These Kubernetes Artifacts provide the resources and instructions to deploy WSO2 Enterprise Service Bus on Kubernetes.

**Getting Started**
>In the context of this document, `KUBERNETES_HOME`, `DOCKERFILES_HOME` and `PUPPET_HOME` will refer to local copies of [`wso2/kubernetes artifacts`](https://github.com/wso2/kubernetes-artifacts/), [`wso2/dockcerfiles`](https://github.com/wso2/Dockerfiles/) and [`wso2/puppet modules`](https://github.com/wso2/puppet-modules) repositories respectively.

To deploy WSO2 Enterprise Service Bus on Kubernetes, the following steps have to be done.
* Build WSO2 Enterprise Service Bus Docker images
* Copy the images to the Kubernetes Nodes
* Run `deploy.sh` which will deploy the Service and the Replication Controllers

***1. Build Docker Images**

To manage configurations and artifacts when building Docker images, WSO2 recommends to use [`wso2/puppet modules`](https://github.com/wso2/puppet-modules) as the provisioning method. A specific data set for Kubernetes platform is available in WSO2 Puppet Modules. It's possible to use this data set to build Dockerfiles for WSO2 Enterprise Service Bus for Kubernetes with minimum configuration changes.

Building WSO2 Enterprise Service Bus Docker images using Puppet for Kubernetes:

  1. Clone `wso2/puppet modules` and `wso2/dockerfiles` repositories (alternatively you can download the released artifacts using the release page of the GitHub repository).
  2. Copy the [dependency jars](https://docs.wso2.com/display/KA100/Kubernetes+Membership+Scheme+for+WSO2+Carbon) for clustering to `PUPPET_HOME/modules/wso2esb/files/configs/repository/components/lib` location.
  3. Copy the JDK [`jdk-7u80-linux-x64.tar.gz`](http://www.oracle.com/technetwork/java/javase/downloads/jdk7-downloads-1880260.html) to `PUPPET_HOME/modules/wso2base/files` location.
  3. Copy  [`kernel patch0005`](http://product-dist.wso2.com/downloads/carbon/4.4.1/patch0005/WSO2-CARBON-PATCH-4.4.1-0005.zip) to `PUPPET_HOME/modules/wso2esb/files/patches/repository/components/patches` folder.
  4. Copy the [`mysql-connector-java-5.1.36-bin.jar`](http://mvnrepository.com/artifact/mysql/mysql-connector-java/5.1.36) file to `PUPPET_HOME/modules/wso2esb/files/configs/repository/components/lib` location.
  5. Copy the WSO2 Enterprise Service Bus 4.9.0 product pack file to `PUPPET_HOME/modules/wso2esb/files` location (Note that if you use a different product version, the `-v` flag provided to the subsequent scripts have to be changed to match).
  6. Set the environment variable `PUPPET_HOME` pointing to location of the puppet modules in local machine.
  7. Navigate to `wso2esb` directory in the Dockerfiles repository; `DOCKERFILES_HOME/wso2esb`.
  8. Build the Dockerfile with the following command:

    **`./build.sh -v 4.9.0 -s kubernetes`**

  Note that `-s kubernetes` flag denotes the Kubernetes platform, when it comes to selecting the configuration from Puppet.

  This will build the default profile of WSO2 Enterprise Service Bus 4.9.0 for Kubernetes platform, using configuration specified in Puppet.

**2. Copy the Images to Kubernetes Nodes/Registry**

Copy the required Docker images over to the Kubernetes Nodes (ex: use `docker save` to create a tarball of the required image, `scp` the tarball to each node, and use `docker load` to reload the images from the copied tarballs on the nodes). Alternatively, if a private Docker registry is used, transfer the images there.

You can make use of the `load-images.sh` helper script to transfer images to the Kubernetes nodes. It will search for any Docker images with `wso2` as a part of its name on your local machine, and ask for verification to transfer them to the Kubernetes nodes. `kubectl` has to be functioning on your local machine in order for the script to retrieve the list of Kubernetes nodes. You can optionally provide a search pattern if you want to override the default `wso2` string.

**`load-images.sh -p wso2esb`**

**Usage**
```
Usage: ./load-images.sh [OPTIONS]

Transfer Docker images to Kubernetes Nodes
Options:

  -u	[OPTIONAL] Username to be used to connect to Kubernetes Nodes. If not provided, default "core" is used.
  -p	[OPTIONAL] Optional search pattern to search for Docker images. If not provided, default "wso2" is used.
  -h	[OPTIONAL] Show help text.

Ex: ./load-images.sh
Ex: ./load-images.sh -u ubuntu
Ex: ./load-images.sh -p wso2is
```

**3. Deploy Kubernetes Artifacts**
  1. Navigate to `wso2esb` directory in kubernetes repository; `KUBERNETES_HOME/wso2esb` location.
  2. run the deploy.sh script:

    **`./deploy.sh`**

      This will deploy the WSO2 Enterprise Service Bus 4.9.0 default profile in Kubernetes, using the image available in Kubernetes nodes, and notify once the intended service starts running on the pod.
      __Please note that each Kubernetes node needs the [`mysql:5.5`](https://hub.docker.com/_/mysql/) Docker image in the node's Docker registry.__

**4. Access Management Console**
  1. Add an host entry (in Linux, using the `/etc/hosts` file) for `wso2esb-default`, resolving to the Kubernetes node IP.
  2. Access the Carbon Management Console URL using `https://wso2esb-default:32122/carbon/`

**5. Undeploying**
  1. Navigate to `wso2esb` directory in Kubernetes repository; `KUBERNETES_HOME/wso2esb` location.
  2. run the `undeploy.sh` script:

    **`./undeploy.sh`**

      This will undeploy the WSO2 Enterprise Service Bus specific DB pod (`mysql-mbdb`), Kubernetes Replication Controllers, and Kubernetes services. Additionally if `-f` flag is provided when running `undeploy.sh`, it will also undeploy the shared Governance and User DB pods, Replication Controllers, and Services.
      **`./undeploy.sh -f`**

For more detailed instructions on deploying WSO2 Enterprise Service Bus on Kubernetes, please refer the wiki links under the Documentation section below.

* Documentation
* [WSO2 Kubernetes Artifacts Wiki](https://docs.wso2.com/display/KA100/WSO2+Kubernetes+Artifacts)

-----------------------------------------------------------------------------------------------
