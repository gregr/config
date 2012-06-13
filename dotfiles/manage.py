#!/usr/bin/python
from argparse import ArgumentParser
import errno
import os
import shutil
from subprocess import call
import sys

dotfiles_path = os.path.realpath(os.path.dirname(sys.argv[0]))
src_path = os.path.realpath(os.path.join(dotfiles_path, 'src'))
backup_path = os.path.realpath(os.path.join(dotfiles_path, 'backup'))
home_path = os.path.realpath(os.path.expanduser('~'))

def parse(argv):
  parser = ArgumentParser(description='manage dotfiles')
  for args, kwargs in (
      (('-i', '--install'), dict(action='store_true', default=False)),
      (('-u', '--uninstall'), dict(action='store_true', default=False)),
      (('-n', '--dryrun'), dict(action='store_true', default=False)),
      (('-f', '--force'), dict(action='store_true', default=False)),):
    parser.add_argument(*args, **kwargs)
  return parser.parse_args(argv)

def mkdirp(path):
  try: os.makedirs(path)
  except OSError as e:
    if e.errno != errno.EEXIST: raise

def files(path):
  for row in os.walk(path): return set(row[1] + row[2])
  return set()

def target(name): return os.path.join(src_path, name)
def is_good_link(name):
  path = os.path.join(home_path, name)
  return os.path.islink(path) and os.path.realpath(path) == target(name)

def run(opts):
  if opts.install and opts.uninstall:
    print 'cannot both install and uninstall in the same run'
    return
  dfs = files(src_path)
  bfs = files(backup_path)
  hfs = files(home_path)
  hsfs = set(filter(is_good_link, hfs))

  if opts.dryrun: print '[dry-run only]'
  if opts.install:
    newfs = dfs - hsfs
    savefs = newfs & hfs
    dangerfs = savefs & bfs
    if opts.force: print 'obliterating backups:', dangerfs
    elif dangerfs:
      print 'already backed up; unable to install:', dangerfs
      savefs -= dangerfs
    if not opts.dryrun: mkdirp(backup_path)
    for fn in newfs:
      hpath = os.path.join(home_path, fn)
      bpath = os.path.join(backup_path, fn)
      tgt = target(fn)
      if fn in savefs:
        print 'moving:', hpath, '->', bpath
        if not opts.dryrun: shutil.move(hpath, bpath)
      print 'linking:', hpath, '->', tgt
      if not opts.dryrun: os.symlink(tgt, hpath)
  elif opts.uninstall:
    restorefs = bfs & hsfs
    dangerfs = (hfs - hsfs) & bfs
    if opts.force: print 'obliterating home files:', dangerfs
    elif dangerfs:
      print 'unable to uninstall over home files:', dangerfs
      restorefs -= dangerfs
    for fn in restorefs:
      hpath = os.path.join(home_path, fn)
      bpath = os.path.join(backup_path, fn)
      print 'removing:', hpath
      if not opts.dryrun: os.unlink(hpath)
      print 'moving:', bpath, '->', hpath
      if not opts.dryrun: shutil.move(bpath, hpath)
    if not opts.dryrun and (not dangerfs or opts.force):
      shutil.rmtree(backup_path)
  else: print 'choose install or uninstall'
  print 'done!'

def main(argv): run(parse(argv))
if __name__ == '__main__': main(sys.argv[1:])
