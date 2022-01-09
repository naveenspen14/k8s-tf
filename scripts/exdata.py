#!/usr/bin/env python
# https://paulbrice.com/terraform/python/2017/12/18/external-provider-terraform.html

"""Script to test the external data provider in Terraform"""

import sys
import json
from subprocess import check_output

    
def read_in():
    """Read input data from terraform"""
    return {x.strip() for x in sys.stdin}

def get_join_cmd(host,privatekey,user):
    """
    SSH to a Kubernetes master server and retrive 
    kubeadm join command
    """
    try:
        join_cmd = check_output(
            [
                'ssh',
                '-i',
                str(privatekey),
                '-o',
                'StrictHostKeyChecking=no',
                str(user)+'@'+str(host),
                'kubeadm',
                'token',
                'create',
                '--print-join-command',

            ]

        )
        # print(f"kubeadm join token successfully obtained: {join_cmd}")
        return str(join_cmd)
    
    except Exception as e:
        #print("Could not execute: kubeadm token create --print-join-command: {e}")
        return "empty"


def main():
    lines = read_in()
    for line in lines:
        if line:
            jsondata = json.loads(line)

            # jsondata = {"host": "1.2.3.4"}
    
    join_cmd = get_join_cmd(jsondata['host'],jsondata['privatekey'],jsondata['user'])
    if join_cmd:
        jsondata['cmd'] = join_cmd

    sys.stdout.write(json.dumps(jsondata))



if __name__ == '__main__':
    """
    Execute kubeadm join commnad retrieval
    """
    main()
