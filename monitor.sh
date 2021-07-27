lin=$(uname -a)
pcpu=$(grep "physical id" /proc/cpuinfo | sort | uniq | wc -l)
vcpu=$(grep "^processor" /proc/cpuinfo | wc -l)
tmem=$(free -m|grep Mem:|awk '{print $2}')
umem=$(free -m|grep Mem:|awk '{print $3}')
pmem=$(free -m|grep Mem:|awk '{printf("(%.2f%%)"),$3/$2*100}')
tdsk=$(df -h --total |grep total| awk '{print $2}')
udsk=$(df -BM --total |grep total| awk '{print $3}'| rev | cut -c2- | rev)
pdsk=$(df -h --total |grep total| awk '{print $5}')
ucpu=$(top -bn1| grep "%Cpu(s):"| awk '{print $2}')
bdate=$(last reboot -n1 --time-format iso |grep reboot| awk '{print $5}'|head -c10)
btime=$(last reboot -n1 --time-format iso |grep reboot| awk '{print $5}'|tail -c15|rev|cut -c10-|rev)
nlvm=$(lvscan|grep ACTIVE|wc -l)
if [ $nlvm > 0 ]; then
	alvm=$(echo "yes")
else
	alvm=$(echo "no")
fi
ctcp=$(netstat|grep tcp|wc -l)
cusers=$(who|wc -l)
ipadr=$(ip route |grep src|awk '{print $9}')
madr=$(ip addr |grep ether| awk '{print $2}')
nsudo=$(cat /var/log/sudo/sudo.log| grep COMMAND| wc -l)

wall -n " 
 #Archintekture: $lin
 #CPU physical: $pcpu
 #vCPU: $vcpu
 #Memory Usage: $umem/$tmem Mb $pmem
 #Disk Usage: $udsk/$tdsk ($pdsk)
 #CPU Load: $ucpu%
 #Last boot: $bdate $btime
 #LVM use: $alvm
 #Connections TCP: $ctcp ESTABLISHED
 #User log: $cusers
 #Network: IP $ipadr ($madr)
 #Sudo: $nsudo cmd"
