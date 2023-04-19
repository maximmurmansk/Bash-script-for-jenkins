IP="IPadr"
USER="root"
SSHKEY="key"

remote_command(){
sudo ssh -oStrictHostKeyChecking=no -i $SSHKEY -y root@$IP "$1"
}

containers=$(remote_command "docker ps -a --format \"{{.ID}} {{.Names}} {{.Status}}\" | awk '\$5 ~ /hours/ || \$5 ~/minutes/ {print \$1}'")
#containers=$(remote_command "docker ps -a --format \"{{.ID}} {{.Names}} {{.Status}}\" | awk '\$5 ~/minutes/ {print \$1}'")

for container in $containers
do
  #echo "Saving logs for container $container"
remote_command "docker logs $container > /$container.log"
done

# Archive the log files
#timestamp=$(date +%Y%m%d_%H%M%S)
remote_command "tar -czvf /logs_$IP.tar.gz /*.log"

# Delete the log files
remote_command "rm /*.log"