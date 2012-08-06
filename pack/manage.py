#!/usr/bin/python
from argparse import ArgumentParser
import logging
import os
from subprocess import call
import sys

default_file_name = os.path.realpath(os.path.join(
  os.path.dirname(sys.argv[0]), 'PACKAGES'))

def parse(argv, file_name=default_file_name):
  parser = ArgumentParser(description='simple package management')
  parser.add_argument('-i', '--install', nargs='+', default=[])
  parser.add_argument('-r', '--remove', nargs='+', default=[])
  parser.add_argument('--reinstall', action='store_true', default=False)
  parser.add_argument('-f', '--filename', nargs=1, default=file_name)
  parser.add_argument('-v', '--verbose', action='store_true', default=False)
  args = parser.parse_args(argv)
  args.install = set(args.install)
  args.remove = set(args.remove)
  return args

def cur_packages(file_name):
  pfile = open(file_name)
  packages = set(line.strip() for line in pfile)
  pfile.close()
  return packages

def run(file_name, install, remove):
  packages = cur_packages(file_name)
  useless = install & remove
  install -= useless
  remove -= useless
  to_install = install - packages
  to_remove = remove & packages
  logging.info('installing: %s, removing: %s', to_install, to_remove)
  for cmd, source in (('install', to_install), ('remove', to_remove)):
    scrap = set()
    for name in source:
      if 0 != call(['apt-get', cmd, '-y', name]): scrap.add(name)
    source -= scrap
  original = packages.copy()
  packages -= to_remove
  packages |= to_install
  if packages != original:
    logging.info('writing updated %s', file_name)
    open(file_name, 'w').write('\n'.join(sorted(list(packages))))
  else: logging.warn('nothing to update!')
  for desc, items in (('uselessly specified', useless),
                      ('already installed', install & original),
                      ('not present to be removed', remove - original)):
    if items: logging.warn('%s: %s', desc, items)

def reinstall(file_name):
  call(['apt-get', 'update'])
  for name in cur_packages(file_name):
    call(['apt-get', 'install', '-y', name])

def main(argv):
  args = parse(argv)
  if args.verbose: logging.basicConfig(level=logging.INFO)
  if args.reinstall: reinstall(args.filename)
  else: run(args.filename, args.install, args.remove)

if __name__ == '__main__': main(sys.argv[1:])
