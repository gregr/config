#!/usr/bin/python
import os
import sys
from subprocess import call

config_path = os.path.realpath(os.path.dirname(sys.argv[0]))
pack_manage = os.path.join(config_path, 'pack/manage.py')
dotfile_manage = os.path.join(config_path, 'dotfiles/manage.py')
cabal_packages = os.path.join(config_path, 'CABAL-PACKAGES')

call(['sudo', pack_manage, '--reinstall'])
call([dotfile_manage, '--install'])

for line in open(cabal_packages):
  package = line.strip()
  if package: call(['cabal', 'install', package])

cur_path = os.getcwd()
os.chdir(config_path)
call(['git', 'submodule', 'update', '--init'])
os.chdir(cur_path)
