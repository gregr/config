#!/usr/bin/python
from argparse import ArgumentParser
import os
import sys
from subprocess import call

config_path = os.path.realpath(os.path.dirname(sys.argv[0]))
pack_manage = os.path.join(config_path, 'pack/manage.py')
dotfile_manage = os.path.join(config_path, 'dotfiles/manage.py')
cabal_packages = os.path.join(config_path, 'CABAL-PACKAGES')
pip_packages = os.path.join(config_path, 'PIP-PACKAGES')
primary_packages = os.path.join(config_path, 'pack/PRIMARY-PACKAGES')
secondary_packages = os.path.join(config_path, 'pack/SECONDARY-PACKAGES')
extra_packages = os.path.join(config_path, 'pack/PACKAGES')

def parse(argv):
  parser = ArgumentParser(description='install dotfiles and packages')
  for args, kwargs in (
      (['--basic'], dict(action='store_true', default=False)),
      (['--all'], dict(action='store_true', default=False)),
      (['-n', '--dryrun'], dict(action='store_true', default=False)),
      ):
    parser.add_argument(*args, **kwargs)
  args = parser.parse_args(argv)
  args.basic = args.basic or args.all
  return args

class Runner(object):
  def __init__(self, opts): self.opts = opts
  def pack_install(self, filename):
    if self.opts.dryrun:
      print 'would install packages from:', filename
    else:
      self.call(['sudo', pack_manage, '--reinstall', '--filename', filename])
  def call(self, cmd):
    if self.opts.dryrun:
      print 'call:', cmd
      return
    return call(cmd)
  def run(self):
    os.chdir(config_path)
    self.pack_install(primary_packages)
    dryrun = self.opts.dryrun and ['--dryrun'] or []
    print 'dryrun:', dryrun
    self.call([dotfile_manage, '--install'] + dryrun)
    self.call(['git', 'submodule', 'update', '--init'])
    if self.opts.basic:
      self.pack_install(secondary_packages)
      def call_each(ppath, cmd):
        for line in open(ppath):
          package = line.strip()
          if package: self.call(cmd + [package])
      call_each(cabal_packages, ['cabal', 'install'])
      call_each(pip_packages, ['sudo', 'pip', 'install'])
    if self.opts.all: self.pack_install(extra_packages)

def main(argv): Runner(parse(argv)).run()
if __name__ == '__main__': main(sys.argv[1:])
