# AllInOneShell
by Mercury180#6286

![demo image](images/demo.png)

### Creation

I was faced with a couple of problems that made me decide to make this tool:
* Copying and pasting reverse shells directly into URLs, would often break, so I would inevitably have to transfer a reverse shell from my machine remotely, then execute it with bash.
* Often, machines will not have useful programs such as `python`, which means the reverse shell will be useless.
* Running sudo for ports under 1000 gets *real* annoying.

### Features

AllInOneShell essentially tries to fix the above problems.
What it does: 
- Adds network admin capabilities to python3/netcat, so no sudo is needed.
- Creates a bash script that systematically tries multiple programs to see if installed, and if so, connects back with a reverse shell.
- Writes the bash script to a unique temporary directory, and starts a backgrounded HTTP server there.
- Prints how to call the bash script from your local machine using `curl` or `wget`
- Starts a netcat listener to catch any reverse shells.
- The HTTP server will timeout after 5 minutes, as the process is detached.

### Config

The default port for the HTTP server is `80` (to try and bypass some basic firewall restrictions), but this can be changed easily at the top of the script in "# Config Items".
Be aware, the HTTP process detaches and once the reverse shell comes through, it can be a pain to kill. There is a timeout for 5 minutes on the process, but that can be extended in the config again.

![config image](images/config.png)


### Note

This program is made specifically for HTB/THM, and should definitely not be used for anything other than boot2root machines. It is quite clunky, but it gives the advantage of convenience, as it tries to incorporate everything you need in a bash script. 
Additionally, the tmp directories are not deleted, but will be on machine restart. 
`rm -r /tmp/tmp-*`, to do this manually.

`ln -sf [path to allinoneshell.sh] /usr/bin/aios`
Then to call the reverse shell tool, simply run `aios`.
