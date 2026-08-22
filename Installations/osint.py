import os
import sys
import time
import subprocess

logDir = "var/log/SysAdmin/Installations"
timestamp = time.time()

apps = ["The Harvester"]
updates = ["apt-get update -y", "apt-get upgrade -y", "apt-get dist-upgrade -y", "apt-get clean", "apt-get autoremove -y"]

def check_root():

        if os.getuid() != 0:
                print("This sript must be run as root", file=sys.stderr)
                sys.exit(1)

                
def logDirValidation(path):
    
    if not os.path.exists(path):
        print("Log path does not exist")
        print("Creating path")
        try:
           os.makedirs(path)
           print(f"{path} has been created")
        except Exception as e:
           print(f"An error has occured: {e}")


def runUpdates(lst):
    
    for i in lst:
        
        command = ["bash", "-c", i]
        
        try:
            subprocess.run(command, check=True)
            print(f"Success: {i}")
        except subprocess.CalledProcessError:
            print(f"Update failed: {i}")
            

check_root()
logDirValidation(logDir)
runUpdates(updates)


