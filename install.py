#!/usr/bin/python
import os
import sys
from subprocess import call

config_path = os.path.realpath(os.path.dirname(sys.argv[0]))
pack_manage = os.path.join(config_path, 'pack/manage.py')
dotfile_manage = os.path.join(config_path, 'dotfiles/manage.py')
cabal_packages = os.path.join(config_path, 'CABAL-PACKAGES')
pip_packages = os.path.join(config_path, 'PIP-PACKAGES')

call(['sudo', pack_manage, '--reinstall'])
call([dotfile_manage, '--install'])

def call_each(ppath, cmd):
  for line in open(ppath):
    package = line.strip()
    if package: call(cmd + [package])
call_each(cabal_packages, ['cabal', 'install'])
call_each(pip_packages, ['sudo', 'pip', 'install'])

cur_path = os.getcwd()
os.chdir(config_path)
call(['git', 'submodule', 'update', '--init'])
os.chdir(cur_path)
