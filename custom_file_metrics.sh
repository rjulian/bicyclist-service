#set -x

put_container_network_in(){
        CONTAINER_ID="$1"
        metric_name='NetworkIn'
        namespace='BicyclistService'
  METRIC_PATH='net/dev'
        CONTAINER_PID=`docker inspect -f '{{ .State.Pid }}' $CONTAINER_ID`
        NETWORK_IN=`cat /proc/$CONTAINER_PID/$METRIC_PATH | grep eth0 | cut -d' ' -f 6`
        echo $NETWORK_IN
        echo $CONTAINER_PID

        aws cloudwatch put-metric-data --metric-name $metric_name --namespace $namespace --unit Bytes --value $NETWORK_IN --dimensions ContainerId=$CONTAINER_ID
}
container_ids(){
  output=$(docker ps --format '{{.ID}}\t{{.Names}}' | grep bicycl | cut -f 1)
  echo $output
}

containers=($(container_ids))

while true
do
  for container in "${containers[@]}"
  do
    put_container_network_in $container
    echo "putting metric for $container"
  done
  sleep 10
done
