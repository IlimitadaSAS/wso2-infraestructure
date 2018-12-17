#!/bin/bash
# ------------------------------------------------------------------------
#
# Copyright 2016 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

# ------------------------------------------------------------------------
self_path=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "${self_path}/common/scripts/base.sh"

function showUsageAndExit() {
        echoBold "Usage: ./load-images.sh [OPTIONS]"
        echo
        echo "Transfer Docker images to Kubernetes Nodes"

        echoBold "Options:"
        echo
        echo -en "  -u\t"
        echo "[OPTIONAL] Username to be used to connect to Kubernetes Nodes. If not provided, default \"core\" is used."
        echo -en "  -p\t"
        echo "[OPTIONAL] Optional search pattern to search for Docker images. If not provided, default \"wso2\" is used."
        echo -en "  -h\t"
        echo "[OPTIONAL] Show help text."
        echo

        echoBold "Ex: ./load-images.sh"
        echoBold "Ex: ./load-images.sh -u ubuntu"
        echoBold "Ex: ./load-images.sh -p wso2is"
        echo
        exit 1
}

kub_username="core"
search_pattern="wso2"

# TODO: handle flag provided, but no value
while getopts :u:p:h FLAG; do
    case $FLAG in
        u)
            kub_username=$OPTARG
            ;;
        p)
            search_pattern=$OPTARG
            ;;
        h)
            showUsageAndExit
            ;;
    esac
done

validateKubeCtlConfig
IFS=$'\n'

kube_nodes=($(getKubeNodes))
if [ "${#kube_nodes[@]}" -lt 1 ]; then
    echoError "No Kubernetes Nodes found."
    exit 1
fi


wso2_docker_images=($(docker images | grep "${search_pattern}" | awk '{print $1 ":" $2}'))

if [ "${#wso2_docker_images[@]}" -lt 1 ]; then
    echo "No Docker images with name \"wso2\" found."
    exit 1
fi

for wso2_image_name in "${wso2_docker_images[@]}"
do
    if [ "${wso2_image_name//[[:space:]]/}" != "" ]; then
        wso2_image=$(docker images $wso2_image_name | awk '{if (NR!=1) print}')
        echo -n $(echo $wso2_image | awk '{print $1 ":" $2, "(" $3 ")"}') " - "
        askBold "Transfer? ( [y]es / [n]o / [e]xit ): "
        read -r xfer_v
        if [ "$xfer_v" == "y" ]; then
            image_id=$(echo $wso2_image | awk '{print $3}')
            echoDim "Saving image ${wso2_image_name}..."
            docker save ${wso2_image_name} > /tmp/$image_id.tar

            for kube_node in "${kube_nodes[@]}"
            do
                echoDim "Copying saved image to ${kube_node}..."
                node_ip=$(getKubeNodeIP $kube_node)

                # Checking if a known_hosts entry already exists
                echoDim "Checking SSH communication to Node ${node_ip}..."
                host_known=$(ssh-keygen -H -F $node_ip)
                if [ ! -z "${host_known}" ]; then
                    # host known, check if up to date
                    key_scheme=$(ssh-keygen -H -F $node_ip | awk '{print $2}')
                    host_key=$(ssh-keygen -H -F $node_ip | awk '{print $3}')
                    server_key=$(ssh-keyscan -t $key_scheme $node_ip | awk '{print $3}')
                    if [ $host_key != $server_key ]; then
                        echo "Removing known_hosts entry ${node_ip}..."
                        ssh-keygen -f "${HOME}/.ssh/known_hosts" -R $node_ip
                    fi
                fi

                scp /tmp/$image_id.tar $kub_username@$node_ip:.
                echoDim "Loading copied image..."
                ssh $kub_username@$node_ip "docker load < ${image_id}.tar"
                ssh $kub_username@$node_ip "rm -rf ${image_id}.tar"
            done

            echoDim "Cleaning..."
            rm -rf /tmp/$image_id.tar
            echoBold "Done"
        elif [ "$xfer_v" == "e" ]; then
            echoBold "Done"
            exit 0
        fi
    fi
done
