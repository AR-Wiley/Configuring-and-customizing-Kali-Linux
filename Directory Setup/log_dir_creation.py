import os
import sys

root_dir = "/var/log/SysAdmin"
sub_dir = ["Updates", "Installations", "Scripts", "Software", "Users", "Other"]

def checkRoot():

        if os.getuid() != 0:
                print("This sript must be run as root", file=sys.stderr)
                sys.exit(1)


def rootDir(path):

    if not os.path.exists(path):
        print("Root path does not exist")
        print("Creating path")
        try:
            os.makedirs(path)
            print(f"{path} had been created")
        except Exception as e:
            print(f"An error has occured: {e}")
    else:
        print(f"{path} already exists")
		
		
def subDir(rootDir, subDir):

        for dir in subDir:
            if not os.path.exists(os.path.join(rootDir, dir)):
                print("Sub directory path does not exist")
                print("Creating path")
                try:
                    os.makedirs(os.path.join(rootDir, dir))
                    print(f"Sub directory {dir} had been created")
                except Exception as e:
                    print(f"An error has occured: {e}")
            else:
                print(f"{path} already exists")


checkRoot
rootDir(root_dir)
subDir(root_dir, sub_dir)
