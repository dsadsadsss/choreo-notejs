import subprocess
import time
cmd = "/start.sh"
subprocess.call(cmd, shell=True)
cmd2 = "/tmp/chatdog.sh"
while True:
  subprocess.call(cmd2, shell=True)
  time.sleep(20)
