#!/usr/bin/python
from argparse import ArgumentParser
import errno
import os
import shutil
import sys

dotfiles_path = os.path.realpath(os.path.dirname(sys.argv[0]))
src_path = os.path.realpath(os.path.join(dotfiles_path, 'src'))
backup_path = os.path.realpath(os.path.join(dotfiles_path, 'backup'))
home_path = os.path.realpath(os.path.expanduser('~'))
manifest_path = os.path.join(dotfiles_path, 'MANIFEST')

def read_manifest(path=manifest_path):
  try: return set(path.strip() for path in open(path).readlines()
                  if path.strip())
  except IOError as e:
    if e.errno != errno.ENOENT: raise
  return set()

def write_manifest(manifest, path=manifest_path):
  open(path, 'w').write('\n'.join(sorted(list(manifest))))

def parse(argv):
  parser = ArgumentParser(description='manage dotfiles')
  for args, kwargs in (
      (('-a', '--add'), dict(nargs='+', default=[])),
      (('-r', '--remove'), dict(nargs='+', default=[])),
      (('-i', '--install'), dict(action='store_true', default=False)),
      (('-u', '--uninstall'), dict(action='store_true', default=False)),
      (('-n', '--dryrun'), dict(action='store_true', default=False)),
      (('-f', '--force'), dict(action='store_true', default=False)),):
    parser.add_argument(*args, **kwargs)
  args = parser.parse_args(argv)
  args.add = set(args.add)
  args.remove = set(args.remove)
  return args

def mkdirp(path):
  try: os.makedirs(path)
  except OSError as e:
    if e.errno != errno.EEXIST: raise

def target(subpath): return os.path.join(src_path, subpath)
def is_subpath(root, path): return os.path.exists(os.path.join(root, path))
def is_src(subpath): return is_subpath(src_path, subpath)
def is_home(subpath): return is_subpath(home_path, subpath)
def is_backup(subpath): return is_subpath(backup_path, subpath)
def is_good_link(subpath):
  path = os.path.join(home_path, subpath)
  return os.path.islink(path) and os.path.realpath(path) == target(subpath)

class Mutator(object):
  def __init__(self, dryrun): self.dryrun = dryrun
  def mkdirp(self, path):
    if self.dryrun: return
    mkdirp(path)
  def move(self, src, tgt):
    print 'moving:', src, '->', tgt
    if self.dryrun: return
    tgt_path = os.path.dirname(tgt)
    if not os.path.exists(tgt_path): self.mkdirp(tgt_path)
    shutil.move(src, tgt)
  def symlink(self, src, tgt):
    print 'linking:', src, '->', tgt
    if self.dryrun: return
    src_dir = os.path.dirname(src)
    if not os.path.exists(src_dir): self.mkdirp(src_dir)
    os.symlink(tgt, src)
  def unlink(self, path):
    print 'removing:', path
    if self.dryrun: return
    os.unlink(path)

def run(opts):
  if opts.install and opts.uninstall:
    print 'cannot both install and uninstall in the same run'
    return

  manifest = read_manifest()
  mut = Mutator(opts.dryrun)
  if opts.dryrun: print '[dry-run only]'
  if opts.add or opts.remove:
    try_add = opts.add - opts.remove
    to_add = set(path for path in try_add if is_src(path))
    to_remove = opts.remove - opts.add
    fail_add = try_add - to_add
    print 'manifest originally contained:', manifest
    if opts.add: print 'adding to manifest:', to_add
    if fail_add: print 'could not find the following to add:', fail_add
    if opts.remove: print 'removing from manifest:', to_remove
    manifest |= to_add
    manifest -= to_remove
    print 'manifest now contains:', manifest
    if not opts.dryrun: write_manifest(manifest)

  sources = set(filter(is_src, manifest))
  missing = manifest - sources
  if missing: print 'manifest paths not found in sources:', missing
  backups = set(filter(is_backup, manifest))
  homers = set(filter(is_home, manifest))
  good_homers = set(filter(is_good_link, homers))
  bad_homers = homers - good_homers

  if opts.install:
    newbs = sources - good_homers
    savers = newbs & bad_homers
    dangers = savers & backups
    if opts.force: print 'obliterating backups:', dangers
    elif dangers:
      print 'already backed up; unable to install:', dangers
      savers -= dangers
    mut.mkdirp(backup_path)
    for subpath in newbs:
      hpath = os.path.join(home_path, subpath)
      bpath = os.path.join(backup_path, subpath)
      tgt = target(subpath)
      if subpath in savers: mut.move(hpath, bpath)
      mut.symlink(hpath, tgt)
  elif opts.uninstall:
    restorers = backups.copy()
    dangers = backups & bad_homers
    if opts.force: print 'obliterating home files:', dangers
    elif dangers:
      print 'unable to uninstall over home files:', dangers
      restorers -= dangers
    for subpath in restorers:
      hpath = os.path.join(home_path, subpath)
      bpath = os.path.join(backup_path, subpath)
      mut.unlink(hpath)
      mut.move(bpath, hpath)
  print 'done!'

def main(argv): run(parse(argv))
if __name__ == '__main__': main(sys.argv[1:])
