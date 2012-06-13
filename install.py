#!/usr/bin/python
import os
import sys
from subprocess import call

config_path = os.path.realpath(os.path.dirname(sys.argv[0]))
pack_manage = os.path.join(config_path, 'pack/manage.py')
dotfile_manage = os.path.join(config_path, 'dotfiles/manage.py')

print pack_manage, dotfile_manage
call(['sudo', pack_manage, '--reinstall'])
call([dotfile_manage, '--install'])
